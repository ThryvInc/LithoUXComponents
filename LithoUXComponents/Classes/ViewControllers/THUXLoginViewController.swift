//
//  THUXLoginViewController.swift
//  ThryvUXComponents
//
//  Created by Elliot Schrock on 2/10/18.
//

import UIKit

open class THUXLoginViewController: THUXFunctionalViewController {
    @IBOutlet open weak var logoImageView: UIImageView?
    @IBOutlet open weak var logoHeight: NSLayoutConstraint!
    @IBOutlet open weak var usernameTextField: UITextField?
    @IBOutlet open weak var passwordTextField: UITextField?
    @IBOutlet open weak var loginButton: UIButton?
    @IBOutlet open weak var loginHeight: NSLayoutConstraint!
    @IBOutlet open weak var signUpButton: UIButton?
    @IBOutlet open weak var spinner: UIActivityIndicatorView?
    
    open var loginViewModel: THUXLoginProtocol?
    
    override open func viewDidLoad() {
        super.viewDidLoad()

        loginViewModel?.outputs.submitButtonEnabled.observeValues({ enabled in
            self.loginButton?.isEnabled = enabled
        })
        loginViewModel?.outputs.activityIndicatorVisible.observeValues({ (visible) in
            self.spinner?.isHidden = !visible
        })
        loginViewModel?.inputs.viewDidLoad()
    }
    
    @IBAction @objc open func usernameChanged() {
        loginViewModel?.inputs.usernameChanged(username: usernameTextField!.text)
    }
    
    @IBAction @objc open func passwordChanged() {
        loginViewModel?.inputs.passwordChanged(password: passwordTextField!.text)
    }
    
    @IBAction @objc open func loginButtonPressed() {
        loginViewModel?.inputs.submitButtonPressed()
    }
    
    @IBAction @objc open func signUpPressed() {}
}
