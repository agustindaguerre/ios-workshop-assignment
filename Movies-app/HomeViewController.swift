
import UIKit
import XLPagerTabStrip
import AlamofireImage
import Alamofire

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, HomeView, IndicatorInfoProvider {
    
    @IBOutlet weak var tableViewMovies: UITableView!
    
    let cellIdentifier = "cellId"
    var movies: [Movie] = []
    var selectedItem: [String: Any]!
    private let presenter = HomePresenter()
    
    
    override func viewDidLoad() {
        tableViewMovies.dataSource = self
        tableViewMovies.delegate = self
        presenter.attachView(view: self)
        presenter.getPlayingMovies()
    }
    
    func endGettingPlayingMovies(movies: [Movie]) {
        self.movies = movies
        tableViewMovies.reloadData()
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Home")//, image: UIImage(named: "i_home"))
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? HomeTableViewCell
        if cell == nil {
            cell = HomeTableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        }
        
        let movie = movies[indexPath.row]
        if let title = movie.title {
            // Set title
            cell!.labelTitle.text = title
            
            //Set image
            let image = movie.poster!
            let size = CGSize(width: 100.0, height: 123.5)
            
            // Scale image to size disregarding aspect ratio
            let scaledImage = image.af_imageScaled(to: size)
            cell!.imagePoster.image = scaledImage
            
            //Set plot
            cell!.labelPlot.text = movie.plot!
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        selectedItem = data[indexPath.row]
//        performSegue(withIdentifier: "detailSegue", sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150;
    }
    
    
}
