//
//  SearchInteractorTests.swift
//  SpotiSearchTests
//
//  Created by Reinaldo Villanueva Javierre on 9/2/21.
//

import XCTest
@testable import SpotiSearch

class SearchInteractorTests: XCTestCase {

    var sut: SearchInteractor!
    var presenterMock: SearchPresenterProtocolMock!
    var tokenManagerMock: TokenManagerProtocolMock!
    var searchManagerMock: SearchManagerProtocolMock!
    var favoritesManager: FavoritesManagerProtocolMock!

    override func setUp() {
        super.setUp()
        createSut()
    }

    override func tearDown() {
        releaseSut()
        super.tearDown()
    }

    func createSut() {
        presenterMock = SearchPresenterProtocolMock()
        tokenManagerMock = TokenManagerProtocolMock()
        searchManagerMock = SearchManagerProtocolMock()
        favoritesManager = FavoritesManagerProtocolMock()
        sut = SearchInteractor(tokenManager: tokenManagerMock,
                               searchManager: searchManagerMock,
                               favoritesManager: favoritesManager,
                               token: nil)
        sut.presenter = presenterMock
    }

    func releaseSut() {
        sut = nil
        tokenManagerMock = nil
        searchManagerMock = nil
        favoritesManager = nil
        presenterMock = nil
    }

    // MARK: - Basic test.
    func testSutIsntNil() {
        XCTAssertNotNil(sut, "Sut must not be nil.")
    }

    func testGetToken() {
        sut.getToken(withRefreshToken: "")
        XCTAssertTrue(tokenManagerMock.refreshTokenWasCalled)
    }

    func testUpdateToken() {
        let token = Token(accessToken: "fdafda", expiresIn: Date())
        sut.updateToken(withToken: token)
        XCTAssertEqual(token, sut.token)
    }

    func testMakeSearchEmptySearch() {
        sut.searchItems = [SearchItem(name: "",
                                      type: .album,
                                      id: "",
                                      popularity: 0,
                                      imageURL: nil,
                                      artist: "",
                                      album: "")]

        sut.makeSearch("", oftype: [.artist])

        XCTAssertTrue(sut.searchItems.isEmpty)
        XCTAssertTrue(searchManagerMock.currentTaskWasCalled)
        XCTAssertTrue(presenterMock.refreshSearchTableWasCalled)
    }

    func testMakeSearchSearch() {
        sut.token = Token(accessToken: "fdsafds", expiresIn: Date())

        sut.makeSearch("resf", oftype: [.artist])

        XCTAssertTrue(searchManagerMock.searchWasCalled)
    }

    func testIsFavorite() {
        let id = "AmbosIds"
        sut.favoriteItems = [SearchItem(name: "",
                                        type: .album,
                                        id: id,
                                        popularity: 0,
                                        imageURL: nil,
                                        artist: "",
                                        album: "")]

        XCTAssertTrue(sut.isFavorite(itemID: id))

    }

    func testIsNotFavorite() {
        let id = "AmbosIds"
        sut.favoriteItems = [SearchItem(name: "",
                                        type: .album,
                                        id: id,
                                        popularity: 0,
                                        imageURL: nil,
                                        artist: "",
                                        album: "")]

        XCTAssertFalse(sut.isFavorite(itemID: "nope"))
    }

    func testLogout() {
        let item = SearchItem(name: "",
                              type: .album,
                              id: "id",
                              popularity: 0,
                              imageURL: nil,
                              artist: "",
                              album: "")
        sut.searchItems = [item]
        sut.favoriteItems = [item]
        sut.token = Token(accessToken: "", expiresIn: Date())

        sut.logout()

        XCTAssertTrue(favoritesManager.deleteFavoritesWasCalled)
        XCTAssertTrue(sut.searchItems.isEmpty)
        XCTAssertTrue(sut.favoriteItems.isEmpty)
        XCTAssertNil(sut.token)
    }

    func testAddFavoriteOrDeleteDeleteCase() {
        let id = "id"
        sut.favoriteItems = [SearchItem(name: "",
                                        type: .album,
                                        id: id,
                                        popularity: 0,
                                        imageURL: nil,
                                        artist: "",
                                        album: "")]
        sut.addFavoriteOrDelete(ResultCellModel(id: id,
                                                name: "",
                                                description: "",
                                                isFavorite: false,
                                                imageURL: nil))

        XCTAssertTrue(favoritesManager.deleteFavoritesWasCalled)
        XCTAssertTrue(favoritesManager.saveFavoritesWasCalled)
        XCTAssertTrue(presenterMock.refreshSearchTableWasCalled)
    }

    func testAddFavoriteOrDeleteInsertCase() {
        let id = "id"
        sut.searchItems = [SearchItem(name: "",
                                      type: .album,
                                      id: id,
                                      popularity: 0,
                                      imageURL: nil,
                                      artist: "",
                                      album: "")]
        sut.addFavoriteOrDelete(ResultCellModel(id: id,
                                                name: "",
                                                description: "",
                                                isFavorite: false,
                                                imageURL: nil))

        XCTAssertTrue(favoritesManager.deleteFavoritesWasCalled)
        XCTAssertTrue(favoritesManager.saveFavoritesWasCalled)
        XCTAssertFalse(presenterMock.refreshSearchTableWasCalled)
    }

    func testAddFavoriteOrDeleteEmpty() {
        sut.addFavoriteOrDelete(ResultCellModel(id: "id",
                                                name: "",
                                                description: "",
                                                isFavorite: false,
                                                imageURL: nil))

        XCTAssertFalse(favoritesManager.deleteFavoritesWasCalled)
        XCTAssertFalse(favoritesManager.saveFavoritesWasCalled)
        XCTAssertFalse(presenterMock.refreshSearchTableWasCalled)
    }
}

class SearchManagerProtocolMock: SearchManagerProtocol {

    var currentTaskWasCalled = false
    var searchWasCalled = false

    func currentTask() -> URLSessionDataTask? {
        currentTaskWasCalled = true
        return nil
    }

    func search(_ search: String,
                for categories: [SearchCategories],
                withToken token: String,
                onSuccess: @escaping ([SearchResultDTO]) -> Void,
                onError: ((Error?) -> Void)?) {
        searchWasCalled = true
    }
}

class FavoritesManagerProtocolMock: FavoritesManagerProtocol {

    var deleteFavoritesWasCalled = false
    var saveFavoritesWasCalled = false

    func saveFavorites(favorites: [SearchItem]) {
        saveFavoritesWasCalled = true
    }

    func loadFavorites() -> [SearchItem] {
        return [SearchItem]()
    }

    func deleteFavorites() {
        deleteFavoritesWasCalled = true
    }
}
