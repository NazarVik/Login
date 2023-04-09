//
//  ViewController.swift
//  Login
//
//  Created by Виктор Назаров on 8.04.23.
//

import UIKit

class ViewController: UIViewController {
    // MARK: - outletes
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signButton: UIButton!
    @IBOutlet weak var passField: UITextField!
    @IBOutlet weak var mailField: UITextField!
    @IBOutlet weak var mailView: UIView!
    @IBOutlet weak var passView: UIView!
    
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.shadowOpacity = 0.4
        loginButton.layer.shadowOffset = CGSize(width: 0, height: 3)
        loginButton.layer.shadowRadius = 3
        loginButton.layer.shadowColor = UIColor.systemPink.cgColor
    }

    //MARK: - Actions
    @IBAction func loginAction(_ sender: Any) {
    }
    @IBAction func signAction(_ sender: Any) {
    }
}

