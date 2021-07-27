//
//  Extension.swift
//  MovieLog
//
//  Created by 신미지 on 2021/07/21.
//

import UIKit

extension UIViewController {
  func setupTapGRForKeyboardDismissal() {
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(
      target: self,
      action: #selector(handleDismissKeyboard)
    )
    view.addGestureRecognizer(tap)
  }
  
  @objc func handleDismissKeyboard() {
    view.endEditing(true)
  }
}

extension UIAlertController {
  func removeErrorWidthConstraints() {
    // width == -16 이라는 constraints 에러를 없애기 위한 func
    for subView in self.view.subviews {
      for constraint in subView.constraints where constraint.debugDescription.contains("width == - 16") {
        subView.removeConstraint(constraint)
      }
    }
  }
}
