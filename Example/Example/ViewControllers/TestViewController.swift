//
//  TestViewController.swift
//  Example
//
//  Created by Rob on 20/09/2019.
//  Copyright © 2019 com.rob. All rights reserved.
//

import Parse
import UIKit
import SRISTableView



final class TestViewController: UIViewController {
    var manager: SRISManager<NewsFeedDelegate, NewsFeedRequest>?
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.manager = setup(managerForTableView: self.tableView,
                             withLoadMoreOnScrollDelegate: NewsFeedDelegate(),
                             andRequestType: NewsFeedRequest())
    }
}

struct NewsFeedDelegate: SRISDelegate {

    typealias ContentType = String

    var className: String {
        return "NewsFeed" // The data class name
    }
    
    var recordsPerRequest: Int {
        return 10 // The amount of results to load per request
    }
    
    func displayedResults(fromUnorderedResults unorderedResults: [String]) -> [String] {
        return unorderedResults.sorted() // How to sorted the data to be displayed
    }
    
    var shouldCacheData: Bool {
        return false
    }
    
    func resultCell(forTableView tableView: UITableView, andObject object: String, atIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsFeedCell", for: indexPath)
        cell.textLabel?.text = object
        return cell
    }
    
    func didSelect<Request>(object: String, fromManager manager: SRISTableViewManager<NewsFeedDelegate, Request>) where Request : SRISTableViewRequestType {
        print("Did tap: \(object)")
    }
    
    var shouldShowFailedCell: Bool {
        return false
    }
    
}

struct NewsFeedRequest: SRISRequest {
    
    // We expect the API to return String objects
    typealias ContentType = String
    
    func load<Delegate>(delegate: Delegate, skipping: Int, cachingData: Bool, _ completion: @escaping ([String]?, Error?) -> ()) where Delegate : SRISDelegate {
    }
    
}
