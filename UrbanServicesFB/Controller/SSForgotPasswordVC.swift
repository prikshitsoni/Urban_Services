//
//  SSForgotPasswordVC.swift
//  UrbanServicesFB
//
//  Created by prikshit soni on 08/04/21.
//

import UIKit
import Firebase

class SSForgotPasswordVC: UIViewController {
    
    @IBOutlet weak var EmailET: UITextField!
    @IBOutlet weak var ErrorLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        ErrorLabel.alpha = 0
    }
    
    func valicateFields() -> String?{
        //check if all fields are filled
        if EmailET.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            return "Please fill in all fields"
        }
        return nil
    }
   
    //Send Button
    @IBAction func SendBTN(_ sender: UIButton) {
        //validate text Fields
        let error = valicateFields()
        if error != nil{ showErrorMessage(error!) }
        else{
            let auth = Auth.auth()
            auth.sendPasswordReset(withEmail:EmailET.text!) {(error) in
                if error != nil {
                    self.showErrorMessage("error")
                    //self.showErrorMessage(error!.localizedDescription)
                }
                else{
                    self.showErrorMessage("Reset Email Sent")
                }
            }
        }
    }
    
    func showErrorMessage(_ messege: String){
        ErrorLabel.text = messege
        ErrorLabel.alpha = 1
    }
}
