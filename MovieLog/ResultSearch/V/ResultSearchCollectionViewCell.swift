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
  }
}
