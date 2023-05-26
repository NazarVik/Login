//
//  ViewController.swift
//  Login
//
//  Created by Виктор Назаров on 8.04.23.
//

import UIKit

class LoginViewController: UIViewController {
    // MARK: - outletes
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signButton: UIButton!
    @IBOutlet weak var passField: UITextField!
    @IBOutlet weak var mailField: UITextField!
    @IBOutlet weak var mailView: UIView!
    @IBOutlet weak var passView: UIView!
    @IBOutlet weak var dontHaveAccountLabel: UILabel!
    @IBOutlet weak var mailImageView: UIImageView!
    @IBOutlet weak var passImageView: UIImageView!
    
    //MARK: - Properties
    var isLogin = true
    private let activeColor = UIColor(named: "Notes") ?? UIColor.gray
    private var email: String = "" {
        didSet {
            loginButton.isUserInteractionEnabled = !(email.isEmpty || password.isEmpty)
            loginButton.backgroundColor = !(email.isEmpty || password.isEmpty) ? activeColor : .systemGray5
        }
    }
    private var password: String = "" {
        didSet {
            loginButton.isUserInteractionEnabled = !(email.isEmpty || password.isEmpty)
            loginButton.backgroundColor = !(email.isEmpty || password.isEmpty) ? activeColor : .systemGray5
        }
    }
    
    private let mockEmail = "abc@gmail.com"
    private let mockPassword = "123456"
    
    
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dontHaveAccountLabel.isHidden = !isLogin
        signButton.isHidden = !isLogin
        setupLoginButton()
        passField.delegate = self
        mailField.delegate = self
        mailField.becomeFirstResponder()
        loginButton.isUserInteractionEnabled = false // делает кнопку не активной
        loginButton.backgroundColor = .systemGray5
    }

    //MARK: - Actions
    @IBAction func loginAction(_ sender: Any) {
        mailField.resignFirstResponder() // делает текстовое поле не активным
        passField.resignFirstResponder()
        
        if email.isEmpty {
            makeErrorField(textField: mailField)
        }
        
        if password.isEmpty {
            makeErrorField(textField: passField)
        }
        
        if isLogin {
            if KeychainManager.checkUser(with: email, password: password) {
                performSegue(withIdentifier: "goToHomePage", sender: sender)
            } else {
                let alert = UIAlertController(title: NSLocalizedString("Error", comment: "") , message: NSLocalizedString("Wrong password or e-mail", comment: ""), preferredStyle: .alert)
                let action = UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .default)
                alert.addAction(action)
                
                present(alert, animated: true)
            }
        } else {
            if KeychainManager.save(email: email, password: password) {
                performSegue(withIdentifier: "goToHomePage", sender: sender)
            } else {
                debugPrint("Error with saving email and password")
            }
        }
    }
    
    @IBAction func signAction(_ sender: Any) {
        guard let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else { return }
        viewController.isLogin = false
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func setupLoginButton() {
        loginButton.layer.shadowOpacity = 0.6
        loginButton.layer.shadowOffset = CGSize(width: 0, height: 3)
        loginButton.layer.shadowRadius = 5
        loginButton.layer.shadowColor = (UIColor(named: "Notes") ?? UIColor.gray).cgColor
        
        loginButton.isUserInteractionEnabled = false
        loginButton.setTitle(isLogin ? "Login".localizedUppercase : "Register".localizedUppercase, for: .normal)
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !text.isEmpty else { return }
        
        switch textField {
        case mailField :
            let isValidEmail = check(mail: text)
            
            if isValidEmail {
                email = text
                mailImageView.tintColor = .systemGray5
                mailView.backgroundColor = .systemGray5
            } else {
                email = ""
                makeErrorField(textField: textField)
            }
        case passField:
            let isValidPassword = check(password: text)
            
            if isValidPassword {
                password = text
                passImageView.tintColor = .systemGray5
                passView.backgroundColor = .systemGray5
            } else {
                password = ""
                makeErrorField(textField: textField)
            }
            
            
        default:
            print("unknown textField")
        }
    }
    
    private func check(mail: String) -> Bool {
        return mail.contains("@") && mail.contains(".")
    }
    
    private func check(password: String) -> Bool {
        return password.count >= 4
    }
    
    private func makeErrorField (textField: UITextField) {
        switch textField {
        case mailField:
            mailImageView.tintColor = activeColor
            mailView.backgroundColor = activeColor
        case passField:
            passImageView.tintColor = activeColor
            passView.backgroundColor = activeColor
        default :
            print("unknown textField")
        }
        
        
    }
}

