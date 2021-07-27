//
//  ComposeViewController.swift
//  MovieLog
//
//  Created by 신미지 on 2021/07/26.
//

import UIKit

class ComposeViewController: UIViewController {
  var editReview: Review?
  var movieName: String!
  var moviePosterName: String?
  var senderValue = 0.0
  var intValues = 0
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var textView: UITextView!
  @IBOutlet weak var slider: UISlider!

  
  var window: UIWindow?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    textView.autocorrectionType = .no
    setupTapGRForKeyboardDismissal()
    
    if let review = editReview {
      titleLabel.text = review.title
      textView.text = review.content
      sliderImage(Float(review.sliderValue), Int(review.intValue))
    } else {
      titleLabel.text = movieName
      slider.value = 0
      textView.text = ""
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    navigationController?.navigationBar.isHidden = false
    navigationController?.navigationBar.barTintColor = .black
    tabBarController?.tabBar.isHidden = true
    setupTapGRForKeyboardDismissal()
  }
  
  
  private func sliderImage(
    _ sliderValue: Float,
    _ intValues: Int) {
    slider.value = sliderValue
    print("slider value \(sliderValue), intvalue \(intValues)")
    for index in 0...5 {
      if let starImage = view.viewWithTag(index) as? UIImageView {
        if index <= intValues / 2 {
          starImage.image = UIImage(named: "star_full")
        } else {
          if (2 * index - intValues) <= 1 {
            starImage.image = UIImage(named: "star_half")
          } else {
            starImage.image = UIImage(named: "star_empty")
          }
        }
      }
    }
  }
  
  @IBAction func onDragSlider(_ sender: UISlider) {
    let intValue = Int(floor(sender.value))
    for index in 0...5 {
      if let starImage = view.viewWithTag(index) as? UIImageView {
        if index <= intValue / 2 {
          starImage.image = UIImage(named: "star_full")
        } else {
          if (2 * index - intValue) <= 1 {
            starImage.image = UIImage(named: "star_half")
          } else {
            starImage.image = UIImage(named: "star_empty")
          }
        }
      }
    }
    senderValue = Double(sender.value)
    intValues = intValue
  }
  
  @IBAction func backBtnTap(_ sender: Any) {
    navigationController?.popViewController(animated: true)
  }
  
  @IBAction func saveBtnTap(_ sender: Any) {
    let nowDate = Date()
    guard let title = titleLabel.text,
          let content = textView.text else { return }
    
    if editReview == nil {
      DataManager.shared.addReview(
        title,
        nowDate,
        senderValue,
        intValues,
        content,
        moviePosterName!)
      NotificationCenter.default.post(
        name: ComposeViewController.newReviewDidInsert,
        object: nil)
      navigationController?.popViewController(animated: true)
      self.tabBarController?.selectedIndex = 2
    } else if let edit = editReview {
      edit.title = title
      let originSenderValue = edit.sliderValue
      let changeIntValue = intValues
      let changeSenderValue = slider.value
      
      if originSenderValue == Double(changeSenderValue) {
        edit.sliderValue = originSenderValue
      } else {
        edit.intValue = Int16(changeIntValue)
        edit.sliderValue = Double(changeSenderValue)
      }
      edit.content = content
      DataManager.shared.saveContext()
      NotificationCenter.default.post(
        name: ComposeViewController.reviewDidChange,
        object: nil)
      navigationController?.popViewController(animated: true)
    }
  }
  
}

extension ComposeViewController {
  static let newReviewDidInsert = Notification.Name("newReviewDidInsert")
  static let reviewDidChange = Notification.Name("reviewDidChange")
}
