//
//  SRISTableViewDelegate+Extension.swift
//  SRISTableView
//
//  Created by Rob on 19/09/2019.
//  Copyright © 2019 com.rob. All rights reserved.
//

import UIKit



public extension SRISDelegate {
    
    var displaySorting: SRISTableViewSorting? {
        return self.querySorting
    }

    var filterParameters: [String: Any] {
        return [:]
    }
    
    var intervalBeforeReload: TimeInterval {
        return 3.0
    }
    
    var querySorting: SRISTableViewSorting? {
        return nil
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

    var shouldShowNoResultCell: Bool {
        return false
    }
    
    var shouldShowLoadingCell: Bool {
        return false
    }
    
    var shouldLoadCacheDataFirst: Bool {
        return false
    }
    
    var tableHeaderHeight: CGFloat {
        return .leastNormalMagnitude
    }
    
    var tableFooterHeight: CGFloat {
        return .leastNormalMagnitude
    }
    
    var tableRowHeight: CGFloat {
        return UITableView.automaticDimension
    }

}
