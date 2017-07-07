
import UIKit
import XLPagerTabStrip

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, HomeView, IndicatorInfoProvider {
    
    @IBOutlet weak var tableViewMovies: UITableView!
    
    let cellIdentifier = "cellId"
    var data: [Movie] = []
    var selectedItem: [String: Any]!
    private let presenter = HomePresenter()
    
    
    override func viewDidLoad() {
        tableViewMovies.dataSource = self
        tableViewMovies.delegate = self
        presenter.attachView(view: self)
        presenter.getPlayingMovies()
    }
    
    func endGettingPlayingMovies(movies: [Movie]) {
        data = movies
        tableViewMovies.reloadData()
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Home")//, image: UIImage(named: "i_home"))
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        }
        
        let movie = data[indexPath.row]
        if let title = movie.title {
            cell!.textLabel?.text = "Title: \(title)"
        }
        cell!.textLabel?.font = UIFont.systemFont(ofSize: 14)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        selectedItem = data[indexPath.row]
//        performSegue(withIdentifier: "detailSegue", sender: self)
    }
    
    
}
