//
//  MoviesApi.swift
//  Movies-app
//
//  Created by Agustin Daguerre on 7/6/17.
//  Copyright © 2017 agustindaguerre. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

class MoviesApi {
    static let apiToken = "91773ba4be3fe63dcdfd1f6b487eb2ce"
    static let baseUrl = "https://api.themoviedb.org/3"
    static let discoverMovie = "/discover/movie"
    static let nowPlaying = "/movie/now_playing"
    
    static func getPlayingMovies(completionHandler: @escaping ([Movie]) -> Void) {
        let url = "\(baseUrl)\(nowPlaying)"
        let parameters: Parameters = ["api_key": apiToken]
        
        Alamofire.request(url, parameters: parameters).responseObject { (response: DataResponse<MoviesResponse>) in
            if let result = response.result.value {
                print("JSON: \(result)") // serialized json response
                completionHandler(result.movies);
            }
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)") // original server data as UTF8 string
            }
        }
    }
    
    static func getMovies(completionHandler: @escaping ([Movie]) -> Void) {
        let url = "\(baseUrl)\(discoverMovie)"
        
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        let today = Date()
        let todayString = formatter.string(from: today)
        let oneMonthAgo = Date().addingTimeInterval(-30 * 24 * 60 * 60)
        let oneMonthAgoString = formatter.string(from: oneMonthAgo)
        
        let parameters: Parameters = [
            "api_key": apiToken,
            "primary_release_date.gte": oneMonthAgoString,
            "primary_release_date.lte": todayString,
            "page": 1,
            "sort_by": "primary_release_date.desc",
            "region": "US",
            "with_original_language": "en"
        ]
        
        Alamofire.request(url, parameters: parameters).responseJSON { response in
            
            //TODO: Remove this prints
            
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            
            if let json = response.result.value {
                print("JSON: \(json)") // serialized json response
            }
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)") // original server data as UTF8 string
            }
        }
    }
}
