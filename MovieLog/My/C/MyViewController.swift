//
//  MyViewController.swift
//  MovieLog
//
//  Created by 신미지 on 2021/07/22.
//

import UIKit

class MyViewController: UIViewController {
  @IBOutlet weak var myReviewCountLabel: UILabel!
  @IBOutlet weak var myTitleLabel: UILabel!
  @IBOutlet weak var collectionView: UICollectionView!
  
  let formatter: DateFormatter = {
    let nowDate = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .long
    dateFormatter.timeStyle = .short
    dateFormatter.locale = Locale(identifier: "ko")
    return dateFormatter
  }()
  
  var token: NSObjectProtocol?
  deinit {
    if let token = token {
      NotificationCenter.default.removeObserver(token)
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureCollectionView()
    token = NotificationCenter.default.addObserver(forName: ComposeViewController.reviewDidChange, object: nil, queue: OperationQueue.main, using: { [weak self] (noti) in
      self?.collectionView.reloadData()
    })
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    navigationController?.navigationBar.isHidden = true
    tabBarController?.tabBar.isHidden = false
    DataManager.shared.fetchReview()
    myReviewCountLabel.text = "내가 작성한 영화 리뷰는, \(DataManager.shared.reviewData.count)개 입니다!"
    collectionView.reloadData()
  }
  
  private func configureCollectionView() {
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.register(
      UINib(nibName: "MyCollectionViewCell", bundle: nil),
      forCellWithReuseIdentifier: "MyCollectionViewCell")
  }
}

extension MyViewController:
  UICollectionViewDelegate,
  UICollectionViewDataSource {
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return DataManager.shared.reviewData.count
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: "MyCollectionViewCell",
      for: indexPath) as! MyCollectionViewCell
    let reviewModel = DataManager.shared.reviewData[indexPath.item]
    
    for index in 0...5 {
      if let starImage = cell.viewWithTag(index) as? UIImageView {
        if index <= reviewModel.intValue / 2 {
          starImage.image = UIImage(named: "star_full")
        } else if (2 * index - Int(reviewModel.intValue)) <= 1 {
          starImage.image = UIImage(named: "star_half")
        } else {
          starImage.image = UIImage(named: "star_empty")
        }
      }
    }
    
    cell.titleLabel.text = reviewModel.title
    let convertNowStr = formatter.string(from: reviewModel.date!)
    cell.dateLabel.text = convertNowStr
    
    if let image = reviewModel.poster {
      cell.posterImageView.kf.setImage(
        with: URL(string: "https://image.tmdb.org/t/p/w500\(image)"))
    } else {
      cell.posterImageView.image = UIImage(named: "noImage")
    }
    return cell
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    didSelectItemAt indexPath: IndexPath
  ) {
    guard let composeVC = self.storyboard?.instantiateViewController(withIdentifier: "ComposeVC") as? ComposeViewController else { return }
    composeVC.editReview = DataManager.shared.reviewData[indexPath.item]
    navigationController?.pushViewController(composeVC, animated: false)
  }
}

extension MyViewController:
  UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    let width = collectionView.safeAreaLayoutGuide.layoutFrame.width
    let height = collectionView.safeAreaLayoutGuide.layoutFrame.height
    return CGSize(width: width / 1.15, height: height)
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumLineSpacingForSectionAt section: Int
  ) -> CGFloat {
    return 20
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumInteritemSpacingForSectionAt section: Int
  ) -> CGFloat {
    return 20
  }
}
