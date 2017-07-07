//
//  Movies.swift
//  Movies-app
//
//  Created by Agustin Daguerre on 7/6/17.
//  Copyright © 2017 agustindaguerre. All rights reserved.
//

import Foundation
import ObjectMapper

class MoviesResponse : Mappable {
    var movies: [Movie]
    
    required init?(map: Map){
        movies = []
    }
    
    func mapping(map: Map) {
        movies <- map["results"]
    }
}

class Movie : Mappable {
    var id: Int?
    var title: String?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
    }
}
