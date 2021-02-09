//
//  SearchPresenterTests.swift
//  SpotiSearchTests
//
//  Created by Reinaldo Villanueva Javierre on 9/2/21.
//

import XCTest
@testable import SpotiSearch

class SearchPresenterTests: XCTestCase {

    var sut: SearchPresenter!
    var viewMock: SearchViewControllerProtocolMock!
    var interactorMock: SearchInteractorProtocolMock!

    override func setUp() {
        super.setUp()
        createSut()
    }

    override func tearDown() {
        releaseSut()
        super.tearDown()
    }

    func createSut() {
        viewMock = SearchViewControllerProtocolMock()
        interactorMock = SearchInteractorProtocolMock()
        sut = SearchPresenter(interactor: interactorMock)
        sut.view = viewMock
    }

    func releaseSut() {
        sut = nil
    }

    // MARK: - Basic test.
    func testSutIsntNil() {
        XCTAssertNotNil(sut, "Sut must not be nil.")
    }

    func testRefreshSearchTable() {
        sut.refreshSearchTable(withItems: [])
        XCTAssertTrue(viewMock.reloadTableWasCalled)
    }

    func testGetToken() {
        sut.getToken(withRefreshToken: "")
        XCTAssertTrue(interactorMock.getTokenWasCalled)
    }

    func testUpdateToken() {
        sut.updateToken(withToken: Token(accessToken: "", expiresIn: Date()))
        XCTAssertTrue(interactorMock.updateTokenWasCalled)
    }

    func testNumberOfRows() {
        _ = sut.numberOfRows()
        XCTAssertTrue(viewMock.addEmptySearchViewWasCalled)
    }

    func testNumberOfRowsWithInfo() {
        sut.cellModels = [ResultCellModel(id: "",
                                          name: "",
                                          description: "",
                                          isFavorite: true,
                                          imageURL: nil)]
        _ = sut.numberOfRows()
        XCTAssertTrue(viewMock.deleteEmptySearchViewWasCalled)
    }

    func testRequestSearch() {
        sut.requestSearch(withSearchString: nil, andType: .Top)
        XCTAssertTrue(interactorMock.makeSearchWasCalled)
    }

    func testLogout() {
        sut.logout()
        XCTAssertTrue(interactorMock.logoutWasCalled)
        XCTAssertTrue(viewMock.reloadTableWasCalled)
    }

    func testAddFavorites() {
        sut.cellModels = [ResultCellModel(id: "",
                                          name: "",
                                          description: "",
                                          isFavorite: true,
                                          imageURL: nil)]
        sut.addFavorites(itemOnIndex: 0)
        XCTAssertTrue(interactorMock.addFavoriteOrDeleteWasCalled)
    }

    func testAddFavoritesNoData() {
        sut.addFavorites(itemOnIndex: 0)
    }

    func testIsFavorite() {
        sut.cellModels = [ResultCellModel(id: "",
                                          name: "",
                                          description: "",
                                          isFavorite: true,
                                          imageURL: nil)]
        _ = sut.isFavorite(itemOnIndex: IndexPath(row: 0, section: 0))
        XCTAssertTrue(interactorMock.isFavoriteWasCalled)
    }

    func testIsFavoriteNoData() {
        _ = sut.isFavorite(itemOnIndex: IndexPath(row: 0, section: 0))
    }
}

class SearchViewControllerProtocolMock: UIViewController, SearchViewControllerProtocol {

    var reloadTableWasCalled = false
    var addEmptySearchViewWasCalled = false
    var deleteEmptySearchViewWasCalled = false

    func recieveNewToken(_ token: Token) {

    }

    func getNewToken(withRefreshToken refreshToken: String) {

    }

    func reloadTable() {
        reloadTableWasCalled = true
    }

    func addEmptySearchView() {
        addEmptySearchViewWasCalled = true
    }

    func deleteEmptySearchView() {
        deleteEmptySearchViewWasCalled = true
    }
}

class SearchInteractorProtocolMock: SearchInteractorProtocol {

    var getTokenWasCalled = false
    var updateTokenWasCalled = false
    var makeSearchWasCalled = false
    var logoutWasCalled = false
    var addFavoriteOrDeleteWasCalled = false
    var isFavoriteWasCalled = false

    func getToken(withRefreshToken refreshToken: String) {
        getTokenWasCalled = true
    }

    func updateToken(withToken token: Token) {
        updateTokenWasCalled = true
    }

    func makeSearch(_ search: String?, oftype types: [SearchItemType]) {
        makeSearchWasCalled = true
    }

    func isFavorite(itemID: String) -> Bool {
        isFavoriteWasCalled = true
        return false
    }

    func logout() {
        logoutWasCalled = true
    }

    func addFavoriteOrDelete(_ item: ResultCellModel) {
        addFavoriteOrDeleteWasCalled = true
    }
}
