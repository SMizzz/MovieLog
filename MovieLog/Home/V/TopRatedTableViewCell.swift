//
//  CommonTableViewCell.swift
//  MovieLog
//
//  Created by 신미지 on 2021/07/20.
//

import UIKit
import Kingfisher

class TopRatedTableViewCell: UITableViewCell {
  
  @IBOutlet weak var collectionView: UICollectionView!
  var topRatedData = [Movie]()
  
  override func awakeFromNib() {
    super.awakeFromNib()
    configureCollectionView()
  }
  
  override func setSelected(
    _ selected: Bool,
    animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  private func configureCollectionView() {
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.register(UINib(nibName: "CommonCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CommonCollectionViewCell")
    collectionView.backgroundColor = .black
  }
  
  func config(with movie: [Movie]) {
    self.topRatedData = movie
    collectionView.reloadData()
  }
}

extension TopRatedTableViewCell:
  UICollectionViewDelegate,
  UICollectionViewDataSource {
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return topRatedData.count
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CommonCollectionViewCell", for: indexPath) as! CommonCollectionViewCell
    if let image = topRatedData[indexPath.item].posterPath {
      cell.posterImage.kf.setImage(with: URL(string: "https://image.tmdb.org/t/p/w500\(image)"))
    } else {
      print("이미지가 없습니다.")
    }
    return cell
  }
}

extension TopRatedTableViewCell:
  UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    let width = collectionView.frame.size.width / 3
    let height = collectionView.safeAreaLayoutGuide.layoutFrame.height
    return CGSize(width: width, height: height)
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumLineSpacingForSectionAt section: Int
  ) -> CGFloat {
    return 15
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumInteritemSpacingForSectionAt section: Int
  ) -> CGFloat {
    return 0
  }
}
