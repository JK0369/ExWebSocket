//
//  EmojiCollectionViewCell.swift
//  ExWebSockets
//
//  Created by Jake.K on 2022/01/07.
//

import UIKit
import SnapKit

final class EmojiCollectionViewCell: UICollectionViewCell {
  // MARK: UI
  private let emojiLabel: UILabel = {
    let label = UILabel()
    return label
  }()
  
  // MARK: Initializers
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.contentView.backgroundColor = .lightGray
    self.contentView.addSubview(self.emojiLabel)
    self.emojiLabel.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    self.prepare(emoji: "")
  }
  
  func prepare(emoji: String) {
    self.emojiLabel.attributedText = NSMutableAttributedString()
      .resize(string: emoji, fontSize: 40)
  }
}
