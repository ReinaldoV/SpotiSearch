//
//  AppCoordinator.swift
//  SpotiSearch
//
//  Created by Reinaldo Villanueva Javierre on 8/2/21.
//

import UIKit

protocol AppCoordinatorProtocol {

}

protocol AuthorizationTokenRetrieverDelegate: class {
    func newTokenRecived(token: Token)
}

class AppCoordinator {

    let window: UIWindow
    let keychainManager: KeychainManager
    weak var rootViewController: SearchViewControllerProtocol?

    init(window: UIWindow, keychainManager: KeychainManager) {
        self.window = window
        self.keychainManager = keychainManager
    }

    func start() {
        do {
            let refreshToken = try self.keychainManager.searchItem()
            self.showSearchModule()
            self.rootViewController?.getNewToken(withRefreshToken: refreshToken)
        } catch {
            self.showSearchModule()
            let coordinator = AuthorizationCoordinator(parentViewController: self.rootViewController ?? UIViewController(),
                                                       tokenDelegate: self)
            coordinator.start()
        }
    }

    private func showSearchModule() {
        let interactor = SearchInteractor(tokenManager: TokenManager(),
                                          searchManager: SearchManager())
        let presenter = SearchPresenter(interactor: interactor)
        let view = SearchViewController.instantiate(presenter: presenter, coordinator: self)
        interactor.presenter = presenter
        presenter.view = view
        self.rootViewController = view

        let navigation = UINavigationController(rootViewController: view)
        self.window.rootViewController = navigation
    }
}

extension AppCoordinator: AppCoordinatorProtocol {

}

extension AppCoordinator: AuthorizationTokenRetrieverDelegate {
    func newTokenRecived(token: Token) {
        self.rootViewController?.recieveNewToken(token)
    }
}
