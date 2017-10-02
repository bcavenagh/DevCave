//
//  ProfileViewController.swift
//  DevCave
//
//  Created by Developer on 8/17/17.
//  Copyright © 2017 DevCave. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {

    @IBOutlet weak var logoutButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func dismiss_OnClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func logout_Clicked(_ sender: Any) {
        do{
            try FIRAuth.auth()?.signOut()
        } catch let logoutError{
            print(logoutError)
        }
        
        let storyboard = UIStoryboard(name: "Start", bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        self.present(loginVC, animated: true, completion: nil)
    }
}
