//
//  NameViewController.swift
//  ExWebSockets
//
//  Created by Jake.K on 2022/01/07.
//

import UIKit
import SnapKit

class NameViewController: UIViewController {
  private let nameLabel: UILabel = {
    let label = UILabel()
    label.textColor = .black
    label.text = "당신의 이름이 무엇입니까?"
    return label
  }()
  private let nameTextField: UITextField = {
    let textField = UITextField()
    textField.borderStyle = .roundedRect
    textField.placeholder = "jake..."
    return textField
  }()
  private let confirmButton: UIButton = {
    let button = UIButton()
    button.setTitle("확인", for: .normal)
    button.setTitleColor(.systemBlue, for: .normal)
    button.setTitleColor(.black, for: .highlighted)
    return button
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    
    self.view.addSubview(self.nameLabel)
    self.view.addSubview(self.nameTextField)
    self.view.addSubview(self.confirmButton)
    
    self.nameLabel.snp.makeConstraints {
      $0.top.equalTo(self.view.safeAreaLayoutGuide)
      $0.centerX.equalToSuperview()
    }
    self.nameTextField.snp.makeConstraints {
      $0.top.equalTo(self.view.safeAreaLayoutGuide).inset(120)
      $0.centerX.equalToSuperview()
    }
    self.confirmButton.snp.makeConstraints {
      $0.centerX.centerY.equalToSuperview()
    }
    self.confirmButton.addTarget(self, action: #selector(didTapConfirmButton), for: .touchUpInside)
  }
  
  @objc
  private func didTapConfirmButton() {
    UserDefaults.standard.set(self.nameTextField.text, forKey: "name")
    let emojiViewController = EmojiViewController()
    self.navigationController?.pushViewController(emojiViewController, animated: true)
  }
}
