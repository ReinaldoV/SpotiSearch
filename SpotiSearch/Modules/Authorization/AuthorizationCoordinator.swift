//
//  AuthorizationCoordinator.swift
//  SpotiSearch
//
//  Created by Reinaldo Villanueva Javierre on 7/2/21.
//

import UIKit

protocol AuthorizationCoordinatorProtocol: class {
    func openLoginWebViewController(view: UIViewController)
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
        let loginURL = self.authManager.requestAuthorizationURL()
        let loginViewController = LoginViewController(loginUrl: loginURL)
        view.navigationController?.pushViewController(loginViewController, animated: true)
    }
}

extension AuthorizationCoordinator: AuthorizationCoordinatorProtocol {

    func openLoginWebViewController(view: UIViewController) {
        self.showLoginViewControler(view: view)
    }
}
