//
//  AuthorizationInteractor.swift
//  SpotiSearch
//
//  Created by Reinaldo Villanueva Javierre on 7/2/21.
//

import Foundation

protocol AuthorizationInteractorProtocol {
    func requestToken(withAuthCode code: String)
}

class AuthorizationInteractor {

    weak var presenter: AuthorizationPresenterProtocol?
    let keyChainManager: KeychainManagerProtocol
    let tokenManager: TokenManagerProtocol

    init(keyChainManager: KeychainManagerProtocol = KeychainManager(),
         tokenManager: TokenManagerProtocol = TokenManager()) {
        self.keyChainManager = keyChainManager
        self.tokenManager = tokenManager
    }
}

extension AuthorizationInteractor: AuthorizationInteractorProtocol {
    func requestToken(withAuthCode code: String) {
        self.tokenManager.requestToken(withAuthorizationCode: code) { tokenDTO in
            do {
                try self.keyChainManager.storeItem(code: tokenDTO.refreshToken)
                DispatchQueue.main.async {
                    self.presenter?.refreshInfoInView(withToken: Token(tokenDTO: tokenDTO))
                }
            } catch KeychainError.unhandledError(let status) {
                print(status)
            } catch {
                print(error)
            }
        } onError: { (error) in
            //Handle Offline errors and such
        }

    }
}
