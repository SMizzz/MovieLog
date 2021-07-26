//
//  MyViewController.swift
//  MovieLog
//
//  Created by 신미지 on 2021/07/22.
//

import UIKit

class MyViewController: UIViewController {
  @IBOutlet weak var myTitleLabel: UILabel!
  @IBOutlet weak var collectionView: UICollectionView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureCollectionView()
  }
  
  private func configureCollectionView() {
    collectionView.delegate = self
    collectionView.dataSource = self
  }
}

extension MyViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    return UICollectionViewCell()
  }
}

extension MyViewController: UICollectionViewDelegateFlowLayout {
  
}
