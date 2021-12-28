//
//  VC3.swift
//  ExCounter
//
//  Created by Jake.K on 2021/12/28.
//

import UIKit
import RxSwift
import RxCocoa

final class VC3: UIViewController {
  
  private let textField: UITextField = {
    let field = UITextField()
    field.borderStyle = .roundedRect
    field.placeholder = "입력"
    return field
  }()
  
  private let disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "텍스트 입력 제한"
    self.view.backgroundColor = .systemGray5
    
    self.view.addSubview(self.textField)
    
    self.textField.snp.makeConstraints {
      $0.top.equalToSuperview().inset(100)
      $0.centerX.equalToSuperview()
    }
    
    textField.rx.text.orEmpty.asObservable()
      .scan("") { lastValue, newValue in
        let removedSpaceString = newValue.replacingOccurrences(of: " ", with: "")
        return removedSpaceString.count == newValue.count ? newValue : lastValue
      }
      .bind(to: self.textField.rx.text)
      .disposed(by: self.disposeBag)
  }
}
