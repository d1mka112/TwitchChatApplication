//
//  WebAuthViewController.swift
//  TwitchChatApplication
//
//  Created by Mac on 19.05.2021.
//

import UIKit
import WebKit

class WebAuthViewController: UIViewController {

    private let webView: WKWebView = {
        let preferences = WKWebpagePreferences()
        preferences.allowsContentJavaScript = true
        
        let configuration = WKWebViewConfiguration()
        configuration.defaultWebpagePreferences = preferences
        
        let webView = WKWebView(frame: .zero, configuration: configuration)
        
        return webView
    }()
    
    var URLRequest: URLRequest?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Twitch Authorization"

        view.backgroundColor = .systemBackground
        view.addSubview(webView)
        guard (webView.load(URLRequest!) != nil) else {
            dismiss(animated: true, completion: nil)
            return
        }
    }
}


