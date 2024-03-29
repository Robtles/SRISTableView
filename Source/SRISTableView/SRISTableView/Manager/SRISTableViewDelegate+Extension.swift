//
//  SRISTableViewDelegate+Extension.swift
//  SRISTableView
//
//  Created by Rob on 19/09/2019.
//  Copyright © 2019 com.rob. All rights reserved.
//

import UIKit



public extension SRISDelegate {
    
    var filterParameters: [SRISTableViewFilter] {
        return []
    }
    
    var intervalBeforeReload: TimeInterval {
        return 3.0
    }
    
    var querySorting: [SRISTableViewSorting] {
        return []
    }
    
    func failedCell(forTableView tableView: UITableView) -> UITableViewCell! {
        if self.shouldShowFailedCell {
            fatalError("Error: failedAfterSomeResultsCell was not implemented.")
        } else {
            return nil
        }
    }
    
    func loadingCell(forTableView tableView: UITableView) -> UITableViewCell! {
        if self.shouldShowLoadingCell {
            fatalError("Error: loadingCell was not implemented.")
        } else {
            return nil
        }
    }
    
    func noResultCell(forTableView tableView: UITableView) -> UITableViewCell! {
        if self.shouldShowNoResultCell {
            fatalError("Error: noResultCell was not implemented.")
        } else {
            return nil
        }
    }
    
    func editActions<Request: SRISRequest>(forObject object: ContentType, fromManager manager: SRISManager<Self, Request>) -> [UITableViewRowAction]? {
        return nil
    }

    var shouldShowNoResultCell: Bool {
        return false
    }
    
    var shouldShowLoadingCell: Bool {
        return false
    }
    
    var shouldLoadCacheDataFirst: Bool {
        return false
    }
    
    var shouldTryReloadOnNoResult: Bool {
        return false
    }
    
    func tableHeaderHeight(withCurrentResults currentResults: [ContentType], forTableView tableView: UITableView) -> CGFloat? {
        return .leastNormalMagnitude
    }
        
    func tableFooterHeight(withCurrentResults currentResults: [ContentType], forTableView tableView: UITableView) -> CGFloat? {
        return .leastNormalMagnitude
    }
    
    func tableResultRowHeight(withCurrentResults currentResults: [ContentType], forTableView tableView: UITableView) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableNoResultRowHeight(withCurrentResults currentResults: [ContentType], forTableView tableView: UITableView) -> CGFloat {
        return self.tableResultRowHeight(withCurrentResults: currentResults, forTableView: tableView)
    }
    
    func tableFailedRowHeight(withCurrentResults currentResults: [ContentType], forTableView tableView: UITableView) -> CGFloat {
        return self.tableResultRowHeight(withCurrentResults: currentResults, forTableView: tableView)
    }
    
    func tableLoadingRowHeight(withCurrentResults currentResults: [ContentType], forTableView tableView: UITableView) -> CGFloat {
        return self.tableResultRowHeight(withCurrentResults: currentResults, forTableView: tableView)
    }
    
}
