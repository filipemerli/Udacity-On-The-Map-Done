//
//  LoginViewController.swift
//  On The Map
//
//  Created by Filipe Merli on 09/01/2018.
//  Copyright © 2018 Filipe Merli. All rights reserved.
//

import UIKit
import Foundation

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var udacityLogo: UIImageView!
    @IBOutlet weak var signUpButton: UIButton!
    
    var keyboardOnScreen = false
    
    var aluno = Student.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        udacityLogo.image = #imageLiteral(resourceName: "logo-u")
        
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        subscribeToKeyboardNotifications()
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    @IBAction func loginRequest (_ sender: Any) {
        
        unsubscribeFromKeyboardNotifications()
        
        aluno.email = emailTextField.text!
        aluno.password = passwordTextField.text!
        
        let spinner = LoginViewController.displaySpinner(onView: self.view)
        
        if emailTextField.text != "" && passwordTextField.text != "" {
            UdacityAPIClient.sharedInstance().authenticateLogin(login: aluno.email, password: aluno.password) { (success, error) in
                if error == nil {
                    performUIUpdatesOnMain {
                        self.completeLogin()
                        LoginViewController.removeSpinner(spinner: spinner)
                    }
                } else{
                    performUIUpdatesOnMain {
                        self.sendUIAlert(error: error)
                        LoginViewController.removeSpinner(spinner: spinner)
                    }
                }
            }
        } else {
            LoginViewController.removeSpinner(spinner: spinner)
            sendUIAlert(error: "Missing E-mail or Password!")
        }
    }
    
    @IBAction func signUpPress (_ sender: Any) {
        if let url = NSURL(string: "https://www.udacity.com/account/auth#!/signup") {
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        }
    }
    
    func completeLogin() {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "MapView") as! UITabBarController
        self.present(controller, animated: true, completion: nil)
    }
    
}

// MARK: TextFields Delegate

extension LoginViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var newText = textField.text! as NSString
        newText = newText.replacingCharacters(in: range, with: string) as NSString
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: Keyboard functions

extension LoginViewController: UINavigationControllerDelegate {
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if passwordTextField.isFirstResponder || emailTextField.isFirstResponder == true {
            view.frame.origin.y = 0 - (getKeyboardHeight(notification)/2.5)
        }
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        if passwordTextField.isFirstResponder || emailTextField.isFirstResponder == true {
            view.frame.origin.y = 0
        }
    }
}

