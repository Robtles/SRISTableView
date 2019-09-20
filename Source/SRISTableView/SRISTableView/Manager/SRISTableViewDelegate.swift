//
//  SRISTableViewDelegate.swift
//  SRISTableView
//
//  Created by Rob on 19/09/2019.
//  Copyright © 2019 com.rob. All rights reserved.
//

import UIKit



public typealias SRISDelegate = SRISTableViewDelegate

// MARK: - Sorting

public enum SRISTableViewSortingProtocol: String {
    case ascending
    case descending
}

public struct SRISTableViewSorting {
    
    public var key: String
    
    public var sorting: SRISTableViewSortingProtocol
    
    public init(_ sorting: SRISTableViewSortingProtocol, key: String) {
        self.sorting = sorting
        self.key = key
    }
    
}

// MARK: - Delegate

public protocol SRISTableViewDelegate {
    
    /// The content type associated
    associatedtype ContentType where ContentType: Equatable
    
    // MARK: Request Data
    
    /// The class name to request
    var className: String { get }
    
    /// The parameters to add to the request (ex: key == "age", value == 20). Defaults to an empty dictionary
    var filterParameters: [String: Any] { get }
    
    /// The time interval before automatic reload if there is no error cell. Default = 3sec
    var intervalBeforeReload: TimeInterval { get }
    
    /// The ascending or descending request sorting key
    var querySorting: SRISTableViewSorting? { get }
    
    /// The amount of results to load per request
    var recordsPerRequest: Int { get }
    
    // MARK: Result Data
    
    /// The sorting used to display the results
    func displayedResults(fromUnorderedResults unorderedResults: [ContentType]) -> [ContentType]
    
    // MARK: Result Cache
    
    /// Set to true if should cache data fetched from request
    var shouldCacheData: Bool { get }
    
    /// If true, the list will be filled with cached data first.
    var shouldLoadCacheDataFirst: Bool { get }
    
    // MARK: Table View Cells
    
    /// The cell to show if a request fails after the list already filled.
    /// Unnecessary if shouldShowFailedCell = false.
    func failedCell(forTableView tableView: UITableView) -> UITableViewCell!
    
    /// The cell to show after the current list of results if a request is in progress.
    /// Unnecessary if shouldShowLoadingCell = false.
    func loadingCell(forTableView tableView: UITableView) -> UITableViewCell!

    /// The cell to show if no result was found.
    /// Unnecessary if shouldShowNoResultCell = false.shouldShowFailedAfterSomeResultsCell
    func noResultCell(forTableView tableView: UITableView) -> UITableViewCell!
    
    /// The result cell (representing an entry)
    func resultCell(forTableView tableView: UITableView, andObject object: ContentType, atIndexPath indexPath: IndexPath) -> UITableViewCell
    
    // MARK: Table View Delegate
    
    /// Tapped cell event
    func didSelect(object: ContentType)
    
    /// If a request fails: show a specific cell or not to the user.
    /// Defaults to false
    var shouldShowFailedCell: Bool { get }
    
    /// If true, will show a supplementary cell while loading data. Defaults to false.
    /// If true, please implement loadingCell.
    var shouldShowLoadingCell: Bool { get }
    
    /// If true, please also implement noResultCell.
    /// Defaults to false.
    var shouldShowNoResultCell: Bool { get }
    
    /// Table view header height
    var tableHeaderHeight: CGFloat { get }
    
    /// Table view footer height
    var tableFooterHeight: CGFloat { get }
    
    /// Table view row height
    var tableRowHeight: CGFloat { get }
    
}
