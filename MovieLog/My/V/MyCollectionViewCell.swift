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
  @IBOutlet weak var slider: UISlider!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
