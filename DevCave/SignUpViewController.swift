//
//  SignUpViewController.swift
//  DevCave
//
//  Created by Developer on 8/16/17.
//  Copyright © 2017 DevCave. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var inputContainerView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userNameInput: UITextField!
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var confirmPasswordInput: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inputContainerView.layer.cornerRadius = 25
        
        customTextField(display: userNameInput)
        customTextField(display: emailInput)
        customTextField(display: passwordInput)
        customTextField(display: confirmPasswordInput)
        
        profileImage.layer.cornerRadius = 40
        profileImage.clipsToBounds = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.handleSelectProfilePhoto))
        profileImage.addGestureRecognizer(tapGesture)
        profileImage.isUserInteractionEnabled = true
        
        signUpButton.setTitleColor(UIColor.red, for: UIControlState.normal)
        signUpButton.backgroundColor = UIColor(red:0.86, green:0.26, blue:0.26, alpha:0.15)
        signUpButton.isEnabled = false
        handleTextField()
    }
    
    func handleTextField(){
        userNameInput.addTarget(self, action: #selector(SignUpViewController.textFieldDidChange), for: UIControlEvents.editingChanged)
        emailInput.addTarget(self, action: #selector(SignUpViewController.textFieldDidChange), for: UIControlEvents.editingChanged)
        passwordInput.addTarget(self, action: #selector(SignUpViewController.textFieldDidChange), for: UIControlEvents.editingChanged)
        confirmPasswordInput.addTarget(self, action: #selector(SignUpViewController.textFieldDidChange), for: UIControlEvents.editingChanged)
    }
    
    func textFieldDidChange(){
        guard let username = userNameInput.text, !username.isEmpty,
            let email = emailInput.text, !email.isEmpty,
            let password = passwordInput.text, !password.isEmpty,
            let confirmPassword = confirmPasswordInput.text, !confirmPassword.isEmpty
            else {
                signUpButton.isEnabled = false
                return
        }
        signUpButton.setTitleColor(UIColor(red:0.40, green:0.76, blue:0.29, alpha:1.0), for: UIControlState.normal)
        signUpButton.backgroundColor = UIColor(red:0.30, green:0.59, blue:0.23, alpha:0.15)
        signUpButton.isEnabled = true
    }
    
    func handleSelectProfilePhoto(){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func dismiss_OnClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //create the custom look to the text fields
    func customTextField(display: UITextField){
        display.backgroundColor = UIColor.clear
        //display.attributedPlaceholder = NSAttributedString(string: display.placeholder!, attributes: [NSForegroundColorAttributeName: UIColor(red:0.26, green:0.79, blue:0.02, alpha:0.5)])
        
        let underlineUsername = CALayer()
        underlineUsername.frame = CGRect(x: 0, y: 29, width: 1000, height: 0.5)
        underlineUsername.backgroundColor = UIColor(red:0.72, green:0.72, blue:0.72, alpha:0.5).cgColor
        display.layer.addSublayer(underlineUsername)
    }
    
    @IBAction func signUp_Clicked(_ sender: Any) {
        if let profileImg = self.selectedImage, let imageData = UIImageJPEGRepresentation(profileImg, 0.1){
            AuthService.signUp(username: userNameInput.text!, email: emailInput.text!, password: passwordInput.text!, imageData: imageData, onSuccess: {
                self.performSegue(withIdentifier: "signUp_Segue", sender: nil)
            }, onError: { (error) in
                print(error!)
            })
        }else{
            print("Profile image can't be empty")
        }
    }
    
}

extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //grabbing the image from the info dicitonary
        //print out info to see the string keys used in the dictionary
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            selectedImage = image
            profileImage.image = image
        }
        dismiss(animated: true, completion: nil)
    }
}


