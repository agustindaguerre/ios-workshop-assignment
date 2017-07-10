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
            runtimeLabel.text = runtimeMins
        } else {
            runtimeLabel.text = movie.episodeRuntime![0]!
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

    @IBAction func onFavoriteSelect(_ sender: Any) {
        let result = favoritePresenter.toggleFavorite(movieId: movieId!)
        // Show the message.
        setFavoriteIcon()
        messagePresenter.showMessage(success: result.saved, message: result.message)
    }
}
