//
//  AuthorizationCoordinator.swift
//  SpotiSearch
//
//  Created by Reinaldo Villanueva Javierre on 7/2/21.
//

import UIKit

class AuthorizationCoordinator {

    let parent: UIViewController
    let authManager: AuthorizationManagerProtocol

    init(parentViewController: UIViewController,
         authorizationManager: AuthorizationManagerProtocol = AuthorizationManager()) {
        self.parent = parentViewController
        self.authManager = authorizationManager
    }

    func start() {
        showAuthorizationViewControler()
    }

    private func showAuthorizationViewControler() {
        let authViewController = AuthorizationViewController.instantiate(delegate: self)
        self.parent.show(authViewController, sender: nil)
    }

    private func showLoginViewControler() {
        let authViewController = AuthorizationViewController.instantiate(delegate: self)
        self.parent.show(authViewController, sender: nil)
    }
}

extension AuthorizationCoordinator: AuthorizationViewControllerDelegate {

    func openLoginWebViewController(view: UIViewController) {
        let loginURL = self.authManager.requestAuthorizationURL()
        let loginViewController = LoginViewController(loginUrl: loginURL)
        view.navigationController?.pushViewController(loginViewController, animated: true)
    }
}
