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
import AlamofireImage

class MoviesApi {
    static let apiToken = "91773ba4be3fe63dcdfd1f6b487eb2ce"
    static let baseUrl = "https://api.themoviedb.org/3"
    static let discoverMovie = "/discover/movie"
    static let nowPlaying = "/movie/now_playing"
    static let imageUrl = "https://image.tmdb.org/t/p/w500"
    static let movieDetailsUrl = "/movie/"
    static let multiSearch = "/search/multi"
    static let discover = "/discover/tv"
    static let seriesDetailsUrl = "/tv/"
    
    static func getPlayingMovies(completionHandler: @escaping ([Movie]) -> Void) {
        let url = "\(baseUrl)\(nowPlaying)"
        let parameters: Parameters = ["api_key": apiToken]

        Alamofire.request(url, parameters: parameters).responseObject { (response: DataResponse<MoviesResponse>) in
            if let result = response.result.value {
                print("JSON: \(result)") // serialized json response
                var movies = Array(result.movies[0...4])
                let imagePaths = movies.map { movie in
                    return movie.posterPath!
                }
                self.getMoviePosters(imagePaths: imagePaths) { (images: [(String, Image)]) in
                    images.forEach { (path, image) in
                        movies = movies.map { movie in
                            if (movie.posterPath! == path) {
                                movie.poster = image
                            }
                            return movie
                        }
                    }
                    completionHandler(movies);
                }
            }

            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)") // original server data as UTF8 string
            }
        }
    }
    
    static func getFavorites(favorites: [Favorite], completionHandler: @escaping ([Movie]) -> Void) {
        var resultShows : [Movie] = []
        favorites.forEach { favorite in
            if (favorite.isMovie) {
                self.getMovieDetails(movieId: Int(favorite.movieId)) { (movie: Movie) in
                    resultShows.append(movie)
                    if (resultShows.count == favorites.count) {
                        completionHandler(resultShows)
                    }
                }
            } else {
                self.getSeriesDetails(seriesId: Int(favorite.movieId)) { (movie: Movie) in
                    resultShows.append(movie)
                    if (resultShows.count == favorites.count) {
                        completionHandler(resultShows)
                    }
                }
            }
        }
    }

    static func makeMultiSearchWithText(text: String, completionHandler: @escaping ([MultiSearchItem]) -> Void) {
        let url = "\(baseUrl)\(multiSearch)"

        let parameters: Parameters = [
            "api_key": apiToken,
            "page": 1,
            "region": "US",
            "query": text
        ]

        Alamofire.request(url, parameters: parameters).responseObject {
            (response: DataResponse<MultiSearchResponse>) in
            if let result = response.result.value {
                var multiSearchItems = Array(result.multiSearchItems).filter { (entity) in entity.mediaType != "person" }

                let multiSerchItemsWithImage = multiSearchItems.filter { (entity) in entity.posterPath != nil }

                let imagePaths = multiSerchItemsWithImage.map { item in return item.posterPath! }

                self.getMoviePosters(imagePaths: imagePaths) { (images: [(String, Image)]) in
                    images.forEach {
                        (path, image) in

                        multiSearchItems = multiSearchItems.map {
                            multiSearchItem in

                            if let posterPath = multiSearchItem.posterPath {
                                if (posterPath == path) {
                                    multiSearchItem.poster = image
                                }
                            }
                            return multiSearchItem
                        }
                    }
                    completionHandler(multiSearchItems)
                }
            }
        }
    }


    static func getRandomTvSeries(ids: String, completionHandler: @escaping ([Serie]) -> Void) {
        let url = "\(baseUrl)\(discover)"

        let parameters: Parameters = [
            "api_key": apiToken,
            "with_genres": ids
        ]

        Alamofire.request(url, parameters: parameters).responseObject {
            (response: DataResponse<SeriesResponse>) in
            if let result = response.result.value {
                var series = Array(result.series)

                let seriesWithImage = series.filter { (serie) in serie.posterPath != nil }

                let imagePaths = seriesWithImage.map { serie in return serie.posterPath! }

                self.getMoviePosters(imagePaths: imagePaths) { (images: [(String, Image)]) in
                    images.forEach {
                        (path, image) in

                        series = series.map {
                            serie in

                            if let posterPath = serie.posterPath {
                                if (posterPath == path) {
                                    serie.poster = image
                                }
                            }
                            return serie
                        }
                    }
                    completionHandler(series)
                }
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

    static func getMovieDetails(movieId: Int, completionHandler: @escaping (Movie) -> Void) {
        let url = "\(baseUrl)\(movieDetailsUrl)\(movieId)"
        let parameters: Parameters = ["api_key": apiToken]

        Alamofire.request(url, parameters: parameters).responseObject { (response: DataResponse<Movie>) in
            if let movie = response.result.value {
                print("JSON: \(movie)") // serialized json response
                
                var imagePaths : [String] = []
                
                if let posterPath = movie.posterPath {
                    imagePaths.append(posterPath)
                }
                
                if let backdropPath = movie.backdropPath {
                    imagePaths.append(backdropPath)
                }
                
                self.getMoviePosters(imagePaths: imagePaths) { (images: [(String, Image)]) in
                    images.forEach { (path, image) in
                        if (path == movie.posterPath!) {
                            movie.poster = image
                        } else {
                            movie.backdropImage = image
                        }
                    }
                    completionHandler(movie);
                }
            }

            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)") // original server data as UTF8 string
            }
        }
    }
    
    static func getSeriesDetails(seriesId: Int, completionHandler: @escaping (Movie) -> Void) {
        let url = "\(baseUrl)\(seriesDetailsUrl)\(seriesId)"
        let parameters: Parameters = ["api_key": apiToken]
        
        Alamofire.request(url, parameters: parameters).responseObject { (response: DataResponse<Movie>) in
            if let movie = response.result.value {
                print("JSON: \(movie)") // serialized json response
                let imagePaths = [movie.posterPath!, movie.backdropPath!]
                self.getMoviePosters(imagePaths: imagePaths) { (images: [(String, Image)]) in
                    images.forEach { (path, image) in
                        if (path == movie.posterPath!) {
                            movie.poster = image
                        } else {
                            movie.backdropImage = image
                        }
                    }
                    completionHandler(movie);
                }
            }
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)") // original server data as UTF8 string
            }
        }
    }
    
    static private func getMoviePosters(imagePaths: [String], completionHandler: @escaping ([(String, Image)]) -> Void) {
        var resultImages : [(String, Image)] = []
        imagePaths.forEach { imagePath in
            let url = imageUrl + imagePath
            Alamofire.request(url).responseImage { response in
                debugPrint(response)
                debugPrint(response.result)
                
                if let image = response.result.value {
                    print("image downloaded: \(image)")
                }
                resultImages.append((imagePath, response.result.value!))
                if (resultImages.count == imagePaths.count) {
                    completionHandler(resultImages)
                }
            }
        }
    }
}
