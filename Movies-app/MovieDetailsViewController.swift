//
//  MovieDetailsViewController.swift
//  Movies-app
//
//  Created by Agustin Daguerre on 7/9/17.
//  Copyright © 2017 agustindaguerre. All rights reserved.
//

import UIKit
import SwiftMessages
import SwiftIcons

class MovieDetailsViewController: UIViewController, MovieDetailsView {
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var socialShare: UIButton!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var runtimeLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var plotLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var scoreIcon: UILabel!
    @IBOutlet weak var favButton: UIButton!
    
    var movieId: Int?
    var seriesId: Int?
    var movie: Movie?
    
    private let movieDetailPresenter = MovieDetailsPresenter()
    private let favoritePresenter = FavoritePresenter(appDelegateParam: UIApplication.shared.delegate as? AppDelegate)
    private let messagePresenter = MessagePresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        movieDetailPresenter.attachView(view: self)
        if let movieIntId = movieId {
            movieDetailPresenter.getMovieDetails(movieId: movieIntId)
        } else {
            movieDetailPresenter.getSeriesDetails(seriesId: seriesId!)
        }
    }
    
    func endGettingMovieDetails(movie: Movie) {
        self.movie = movie
        if let movieTitle = movie.title {
            titleLabel.text = movieTitle
        } else {
            titleLabel.text = movie.name!
        }
        
        
        //Set poster
        
        if let image = movie.poster {
            let size = CGSize(width: 133, height: 184)
            
            let scaledImage = image.af_imageScaled(to: size)
            posterImage.image = scaledImage
        }
        
        //Set bakcground
        
        if let backdropImage = movie.backdropImage {
            let bckSize = backgroundImage.frame.size
            let scaledBckImage = backdropImage.af_imageScaled(to: bckSize)
            backgroundImage.image = scaledBckImage
        }
        
        let releaseDate = movie.releaseDate!
        let releaseYear = releaseDate.characters.split(separator: "-").map(String.init).first!
        yearLabel.text = "(\(releaseYear))"
        
        let genres = movie.genres.map { genre in
            genre.name!
        }
        
        let genresString = genres.reduce("", { x, y in
            if (x.isEmpty) {
                return "\(y)"
            } else {
                return "\(x), \(y)"
            }
        })
        
        if let runtimeMins = movie.runtime {
            runtimeLabel.text = "\(runtimeMins) mins"
        } else {
            runtimeLabel.text = "\(movie.episodeRuntime[0]!) mins"
        }
        
        genresLabel.text = genresString
        plotLabel.text = movie.plot!
        scoreLabel.text = "\(movie.voteAverage!) / 10"
        scoreIcon.text = "⭐️"
        setFavoriteIcon()
    }
    
    func setFavoriteIcon() {
        let isFavorite = favoritePresenter.isFavorite(movieId: movieId!)
        if (isFavorite) {
            favButton.setIcon(icon: .googleMaterialDesign(.star), iconSize: 30, color: .yellow, forState: .normal)
        } else {
            favButton.setIcon(icon: .googleMaterialDesign(.starBorder), iconSize: 30, color: .yellow, forState: .normal)
        }
    }
    
    func endGettingTrailer(trailer: Trailer) {
        let urlString = "https://www.youtube.com/watch?v=\(trailer.key!)"
        let urlWhats = "whatsapp://send?text=\(urlString)"
        
        if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) {
            if let whatsappURL = NSURL(string: urlString) {
                if UIApplication.shared.canOpenURL(whatsappURL as URL) {
//                    UIApplication.shared.openURL(whatsappURL as URL)
                    UIApplication.shared.open(whatsappURL as URL, options: [:])
                } else {
                    let alert = UIAlertController(title: "Alert", message: "Whatsapp not installed", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }

    @IBAction func shareLink(_ sender: Any) {
        if let movieIdInt = movieId {
            movieDetailPresenter.getTrailer(showId: movieIdInt, isMovie: true)
        } else {
            movieDetailPresenter.getTrailer(showId: seriesId!, isMovie: false)
        }
    }
    
    @IBAction func onFavoriteSelect(_ sender: Any) {
        var result : (saved: Bool, message: String)
        if let movieIdInt = movieId {
            result = favoritePresenter.toggleFavorite(movieId: movieIdInt, isMovie: true)
        } else {
            result = favoritePresenter.toggleFavorite(movieId: seriesId!, isMovie: false)
        }
        // Show the message.
        setFavoriteIcon()
        messagePresenter.showMessage(success: result.saved, message: result.message)
    }
}
