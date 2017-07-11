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

class TrailersResponse : Mappable {
    var trailers: [Trailer]
    
    required init?(map: Map) {
        trailers = []
    }
    
    func mapping(map: Map) {
        trailers <- map["results"]
    }
}

class Trailer : Mappable {
    var site: String?
    var key: String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        site <- map["site"]
        key <- map["key"]
    }
}
