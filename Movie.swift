//
//  Movie.swift
//  MyMDB
//
//  Created by Justin Michal on 1/20/19.
//  Copyright © 2019 Justin Michal. All rights reserved.
//

import UIKit
import Foundation

class Movie {
    var genre: String
    var year: String
    var title: String
    var cast: String
    var imdbRating: String = ""
    var rottenTomatoestRating: String = ""
    var poster: UIImage
    var description: String
    init(movie: NSDictionary) {
        self.title = movie["Title"] as! String
        self.year = movie["Year"] as! String
        self.genre = movie["Genre"] as! String
        self.cast = movie["Actors"] as! String
        self.description = movie["Plot"] as! String
        //download image from internet and set it as the movie poster
        let poster_path = movie["Poster"] as! String
        let url = URL(string: poster_path)
        let data = try? Data(contentsOf: url!)
        if data != nil {
            self.poster =  UIImage(data: data!)!
        }
        else {
            self.poster = UIImage()
        }
        let ratings = movie["Ratings"] as! NSArray
        for case let rating as NSDictionary in ratings {
            if rating["Source"] as! String == "Internet Movie Database" {
                let toomuch = rating["Value"] as! String
                self.imdbRating = String(toomuch.prefix(3))
            }
            else if rating["Source"] as! String == "Rotten Tomatoes" {
                self.rottenTomatoestRating = rating["Value"] as! String
            }
        }
    }
}
