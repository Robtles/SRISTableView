//
//  FakeAPITestViewController.swift
//  Example
//
//  Created by Rob on 19/09/2019.
//  Copyright © 2019 com.rob. All rights reserved.
//

import SRISTableView
import UIKit

class FakeAPITestViewController: UIViewController {
    
    var manager: SRISManager<SRISFakeDelegate, SRISFakeRequest>?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.manager = setup(managerForTableView: self.tableView,
                             withLoadMoreOnScrollDelegate: SRISFakeDelegate(),
                             andRequestType: SRISFakeRequest())
    }
    
}


struct SRISFakeDelegate: SRISDelegate {
    
    typealias ContentType = Int
    
    var className: String {
        return ""
    }
    
    func displayedResults(fromUnorderedResults unorderedResults: [Int]) -> [Int] {
        return unorderedResults.sorted()
    }
    
    var recordsPerRequest: Int {
        return 3
    }
    
    var intervalBeforeReload: TimeInterval {
        return 4.0
    }
    
    func resultCell(forTableView tableView: UITableView, andObject object: Int, atIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "fakeCell", for: indexPath) as! FakeCell
        cell.fakeLabel.text = "\(object)"
        return cell
    }
    
    func didSelect<Request>(object: Int, fromManager manager: SRISTableViewManager<SRISFakeDelegate, Request>) where Request : SRISTableViewRequestType {
        print("Did tap \(object)")
    }
    
    var shouldCacheData: Bool {
        return false
    }
    
    var shouldLoadCacheDataFirst: Bool {
        return true
    }
    
    var shouldShowFailedCell: Bool {
        return false
    }
    
    var querySorting: SRISTableViewSorting? {
        return SRISTableViewSorting(.ascending, key: "value")
    }
    
}


final class FakeCell: UITableViewCell {
    
    @IBOutlet weak var fakeLabel: UILabel!
    
}
