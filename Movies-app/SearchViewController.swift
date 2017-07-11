
import UIKit
import XLPagerTabStrip
import Alamofire

class SearchViewController: UITableViewController, UISearchBarDelegate, IndicatorInfoProvider {
    var items = [MultiSearchItem]()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    let SEARCH_DETAILS_SEGUE = "searchDetails"
    
    var selectedItem: MultiSearchItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.contentInset = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchInput = searchBar.text
        
        let urlizedInput = searchInput?.replacingOccurrences(of: " ", with: "+")
        
        if urlizedInput != nil {
            MoviesApi.makeMultiSearchWithText(text: urlizedInput!, completionHandler: self.onSearchResultsReceived)
            self.view.endEditing(true)
        }
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Search")
    }
    
    func onSearchResultsReceived(results: [MultiSearchItem]) {
        items = results
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        
        let currentItem = items[indexPath.row]
        
        let imageView = cell?.viewWithTag(2) as! UIImageView
        
        if let poster = currentItem.poster {
            imageView.image = poster
        }
        
        let label = cell?.viewWithTag(1) as! UILabel
        
        let summaryLabel = cell?.viewWithTag(3) as! UILabel
        
        summaryLabel.text = currentItem.summary!
        
        if currentItem.mediaType == "movie" {
            label.text = currentItem.title!
        } else {
            label.text = currentItem.name!
        }
        
        return cell!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SEARCH_DETAILS_SEGUE {
            let movieDetailsController = segue.destination as! MovieDetailsViewController
            movieDetailsController.movieId = selectedItem!.id
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedItem = items[indexPath.row]
        performSegue(withIdentifier: SEARCH_DETAILS_SEGUE, sender: self)
    }
}
