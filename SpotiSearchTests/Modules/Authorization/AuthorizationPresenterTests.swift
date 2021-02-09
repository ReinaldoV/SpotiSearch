//
//  AuthorizationPresenterTests.swift
//  SpotiSearchTests
//
//  Created by Reinaldo Villanueva Javierre on 9/2/21.
//

import XCTest
@testable import SpotiSearch

class AuthorizationPresenterTests: XCTestCase {

    var sut: AuthorizationPresenter!
    var viewMock: AuthorizationViewControllerProtocolMock!
    var interactorMock: AuthorizationInteractorProtocolMock!

    override func setUp() {
        super.setUp()
        createSut()
    }

    override func tearDown() {
        releaseSut()
        super.tearDown()
    }

    func createSut() {
        self.viewMock = AuthorizationViewControllerProtocolMock()
        self.interactorMock = AuthorizationInteractorProtocolMock()
        sut = AuthorizationPresenter(interactor: self.interactorMock)
        sut.viewController = self.viewMock
    }

    func releaseSut() {
        sut = nil
        self.viewMock = nil
        self.interactorMock = nil
    }

    // MARK: - Basic test.
    func testSutIsntNil() {
        XCTAssertNotNil(sut, "Sut must not be nil.")
    }

    func testRequestToken() {
        sut.requestToken(withAuthCode: "")
        XCTAssertTrue(self.viewMock.showLoadingWasCalled)
        XCTAssertTrue(self.interactorMock.requestTokenWasCalled)
    }

    func testRefreshInfoInView() {
        sut.refreshInfoInView(withToken: Token(accessToken: "", expiresIn: Date()))
        XCTAssertTrue(self.viewMock.stopLoadingWasCalled)
        XCTAssertTrue(self.viewMock.passTokenInfoToCoordinatorWasCalled)
    }

    func testErrorOnAPI() {
        sut.errorOnAPI()
        XCTAssertTrue(self.viewMock.stopLoadingWasCalled)
    }
}

class AuthorizationViewControllerProtocolMock: UIViewController,
    AuthorizationViewControllerProtocol {
    var getTokensWasCalled = false
    var showLoadingWasCalled = false
    var stopLoadingWasCalled = false
    var passTokenInfoToCoordinatorWasCalled = false

    func getTokens(fromAuthCode code: String) {
        getTokensWasCalled = true
    }

    func showLoading() {
        showLoadingWasCalled = true
    }

    func stopLoading() {
        stopLoadingWasCalled = true
    }

    func passTokenInfoToCoordinator(_ token: Token) {
        passTokenInfoToCoordinatorWasCalled = true
    }
}

class AuthorizationInteractorProtocolMock: AuthorizationInteractorProtocol {

    var requestTokenWasCalled = false

    func requestToken(withAuthCode code: String) {
        requestTokenWasCalled = true
    }
}
