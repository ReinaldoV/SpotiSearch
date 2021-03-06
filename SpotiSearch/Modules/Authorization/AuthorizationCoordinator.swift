//
//  AuthorizationCoordinator.swift
//  SpotiSearch
//
//  Created by Reinaldo Villanueva Javierre on 7/2/21.
//

import UIKit

protocol AuthorizationCoordinatorProtocol {
    func openLoginWebViewController(view: UIViewController)
    func recieveTokenFromAuth(token: Token)
}

protocol AuthorizationCompleteDelegate: class {
    func authAccepted(authCode: String)
    func authCanceled()
}

class AuthorizationCoordinator {

    let parent: UIViewController
    let authManager: AuthorizationManagerProtocol
    private weak var tokenDelegate: AuthorizationTokenRetrieverDelegate?
    private weak var authViewController: AuthorizationViewControllerProtocol?


    init(parentViewController: UIViewController,
         tokenDelegate: AuthorizationTokenRetrieverDelegate,
         authorizationManager: AuthorizationManagerProtocol = AuthorizationManager()) {
        self.parent = parentViewController
        self.tokenDelegate = tokenDelegate
        self.authManager = authorizationManager
    }

    func start() {
        showAuthorizationViewControler()
    }

    private func showAuthorizationViewControler() {
        let interactor = AuthorizationInteractor()
        let presenter = AuthorizationPresenter(interactor: interactor)
        let authViewController = AuthorizationViewController.instantiate(coordinator: self, presenter: presenter)
        interactor.presenter = presenter
        presenter.viewController = authViewController
        let navigation = UINavigationController(rootViewController: authViewController)
        navigation.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigation.navigationBar.shadowImage = UIImage()
        navigation.navigationBar.isTranslucent = true
        navigation.view.backgroundColor = .clear
        self.authViewController = authViewController
        navigation.modalPresentationStyle = .overCurrentContext
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

    func recieveTokenFromAuth(token: Token) {
        self.authViewController?.dismiss(animated: true, completion: nil)
        self.tokenDelegate?.newTokenRecived(token: token)
    }
}

extension AuthorizationCoordinator: AuthorizationCompleteDelegate {
    func authAccepted(authCode: String) {
        self.authViewController?.getTokens(fromAuthCode: authCode)
    }

    func authCanceled() {
        let alert = UIAlertController(title: "Login Error",
                                      message: "You need to log in with Spotify to search for your favorite music",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default))
        self.authViewController?.present(alert, animated: false, completion: nil)
    }
}
