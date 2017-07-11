
import UIKit
import XLPagerTabStrip
import DZNEmptyDataSet

class FavoritesViewController: UIViewController, IndicatorInfoProvider, UITableViewDelegate, UITableViewDataSource, FavoritesView, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    @IBOutlet weak var tableViewFavorites: UITableView!
    
    let cellIdentifier = "cellId"
    var movies: [Movie] = []
    var selectedMovie: Movie?
    private let favoritePresenter = FavoritePresenter(appDelegateParam: UIApplication.shared.delegate as? AppDelegate)
    private let messagePresenter = MessagePresenter()
    
    override func viewWillAppear(_ animated: Bool) {
        favoritePresenter.getFavoriteMovies()
    }
    
    override func viewDidLoad() {
        tableViewFavorites.dataSource = self
        tableViewFavorites.delegate = self
        tableViewFavorites.emptyDataSetSource = self
        tableViewFavorites.emptyDataSetDelegate = self
        favoritePresenter.attachView(view: self)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let font = UIFont(name: "Helvetica", size: 16)
        let color = UIColor.white
        let attr = [NSFontAttributeName: font, NSStrokeColorAttributeName: color]
        return NSAttributedString(string: "No movies or series added to favorites", attributes: attr)
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Favorites")//, image: UIImage(named: "i_favorites"))
    }
    
    func endGettingFavorites(movies: [Movie]) {
        self.movies = movies
        tableViewFavorites.reloadData()
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
        if let movieTitle = movie.title {
            cell!.labelTitle.text = movieTitle
        }
        
        if let seriesName = movie.name {
            cell!.labelTitle.text = seriesName
        }
        
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
        performSegue(withIdentifier: "favoriteDetails", sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150;
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "favoriteDetails" {
            let movieDetailsController = segue.destination as! MovieDetailsViewController
            if (selectedMovie?.title) != nil {
                movieDetailsController.movieId = selectedMovie!.id
            } else {
                movieDetailsController.seriesId = selectedMovie!.id
            }
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
        let favSelectedMovie = movies.first { movie in
            return movie.id == movieId
        }
        let isMovie = favSelectedMovie!.name == nil
        favoritePresenter.toggleFavorite(movieId: movieId, isMovie: isMovie)
        // Show the message.
        setFavoriteIcon(movieId: movieId, button: button)
    }
}
