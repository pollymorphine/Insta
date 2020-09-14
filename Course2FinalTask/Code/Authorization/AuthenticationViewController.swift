//
//  AuthenticationViewController.swift
//  Course2FinalTask
//
//  Created by Polina on 27.06.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import Foundation
import UIKit

final class AuthenticationViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var loginTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var signInButton: UIButton!
    
    override  func viewDidLoad() {
        super.viewDidLoad()
        
        signInButton.layer.cornerRadius = 6
        setloginButton(enabled: false)
        
        passwordTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        loginTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        
        let gestureView = UITapGestureRecognizer(target: self, action: #selector(tapRootView(_:)))
        view.addGestureRecognizer(gestureView)
        
    }
    
    @objc func tapRootView(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    private func setloginButton(enabled: Bool) {
        if enabled {
            signInButton.alpha = 1.0
            signInButton.isEnabled = true
        } else {
            signInButton.alpha = 0.3
            signInButton.isEnabled = false
        }
    }
    
    @objc private func textFieldChanged() {
        guard let repo = loginTextField.text, let lang = passwordTextField.text else { return }
        let formFilled = !(repo.isEmpty) && !(lang.isEmpty)
        setloginButton(enabled: formFilled)
    }
    
    @IBAction func signInPressed(_ sender: Any) {
        guard let login = loginTextField.text , let password = passwordTextField.text else { return }
        NetworkProvider.shared.signIn(login: login, password: password) { (result) in
            switch result {
            case .success(let token):
                DispatchQueue.main.async {
                    Keychain.shared.saveToken(token.token)
                    self.performSegue(withIdentifier: "switchToFeed", sender: self)
                    print(token)
                }
            case .fail(let networkError):
                DispatchQueue.main.async {
                    Alert.shared.showError(self, message: networkError.error)
                }
            }
        }
    }
    
    @IBAction func unwindToAuthenticationViewController(segue: UIStoryboardSegue) {
        loginTextField.text = ""
        passwordTextField.text = ""
        if loginTextField.text == "" && passwordTextField.text == "" {
            signInButton.alpha = 0.3
            signInButton.isEnabled = false
        }
    }
}
