//
//  TwitchChatLoginViewController.swift
//  TwitchChatApplication
//
//  Created by Mac on 06.05.2021.
//

import UIKit
import WebKit

class TwitchChatLoginViewController: UIViewController {
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var label: UILabel!
    
    private var nextViewController: TwitchChannelChatViewController!
    
    var accessToken: String!
    
    func initLoginButton() {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 300, height: 50))
        
        button.addTarget(self, action: #selector(loginButtonTouched), for: UIControl.Event.touchUpInside)
        button.setTitle("Login", for: .normal)
        button.backgroundColor = .purple
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitleColor(UIColor.gray, for: .highlighted)
        
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        
        
        let horizontalConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
        let verticalConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0)
        
        self.view.addSubview(button)
        self.loginButton = button
        self.view.addConstraints([horizontalConstraint, verticalConstraint])
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 50))
        label.numberOfLines = 0
        self.label = label
        self.view.addSubview(label)
    }
    
    func initWebView(_ url: URLRequest) {
        //DispatchQueue.main.async {
        
        
        let preferences = WKWebpagePreferences()
        preferences.allowsContentJavaScript = true
        let configuration = WKWebViewConfiguration()
        configuration.defaultWebpagePreferences = preferences
        
        let webView = WKWebView(frame: .zero, configuration: configuration)
        
        webView.backgroundColor = UIColor.black
        //webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false

        let horizontalConstraint = NSLayoutConstraint(item: webView, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
        let verticalConstraint = NSLayoutConstraint(item: webView, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: webView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: webView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.height, multiplier: 0.5, constant: 0)
            
        self.view.addSubview(webView)
        self.view.addConstraints([horizontalConstraint, verticalConstraint, heightConstraint, widthConstraint])
            
        webView.load(url)
        webView.sizeToFit()
        //}
    }
    
    @IBAction func loginButtonTouched(){
        let loginRequest = TwitchChatLogin()
        let vc = WebAuthViewController()
        vc.delegate = self
        vc.URLRequest = loginRequest.getRequset()
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initLoginButton()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension TwitchChatLoginViewController: WebAuthViewDelegate {
    func AccessTokenDidGet(_ acessToken: String) {
        self.accessToken = acessToken
        
        let login = TwitchChatLogin()
        login.delegate = self
        login.getUserObject(oauth: acessToken)
        label.text = acessToken
        print(acessToken)
        
        // TODO: Fix the problem of memory overflow!!!
        /*
        if self.nextViewController == nil {
            self.nextViewController = TwitchChannelChatViewController()
        }
        self.nextViewController.accessToken = acessToken
        self.navigationController?.pushViewController(self.nextViewController, animated: true)
        present(nextViewController, animated: true, completion: nil)
        //print("TwitchChatLoginViewContorller \(acessToken)")*/
    }
}
extension TwitchChatLoginViewController: TwitchChatLoginDelegate {
    func OnMessage(_ data: Data) {
        let str = String(decoding: data, as: UTF8.self)
        
        if str.isEmpty {
            print("Data is Empty")
            return
        }
        DispatchQueue.main.async {
            self.label.text! += "\n\(str)"
        }
    }
}
