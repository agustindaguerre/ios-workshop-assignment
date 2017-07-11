//
//  HomePresenter.swift
//  Movies-app
//
//  Created by Agustin Daguerre on 7/1/17.
//  Copyright © 2017 agustindaguerre. All rights reserved.
//

import Foundation
import CoreData
import AlamofireImage

class MovieDetailsPresenter {
    private var movieDetailsView : MovieDetailsView?
    
    func attachView(view: MovieDetailsView) {
        movieDetailsView = view
    }
    
    func getMovieDetails(movieId: Int) {
        MoviesApi.getMovieDetails(movieId: movieId, completionHandler: self.getMovieDetailClosure);
    }
    
    func getSeriesDetails(seriesId: Int) {
        MoviesApi.getSeriesDetails(seriesId: seriesId, completionHandler: self.getMovieDetailClosure);
    }
    
    func getTrailer(showId: Int, isMovie: Bool) {
        MoviesApi.getMovieTrailer(showId: showId, isMovie: isMovie, completionHandler: self.getTrailerClosure)
    }
    
    func getTrailerClosure(trailer: Trailer) {
        if let movieDetailsViewController = self.movieDetailsView {
            movieDetailsViewController.endGettingTrailer(trailer: trailer)
        }
    }
    
    func getMovieDetailClosure(movie: Movie) {
        if let movieDetailsViewController = self.movieDetailsView {
            movieDetailsViewController.endGettingMovieDetails(movie: movie)
        }
    }
}

protocol MovieDetailsView {
    func endGettingMovieDetails(movie: Movie)
    func endGettingTrailer(trailer: Trailer)
}

