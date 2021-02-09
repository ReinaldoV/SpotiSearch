//
//  AuthorizationViewControllerTests.swift
//  SpotiSearchTests
//
//  Created by Reinaldo Villanueva Javierre on 9/2/21.
//

import XCTest
@testable import SpotiSearch

class AuthorizationViewControllerTests: XCTestCase {

    var sut: AuthorizationViewController!

    override func setUp() {
        super.setUp()
        createSut()
    }

    override func tearDown() {
        releaseSut()
        super.tearDown()
    }

    func createSut() {
        sut = AuthorizationViewController.instantiate(coordinator: nil,
                                                      presenter: AuthorizationPresenterProtocolMock())
    }

    func releaseSut() {
        sut = nil
    }

    // MARK: - Basic test.
    func testSutIsntNil() {
        XCTAssertNotNil(sut, "Sut must not be nil.")
    }

    // MARK: - Test viewDidLoad
    func testLoadViewSuccess() {
        _ = sut.view
        sut.viewWillAppear(true)
    }
}

class AuthorizationPresenterProtocolMock: AuthorizationPresenterProtocol {
    func requestToken(withAuthCode code: String) {

    }

    func refreshInfoInView(withToken token: Token) {

    }

    func errorOnAPI() {

    }
}
