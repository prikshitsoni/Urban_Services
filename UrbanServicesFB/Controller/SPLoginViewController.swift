//
//  SPLoginViewController.swift
//  UrbanServicesFB
//
//  Created by prikshit soni on 30/03/21.
//

import UIKit
import Firebase

class SPLoginViewController: UIViewController {
    @IBOutlet weak var SPEmailET: UITextField!
    @IBOutlet weak var SPPasswordET: UITextField!
    @IBOutlet weak var SPErrorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
    }
    func setUpElements(){
        SPErrorLabel.alpha = 0
    }
    
    //check if all fields are filled
    func valicateFields() -> String?{
        if SPEmailET.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || SPPasswordET.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            return "Please fill in all fields"
        }
        //check if password is secure
        let cleanPassword = SPPasswordET.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if Utilities.isPasswordValid(cleanPassword) == false {
            return "Please enter a valid password"
        }
        //check is email is properly formatted
        let cleanEmail = SPEmailET.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if Utilities.isEmailValid(cleanEmail) == false {
            return "please enter a valid email addess"
        }
        return nil
    }
    
    //Login button
    @IBAction func LogInBtnPressed(_ sender: UIButton) {
        //validate text Fields
        let error = valicateFields()
        if error != nil{
            showErrorMessage(error!)
        }
        else{
            //create clean version of data
            let email = SPEmailET.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = SPPasswordET.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            //Login User
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                if error != nil{
                    //show error messege
                    self.showErrorMessage(error!.localizedDescription)
                }else{
                    
                    //changing root view controller to SPHomeTabBarController
                    let SPHomeViewController = self.storyboard?.instantiateViewController(identifier: "ServiceProviderHome") as? SPHomeTabBarController
                    self.view.window?.rootViewController = SPHomeViewController
                    self.view.window?.makeKeyAndVisible()
                }
            }
        }
    }
    func showErrorMessage(_ messege: String){
        SPErrorLabel.text = messege
        SPErrorLabel.alpha = 1
    }
}
