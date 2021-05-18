//
//  WebAuthViewController.swift
//  TwitchChatApplication
//
//  Created by Mac on 19.05.2021.
//

import UIKit
import WebKit

protocol WebAuthViewDelegate {
    func AccessTokenDidGet(_ acessToken: String)
}

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
    
    var delegate: WebAuthViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Twitch Authorization"

        view.backgroundColor = .systemBackground
        view.addSubview(webView)
        webView.navigationDelegate = self
        webView.frame = view.bounds
        guard (webView.load(URLRequest!) != nil) else {
            dismiss(animated: true, completion: nil)
            return
        }
    }
}

extension WebAuthViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == .other {
            if let url = navigationAction.request.url {
                guard let accessToken = url["access_token"] else {
                    decisionHandler(.allow)
                    return
                }
                //print(accessToken)
                delegate?.AccessTokenDidGet(accessToken)
                decisionHandler(.cancel)
                return
            }
        }
        print("captured")
        decisionHandler(.allow)
    }
}


