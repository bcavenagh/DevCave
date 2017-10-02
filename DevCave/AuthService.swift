//
//  AuthService.swift
//  DevCave
//
//  Created by Developer on 8/17/17.
//  Copyright © 2017 DevCave. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class AuthService{
    static func login(email: String, password: String, onSuccess: @escaping () -> Void, onError: @escaping (_ errorMessage: String?) -> Void){
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil{
                onError(error!.localizedDescription)
                return
            }
            onSuccess()
        })
    }
    
    static func signUp(username: String, email: String, password: String, imageData: Data, onSuccess: @escaping () -> Void, onError: @escaping (_ errorMessage: String?) -> Void){
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user: FIRUser?, error: Error?) in
            if error != nil{
                onError(error!.localizedDescription)
                return
            }
            //get the uid of the created user
            let uid = user?.uid
            
            //get reference of Storage
            let storageRef = FIRStorage.storage().reference(forURL: Config.STORAGE_ROOT_REF).child("profile_image").child(uid!)
            
            storageRef.put(imageData, metadata: nil, completion: { (metadata, error) in
                if error != nil{
                    return
                }
                //get the profile images url in string format
                let profileImageUrl = metadata?.downloadURL()?.absoluteString
                //set the information in the database as provided by the inputs
                self.setUserInformation(profileImageUrl: profileImageUrl!, username: username, email: email, uid: uid!, onSuccess: onSuccess)
            })
        })
    }
    
    
    static func setUserInformation(profileImageUrl: String, username: String, email: String, uid: String, onSuccess: @escaping () -> Void){
        //get reference of database
        let ref = FIRDatabase.database().reference()
        //get reference of "users" node
        let usersRef = ref.child("users")
        let newUserRef = usersRef.child(uid)
        //set the values of the user in the database
        newUserRef.setValue(["username": username,
                             "email": email,
                             "profileImageUrl": profileImageUrl])
        onSuccess()
    }
}
