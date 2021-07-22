//
//  SearchViewController.swift
//  MovieLog
//
//  Created by 신미지 on 2021/07/19.
//

import UIKit

class SearchViewController: UIViewController {
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var tableView: UITableView!
  
  var popularKeyword = [Movie]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureSearchBar()
    configureTableView()
    getData()
    setupTapGRForKeyboardDismissal()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    navigationController?.navigationBar.isHidden = true
    tabBarController?.tabBar.isHidden = false
  }
  
  private func configureSearchBar() {
    searchBar.backgroundImage = UIImage()
    searchBar.setImage(
      UIImage(named: "search_white"),
      for: .search,
      state: .normal)
    searchBar.tintColor = .white
    searchBar.barStyle = .black
    
    searchBar.searchTextField.textColor = .white
    searchBar.searchTextField.autocorrectionType = .no
    searchBar.delegate = self
  }
  
  private func configureTableView() {
    tableView.delegate = self
    tableView.dataSource = self
    tableView.separatorColor = .white
    tableView.allowsSelection = true
  }
  
  private func getData() {
    MovieNetworkManager.getMovieData(source: .popular) { (movies) in
      self.popularKeyword = movies
      self.tableView.reloadData()
    }
  }
}

extension SearchViewController:
  UITableViewDelegate,
  UITableViewDataSource {
  func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int
  ) -> Int {
    return popularKeyword.count
  }
  
  func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(
      withIdentifier: "PopularKeywordTableViewCell",
      for: indexPath) as! PopularKeywordTableViewCell
    cell.backgroundColor = .black
    let popular = popularKeyword[indexPath.row]
    var number = [Int]()
    for num in 1...popularKeyword.count - 1 {
      number.append(num)
    }
    cell.keywordLabel.text = "\(number[indexPath.item]). \(popular.title!)"
    return cell
  }
  
  func tableView(
    _ tableView: UITableView,
    heightForRowAt indexPath: IndexPath
  ) -> CGFloat {
    return 50.0
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
        x: 17, y: 4,
        width: view.bounds.size.width,
        height: view.bounds.size.height))
    label.font = UIFont.boldSystemFont(ofSize: 17)
    label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    label.textColor = .white
    view.addSubview(label)
    label.text = "인기 영화 순위"
    return view
  }
  
  func tableView(
    _ tableView: UITableView,
    heightForHeaderInSection section: Int
  ) -> CGFloat {
    return 50.0
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    print("tapped")
  }
}

extension SearchViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    guard let resultVC = self.storyboard?.instantiateViewController(withIdentifier: "ResultSearchVC") as? ResultSearchViewController else { return }
    resultVC.query = searchBar.searchTextField.text!
    self.navigationController?.pushViewController(resultVC, animated: true)
  }
}
