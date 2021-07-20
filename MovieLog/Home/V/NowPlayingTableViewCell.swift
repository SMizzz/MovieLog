//
//  NowPlayingTableViewCell.swift
//  MovieLog
//
//  Created by 신미지 on 2021/07/19.
//

import UIKit
import Kingfisher

protocol NowPlayingCellDelegate: AnyObject {
  func nowPlayingCellTapped(indexPath: IndexPath)
}

class NowPlayingTableViewCell: UITableViewCell {
  weak var delegate: NowPlayingCellDelegate?
  @IBOutlet weak var collectionView: UICollectionView!
  
  var nowPlayingData = [Movie]()
  
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
      UINib(nibName: "NowPlayingCollectionViewCell", bundle: nil),
      forCellWithReuseIdentifier: "NowPlayingCollectionViewCell")
  }
  
  func config(with movie: [Movie]) {
    self.nowPlayingData = movie
    collectionView.reloadData()
  }
}

extension NowPlayingTableViewCell:
  UICollectionViewDelegate,
  UICollectionViewDataSource {
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return nowPlayingData.count
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NowPlayingCollectionViewCell", for: indexPath) as! NowPlayingCollectionViewCell
    if let image = nowPlayingData[indexPath.item].backdropPath {
      cell.posterImageView.kf.setImage(with: URL(string: "https://image.tmdb.org/t/p/w500\(image)"))
    } else {
      print("이미지가 없습니다.")
    }
    return cell
  }
}

extension NowPlayingTableViewCell: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    let width = collectionView.safeAreaLayoutGuide.layoutFrame.width
    let height = collectionView.safeAreaLayoutGuide.layoutFrame.height
    return CGSize(width: width, height: height)
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumLineSpacingForSectionAt section: Int
  ) -> CGFloat {
    return 0
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumInteritemSpacingForSectionAt section: Int
  ) -> CGFloat {
    return 0
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    delegate?.nowPlayingCellTapped(indexPath: indexPath)
  }
}
