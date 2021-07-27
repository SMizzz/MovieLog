//
//  MyCollectionViewCell.swift
//  MovieLog
//
//  Created by 신미지 on 2021/07/26.
//

import UIKit

class MyCollectionViewCell: UICollectionViewCell {
  @IBOutlet weak var posterImageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var slider: UISlider!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    backgroundColor = .black
    labelShadow()
  }
  
  private func labelShadow() {
    titleLabel.layer.shadowColor = UIColor.black.cgColor
    titleLabel.layer.shadowRadius = 3.0
    titleLabel.layer.shadowOpacity = 0.5
    titleLabel.layer.shadowOffset = CGSize(width: 2, height: 2)
    titleLabel.layer.masksToBounds = false
    
    dateLabel.layer.shadowColor = UIColor.black.cgColor
    dateLabel.layer.shadowRadius = 3.0
    dateLabel.layer.shadowOpacity = 0.5
    dateLabel.layer.shadowOffset = CGSize(width: 2, height: 2)
    dateLabel.layer.masksToBounds = false
  }
}
