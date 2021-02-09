//
//  AuthorizationInteractorTests.swift
//  SpotiSearchTests
//
//  Created by Reinaldo Villanueva Javierre on 9/2/21.
//

import XCTest
@testable import SpotiSearch

class AuthorizationInteractorTests: XCTestCase {

    var sut: AuthorizationInteractor!
    var keychainManagerProtocolMock: KeychainManagerProtocolMock!
    var tokenManagerProtocolMock: TokenManagerProtocolMock!


    override func setUp() {
        super.setUp()
        createSut()
    }

    override func tearDown() {
        releaseSut()
        super.tearDown()
    }

    func createSut() {
        keychainManagerProtocolMock = KeychainManagerProtocolMock()
        tokenManagerProtocolMock = TokenManagerProtocolMock()
        sut = AuthorizationInteractor(keyChainManager: keychainManagerProtocolMock,
                                      tokenManager: tokenManagerProtocolMock)
    }

    func releaseSut() {
        sut = nil
        tokenManagerProtocolMock = nil
        keychainManagerProtocolMock = nil
    }

    // MARK: - Basic test.
    func testSutIsntNil() {
        XCTAssertNotNil(sut, "Sut must not be nil.")
    }

    func testrequestAuthorizationURL() {
        sut.requestToken(withAuthCode: "")
        XCTAssertTrue(tokenManagerProtocolMock.requestTokenWasCalled)
        XCTAssertTrue(keychainManagerProtocolMock.storeItemWasCalled)
    }
}

class KeychainManagerProtocolMock: KeychainManagerProtocol {

    var storeItemWasCalled = false

    func storeItem(code: String) throws {
        storeItemWasCalled = true
    }

    func searchItem() throws -> String {
        return ""
    }

    func deleteItem() throws {

    }
}

class TokenManagerProtocolMock: TokenManagerProtocol {

    var requestTokenWasCalled = false
    var refreshTokenWasCalled = false

    var refreshTokenSucces = true

    func requestToken(withAuthorizationCode code: String, onSuccess: @escaping (TokenDTO) -> Void, onError: ((Error?) -> Void)?) {
        requestTokenWasCalled = true
        onSuccess(TokenDTO(accessToken: "", expiresIn: 0.0, refreshToken: ""))
    }

    func refreshToken(token: String, onSuccess: @escaping (TokenDTO) -> Void, onError: ((Error?) -> Void)?) {
        refreshTokenWasCalled = true
        if refreshTokenSucces {
            onSuccess(TokenDTO(accessToken: "", expiresIn: 0.0, refreshToken: ""))
        } else {
            onError?(nil)
        }
    }
}
