//
//  AuthorizationPresenter.swift
//  SpotiSearch
//
//  Created by Reinaldo Villanueva Javierre on 7/2/21.
//

protocol AuthorizationPresenterProtocol: class {
    func requestToken(withAuthCode code: String)
    func refreshInfoInView(withToken token: Token)
    func errorOnAPI()
}

class AuthorizationPresenter {

    weak var viewController: AuthorizationViewControllerProtocol?
    let interactor: AuthorizationInteractorProtocol

    init(interactor: AuthorizationInteractorProtocol) {
        self.interactor = interactor
    }
}

extension AuthorizationPresenter: AuthorizationPresenterProtocol {

    func requestToken(withAuthCode code: String) {
        self.viewController?.showLoading()
        self.interactor.requestToken(withAuthCode: code)
    }

    func refreshInfoInView(withToken token: Token) {
        self.viewController?.stopLoading()
        self.viewController?.passTokenInfoToCoordinator(token)
    }

    func errorOnAPI() {
        self.viewController?.stopLoading()
    }
}
