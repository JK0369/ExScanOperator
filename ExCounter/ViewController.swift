//
//  ViewController.swift
//  ExCounter
//
//  Created by Jake.K on 2021/12/28.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class ViewController: UIViewController {
  private let countLabel: UILabel = {
    let label = UILabel()
    label.textColor = .black
    label.text = "0"
    label.font = .systemFont(ofSize: 24)
    return label
  }()
  
  private let stackView: UIStackView = {
    let view = UIStackView()
    view.distribution = .fillEqually
    return view
  }()
  
  private let addButton: UIButton = {
    let button = UIButton()
    button.setTitle("+", for: .normal)
    button.setTitleColor(.systemBlue, for: .normal)
    button.setTitleColor(.blue, for: .highlighted)
    return button
  }()
  
  private let subtractButton: UIButton = {
    let button = UIButton()
    button.setTitle("-", for: .normal)
    button.setTitleColor(.systemBlue, for: .normal)
    button.setTitleColor(.blue, for: .highlighted)
    return button
  }()
  
  private var disposeBag = DisposeBag()
  private let countRelay = BehaviorRelay<Int>(value: 0)
  
  override func viewDidLoad() {
    super.viewDidLoad()
  
    self.setupViews()
    self.addRoutingVC2InNavigationItem()
    self.addSubviews()
    self.setupLayout()
    self.bindInput()
  }
  
  private func setupViews() {
    self.view.backgroundColor = .systemGray5
    self.title = "카운터 구현"
  }
  
  private func addRoutingVC2InNavigationItem() {
    let addRoutingVC2Button = UIButton()
    addRoutingVC2Button.setTitle("토글 버튼", for: .normal)
    addRoutingVC2Button.setTitleColor(.systemBlue, for: .normal)
    
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: addRoutingVC2Button)
    addRoutingVC2Button.rx.tap
      .withUnretained(self)
      .bind { ss, _ in
        let vc2 = VC2()
        ss.navigationController?.pushViewController(vc2, animated: true)
      }
      .disposed(by: self.disposeBag)
  }
  
  private func addSubviews() {
    self.view.addSubview(self.countLabel)
    self.view.addSubview(self.stackView)
    self.stackView.addArrangedSubview(self.subtractButton)
    self.stackView.addArrangedSubview(self.addButton)
  }
  
  private func setupLayout() {
    self.countLabel.snp.makeConstraints {
      $0.top.equalToSuperview().inset(100)
      $0.centerX.equalToSuperview()
    }
    self.stackView.snp.makeConstraints {
      $0.left.right.equalToSuperview().inset(16)
      $0.top.equalTo(self.countLabel.snp.bottom).offset(16)
    }
  }
  
  private func bindInput() {
    self.addButton.rx.tap
      .map { 1 }
      .bind(to: self.countRelay)
      .disposed(by: self.disposeBag)

    self.subtractButton.rx.tap
      .map { -1 }
      .bind(to: self.countRelay)
      .disposed(by: self.disposeBag)
    
    self.countRelay
      .scan(0, accumulator: { $0 + $1 }) // $0: lastValue, $1: newValue
      .withUnretained(self)
      .map { "\($1)" }
      .bind(to: self.countLabel.rx.text)
      .disposed(by: self.disposeBag)
  }
}
