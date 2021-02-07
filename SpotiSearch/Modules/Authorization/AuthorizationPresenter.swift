//
//  AuthorizationPresenter.swift
//  SpotiSearch
//
//  Created by Reinaldo Villanueva Javierre on 7/2/21.
//

protocol AuthorizationPresenterProtocol {
    func requestToken(withAuthCode code: String)
}

class AuthorizationPresenter {

    let interactor: AuthorizationInteractorProtocol

    init(interactor: AuthorizationInteractorProtocol) {
        self.interactor = interactor
    }
}
