//
//  ParseTestViewController.swift
//  Example
//
//  Created by Rob on 19/09/2019.
//  Copyright © 2019 com.rob. All rights reserved.
//

import Parse
import SRISTableView
import UIKit

class ParseTestViewController: UIViewController {
    
    var manager: SRISManager<SRISParseTestDelegate, SRISParseRequest>?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.manager = setup(managerForTableView: self.tableView,
                             withLoadMoreOnScrollDelegate: SRISParseTestDelegate(),
                             andRequestType: SRISParseRequest())
    }
    
}

struct SRISParseTestDelegate: SRISDelegate {
    
    typealias ContentType = PFObject
    
    var className: String {
        return "YourClassName"
    }
    
    func displayedResults(fromUnorderedResults unorderedResults: [PFObject]) -> [PFObject] {
        return unorderedResults
    }
    
    var recordsPerRequest: Int {
        return 15
    }
    
    func resultCell(forTableView tableView: UITableView, andObject object: PFObject, atIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath)
        cell.textLabel?.text = object["title"] as? String ?? "No title for this object."
        return cell
    }
    
    func didSelect<Request>(object: PFObject, fromManager manager: SRISTableViewManager<SRISParseTestDelegate, Request>) where Request : SRISTableViewRequestType {}
    
    var parameters: [String : Any] {
        return [:]
    }
    
    var shouldShowNoResultCell: Bool {
        return false
    }
    
    var shouldCacheData: Bool {
        return false
    }
    
    var shouldShowFailedCell: Bool {
        return false
    }
    
    var shouldShowLoadingCell: Bool {
        return true
    }
    
    func failedCell(forTableView tableView: UITableView) -> UITableViewCell! {
        return tableView.dequeueReusableCell(withIdentifier: "failedCellWithResults")
    }
    
    func noResultCell(forTableView tableView: UITableView) -> UITableViewCell! {
        return tableView.dequeueReusableCell(withIdentifier: "noResultCell")
    }
    
    func loadingCell(forTableView tableView: UITableView) -> UITableViewCell! {
        return tableView.dequeueReusableCell(withIdentifier: "loadingCell") as! SpinnerCell
    }
    
}


final class SpinnerCell: UITableViewCell {
    
    @IBOutlet weak var spinner: UIActivityIndicatorView?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        if let spinner = self.spinner {
            spinner.startAnimating()
        }
    }
    
}
