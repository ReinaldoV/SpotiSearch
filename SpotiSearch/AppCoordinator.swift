//
//  AppCoordinator.swift
//  SpotiSearch
//
//  Created by Reinaldo Villanueva Javierre on 8/2/21.
//

import UIKit

protocol AppCoordinatorProtocol {
    func logout()
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
                                          searchManager: SearchManager(),
                                          favoritesManager: FavoritesManager())
        let presenter = SearchPresenter(interactor: interactor)
        let view = SearchViewController.instantiate(presenter: presenter, coordinator: self)
        interactor.presenter = presenter
        presenter.view = view
        self.rootViewController = view

        self.window.rootViewController = view
    }
}

extension AppCoordinator: AppCoordinatorProtocol {
    func logout() {
        do {
            try self.keychainManager.deleteItem()
        } catch {
            //error deleting refresh token
        }
        let coordinator = AuthorizationCoordinator(parentViewController: self.rootViewController ?? UIViewController(),
                                                   tokenDelegate: self)
        coordinator.start()
    }
}

extension AppCoordinator: AuthorizationTokenRetrieverDelegate {
    func newTokenRecived(token: Token) {
        self.rootViewController?.recieveNewToken(token)
    }
}
