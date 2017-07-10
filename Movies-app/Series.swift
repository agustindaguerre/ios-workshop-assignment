
import Foundation
import ObjectMapper
import AlamofireImage

class SeriesResponse : Mappable {
    var series: [Serie]
    
    required init?(map: Map) {
        series = []
    }
    
    func mapping(map: Map) {
        series <- map["results"]
    }
}

class Serie : Mappable {
    var id: Int?
    var name: String?
    var posterPath: String?
    var poster: Image?
    var summary: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        posterPath <- map["poster_path"]
        summary <- map["summary"]
    }
}
