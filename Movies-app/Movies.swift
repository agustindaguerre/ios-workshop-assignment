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
    var posterPath: String?
    var poster: Image?
    var plot: String?
    var runtime: Int?
    var releaseDate: String?

    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        posterPath <- map["poster_path"]
        plot <- map["overview"]
        runtime <- map["runtime"]
        releaseDate <- map["release_date"]
    }
}
