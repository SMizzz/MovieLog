//
//  DetailMovieViewController.swift
//  MovieLog
//
//  Created by 신미지 on 2021/07/20.
//

import UIKit

class DetailMovieViewController: UIViewController {
  
  @IBOutlet weak var posterImageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var averageLabel: UILabel!
  @IBOutlet weak var overviewLabel: UILabel!
  
  var id: Int = 0

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.navigationBar.isHidden = false
    tabBarController?.tabBar.isHidden = true
    getData()
  }
  
  private func getData() {
    MovieNetworkManager.getDetailMovieData(id: id) { (movie) in
      if let image = movie.posterPath {
        self.posterImageView.kf.setImage(with: URL(string: "https://image.tmdb.org/t/p/w500\(image)"))
      } else {
        print("이미지가 없습니다.")
      }
      self.titleLabel.text = movie.title
      self.averageLabel.text = "⭐\(movie.average!)"
      self.overviewLabel.text = movie.overview
    }
  }
}
