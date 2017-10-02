//
//  LoginViewController.swift
//  DevCave
//
//  Created by Developer on 8/16/17.
//  Copyright © 2017 DevCave. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var inputContainerView: UIView!
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var facebookLogin: UIButton!
    @IBOutlet weak var googleLogin: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inputContainerView.layer.cornerRadius = 25
        customTextField(display: emailInput)
        customTextField(display: passwordInput)
        
        loginButton.isEnabled = false
        loginButton.setTitleColor(UIColor(red:0.86, green:0.26, blue:0.26, alpha:0.3), for: UIControlState.normal)
        loginButton.backgroundColor = UIColor(red:0.86, green:0.26, blue:0.26, alpha:0.15)
        handleTextField()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if FIRAuth.auth()?.currentUser != nil{
            self.performSegue(withIdentifier: "signIn_Segue", sender: nil)
        }
    }
    
    //create the custom look to the text fields
    func customTextField(display: UITextField){
        display.backgroundColor = UIColor.clear
        //display.attributedPlaceholder = NSAttributedString(string: display.placeholder!, attributes: [NSForegroundColorAttributeName: UIColor(red:0.26, green:0.79, blue:0.02, alpha:0.5)])
        
        let underline = CALayer()
        underline.frame = CGRect(x: 0, y: 29, width: 1000, height: 0.5)
        underline.backgroundColor = UIColor(red:0.72, green:0.72, blue:0.72, alpha:0.5).cgColor
        display.layer.addSublayer(underline)
    }
    
    func handleTextField(){
        emailInput.addTarget(self, action: #selector(LoginViewController.textFieldDidChange), for: UIControlEvents.editingChanged)
        passwordInput.addTarget(self, action: #selector(LoginViewController.textFieldDidChange), for: UIControlEvents.editingChanged)
    }
    
    func textFieldDidChange(){
        guard let email = emailInput.text, !email.isEmpty,
            let password = passwordInput.text, !password.isEmpty
            else {
                loginButton.isEnabled = false
                return
        }
        loginButton.setTitleColor(UIColor(red:0.40, green:0.76, blue:0.29, alpha:1.0), for: UIControlState.normal)
        loginButton.backgroundColor = UIColor(red:0.30, green:0.59, blue:0.23, alpha:0.15)
        loginButton.isEnabled = true
    }
    @IBAction func login_Clicked(_ sender: Any) {
        AuthService.login(email: emailInput.text!, password: passwordInput.text!, onSuccess: {
            self.performSegue(withIdentifier: "signIn_Segue", sender: nil)
        }, onError: { error in
            print(error!)
        })
    }
    
}
