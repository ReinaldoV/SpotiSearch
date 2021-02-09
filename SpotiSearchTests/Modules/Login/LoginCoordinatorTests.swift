//
//  LoginCoordinatorTests.swift
//  SpotiSearchTests
//
//  Created by Reinaldo Villanueva Javierre on 9/2/21.
//

import XCTest
@testable import SpotiSearch

class LoginCoordinatorTests: XCTestCase {

    var sut: LoginCoordinator!
    var delegateMock: AuthorizationCompleteDelegateMock!

    override func setUp() {
        super.setUp()
        createSut()
    }

    override func tearDown() {
        releaseSut()
        super.tearDown()
    }

    func createSut() {
        delegateMock = AuthorizationCompleteDelegateMock()
        sut = LoginCoordinator(parentViewController: UIViewController(),
                               loginURL: nil,
                               delegate: delegateMock)
    }

    func releaseSut() {
        sut = nil
        delegateMock = nil
    }

    // MARK: - Basic test.
    func testSutIsntNil() {
        XCTAssertNotNil(sut, "Sut must not be nil.")
    }

    // MARK: - Test viewDidLoad
    func testAuthAccepted() {
        sut.authAccepted(authCode: "")
        XCTAssertTrue(delegateMock.authAcceptedWasCalled)
    }

    func testAuthCanceled() {
        sut.authCanceled()
        XCTAssertTrue(delegateMock.authCanceledWasCalled)
    }
}

class AuthorizationCompleteDelegateMock: AuthorizationCompleteDelegate {

    var authAcceptedWasCalled = false
    var authCanceledWasCalled = false

    func authAccepted(authCode: String) {
        authAcceptedWasCalled = true
    }

    func authCanceled() {
        authCanceledWasCalled = true
    }
}
