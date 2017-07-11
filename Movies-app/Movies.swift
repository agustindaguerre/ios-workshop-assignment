//
//  Movies.swift
//  Movies-app
//
//  Created by Agustin Daguerre on 7/6/17.
//  Copyright © 2017 agustindaguerre. All rights reserved.
//

import Foundation
import ObjectMapper
import AlamofireImage

class MoviesResponse : Mappable {
    var movies: [Movie]
    
    required init?(map: Map) {
        movies = []
    }
    
    func mapping(map: Map) {
        movies <- map["results"]
    }
}

class Movie : Mappable {
    var id: Int?
    var title: String?
    var name: String?
    var posterPath: String?
    var backdropPath: String?
    var backdropImage: Image?
    var poster: Image?
    var plot: String?
    var runtime: Int?
    var releaseDate: String?
    var genres: [Genre]
    var voteAverage: Float?
    var voteCount: Int?
    var episodeRuntime: [Int?]

    required init?(map: Map) {
        genres = []
        episodeRuntime = []
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        name <- map["name"]
        posterPath <- map["poster_path"]
        plot <- map["overview"]
        runtime <- map["runtime"]
        releaseDate <- map["release_date"]
        genres <- map["genres"]
        voteAverage <- map["vote_average"]
        voteCount <- map["vote_count"]
        backdropPath <- map["backdrop_path"]
        episodeRuntime <- map["episode_run_time"]
    }
}

class Genre : Mappable {
    var id: Int?
    var name: String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
    }
}
