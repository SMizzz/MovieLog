//
//  NoSearchResultView.swift
//  MovieLog
//
//  Created by 신미지 on 2021/07/21.
//

import UIKit

class NoSearchResultView: UIView {
  // MARK: - Properties
  let emotionImageView: UIImageView = {
    let iv = UIImageView()
    var image = UIImage(named: "emotion-embrassed")
    iv.image = image
    return iv
  }()
  
  let resultLabel: UILabel = {
    let label = UILabel()
    label.text = "검색결과가 없습니다. 다시 검색해주세요!"
    label.textAlignment = .center
    label.textColor = .white
    label.numberOfLines = 0
    label.font = UIFont.boldSystemFont(ofSize: 18)
    return label
  }()
  
  // MARK: - Init
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
    addViews()
    setConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Handlers
  private func setup() {
    backgroundColor = .black
  }
  
  private func addViews() {
    addSubview(emotionImageView)
    addSubview(resultLabel)
  }
  
  private func setConstraints() {
    emotionImageViewConstraints()
    resultLabelConstraints()
  }
  
  // MARK: - Constraints
  private func emotionImageViewConstraints() {
    emotionImageView.translatesAutoresizingMaskIntoConstraints = false
    emotionImageView.widthAnchor.constraint(equalToConstant: 90).isActive = true
    emotionImageView.heightAnchor.constraint(equalToConstant: 90).isActive = true
    emotionImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -30).isActive = true
    emotionImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
  }
  private func resultLabelConstraints() {
    resultLabel.translatesAutoresizingMaskIntoConstraints = false
    resultLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5).isActive = true
    resultLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
    resultLabel.topAnchor.constraint(equalTo: emotionImageView.bottomAnchor, constant: 10).isActive = true
    resultLabel.centerXAnchor.constraint(equalTo: emotionImageView.centerXAnchor).isActive = true
  }
}
