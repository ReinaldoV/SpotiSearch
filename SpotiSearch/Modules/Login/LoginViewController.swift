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
    var coordinator: LoginCoordinatorProtocol?

    convenience init(loginUrl: URL?, coordinator: LoginCoordinatorProtocol?) {
        self.init()
        self.myURL = loginUrl
        self.coordinator = coordinator
    }

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
                self.coordinator?.authCanceled()
                return
            }
            self.coordinator?.authAccepted(authCode: code)
            decisionHandler(.cancel)
            return
        }
        decisionHandler(.allow)
    }
}
