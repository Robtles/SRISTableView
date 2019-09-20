# SRISTableView *(SRInfiniteScrollingTableView)*
SRISTableView is a library helping developers implementing infinite scrollable `UITableViews`, like Facebook or Twitter newsfeeds.

## Installation
### Manually
Simply clone the project on your computer, and add the files under `Source/SRISTableView` in your project.

### CocoaPods
Just add this line in your Podfile: 
`pod 'SRISTableView'`

## How to use
Let's say you already have a `UIViewController`, containing a `UITableView`, and you want to make this table view infinitely scrollable.

    final class TestViewController: UIViewController {
        @IBOutlet weak var tableView: UITableView!
    }
    
You will only need three things (actually, only two):

**A Delegate Type** (`SRISDelegate`)

A custom type conforming to `SRISDelegate`, acting like a delegate for your table view. 
This delegate will handle the following things:
 - Declare a generic `ContentType`
 - Fill the request data (`className`, `filterParameters`, `sorting`, `recordsPerRequest`...)
 - Sort the result data
 - Handle the cache
 - Design the different expected cells (`resultCell`, `failedCell`, `noResultCell`...)
 - Basic table view delegate methods and properties (`didSelect()`, `tableRowHeight`...)

**Request Type** (`SRISRequest`)

Another custom type conforming to `SRISRequest`, where you define your API call and the expected completion. 
If needed, you can also declare a call handling the cache.

**Manager** (`SRISManager`)

The object that will mix a `SRISDelegate` and a `SRISRequest`, and will be linked to your table view.

## Example
Let's say we want to create a newsfeed, using data from a fictitious API. 
A simple table view, without using any cache data. We only want to display simple `String` objects.

**The request type**

    func load<Delegate>(delegate: Delegate, skipping: Int, cachingData: Bool, _ completion: @escaping ([String]?, Error?) -> ()) where Delegate : SRISDelegate {
        var query = TestQuery(clasName: delegate.className) // The class name, for example "NewsFeed"
        delegate.filterParameters.forEach { key, value in
            query.whereKey(key, equalTo: value)
        }
        query.limit = delegate.recordsPerRequest // The limit of results per request
        query.skipping = skipping // The number of results to skip
        // Fetching data
        query.fetchData { (result, error) in 
            completion(result, error)
        }
    }
    
**The delegate**

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
    
        func didSelect(object: String) {
            // Equivalent of didSelectRow(atIndexPath)
        }
    
        var shouldShowFailedCell: Bool {
            return false
        }
    }
    
**The manager**

    final class TestViewController: UIViewController {
        var manager: SRISManager<NewsFeedDelegate, NewsFeedRequest>?
        @IBOutlet weak var tableView: UITableView!
    
        override func viewDidLoad() {
            super.viewDidLoad()
            self.manager = SRISManager.setupAndStart(inTableView: self.tableView,
                                                     withLoadMoreOnScrollDelegate: NewsFeedDelegate(),
                                                     andRequestType: NewsFeedRequest())
        }
    }
    
And... voilà!

## License
SRISTableView is released under the MIT license. See LICENSE for details.
