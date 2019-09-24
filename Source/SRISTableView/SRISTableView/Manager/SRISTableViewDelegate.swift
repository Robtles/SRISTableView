//
//  SRISTableViewDelegate.swift
//  SRISTableView
//
//  Created by Rob on 19/09/2019.
//  Copyright © 2019 com.rob. All rights reserved.
//

import UIKit



public typealias SRISDelegate = SRISTableViewDelegate

// MARK: - Filter

public enum SRISTableViewFilterProtocol {
    case containedIn
    case containsString
    case equalTo
    case greaterThan
    case greaterThanOrEqual
    case keyDoesNotExists
    case keyExists
    case lessThan
    case lessThanOrEqual
    case notContainedIn
    case notEqualTo
}

public struct SRISTableViewFilter {
    
    public var condition: SRISTableViewFilterProtocol
    
    public var key: String
    
    public var value: Any
    
    public init(whereKey key: String, _ condition: SRISTableViewFilterProtocol, value: Any) {
        self.condition = condition
        self.key = key
        self.value = value
    }
    
}

// MARK: - Sorting

public enum SRISTableViewSortingProtocol {
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
    var filterParameters: [SRISTableViewFilter] { get }
    
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
    func didSelect<Request: SRISRequest>(object: ContentType, fromManager manager: SRISManager<Self, Request>)
    
    /// The edit actions available for a given object
    func editActions<Request: SRISRequest>(forObject object: ContentType, fromManager manager: SRISManager<Self, Request>) -> [UITableViewRowAction]?
    
    /// If a request fails: show a specific cell or not to the user.
    /// Defaults to false
    var shouldShowFailedCell: Bool { get }
    
    /// If true, will show a supplementary cell while loading data. Defaults to false.
    /// If true, please implement loadingCell.
    var shouldShowLoadingCell: Bool { get }
    
    /// If true, please also implement noResultCell.
    /// Defaults to false.
    var shouldShowNoResultCell: Bool { get }
    
    /// If true, tapping the cell if no result will try to reload data
    var shouldTryReloadOnNoResult: Bool { get }
    
    /// Table view header height
    func tableHeaderHeight(withCurrentResults currentResults: [ContentType], forTableView tableView: UITableView) -> CGFloat?
    
    /// Table view footer height
    func tableFooterHeight(withCurrentResults currentResults: [ContentType], forTableView tableView: UITableView) -> CGFloat?
    
    /// Table view result row height
    func tableResultRowHeight(withCurrentResults currentResults: [ContentType], forTableView tableView: UITableView) -> CGFloat
    
    /// Table view no result row height
    func tableNoResultRowHeight(withCurrentResults currentResults: [ContentType], forTableView tableView: UITableView) -> CGFloat
    
    /// Table view failed row height
    func tableFailedRowHeight(withCurrentResults currentResults: [ContentType], forTableView tableView: UITableView) -> CGFloat
    
    /// Table view loading row height
    func tableLoadingRowHeight(withCurrentResults currentResults: [ContentType], forTableView tableView: UITableView) -> CGFloat
    
}
