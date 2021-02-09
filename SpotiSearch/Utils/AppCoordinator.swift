//
//  AppCoordinator.swift
//  SpotiSearch
//
//  Created by Reinaldo Villanueva Javierre on 8/2/21.
//

import UIKit

protocol AppCoordinatorProtocol {

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
            self.showSearchModule(withToken: nil, refreshToken: refreshToken)
        } catch {
            self.showSearchModule(withToken: nil, refreshToken: nil)
            let coordinator = AuthorizationCoordinator(parentViewController: self.rootViewController ?? UIViewController())
            coordinator.start()
        }
    }

    private func showSearchModule(withToken: Token?, refreshToken: String?) {
        let interactor = SearchInteractor(tokenManager: TokenManager(),
                                          searchManager: SearchManager(),
                                          token: withToken)
        let presenter = SearchPresenter(interactor: interactor)
        let view = SearchViewController.instantiate(presenter: presenter, coordinator: self)
        interactor.presenter = presenter
        presenter.view = view
        self.rootViewController = view

        let navigation = UINavigationController(rootViewController: view)
        self.window.rootViewController = navigation
        if let refresh = refreshToken {
            interactor.getToken(withRefreshToken: refresh)
        }
    }
}

extension AppCoordinator: AppCoordinatorProtocol {

}
