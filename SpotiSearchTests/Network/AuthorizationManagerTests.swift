//
//  AuthorizationManagerTests.swift
//  SpotiSearchTests
//
//  Created by Reinaldo Villanueva Javierre on 9/2/21.
//

import XCTest
@testable import SpotiSearch

class AuthorizationManagerTests: XCTestCase {

    var sut: AuthorizationManager!

    override func setUp() {
        super.setUp()
        createSut()
    }

    override func tearDown() {
        releaseSut()
        super.tearDown()
    }

    func createSut() {
        sut = AuthorizationManager()
    }

    func releaseSut() {
        sut = nil
    }

    // MARK: - Basic test.
    func testSutIsntNil() {
        XCTAssertNotNil(sut, "Sut must not be nil.")
    }
    
    func testrequestAuthorizationURL() {
        let result = sut.requestAuthorizationURL()
        XCTAssertNotNil(result)
    }
}
