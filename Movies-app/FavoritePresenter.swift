//
//  FavoritePresenter.swift
//  Movies-app
//
//  Created by Agustin Daguerre on 7/10/17.
//  Copyright © 2017 agustindaguerre. All rights reserved.
//

import Foundation
import CoreData
import AlamofireImage

class FavoritePresenter {
    private let entityType = "Favorite"
    private var appDelegate: AppDelegate
    private var managedContext: NSManagedObjectContext
    private var favoritesView : FavoritesView?
    
    
    init(appDelegateParam: AppDelegate?) {
        appDelegate = appDelegateParam!
        managedContext = appDelegate.persistentContainer.viewContext
    }
    
    func attachView(view: FavoritesView) {
        favoritesView = view
    }
    
    func toggleFavorite(movieId: Int, isMovie: Bool) -> (saved: Bool, message: String) {
        var result = true
        var message = ""
        let favoriteResult = getFavorite(movieId: movieId)
        
        if let favorite = favoriteResult {
            managedContext.delete(favorite)
            message = "Removed from favorites"
        } else {
            let entity = NSEntityDescription.entity(forEntityName: entityType, in: managedContext)!
            let favorite = NSManagedObject(entity: entity, insertInto: managedContext)
            
            favorite.setValue(movieId, forKeyPath: "movieId")
            favorite.setValue(isMovie, forKeyPath: "isMovie")
            message = "Added to favorites"
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            result = false
            message = "Could not update favorite. Try again"
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        return (result, message)
    }
    
    func getFavorite(movieId: Int) -> Favorite? {
        // fetch request
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityType)
        let predicate = NSPredicate(format: "movieId == %@", NSNumber(value: movieId))
        fetchRequest.predicate = predicate
        
        
        var favorites: [Favorite] = []
        do {
            favorites = try managedContext.fetch(fetchRequest) as! [Favorite]
            print(favorites.count)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return favorites.first
    }
    
    func isFavorite(movieId: Int) -> Bool {
        var result = false
        let favoriteResult = getFavorite(movieId: movieId)
        if ((favoriteResult) != nil) {
            result = true
        }
        return result
    }
    
    func getFavorites() -> [Favorite] {
        // fetch request
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityType)
        var favorites: [Favorite] = []
        do {
            favorites = try managedContext.fetch(fetchRequest) as! [Favorite]
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return favorites
    }
    
    func getFavoriteMovies() {
        let favorites = self.getFavorites()
        if (favorites.isEmpty) {
            self.getFavoriteMoviesClosure(movies: [])
        } else {
            MoviesApi.getFavorites(favorites: favorites, completionHandler: self.getFavoriteMoviesClosure)
        }
    }
    
    func getFavoriteMoviesClosure(movies: [Movie]) {
        if let favoritesViewController = self.favoritesView {
            favoritesViewController.endGettingFavorites(movies: movies)
        }
    }

}

protocol FavoritesView {
    func endGettingFavorites(movies: [Movie])
}

