//
//  AuthorizationViewController.swift
//  SpotiSearch
//
//  Created by Reinaldo Villanueva Javierre on 7/2/21.

import UIKit

protocol AuthorizationViewControllerProtocol: UIViewController {
    func getTokens(fromAuthCode code: String)
    func showLoading()
    func stopLoading()
    func passTokenInfoToCoordinator(_ token: Token)
}

class AuthorizationViewController: UIViewController {

    @IBOutlet weak var windowView: UIView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var activityIndicatorLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    private var coordinator: AuthorizationCoordinatorProtocol?
    private var presenter: AuthorizationPresenterProtocol?

    static func instantiate(coordinator: AuthorizationCoordinatorProtocol?,
                            presenter: AuthorizationPresenterProtocol) -> AuthorizationViewController {
        let nib = UINib(nibName: "AuthorizationViewController", bundle: nil)
        let viewController = nib.instantiate(withOwner: self, options: nil)[0] as? AuthorizationViewController
        viewController?.coordinator = coordinator
        viewController?.presenter = presenter
        return viewController ?? AuthorizationViewController()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.roundAndBeautifyViews()
        self.activityIndicator.isHidden = true
        self.activityIndicatorLabel.isHidden = true
    }

    @IBAction func logInButton(_ sender: Any) {
        self.coordinator?.openLoginWebViewController(view: self)
    }

    private func roundAndBeautifyViews() {
        windowView.layer.cornerRadius = 10
        gradientView.layer.cornerRadius = 10

        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [UIColor(red: 119 / 255, green: 195 / 255, blue: 68 / 255, alpha: 1).cgColor,
                           UIColor(red: 49 / 255, green: 212 / 255, blue: 111 / 255, alpha: 1).cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = CGRect(x: 0.0,
                                y: 0.0,
                                width: self.gradientView.frame.size.width,
                                height: self.gradientView.frame.size.height)
        gradient.cornerRadius = 10
        self.gradientView.layer.insertSublayer(gradient, at: 0)
    }
}

extension AuthorizationViewController: AuthorizationViewControllerProtocol {
    func getTokens(fromAuthCode code: String) {
        self.presenter?.requestToken(withAuthCode: code)
    }

    func showLoading() {
        self.activityIndicator.isHidden = false
        self.activityIndicatorLabel.isHidden = false
        self.activityIndicator.startAnimating()
    }

    func stopLoading() {
        self.activityIndicator.isHidden = true
        self.activityIndicatorLabel.isHidden = true
        self.activityIndicator.stopAnimating()
    }

    func passTokenInfoToCoordinator(_ token: Token) {

    }
}
