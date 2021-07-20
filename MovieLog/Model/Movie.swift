//
//  Movie.swift
//  MovieLog
//
//  Created by 신미지 on 2021/07/20.
//

import Foundation

struct Movie: Codable {
  var id: Int? = 0
  var backdropPath: String? = ""
  var posterPath: String? = ""
  var title: String? = ""
  var overview: String? = ""
  var average: Float? = 0.0
  
  enum CodingKeys: String, CodingKey {
    case id
    case backdropPath = "backdrop_path"
    case posterPath = "poster_path"
    case title
    case overview
    case average = "vote_average"
  }
  
  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    id = try values.decodeIfPresent(Int.self, forKey: .id)
    backdropPath = try values.decodeIfPresent(String.self, forKey: .backdropPath)
    posterPath = try values.decodeIfPresent(String.self, forKey: .posterPath)
    title = try values.decodeIfPresent(String.self, forKey: .title)
    overview = try values.decodeIfPresent(String.self, forKey: .overview)
    average = try values.decodeIfPresent(Float.self, forKey: .average)
  }
}

struct MovieDataStore: Codable {
  var results: [Movie]
}
