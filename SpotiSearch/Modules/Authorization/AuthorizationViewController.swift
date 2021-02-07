//
//  AuthorizationViewController.swift
//  SpotiSearch
//
//  Created by Reinaldo Villanueva Javierre on 7/2/21.

import UIKit

class AuthorizationViewController: UIViewController {

    @IBOutlet weak var windowView: UIView!
    @IBOutlet weak var gradientView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.roundAndBeautifyViews()
    }

    @IBAction func logInButton(_ sender: Any) {

    }

    private func roundAndBeautifyViews() {
        windowView.layer.cornerRadius = 5
        gradientView.layer.cornerRadius = 5

        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [UIColor(red: 119/255, green: 195/255, blue: 68/255, alpha: 1).cgColor,
                           UIColor(red: 49/255, green: 212/255, blue: 111/255, alpha: 1).cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = CGRect(x: 0.0,
                                y: 0.0,
                                width: self.gradientView.frame.size.width,
                                height: self.gradientView.frame.size.height)
        self.gradientView.layer.insertSublayer(gradient, at: 0)
    }
}
