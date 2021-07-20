//
//  MovieAPI.swift
//  MovieLog
//
//  Created by 신미지 on 2021/07/20.
//

import Moya

enum MovieAPI {
  case nowPlaying
  case topRated
  case upComing
  case detail(id: Int)
  case movieSearch(query: String)
}

extension MovieAPI: TargetType {
  var baseURL: URL {
    guard let url = URL(string: "https://api.themoviedb.org/3") else { fatalError("url error") }
    return url
  }
  
  var path: String {
    switch self {
    case .nowPlaying:
      return "/movie/now_playing"
    case .topRated:
      return "/movie/top_rated"
    case .upComing:
      return "/movie/upcoming"
    case .detail(let id):
      return "/movie/\(id)"
    case .movieSearch(_):
      return "/search/movie"
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .nowPlaying, .topRated, .upComing, .detail(_), .movieSearch(_):
      return .get
    }
  }
  
  var sampleData: Data {
    return Data()
  }
  
  var task: Task {
    switch self {
    case .nowPlaying, .topRated, .upComing:
      return .requestParameters(
        parameters: [
          "api_key": "1f2d99c9366d63893dfedd75762e09ba",
          "language": "ko"],
        encoding: URLEncoding.queryString)
    case .detail(let id):
      return .requestParameters(
        parameters: [
          "api_key": "1f2d99c9366d63893dfedd75762e09ba",
          "language": "ko",
          "id": id],
        encoding: URLEncoding.queryString)
    case .movieSearch(let query):
      return .requestParameters(
        parameters: [
          "api_key": "1f2d99c9366d63893dfedd75762e09ba",
          "language": "ko",
          "query": query],
        encoding: URLEncoding.queryString)
    }
  }
  
  var headers: [String : String]? {
    return ["Content-Type": "application/json"]
  }
}
