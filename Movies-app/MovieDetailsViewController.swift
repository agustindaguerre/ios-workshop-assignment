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
    
    var movieId: Int?
    private let presenter = MovieDetailsPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.attachView(view: self)
        presenter.getMovieDetails(movieId: movieId!)
    }
    
    func endGettingMovieDetails(movie: Movie) {
        //        titleLabel.numberOfLines = 1;
        //        titleLabel. = 11;
        //        titleLabel.adjustsFontSizeToFitWidth = true;
        titleLabel.text = movie.title!
        
        posterImage.image = movie.poster!
        let releaseDate = movie.releaseDate!
        let releaseYear = releaseDate.characters.split(separator: "-").map(String.init).first!
        yearLabel.text = "(\(releaseYear))"
    }

}
