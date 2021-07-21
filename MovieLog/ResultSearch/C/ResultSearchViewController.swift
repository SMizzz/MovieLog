//
//  ResultSearchViewController.swift
//  MovieLog
//
//  Created by 신미지 on 2021/07/21.
//

import UIKit

class ResultSearchViewController: UIViewController {
  
  @IBOutlet weak var collectionView: UICollectionView!
  var query: String = ""
  var resultMovieData = [Movie]()
  let noResultView = NoSearchResultView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.navigationBar.isHidden = false
    navigationController?.navigationBar.barTintColor = .black
    tabBarController?.tabBar.isHidden = true
    addViews()
    setConstraints()
    collectionView.isHidden = false
    noResultView.isHidden = true
    configureNavigationBar()
    configureCollectionView()
    getData()
  }
  
  private func configureNavigationBar() {
    let leftBarButton = UIBarButtonItem(
      image: UIImage(named: "arrow-left"),
      style: .plain,
      target: self,
      action: #selector(handleLeftBarBtnPressed))
    leftBarButton.tintColor = .white
    self.navigationItem.leftBarButtonItem = leftBarButton
  }
  
  @objc func handleLeftBarBtnPressed() {
    navigationController?.popViewController(animated: true)
  }
  
  private func configureCollectionView() {
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.register(
      UINib(nibName: "ResultSearchCollectionViewCell", bundle: nil),
      forCellWithReuseIdentifier: "ResultSearchCollectionViewCell")
  }
  
  private func getData() {
    MovieNetworkManager.getMovieData(source: .movieSearch(query: query)) { (movies) in      self.resultMovieData = movies
      self.collectionView.reloadData()
    }
  }
  
  private func addViews() {
    view.addSubview(noResultView)
  }
  
  private func setConstraints() {
    noResultViewConstraints()
  }
  
  private func noResultViewConstraints() {
    noResultView.translatesAutoresizingMaskIntoConstraints = false
    noResultView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    noResultView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    noResultView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    noResultView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
  }
}

extension ResultSearchViewController:
  UICollectionViewDelegate,
  UICollectionViewDataSource {
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    if resultMovieData.count == 0 {
      noResultView.isHidden = false
      collectionView.isHidden = true
    } else {
      noResultView.isHidden = true
      collectionView.isHidden = false
    }
    return resultMovieData.count
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: "ResultSearchCollectionViewCell",
      for: indexPath) as! ResultSearchCollectionViewCell
    let result = resultMovieData[indexPath.item]
    if let image = result.backdropPath {
      cell.posterImageView.kf.setImage(with: URL(string: "https://image.tmdb.org/t/p/w500\(image)"))
    } else {
      cell.posterImageView.image = UIImage(named: "noImage")
    }
    cell.titleLabel.text = result.title
    return cell
  }
}

extension ResultSearchViewController:
  UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    let width = collectionView.frame.size.width
    return CGSize(width: width - 30, height: 230)
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumLineSpacingForSectionAt section: Int
  ) -> CGFloat {
    return 15
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumInteritemSpacingForSectionAt section: Int
  ) -> CGFloat {
    return 0
  }
}
