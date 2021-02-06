//
//  LoginViewController.swift
//  SpotiSearch
//
//  Created by Reinaldo Villanueva Javierre on 6/2/21.
//

import WebKit

class LoginViewController: UIViewController {

    var webView = WKWebView()
    var myURL: URL?

    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = self.myURL {
          let myRequest = URLRequest(url: url)
          webView.load(myRequest)
        }
    }

    override func loadView() {
       let webConfiguration = WKWebViewConfiguration()
       webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.navigationDelegate = self
       view = webView
    }
}

extension LoginViewController: WKNavigationDelegate {
    public func webView(_ webView: WKWebView,
                        decidePolicyFor navigationAction: WKNavigationAction,
                        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

        if navigationAction.request.url?.host == "login-callback",
           let parameters = navigationAction.request.url?.queryParameters {
            guard let code = parameters["code"] else {
                decisionHandler(.cancel)
                return
            }
            TokenManager().requestToken(withAuthorizationCode: code)
            decisionHandler(.cancel)
            return
        }
        decisionHandler(.allow)
    }
}
