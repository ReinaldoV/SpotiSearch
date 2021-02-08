//
//  ViewController.swift
//  SpotiSearch
//
//  Created by Reinaldo Villanueva Javierre on 4/2/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        let login = LoginViewController()
//        login.myURL = AuthorizationManager().requestAuthorizationURL()
//        self.navigationController?.pushViewController(login, animated: true)

//        let coord = AuthorizationCoordinator(parentViewController: self)
//        coord.start()

        let nib = UINib(nibName: "SearchViewController", bundle: nil)
        let search = nib.instantiate(withOwner: self, options: nil)[0] as? SearchViewController ?? UIViewController()
        self.navigationController?.pushViewController(search, animated: true)
    }


}

