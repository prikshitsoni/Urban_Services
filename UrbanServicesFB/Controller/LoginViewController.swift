//
//  LoginViewController.swift
//  UrbanServicesFB
//
//  Created by prikshit soni on 23/03/21.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var LoginPageEmailET: UITextField!
    @IBOutlet weak var LoginPagePasswordET: UITextField!
    @IBOutlet weak var LoginBtn: UIButton!
    @IBOutlet weak var LoginPageErrorLabel: UILabel!
    @IBOutlet weak var LogoImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
    }
    func setUpElements(){
        LoginPageErrorLabel.alpha = 0
    }
    
    //validating all Fields
    func valicateFields() -> String?{
        //if Email and password Fields are not empty
        if LoginPageEmailET.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || LoginPagePasswordET.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields"
        }
        //check if password is secure
        let cleanPassword = LoginPagePasswordET.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if Utilities.isPasswordValid(cleanPassword) == false {
            return "Please enter a valid password"
        }
        //check if email is properly formatted
        let cleanEmail = LoginPageEmailET.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if Utilities.isEmailValid(cleanEmail) == false {
            return "please enter a valid email addess"
        }
        return nil
    }
    
    @IBAction func LoginBtnPressed(_ sender: UIButton) {
        //validate text Fields
        let error = valicateFields()
        if error != nil{
            showErrorMessage(error!)
        }
        else{
            //create clean version of data
            let email = LoginPageEmailET.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = LoginPagePasswordET.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            //Login User
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                if error != nil{
                    //show error messege
                    self.showErrorMessage(error!.localizedDescription)
                }else{
                    //change root controller to UserHomeTabBarController
                    let userHomeViewController = self.storyboard?.instantiateViewController(identifier: "userHome") as? UserHomeTabBarController
                    self.view.window?.rootViewController = userHomeViewController
                    self.view.window?.makeKeyAndVisible()
                }
            }
        }
    }
    func showErrorMessage(_ messege: String){
        LoginPageErrorLabel.text = messege
        LoginPageErrorLabel.alpha = 1
    }
}
