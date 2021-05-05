//
//  ViewController.swift
//  TwitchChatApplication
//
//  Created by Mac on 24.04.2021.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, TwitchChatConnectionDelegate, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var channelNameLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var arrayOfChatMessages: [TwitchChatMessage] = []
    
    
    func initChannelNameLabelConstraints() {
        channelNameLabel.font = UIFont(name:"HelveticaNeue-Bold", size: 20.0)
        
        channelNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let horizontalConstraint = NSLayoutConstraint(item: channelNameLabel!, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
        let verticalConstraint = NSLayoutConstraint(item: channelNameLabel!, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 20)
        view.addConstraints([horizontalConstraint, verticalConstraint])
    }
    
    func initTableViewConstraints() {
        tableView.backgroundColor = UIColor.init(red: 0.968, green: 0.968, blue: 0.972, alpha: 0.0)
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        let horizontalConstraint = NSLayoutConstraint(item: tableView!, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
        let verticalConstraint = NSLayoutConstraint(item: tableView!, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: tableView!, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: tableView!, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.height, multiplier: 1, constant: -100)
        view.addConstraints([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initChannelNameLabelConstraints()
        initTableViewConstraints()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let twitchChat = TwitchChatConnection()

        twitchChat.delegate = self
        
        twitchChat.willRead = true

        twitchChat.connectToTheServer()
        twitchChat.connectToTheChatChannel(into: "dinablin")

        twitchChat.readMessage()

        DispatchQueue.main.asyncAfter(deadline: .now() + 20) {
            twitchChat.willRead = false
        }
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfChatMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath)
        let message = arrayOfChatMessages[indexPath.row]
        
        let nicknameText = message.nickname
        let attrs = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16)]
        let nicknameString = NSMutableAttributedString(string: nicknameText, attributes: attrs)
        
        let messageText = ": \(message.message)"
        let attrs2 = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16.0)]
        let messageString = NSMutableAttributedString(string: messageText, attributes: attrs2)
        
        nicknameString.append(messageString)
        
        cell.textLabel?.attributedText = nicknameString
        //cell.textLabel!.text = "\(message.nickname): \(message.message)"
        
        cell.textLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
        cell.textLabel?.numberOfLines = 0
        
        return cell
    }
    
    func onChatMessage(_ message: String) {
        let chatMessage = TwitchChatMessage(rawMessage: message)
        
        self.arrayOfChatMessages.append(chatMessage)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
    
    func onJoinChannel(_ nameChannel: String) {
        DispatchQueue.main.async {
            self.channelNameLabel.text = nameChannel
        }
    }


}

