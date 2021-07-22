//
//  PopularKeywordTableViewCell.swift
//  MovieLog
//
//  Created by 신미지 on 2021/07/21.
//

import UIKit

protocol PopularKeywordCellDelegate: AnyObject {
  func cellTapped(cell: PopularKeywordTableViewCell)
}

class PopularKeywordTableViewCell: UITableViewCell {
  weak var delegate: PopularKeywordCellDelegate?
  @IBOutlet weak var popularKeywordButton: UIButton!
  
  @IBAction func popularKeywordBtnTap(_ sender: Any) {
    delegate?.cellTapped(cell: self)
  }
}
