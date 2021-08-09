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
    navigationController?.navigationBar.barTintColor = .black
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    navigationController?.navigationBar.isHidden = true
    tabBarController?.tabBar.isHidden = false
    searchBar.searchTextField.text = ""
    searchBar.searchTextField.resignFirstResponder()
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
    tableView.allowsSelectionDuringEditing = true
  }
  
  private func getData() {
    MovieNetworkManager.getPopularMovieData(page: 1) { (movies) in
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
    cell.popularKeywordButton.contentHorizontalAlignment = .left
    cell.popularKeywordButton.setTitle("\(indexPath.row + 1)위  \(popularKeyword[indexPath.row].title!)", for: .normal)
    cell.delegate = self
    return cell
  }
  
  func tableView(
    _ tableView: UITableView,
    heightForRowAt indexPath: IndexPath
  ) -> CGFloat {
    return 44.0
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
    label.text = "๑'ٮ'๑ 영화 TOP 20 "
    return view
  }
  
  func tableView(
    _ tableView: UITableView,
    heightForHeaderInSection section: Int
  ) -> CGFloat {
    return 50.0
  }
}

extension SearchViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    guard let resultVC = self.storyboard?.instantiateViewController(withIdentifier: "ResultSearchVC") as? ResultSearchViewController else { return }
    resultVC.query = searchBar.searchTextField.text!
    self.navigationController?.pushViewController(resultVC, animated: false)
  }
}

extension SearchViewController: PopularKeywordCellDelegate {
  func cellTapped(cell: PopularKeywordTableViewCell) {
    let indexPath = tableView.indexPath(for: cell)
    guard let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "DetailMovieVC") as? DetailMovieViewController else { return }
    detailVC.id = popularKeyword[indexPath!.row].id!
    navigationController?.pushViewController(detailVC, animated: false)
  }
}
