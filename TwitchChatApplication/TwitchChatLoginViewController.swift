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
    }
    
    func initWebView(_ url: URLRequest) {
        //DispatchQueue.main.async {
            let webView = WKWebView()
            webView.backgroundColor = UIColor.black
            
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
        /*loginRequest.delegate = self
        loginRequest.oAuthRequest()*/
        initWebView(loginRequest.getRequset())
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

extension TwitchChatLoginViewController: TwitchChatLoginDelegate {
    func OnMessage(_ data: Data) {
        let newString = String(data: data, encoding: .utf8)!
        print(newString)
        //self.initWebView(newString)
    }
}

extension URL {
    subscript(queryParam:String) -> String? {
        guard let url = URLComponents(string: self.absoluteString) else { return nil }
        return url.queryItems?.first(where: { $0.name == queryParam })?.value
    }
}

extension TwitchChatLoginViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        
    }
}
