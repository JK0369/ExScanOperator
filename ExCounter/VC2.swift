//
//  VC2.swift
//  ExCounter
//
//  Created by Jake.K on 2021/12/28.
//

import UIKit
import RxSwift
import RxCocoa

final class VC2: UIViewController {
  private lazy var toggleLabel: UILabel = {
    let label = UILabel()
    label.textColor = .black
    label.text = "버튼이 현재 선택되어있는지? -> \(self.button.isSelected)"
    return label
  }()
  
  private let button: UIButton = {
    let button = UIButton()
    button.setTitle("버튼", for: .normal)
    button.setTitleColor(.systemBlue, for: .normal)
    button.setTitleColor(.blue, for: .highlighted)
    return button
  }()
  
  private let disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.addRoutingVC3InNavigationItem()
    self.title = "토글 버튼 구현"
    
    self.view.backgroundColor = .systemGray5
    
    self.view.addSubview(self.toggleLabel)
    self.view.addSubview(self.button)
    
    self.toggleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().inset(100)
      $0.centerX.equalToSuperview()
    }
    self.button.snp.makeConstraints {
      $0.left.right.equalToSuperview().inset(16)
      $0.top.equalTo(self.toggleLabel.snp.bottom).offset(16)
    }
    
    self.button.rx.tap
      .scan(false) { lastState, newState in !lastState }
      .map { "버튼이 현재 선택되어있는지? -> \($0)" }
      .bind(to: self.toggleLabel.rx.text)
      .disposed(by: self.disposeBag)
  }
  
  private func addRoutingVC3InNavigationItem() {
    let addRoutingVC3Button = UIButton()
    addRoutingVC3Button.setTitle("텍스트 입력 제한", for: .normal)
    addRoutingVC3Button.setTitleColor(.systemBlue, for: .normal)
    
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: addRoutingVC3Button)
    addRoutingVC3Button.rx.tap
      .withUnretained(self)
      .bind { ss, _ in
        let vc3 = VC3()
        ss.navigationController?.pushViewController(vc3, animated: true)
      }
      .disposed(by: self.disposeBag)
  }
}
