//
//  UpcomingTableViewCell.swift
//  MovieLog
//
//  Created by 신미지 on 2021/07/20.
//

import UIKit
import Kingfisher

protocol UpcomingCellDelegate: AnyObject {
  func upcomingCellDelegate(indexPath: IndexPath)
}

class UpcomingTableViewCell: UITableViewCell {
  weak var delegate: UpcomingCellDelegate?
  var upcomingData = [Movie]()
  @IBOutlet weak var collectionView: UICollectionView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    configureCollectionView()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  private func configureCollectionView() {
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.register(
      UINib(nibName: "CommonCollectionViewCell", bundle: nil),
      forCellWithReuseIdentifier: "CommonCollectionViewCell")
    collectionView.backgroundColor = .black
  }
  
  func config(with movie: [Movie]) {
    self.upcomingData = movie
    collectionView.reloadData()
  }
}

extension UpcomingTableViewCell:
  UICollectionViewDelegate,
  UICollectionViewDataSource {
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return upcomingData.count
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CommonCollectionViewCell", for: indexPath) as! CommonCollectionViewCell
    if let image = upcomingData[indexPath.item].posterPath {
      cell.posterImage.kf.setImage(with: URL(string: "https://image.tmdb.org/t/p/w500\(image)"))
    } else {
      print("이미지가 없습니다.")
    }
    return cell
  }
}

extension UpcomingTableViewCell:
  UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    let width = collectionView.frame.size.width
    let height = collectionView.frame.size.height
    return CGSize(width: width / 3, height: height)
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumLineSpacingForSectionAt section: Int
  ) -> CGFloat {
    return 15.0
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumInteritemSpacingForSectionAt section: Int
  ) -> CGFloat {
    return 0.0
  }
  func collectionView(
    _ collectionView: UICollectionView,
    didSelectItemAt indexPath: IndexPath
  ) {
    delegate?.upcomingCellDelegate(indexPath: indexPath)
  }
}
