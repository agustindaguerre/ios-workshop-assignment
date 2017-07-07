//
//  HomePresenter.swift
//  Movies-app
//
//  Created by Agustin Daguerre on 7/1/17.
//  Copyright © 2017 agustindaguerre. All rights reserved.
//

import Foundation
import CoreData

class HomePresenter {
    private var homeView : HomeView?
    
    func attachView(view: HomeView) {
        homeView = view
    }
    
    func getPlayingMovies() {
        MoviesApi.getPlayingMovies(completionHandler: self.getPlayingMoviewClosure);
    }
    
    func getPlayingMoviewClosure(movies: [Movie]) {
        if let homeViewController = self.homeView {
            homeViewController.endGettingPlayingMovies(movies: movies)
        }
    }
    
}

protocol HomeView {
    func endGettingPlayingMovies(movies: [Movie])
}

