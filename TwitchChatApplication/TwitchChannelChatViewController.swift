//
//  ViewController.swift
//  TwitchChatApplication
//
//  Created by Mac on 24.04.2021.
//

import UIKit

class TwitchChannelChatViewController: UIViewController, UITextFieldDelegate, TwitchChatConnectionDelegate, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var channelNameLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    @IBOutlet var listeningButton: UIButton!
    @IBOutlet var messageTextField: UITextField!
    
    let numberOfMessagesInArray: Int = 100
    
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
        let textField = UITextField()
        
        button.addTarget(self, action: #selector(listeningButtonTouched), for: UIControl.Event.touchUpInside)
        button.setTitle("Start Listening", for: .normal)
        button.backgroundColor = .blue
        button.translatesAutoresizingMaskIntoConstraints = false
        
        
        textField.placeholder = "Text a message"
        textField.translatesAutoresizingMaskIntoConstraints = false

        
        let horizontalConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
        let verticalConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: textField, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 0)
        let width = NSLayoutConstraint(item: button, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1, constant: 0)
        let height = NSLayoutConstraint(item: button, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 50)
        
        let leadingConstraintTF = NSLayoutConstraint(item: textField, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: 50)
        let trailingConstraintTF = NSLayoutConstraint(item: textField, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: -50)
        let bottomConstrainTF = NSLayoutConstraint(item: textField, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 0)
        let heightConstraintTF = NSLayoutConstraint(item: textField, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 50)
        
        
        self.view.addSubview(button)
        self.view.addSubview(textField)
        
        self.listeningButton = button
        self.messageTextField = textField
        
        self.view.addConstraints([horizontalConstraint, verticalConstraint, width, height, leadingConstraintTF, trailingConstraintTF, bottomConstrainTF, heightConstraintTF])
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
        let tableView = UITableView()
        
        tableView.backgroundColor = UIColor.init(red: 0.968, green: 0.968, blue: 0.972, alpha: 0.0)
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let topConstraint = NSLayoutConstraint(item: tableView, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: channelNameLabel, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 20)
        let bottomConstraint = NSLayoutConstraint(item: tableView, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: listeningButton, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: -20)
        let leadingConstraint = NSLayoutConstraint(item: tableView, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: 0)
        let trailingConstraint = NSLayoutConstraint(item: tableView, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: 0)
        /*
        let horizontalConstraint = NSLayoutConstraint(item: tableView!, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
        let verticalConstraint = NSLayoutConstraint(item: tableView!, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: tableView!, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: tableView!, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.height, multiplier: 1, constant: -100)*/
        
        self.view.addSubview(tableView)
        self.tableView = tableView
        self.view.addConstraints([topConstraint, bottomConstraint, leadingConstraint, trailingConstraint])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initListeningButton()
        initChannelNameLabelConstraints()
        initTableViewConstraints()
        
        //tableView.delegate = self
        //tableView.dataSource = self

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
        //let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath)
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        let message = arrayOfChatMessages[indexPath.row]
        
        let nicknameText = message.nickname
        // Nickname color/bold style/ and on and on
        let attrs = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor : UIColor.red]
        let nicknameString = NSMutableAttributedString(string: nicknameText, attributes: attrs)
        
        let messageText = ": \(message.message)"
        let attrs2 = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16.0)]
        let messageString = NSMutableAttributedString(string: messageText, attributes: attrs2)
        
        nicknameString.append(messageString)
        
        cell.textLabel?.attributedText = nicknameString
        cell.textLabel?.numberOfLines = 0
        
        return cell
    }
    
    //ToDo:
    /*
        -add restriction of size of array
    */
     
    func onChatMessage(_ message: String) {
        
        let chatMessage = TwitchChatMessage(rawMessage: message)
        
        var tempArray = self.arrayOfChatMessages
        
        if(tempArray.count >= numberOfMessagesInArray)
        {
            tempArray.removeFirst()
            tempArray.append(chatMessage)
        }
        else{
            tempArray.append(chatMessage)
        }
        let count = tempArray.count - 1
        self.arrayOfChatMessages = tempArray
        DispatchQueue.main.async {
            
            self.tableView.reloadData()
            if(tempArray.count > 10) {
                self.tableView.scrollToRow(at: IndexPath(row: count, section: 0), at: UITableView.ScrollPosition.bottom, animated: true)
            }
        }
        
    }
    
    func onJoinChannel(_ nameChannel: String) {
        DispatchQueue.main.async {
            //self.listeningButton.isEnabled = true
            self.channelNameLabel.text = nameChannel
        }
    }


}

