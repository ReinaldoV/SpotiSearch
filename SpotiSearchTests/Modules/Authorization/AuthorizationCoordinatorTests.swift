//
//  AuthorizationCoordinatorTests.swift
//  SpotiSearchTests
//
//  Created by Reinaldo Villanueva Javierre on 9/2/21.
//

import XCTest
@testable import SpotiSearch

class AuthorizationCoordinatorTests: XCTestCase {

    var sut: AuthorizationCoordinator!
    var viewControllerMock: UIViewControllerMock!
    var authorizationTokenRetrieverDelegateMock: AuthorizationTokenRetrieverDelegateMock!
    var authorizationManagerProtocolMock: AuthorizationManagerProtocolMock!

    override func setUp() {
        super.setUp()
        createSut()
    }

    override func tearDown() {
        releaseSut()
        super.tearDown()
    }

    func createSut() {
        viewControllerMock = UIViewControllerMock()
        authorizationTokenRetrieverDelegateMock = AuthorizationTokenRetrieverDelegateMock()
        authorizationManagerProtocolMock = AuthorizationManagerProtocolMock()
        sut = AuthorizationCoordinator(parentViewController: viewControllerMock,
                                       tokenDelegate: authorizationTokenRetrieverDelegateMock,
                                       authorizationManager: authorizationManagerProtocolMock)
    }

    func releaseSut() {
        sut = nil
        viewControllerMock = nil
        authorizationTokenRetrieverDelegateMock = nil
        authorizationManagerProtocolMock = nil
    }

    // MARK: - Basic test.
    func testSutIsntNil() {
        XCTAssertNotNil(sut, "Sut must not be nil.")
    }

    func testOpenLoginWebViewController() {
        sut.openLoginWebViewController(view: viewControllerMock)
        XCTAssertTrue(authorizationManagerProtocolMock.requestAuthorizationURLWasCalled)
    }

    func testRecieveTokenFromAuth() {
        sut.recieveTokenFromAuth(token: Token(accessToken: "", expiresIn: Date()))
        XCTAssertTrue(authorizationTokenRetrieverDelegateMock.newTokenRecivedWasCalled)
    }

    func testAuthAccepted() {
        sut.authAccepted(authCode: "")
    }

    func testAuthCanceled() {
        sut.authCanceled()
    }
}

class AuthorizationTokenRetrieverDelegateMock: AuthorizationTokenRetrieverDelegate {

    var newTokenRecivedWasCalled = false

    func newTokenRecived(token: Token) {
        newTokenRecivedWasCalled = true
    }
}

class AuthorizationManagerProtocolMock: AuthorizationManagerProtocol {

    var requestAuthorizationURLWasCalled = false

    func requestAuthorizationURL() -> URL? {
        requestAuthorizationURLWasCalled = true
        return nil
    }
}
