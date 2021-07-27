//
//  ResultSearchCollectionViewCell.swift
//  MovieLog
//
//  Created by 신미지 on 2021/07/21.
//

import UIKit

class ResultSearchCollectionViewCell: UICollectionViewCell {
  @IBOutlet weak var posterImageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.layer.cornerRadius = 40
    labelShadow()
  }
  
  private func labelShadow() {
    titleLabel.layer.shadowColor = UIColor.black.cgColor
    titleLabel.layer.shadowRadius = 3.0
    titleLabel.layer.shadowOpacity = 0.5
    titleLabel.layer.shadowOffset = CGSize(width: 2, height: 2)
    titleLabel.layer.masksToBounds = false
  }
}
