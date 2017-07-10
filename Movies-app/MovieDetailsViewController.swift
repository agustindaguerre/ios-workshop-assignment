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
    var movie: Movie?
    
    private let movieDetailPresenter = MovieDetailsPresenter()
    private let favoritePresenter = FavoritePresenter(appDelegateParam: UIApplication.shared.delegate as? AppDelegate)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        movieDetailPresenter.attachView(view: self)
        movieDetailPresenter.getMovieDetails(movieId: movieId!)
    }
    
    func endGettingMovieDetails(movie: Movie) {
        self.movie = movie
        titleLabel.text = movie.title!
        
        //Set poster
        let image = movie.poster!
        let size = CGSize(width: 133, height: 184)
        
        // Scale image to size disregarding aspect ratio
        let scaledImage = image.af_imageScaled(to: size)
        posterImage.image = scaledImage
        
        //Set bakcground
        let bckImage = movie.backdropImage!
        let bckSize = backgroundImage.frame.size
        
        // Scale image to size disregarding aspect ratio
        let scaledBckImage = bckImage.af_imageScaled(to: bckSize)
        backgroundImage.image = scaledBckImage
        
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
        
        genresLabel.text = genresString
        runtimeLabel.text = "\(movie.runtime!) min"
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
        let view = MessageView.viewFromNib(layout: .CardView)
        var config = SwiftMessages.Config()
        config.dimMode = .gray(interactive: true)
        config.duration = .seconds(seconds: 1.5)
        view.button = nil
        
        // Add a drop shadow.
        view.configureDropShadow()
        
        if (result.saved) {
            // Theme message elements with the warning style.
            view.configureTheme(.success)
            let iconText = "✅"
            view.configureContent(title: "Success!", body: result.message, iconText: iconText)
            // Specify one or more event listeners to respond to show and hide events.
        } else {
            // Theme message elements with the warning style.
            view.configureTheme(.error)
            let iconText = "❌"
            view.configureContent(title: "Error", body: result.message, iconText: iconText)
        }
        
        // Show the message.
        setFavoriteIcon()
        SwiftMessages.show(config: config, view: view)
    }
}
