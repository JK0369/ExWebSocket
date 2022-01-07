//
//  EmojiViewController.swift
//  ExWebSockets
//
//  Created by Jake.K on 2022/01/07.
//

import UIKit
// 1
import Starscream

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

  // MARK: UI
  private let informationLabel: UILabel = {
    let label = UILabel()
    label.textColor = .black
    return label
  }()
  private let sendButton: UIButton = {
    let button = UIButton()
    button.setTitle("이모지 전송", for: .normal)
    button.setTitleColor(.systemBlue, for: .normal)
    button.setTitleColor(.blue, for: .highlighted)
    button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    return button
  }()
  private let separatorView: UIView = {
    let view = UIView()
    view.backgroundColor = .lightGray
    return view
  }()
  
  // MARK: Priperties
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
  private var informationLabelText: String = "" {
    didSet {
      self.informationLabel.attributedText = NSMutableAttributedString()
        .resize(string: self.informationLabelText, fontSize: 120)
    }
  }
  private let userName: String
  private var socket: WebSocket?
  
  init() {
    self.userName = UserDefaults.standard.string(forKey: "name") ?? ""
    super.init(nibName: nil, bundle: nil)
  }
  
  // 5
  deinit {
    socket?.disconnect()
    socket?.delegate = nil
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "이모지 선택"
    
    self.view.backgroundColor = Color.white
    self.view.addSubview(self.collectionView)
    self.view.addSubview(self.informationLabel)
    self.view.addSubview(self.sendButton)
    self.view.addSubview(self.separatorView)
    
    self.collectionView.snp.makeConstraints {
      $0.left.right.equalToSuperview()
      $0.top.equalTo(self.view.safeAreaLayoutGuide).inset(250)
      $0.bottom.equalTo(self.view.safeAreaLayoutGuide)
    }
    self.informationLabel.snp.makeConstraints {
      $0.top.equalTo(self.view.safeAreaLayoutGuide).inset(32)
      $0.centerX.equalToSuperview()
    }
    self.sendButton.snp.makeConstraints {
      $0.top.equalTo(self.collectionView.snp.top).offset(-50)
      $0.centerX.equalToSuperview()
    }
    self.separatorView.snp.makeConstraints {
      $0.height.equalTo(1)
      $0.bottom.equalTo(self.collectionView.snp.top).offset(1)
      $0.left.right.equalToSuperview()
    }
    
    self.collectionView.dataSource = self
    self.collectionView.delegate = self
    
    // 2 connect to web socket server
    self.setupWebSocket()
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesEnded(touches, with: event)
    self.view.endEditing(true)
  }
  
  private func setupWebSocket() {
    let url = URL(string: "ws://localhost:1337/")!
    var request = URLRequest(url: url)
    request.timeoutInterval = 5
    socket = WebSocket(request: request)
    socket?.delegate = self
    socket?.connect()
  }
  
  @objc private func didTapButton() {
    // 3-2
    self.sendMessage(self.informationLabelText)
  }
  
  // 3-1
  private func sendMessage(_ message: String) {
    self.title = "메세지 전송"
    socket?.write(string: message)
  }
  
  // 4-1
  private func receivedMessage(_ message: String, senderName: String) {
    self.title = "메세지 from (\(senderName))"
    self.informationLabelText = message
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
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let message = emojis[indexPath.item]
    self.informationLabelText = message
  }
}

extension EmojiViewController: WebSocketDelegate {
  func didReceive(event: WebSocketEvent, client: WebSocket) {
    switch event {
    case .connected(let headers):
      client.write(string: userName)
      print("websocket is connected: \(headers)")
    case .disconnected(let reason, let code):
      print("websocket is disconnected: \(reason) with code: \(code)")
    case .text(let text):
      // 4-2
      guard let data = text.data(using: .utf16),
        let jsonData = try? JSONSerialization.jsonObject(with: data, options: []),
        let jsonDict = jsonData as? NSDictionary,
        let messageType = jsonDict["type"] as? String else {
          return
      }
      
      if messageType == "message",
        let messageData = jsonDict["data"] as? NSDictionary,
        let messageAuthor = messageData["author"] as? String,
        let messageText = messageData["text"] as? String {
        self.receivedMessage(messageText, senderName: messageAuthor)
      }
    case .binary(let data):
      print("Received data: \(data.count)")
    case .ping(_):
      break
    case .pong(_):
      break
    case .viabilityChanged(_):
      break
    case .reconnectSuggested(_):
      break
    case .cancelled:
      print("websocket is canclled")
    case .error(let error):
      print("websocket is error = \(error!)")
    }
  }
}
