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
    
    
    
    @IBOutlet var listeningButton: UIButton!
    let numberOfMessagesInArray: Int = 1000
    
    var arrayOfChatMessages: [TwitchChatMessage] = []
    
    var twitchChat: TwitchChatConnection!
    
    @IBAction func listeningButtonTouched() {
        if self.twitchChat.willRead {
            self.listeningButton.setTitle("Start Listening", for: .normal)
            self.twitchChat.stopListening()
        }
        else {
            self.listeningButton.setTitle("Stop Listening", for: .normal)
            self.twitchChat.startListening()
        }
            
    }
    
    func initListeningButton () {
        let button = UIButton()
        
        button.addTarget(self, action: #selector(listeningButtonTouched), for: UIControl.Event.touchUpInside)
        button.setTitle("Start Listening", for: .normal)
        button.backgroundColor = .blue
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let horizontalConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
        let verticalConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: -15)
        let width = NSLayoutConstraint(item: button, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1, constant: 0)
        let height = NSLayoutConstraint(item: button, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 30)
        
        self.view.addSubview(button)
        self.listeningButton = button
        self.view.addConstraints([horizontalConstraint, verticalConstraint, width, height])
    }
    
    func initChannelNameLabelConstraints() {
        channelNameLabel.font = UIFont(name:"HelveticaNeue-Bold", size: 20.0)
        
        channelNameLabel.text = "channel"
        
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
        initListeningButton()
        initChannelNameLabelConstraints()
        initTableViewConstraints()
        
        tableView.delegate = self
        tableView.dataSource = self

        twitchChat = TwitchChatConnection()
        twitchChat.delegate = self

        twitchChat.connectToTheServer()
        twitchChat.connectToTheChatChannel(into: "modestal")
/*
        twitchChat.startListening()

        DispatchQueue.main.asyncAfter(deadline: .now() + 20) {
            self.twitchChat.stopListening()
        }*/
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
        
        //cell.textLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
        cell.textLabel?.numberOfLines = 0
        
        return cell
    }
    
    //ToDo:
    /*
        -add restriction of size of array
    */
     
    func onChatMessage(_ message: String) {
        
        let chatMessage = TwitchChatMessage(rawMessage: message)
        
        if(arrayOfChatMessages.count > numberOfMessagesInArray)
        {
            self.arrayOfChatMessages.removeFirst()
            self.arrayOfChatMessages.append(chatMessage)
        }
        else{
            self.arrayOfChatMessages.append(chatMessage)
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.tableView.scrollToRow(at: IndexPath(row: self.arrayOfChatMessages.count-1, section: 0), at: UITableView.ScrollPosition.bottom, animated: true)
        }
        
    }
    
    func onJoinChannel(_ nameChannel: String) {
        DispatchQueue.main.async {
            self.channelNameLabel.text = nameChannel
        }
    }


}

