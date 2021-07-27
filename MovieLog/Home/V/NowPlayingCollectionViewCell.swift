//
//  NowPlayingCollectionViewCell.swift
//  MovieLog
//
//  Created by 신미지 on 2021/07/19.
//

import UIKit

class NowPlayingCollectionViewCell: UICollectionViewCell {
  
  @IBOutlet weak var posterImageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    labelShadow()
  }
  
  private func labelShadow() {
    titleLabel.layer.shadowColor = UIColor.black.cgColor
    titleLabel.layer.shadowRadius = 3.0
    titleLabel.layer.shadowOpacity = 0.8
    titleLabel.layer.shadowOffset = CGSize(width: 3, height: 3)
    titleLabel.layer.masksToBounds = false
  }
}
