
import UIKit
import XLPagerTabStrip
import AlamofireImage
import Alamofire
import SwiftMessages

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, HomeView, IndicatorInfoProvider {
    
    @IBOutlet weak var tableViewMovies: UITableView!
    
    let cellIdentifier = "cellId"
    var movies: [Movie] = []
    var selectedMovie: Movie?
    private let presenter = HomePresenter()
    private let favoritePresenter = FavoritePresenter(appDelegateParam: UIApplication.shared.delegate as? AppDelegate)
    private let messagePresenter = MessagePresenter()
    
    override func viewDidLoad() {
        self.navigationController?.setToolbarHidden(true, animated: false)
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
        cell!.selectionStyle = .none
        
        cell!.viewContainer.layer.cornerRadius = 2.0
        
        let movie = movies[indexPath.row]
        // Set title
        cell!.labelTitle.text = movie.title!
            
        //Set image
        let image = movie.poster!
        let size = CGSize(width: 90, height: 115)
            
        // Scale image to size disregarding aspect ratio
        let scaledImage = image.af_imageScaled(to: size)
        cell!.imagePoster.image = scaledImage
        
        //Set score
        cell!.scoreLabel.text = "\(movie.voteAverage!) / 10"
        
        //Set votes count
        cell!.votesCountLabel.text = "(\(movie.voteCount!) votes)"
        setFavoriteIcon(movieId: movie.id!, button: cell!.favButton)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedMovie = movies[indexPath.row]
        performSegue(withIdentifier: "movieDetails", sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150;
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.navigationController?.setToolbarHidden(false, animated: false)
        if segue.identifier == "movieDetails" {
            let movieDetailsController = segue.destination as! MovieDetailsViewController
            movieDetailsController.movieId = selectedMovie!.id
        }
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
    
    @IBAction func onFavSelected(_ sender: Any) {
        let button = sender as! UIButton
        let movieId = button.tag
        let result = favoritePresenter.toggleFavorite(movieId: movieId)
        // Show the message.
        setFavoriteIcon(movieId: movieId, button: button)
    }
}
