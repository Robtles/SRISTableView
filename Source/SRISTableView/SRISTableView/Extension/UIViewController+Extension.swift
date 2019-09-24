//
//  UIViewController+Extension.swift
//  SRISTableView
//
//  Created by Rob on 24/09/2019.
//  Copyright © 2019 com.rob. All rights reserved.
//

import UIKit



public extension UIViewController {

    func setup<Delegate: SRISDelegate, Request: SRISRequest>(managerForTableView tableView: UITableView, withLoadMoreOnScrollDelegate loadMoreOnScrollDelegate: Delegate, andRequestType requestType: Request) -> SRISManager<Delegate, Request> {
        let manager = SRISTableViewManager<Delegate, Request>()
        manager.loadMoreOnScrollDelegate = loadMoreOnScrollDelegate
        manager.loadMoreOnScrollRequest = requestType
        manager.tableView = tableView
        manager.callingViewController = self
        manager.start()
        return manager
    }

}
