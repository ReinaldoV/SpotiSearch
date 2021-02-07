//
//  LoginCoordinator.swift
//  SpotiSearch
//
//  Created by Reinaldo Villanueva Javierre on 7/2/21.
//

import UIKit

protocol LoginCoordinatorProtocol {
    func authAccepted(authCode: String)
    func authCanceled()
}

class LoginCoordinator {

    let parent: UIViewController
    let loginURL: URL?
    weak var loginViewController: UIViewController?
    weak var delegate: AuthorizationCompleteDelegate?

    init(parentViewController: UIViewController,
         loginURL: URL?,
         delegate: AuthorizationCompleteDelegate) {
        self.parent = parentViewController
        self.loginURL = loginURL
        self.delegate = delegate
    }

    func start() {
        showLoginViewControler()
    }

    private func showLoginViewControler() {
        let loginViewController = LoginViewController(loginUrl: self.loginURL, coordinator: self)
        self.loginViewController = loginViewController
        self.parent.navigationController?.pushViewController(loginViewController, animated: true)
    }
}

extension LoginCoordinator: LoginCoordinatorProtocol {

    func authAccepted(authCode: String) {
        self.delegate?.authAccepted(authCode: authCode)
        self.loginViewController?.navigationController?.popViewController(animated: true)
    }

    func authCanceled() {
        self.delegate?.authCanceled()
        self.loginViewController?.navigationController?.popViewController(animated: true)
    }
}
