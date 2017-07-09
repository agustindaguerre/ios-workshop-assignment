//
//  MovieDetailsViewController.swift
//  Movies-app
//
//  Created by Agustin Daguerre on 7/9/17.
//  Copyright © 2017 agustindaguerre. All rights reserved.
//

import UIKit

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
    
    var movieId: Int?
    var movie: Movie?
    
    private let presenter = MovieDetailsPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.attachView(view: self)
        presenter.getMovieDetails(movieId: movieId!)
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
    }

}
