import Foundation
import ObjectMapper
import AlamofireImage

class MultiSearchResponse : Mappable {
    var multiSearchItems: [MultiSearchItem]
    
    required init?(map: Map) {
        multiSearchItems = []
    }
    
    func mapping(map: Map) {
        multiSearchItems <- map["results"]
    }
}

class MultiSearchItem : Mappable {
    var id: Int?
    var name: String?
    var title: String?
    var mediaType: String?
    var posterPath: String?
    var poster: Image?
    var summary: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        title <- map["title"]
        mediaType <- map["media_type"]
        posterPath <- map["poster_path"]
        summary <- map["overview"]
    }
}
