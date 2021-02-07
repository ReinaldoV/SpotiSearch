//
//  AuthorizationCoordinator.swift
//  SpotiSearch
//
//  Created by Reinaldo Villanueva Javierre on 7/2/21.
//

import UIKit

protocol AuthorizationCoordinatorProtocol {
    func openLoginWebViewController(view: UIViewController)
}

protocol AuthorizationCompleteDelegate: class {
    func authAccepted(authCode: String)
    func authCanceled()
}

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
        let authViewController = AuthorizationViewController.instantiate(coordinator: self)
        let navigation = UINavigationController(rootViewController: authViewController)
        navigation.modalPresentationStyle = .fullScreen
        self.parent.present(navigation, animated: true, completion: nil)
    }

    private func showLoginViewControler(view: UIViewController) {
        let loginCoordinator = LoginCoordinator(parentViewController: view,
                                                loginURL: authManager.requestAuthorizationURL(),
                                                delegate: self)
        loginCoordinator.start()
    }
}

extension AuthorizationCoordinator: AuthorizationCoordinatorProtocol {

    func openLoginWebViewController(view: UIViewController) {
        self.showLoginViewControler(view: view)
    }
}

extension AuthorizationCoordinator: AuthorizationCompleteDelegate {
    func authAccepted(authCode: String) {

    }

    func authCanceled() {

    }
}
