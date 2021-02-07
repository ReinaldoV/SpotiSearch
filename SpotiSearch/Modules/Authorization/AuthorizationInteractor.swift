//
//  AuthorizationInteractor.swift
//  SpotiSearch
//
//  Created by Reinaldo Villanueva Javierre on 7/2/21.
//

protocol AuthorizationInteractorProtocol {
    func requestToken(withAuthCode code: String)
}

class AuthorizationInteractor {

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

    }
}
