//
//  LoginViewController.swift
//  InventoryApp
//
//  Created by Meghan on 12/17/19.
//  Copyright © 2019 Herberger IT. All rights reserved.
//

import UIKit
import FirebaseUI

class LoginViewController: UIViewController, FUIAuthDelegate {
    
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var hidaLogo: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnLogin.layer.cornerRadius = 10
        
        hidaLogo.image = UIImage(named: "HIDA logo")
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        // Get the default Auth UI Object
        let authUI = FUIAuth.defaultAuthUI()
        
        guard authUI != nil else {
            // Log the error
            return
        }
        
        // Set ourselves as the delegate
        authUI?.delegate = self
        authUI?.providers = [FUIEmailAuth()]
        
        // Get a reference to the auth UI view contoller
        let authViewController = authUI?.authViewController()
        
        // Show it.
        present(authViewController!, animated: true, completion: nil)
    }
    
    @IBAction func unwindToLogin(segue: UIStoryboardSegue) {}
    
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        
        //  Check if there was an error
        
        //  guard is like saying if error == nil then do nothing else { Log the error and then return }
        guard error == nil else {
            print(error?.localizedDescription as Any)
            return
        }
        //authDataResult?.user.uid
        performSegue(withIdentifier: "enterApp", sender: self)
        
    }
}
