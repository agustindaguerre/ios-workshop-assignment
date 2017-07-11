
import UIKit
import XLPagerTabStrip
import Alamofire
import DZNEmptyDataSet

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, IndicatorInfoProvider {
    let cellIdentifier = "searchCell"
    var items = [MultiSearchItem]()
    
    @IBOutlet weak var resultsTable: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let SEARCH_DETAILS_SEGUE = "searchDetails"
    private let favoritePresenter = FavoritePresenter(appDelegateParam: UIApplication.shared.delegate as? AppDelegate)
    
    var selectedItem: MultiSearchItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultsTable.dataSource = self
        resultsTable.delegate = self
        searchBar.delegate = self
        searchBar.showsScopeBar = true
        self.prepareEmptyDataSet()
//        self.tableView.contentInset = UIEdgeInsets(top: 70, left: 30, bottom: 30, right: 30)
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
        resultsTable.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = resultsTable.dequeueReusableCell(withIdentifier: cellIdentifier) as? HomeTableViewCell
        if cell == nil {
            cell = HomeTableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        }
        cell!.selectionStyle = .none
        
        cell!.viewContainer.layer.cornerRadius = 2.0
        
        let item = items[indexPath.row]
        // Set title
        if let movieTitle = item.title {
            cell!.labelTitle.text = movieTitle
        }
        
        if let seriesTitle = item.name {
            cell!.labelTitle.text = seriesTitle
        }
        
        //Set image
        if let image = item.poster {
            let size = CGSize(width: 90, height: 115)
            
            // Scale image to size disregarding aspect ratio
            let scaledImage = image.af_imageScaled(to: size)
            cell!.imagePoster.image = scaledImage
        } else {
            cell!.imagePoster.image = UIImage.init(icon: .emoji(.television), size: CGSize(width: 30, height: 30))
        }
        
        //Set score
        cell!.scoreLabel.text = "\(item.voteAverage!) / 10"
        
        //Set votes count
        cell!.votesCountLabel.text = "(\(item.voteCount!) votes)"
        setFavoriteIcon(movieId: item.id!, button: cell!.favButton)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150;
    }
    
    func setFavoriteIcon(movieId: Int, button: UIButton) {
        let isFavorite = favoritePresenter.isFavorite(movieId: movieId)
        if (isFavorite) {
            button.setIcon(icon: .googleMaterialDesign(.star), iconSize: 40, color: .yellow, forState: .normal)
        } else {
            button.setIcon(icon: .googleMaterialDesign(.starBorder), iconSize: 40, color: .yellow, forState: .normal)
        }
        button.tag = movieId
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SEARCH_DETAILS_SEGUE {
            let movieDetailsController = segue.destination as! MovieDetailsViewController
            if selectedItem!.mediaType == "movie" {
                movieDetailsController.movieId = selectedItem!.id
            } else {
                movieDetailsController.seriesId = selectedItem!.id
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedItem = items[indexPath.row]
        performSegue(withIdentifier: SEARCH_DETAILS_SEGUE, sender: self)
    }
    
    @IBAction func favButton(_ sender: Any) {
        let button = sender as! UIButton
        let movieId = button.tag
        let favSelectedMovie = items.first { movie in
            return movie.id == movieId
        }
        let isMovie = favSelectedMovie!.name == nil
        favoritePresenter.toggleFavorite(movieId: movieId, isMovie: isMovie)
        // Show the message.
        setFavoriteIcon(movieId: movieId, button: button)
    }
}

extension SearchViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "i_search")
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let attributes = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 16)]
        
        return NSAttributedString(string: "No recent searchs", attributes: attributes)
    }
    
    func prepareEmptyDataSet() {
        resultsTable.emptyDataSetSource = self
        resultsTable.emptyDataSetDelegate = self
        resultsTable.tableFooterView = UIView()
    }
}
