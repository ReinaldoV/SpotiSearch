//
//  AppCoordinator.swift
//  SpotiSearch
//
//  Created by Reinaldo Villanueva Javierre on 8/2/21.
//

import UIKit

class AppCoordinator {

    let window: UIWindow
    let keychainManager: KeychainManager

    init(window: UIWindow, keychainManager: KeychainManager) {
        self.window = window
        self.keychainManager = keychainManager
    }

    func start() {
        do {
            let refreshToken = try self.keychainManager.searchItem()
            //Create search with refreshToken
        } catch {
            //Create search withouth refreshToken
            //put on him the auth view
        }
    }
}
