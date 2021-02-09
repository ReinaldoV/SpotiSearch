//
//  SearchViewControllerTests.swift
//  SpotiSearchTests
//
//  Created by Reinaldo Villanueva Javierre on 9/2/21.
//

import XCTest
@testable import SpotiSearch

class SearchViewControllerTests: XCTestCase {

    var sut: SearchViewController!
    var searchPresenterProtocolMock: SearchPresenterProtocolMock!
    var appCoordinatorProtocolMock: AppCoordinatorProtocolMock!

    override func setUp() {
        super.setUp()
        createSut()
    }

    override func tearDown() {
        releaseSut()
        super.tearDown()
    }

    func createSut() {
        searchPresenterProtocolMock = SearchPresenterProtocolMock()
        appCoordinatorProtocolMock = AppCoordinatorProtocolMock()
        sut = SearchViewController.instantiate(presenter: searchPresenterProtocolMock,
                                               coordinator: appCoordinatorProtocolMock)
    }

    func releaseSut() {
        sut = nil
        searchPresenterProtocolMock = nil
        appCoordinatorProtocolMock = nil
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

class SearchPresenterProtocolMock: SearchPresenterProtocol {
    func logout() {

    }

    func refreshSearchTable(withItems items: [SearchItem]) {

    }

    func getToken(withRefreshToken refreshToken: String) {

    }

    func updateToken(withToken token: Token) {

    }

    func numberOfRows() -> Int {
        return 0
    }

    func modelFor(cellForRowAt indexPath: IndexPath) -> ResultCellModel {
        return ResultCellModel(id: "",
                               name: "",
                               description: "",
                               isFavorite: false,
                               imageURL: nil)
    }

    func requestSearch(withSearchString searchString: String?, andType type: SearchTypeCell.CellType?) {

    }

    func addFavorites(itemOnIndex index: Int) {

    }

    func isFavorite(itemOnIndex index: IndexPath) -> Bool {
        return false
    }
}

class AppCoordinatorProtocolMock: AppCoordinatorProtocol {
    func logout() {

    }
}
