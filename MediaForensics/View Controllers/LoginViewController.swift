//
//  LoginViewController.swift
//  MediaForensics
//
//  Created by Waad Alkatheeri on 15/04/2020.
//  Copyright © 2020 Waad Alkatheeri. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailNameTextField: UITextField!
    @IBOutlet weak var passwordNameTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpElements()
    }
    
    func setUpElements() {
         
        //Hide the error label
        errorLabel.alpha = 0
        
        //Style the elements
        Utilities.styleTextField(emailNameTextField)
        Utilities.styleTextField(passwordNameTextField)
        Utilities.styleFilledButton(loginButton)
    }


    @IBAction func loginTapped(_ sender: Any) {
        
        // Validate text Fields
        
        // Create cleaned versions of the text field
        let email = emailNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Signing in the user
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            if error != nil {
                // Couldn't sign in
                self.errorLabel.text = error!.localizedDescription
                self.errorLabel.alpha = 1
            }
            else {
                
                let homeViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
                
                self.view.window?.rootViewController = homeViewController
                self.view.window?.makeKeyAndVisible()
            }
        }
        
    }
    
}
