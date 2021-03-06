//
//  HomeViewController.swift
//  MovieLog
//
//  Created by 신미지 on 2021/07/19.
//

import UIKit

class HomeViewController: UIViewController {
  
  var nowPlayingData = [Movie]()
  var topRatedData = [Movie]()
  var upComingData = [Movie]()
  @IBOutlet weak var tableView: UITableView!
  var pageControlIndexPath: IndexPath!
  let myPageControl = UIPageControl()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.navigationBar.isHidden = true
    configureTableView()
    getData()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    navigationController?.navigationBar.isHidden = true
    tabBarController?.tabBar.isHidden = false
  }
  
  private func configureTableView() {
    tableView.delegate = self
    tableView.dataSource = self
  }
  
  private func getData() {
    MovieNetworkManager.getMovieData(source: .nowPlaying) { (movies) in
      self.nowPlayingData = movies
      OperationQueue.main.addOperation {
        self.tableView.reloadData()
      }
    }
    
    MovieNetworkManager.getMovieData(source: .topRated) { (movies) in
      self.topRatedData = movies
      OperationQueue.main.addOperation {
        self.tableView.reloadData()
      }
    }
    
    MovieNetworkManager.getMovieData(source: .upComing) { (movies) in
      self.upComingData = movies
      OperationQueue.main.addOperation {
        self.tableView.reloadData()
      }
    }
  }
}

extension HomeViewController:
  UITableViewDelegate,
  UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 3
  }
  
  func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int
  ) -> Int {
    return 1
  }
  
  func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    if indexPath.section == 0 {
      let nowPlayingCell = tableView.dequeueReusableCell(withIdentifier: "NowPlayingTableViewCell", for: indexPath) as! NowPlayingTableViewCell
      nowPlayingCell.config(with: nowPlayingData)
      nowPlayingCell.delegate = self
      return nowPlayingCell
    } else if indexPath.section == 1 {
      let topRatedCell = tableView.dequeueReusableCell(withIdentifier: "TopRatedTableViewCell", for: indexPath) as! TopRatedTableViewCell
      topRatedCell.config(with: topRatedData)
      topRatedCell.delegate = self
      return topRatedCell
    } else if indexPath.section == 2 {
      let upcomingCell = tableView.dequeueReusableCell(withIdentifier: "UpcomingTableViewCell", for: indexPath) as! UpcomingTableViewCell
      upcomingCell.config(with: upComingData)
      upcomingCell.delegate = self
      return upcomingCell
    }
    return UITableViewCell()
  }
  
  func tableView(
    _ tableView: UITableView,
    heightForRowAt indexPath: IndexPath
  ) -> CGFloat {
    if indexPath.section == 0 {
      return 350.0
    } else if indexPath.section == 1 {
      return 200.0
    } else if indexPath.section == 2 {
      return 200.0
    }
    return 0.0
  }
  
  func tableView(
    _ tableView: UITableView,
    viewForHeaderInSection section: Int
  ) -> UIView? {
    let view = UIView(
      frame: CGRect(
        x: 0, y: 0,
        width: tableView.frame.width,
        height: tableView.frame.height))
    view.backgroundColor = .black
    let label = UILabel(
      frame: CGRect(
        x: 8, y: 4,
        width: view.bounds.size.width,
        height: view.bounds.size.height))
    label.font = UIFont.boldSystemFont(ofSize: 17)
    label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    label.textColor = .white
    view.addSubview(label)
    if section == 1 {
      label.text = "인기 영화"
    } else if section == 2 {
      label.text = "개봉 예정작"
    }
    return view
  }
  
  func tableView(
    _ tableView: UITableView,
    heightForHeaderInSection section: Int
  ) -> CGFloat {
    if section == 1 {
      return 50.0
    } else if section == 2 {
      return 50.0
    }
    return 0
  }
  
  func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    let footerView = UIView(
      frame: CGRect(
        x: 0, y: 0,
        width: tableView.frame.width,
        height: 40))
    footerView.backgroundColor = .black
    footerView.addSubview(myPageControl)
    myPageControl.translatesAutoresizingMaskIntoConstraints = false
    myPageControl.widthAnchor.constraint(equalTo: footerView.widthAnchor, multiplier: 0.45).isActive = true
    myPageControl.heightAnchor.constraint(equalToConstant: 28).isActive = true
    myPageControl.centerXAnchor.constraint(equalTo: footerView.centerXAnchor).isActive = true
    myPageControl.centerYAnchor.constraint(equalTo: footerView.centerYAnchor).isActive = true
    configureFooterMyPageControl()
    return footerView
  }
  
  private func configureFooterMyPageControl() {
    myPageControl.tintColor = .white
    myPageControl.currentPageIndicatorTintColor = .lightGray
    myPageControl.currentPage = 0
    myPageControl.numberOfPages = nowPlayingData.count
  }
  
  func tableView(
    _ tableView: UITableView,
    heightForFooterInSection section: Int
  ) -> CGFloat {
    if section == 0 {
      return 30.0
    }
    return 0.0
  }
}

extension HomeViewController:
  NowPlayingCellDelegate,
  TopRatedCellDelegate,
  UpcomingCellDelegate {
  func nowPlayingCellTapped(indexPath: IndexPath) {
    guard let detailVC = self.storyboard?.instantiateViewController(identifier: "DetailMovieVC") as? DetailMovieViewController else { return }
    detailVC.id = nowPlayingData[indexPath.item].id!
    navigationController?.pushViewController(detailVC, animated: true)
  }
  
  func swipeNowPlayingCellTapped(indexPath: IndexPath) {
    myPageControl.currentPage = indexPath.item
  }
  
  func topRatedCellTapped(indexPath: IndexPath) {
    guard let detailVC = self.storyboard?.instantiateViewController(identifier: "DetailMovieVC") as? DetailMovieViewController else { return }
    detailVC.id = topRatedData[indexPath.item].id!
    navigationController?.pushViewController(detailVC, animated: true)
  }
  
  func upcomingCellDelegate(indexPath: IndexPath) {
    guard let detailVC = self.storyboard?.instantiateViewController(identifier: "DetailMovieVC") as? DetailMovieViewController else { return }
    detailVC.id = upComingData[indexPath.item].id!
    navigationController?.pushViewController(detailVC, animated: true)
  }
}
