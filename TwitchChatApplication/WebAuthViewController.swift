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
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(String(describing: error))
    }
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        print("captured redirect")
        if let url = webView.url  {
            guard let accessToken = url["access_token"] else {
                return
            }
            dismiss(animated: true, completion: nil)
            delegate?.AccessTokenDidGet(accessToken)
            return
        }
    }
}


