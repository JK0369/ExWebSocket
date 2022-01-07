//
//  NameViewController.swift
//  ExWebSockets
//
//  Created by Jake.K on 2022/01/07.
//

import UIKit

final class EmojiViewController: UIViewController {
  // MARK: Constants
  private enum Metric {
    static let collectionViewItemSize = CGSize(width: 40, height: 40)
    static let collectionViewSpacing = 16.0
    static let collectionViewContentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
  }
  private enum Color {
    static let white = UIColor.white
    static let clear = UIColor.clear
  }
  
  private let emojis = ["😀", "😬", "😁", "😂", "😃", "😄", "😅", "😆", "😇", "😉", "😊", "🙂", "🙃", "☺️", "😋", "😌", "😍", "😘", "😗", "😙", "😚", "😜", "😝", "😛", "🤑", "🤓", "😎", "🤗", "😏", "😶", "😐", "😑", "😒", "🙄", "🤔", "😳", "😞", "😟", "😠", "😡", "😔", "😕", "🙁", "☹️", "😣", "😖", "😫", "😩", "😤", "😮", "😱", "😨", "😰", "😯", "😦", "😧", "😢", "😥", "😪", "😓", "😭", "😵", "😲", "🤐", "😷", "🤒", "🤕", "😴", "💩"]
  
  private let collectionView: UICollectionView = {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.itemSize = Metric.collectionViewItemSize
    flowLayout.minimumInteritemSpacing = Metric.collectionViewSpacing
    flowLayout.minimumLineSpacing = Metric.collectionViewSpacing
    
    let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    view.register(EmojiCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    view.contentInset = Metric.collectionViewContentInset
    view.showsHorizontalScrollIndicator = false
    view.backgroundColor = Color.clear
    return view
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "이모지 선택"
    
    self.view.backgroundColor = Color.white
    self.view.addSubview(self.collectionView)
    self.collectionView.snp.makeConstraints {
      $0.left.right.equalToSuperview()
      $0.top.bottom.equalTo(self.view.safeAreaLayoutGuide)
    }
    
    self.collectionView.dataSource = self
    self.collectionView.delegate = self
  }
}

extension EmojiViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    self.emojis.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! EmojiCollectionViewCell
    cell.prepare(emoji: emojis[indexPath.item])
    return cell
  }
}
