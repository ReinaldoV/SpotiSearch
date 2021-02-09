//
//  UIViewControllerMock.swift
//  SpotiSearchTests
//
//  Created by Reinaldo Villanueva Javierre on 9/2/21.
//

import UIKit

class UIViewControllerMock: UIViewController {

    var presentWasCalled = false

    override func present(_ viewControllerToPresent: UIViewController,
                          animated flag: Bool,
                          completion: (() -> Void)? = nil) {
        presentWasCalled = true
    }
}
