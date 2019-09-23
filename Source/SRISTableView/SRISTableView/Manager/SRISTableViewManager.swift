//
//  SRISTableViewManager.swift
//  SRISTableView
//
//  Created by Rob on 19/09/2019.
//  Copyright © 2019 com.rob. All rights reserved.
//

import UIKit



public typealias SRISManager = SRISTableViewManager

/// Represents the state of the current data fetching
public enum LoadMoreOnScrollTableViewState: Equatable {
    case failed(withPreviousResults: Bool) // An error occurred, we should use a different UI if some results have already been fetched or not
    case finished(withPreviousResults: Bool) // No error occurred, all results have been fetched
    case loading // Currently loading data
    case pending // Fetch has not started yet
    case succeeded // Did successfully fetch some data, not reloading yet
}

open class SRISTableViewManager<Delegate: SRISDelegate, Request: SRISRequest>: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Instance Properties
    
    private var allResultsOrdered: [Delegate.ContentType] {
        return self.loadMoreOnScrollDelegate.displayedResults(fromUnorderedResults: (self.results + self.cachedResults))
    }
    
    private var allResultsRaw: [Delegate.ContentType] {
        return self.results + self.cachedResults
    }
    
    private var cachedResults: [Delegate.ContentType] = []
    
    private var loadMoreOnScrollDelegate: Delegate!
    
    private var loadMoreOnScrollRequest: Request!
    
    private var pageCount: Int?
    
    private var recordCount: Int?
    
    private var results: [Delegate.ContentType] = []
    
    private var state: LoadMoreOnScrollTableViewState = .pending {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: View Properties
    
    private var tableView: UITableView! {
        didSet {
            self.tableView.dataSource = self
            self.tableView.delegate = self
        }
    }
    
    // MARK: Manager Methods
    
    private func load() {
        switch self.state {
        case .loading, .finished, .failed:
            return
        default:
            break
        }
        self.state = .loading
        self.loadMoreOnScrollRequest.load(delegate: self.loadMoreOnScrollDelegate, skipping: self.results.count, cachingData: self.loadMoreOnScrollDelegate.shouldCacheData) { (result, error) in
            if let result = result as? [Delegate.ContentType] {
                if result.isEmpty {
                    self.state = .finished(withPreviousResults: !self.results.isEmpty)
                } else {
                    if !self.cachedResults.isEmpty {
                        result.forEach({ subResult in
                            if self.cachedResults.contains(subResult) {
                                self.cachedResults.removeAll(where: { $0 == subResult })
                            }
                        })
                    }
                    self.results.append(contentsOf: result)
                    self.state = .succeeded
                    if !self.cachedResults.isEmpty {
                        self.load()
                    }
                }
            } else {
                if let error = error {
                    print("Oops: \(error.localizedDescription)")
                }
                self.state = .failed(withPreviousResults: !self.allResultsOrdered.isEmpty)
                self.tryReload()
            }
        }
    }
    
    private func loadCache() {
        self.loadMoreOnScrollRequest.loadFromCache(delegate: self.loadMoreOnScrollDelegate) { (result, error) in
            if let error = error {
                print("Oops: \(error.localizedDescription)")
                self.state = .failed(withPreviousResults: !self.allResultsOrdered.isEmpty)
                self.tryReload(fromCache: true)
            } else if let result = result as? [Delegate.ContentType] {
                self.cachedResults.append(contentsOf: result)
                self.load()
            }
        }
    }
    
    private func start() {
        if self.loadMoreOnScrollDelegate.shouldLoadCacheDataFirst {
            self.loadCache()
        } else {
            self.load()
        }
    }
    
    public static func setupAndStart(inTableView tableView: UITableView, withLoadMoreOnScrollDelegate loadMoreOnScrollDelegate: Delegate, andRequestType requestType: Request) -> SRISManager<Delegate, Request> {
        let manager = SRISTableViewManager()
        manager.loadMoreOnScrollDelegate = loadMoreOnScrollDelegate
        manager.loadMoreOnScrollRequest = requestType
        manager.tableView = tableView
        manager.start()
        return manager
    }
    
    private func tryReload(fromCache: Bool = false) {
        SRISTableViewDelayer.delay(self.loadMoreOnScrollDelegate.intervalBeforeReload) {
            switch self.state {
            case .failed, .pending:
                self.state = .pending
                if fromCache {
                    self.loadCache()
                } else {
                    self.load()
                }
            default:
                return
            }
        }
    }
    
    // MARK: Table Methods
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch self.state {
        case .failed(let withResults):
            if withResults {
                if self.loadMoreOnScrollDelegate.shouldShowFailedCell, indexPath.row == self.allResultsOrdered.count {
                    return self.loadMoreOnScrollDelegate.failedCell(forTableView: tableView)
                } else {
                    return self.loadMoreOnScrollDelegate.resultCell(forTableView: tableView, andObject: self.allResultsOrdered[indexPath.row], atIndexPath: indexPath)
                }
            } else {
                return self.loadMoreOnScrollDelegate.failedCell(forTableView: tableView)
            }
        case .finished(let withResults):
            return withResults ? self.loadMoreOnScrollDelegate.resultCell(forTableView: tableView, andObject: self.allResultsOrdered[indexPath.row], atIndexPath: indexPath) : self.loadMoreOnScrollDelegate.noResultCell(forTableView: tableView)
        case .loading:
            return self.loadMoreOnScrollDelegate.shouldShowLoadingCell && indexPath.row == self.allResultsOrdered.count ? (self.loadMoreOnScrollDelegate.loadingCell(forTableView: tableView)) : self.loadMoreOnScrollDelegate.resultCell(forTableView: tableView, andObject: self.allResultsOrdered[indexPath.row], atIndexPath: indexPath)
        case .succeeded, .pending:
            return self.loadMoreOnScrollDelegate.resultCell(forTableView: tableView, andObject: self.allResultsOrdered[indexPath.row], atIndexPath: indexPath)
        }
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch self.state {
        case .pending:
            return
        case .loading, .failed, .finished, .succeeded:
            if indexPath.row < self.allResultsOrdered.count {
                self.loadMoreOnScrollDelegate.didSelect(object: self.allResultsOrdered[indexPath.row])
            }
            if self.state != .loading && indexPath.row == self.allResultsOrdered.count {
                self.state = .pending
                self.load()
            }
        }
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.loadMoreOnScrollDelegate.tableRowHeight(withCurrentResults: self.allResultsRaw) ?? 0.0
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.loadMoreOnScrollDelegate.tableRowHeight(withCurrentResults: self.allResultsRaw) ?? 0.0
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return self.loadMoreOnScrollDelegate.tableFooterHeight(withCurrentResults: self.allResultsRaw) ?? 0.0
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: self.loadMoreOnScrollDelegate.tableFooterHeight(withCurrentResults: self.allResultsRaw) ?? 0.0))
        view.backgroundColor = .clear
        return view
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.loadMoreOnScrollDelegate.tableHeaderHeight(withCurrentResults: self.allResultsRaw) ?? 0.0
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: self.loadMoreOnScrollDelegate.tableHeaderHeight(withCurrentResults: self.allResultsRaw) ?? 0.0))
        view.backgroundColor = .clear
        return view
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.state {
        case .failed:
            return self.allResultsOrdered.count + ((self.loadMoreOnScrollDelegate?.shouldShowFailedCell ?? false) ? 1 : 0)
        case .finished(let withResults):
            return self.allResultsOrdered.count + (withResults ? 0 : ((self.loadMoreOnScrollDelegate?.shouldShowNoResultCell ?? false) ? 1 : 0))
        case .loading:
            return self.allResultsOrdered.count + ((self.loadMoreOnScrollDelegate?.shouldShowLoadingCell ?? false) ? 1 : 0)
        case .pending, .succeeded:
            return self.allResultsOrdered.count
        }
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        switch self.state {
        case .loading, .finished, .failed(withPreviousResults: true):
            return
        default:
            break
        }
        guard self.allResultsOrdered.count - indexPath.row < 4 else {
            return
        }
        self.load()
    }
    
}
