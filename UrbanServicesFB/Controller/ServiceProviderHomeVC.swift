//
//  ServiceProviderHomeVC.swift
//  UrbanServicesFB
//
//  Created by prikshit soni on 29/03/21.
//

import UIKit
import Firebase

class ServiceProviderHomeVC: UIViewController {
    var CurrentStatus : String = ""
    @IBOutlet weak var statusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        statusLabel.text = "I'm Open To Work!"
        CurrentStatus = "online"
        changeStatus(curStatus: CurrentStatus)
        statusLabel.backgroundColor = UIColor.green
    }

    //Open to work button
    @IBAction func OTWButton(_ sender: UIButton) {
        statusLabel.text = "I'm Open To Work!"
        CurrentStatus = "online"
        changeStatus(curStatus: CurrentStatus)
        statusLabel.backgroundColor = UIColor.green
        
    }
    //Out on Break button
    
    @IBAction func OOBButton(_ sender: UIButton) {
        statusLabel.text = "I'm Out on Break!"
        CurrentStatus = "break"
        changeStatus(curStatus: CurrentStatus)
        statusLabel.backgroundColor = UIColor.orange
        
    }
    
    //Signing off button
    //Done for day button
    @IBAction func DFDButton(_ sender: UIButton) {
        statusLabel.text = "I'm Done For Today!"
        CurrentStatus = "offline"
        changeStatus(curStatus: CurrentStatus)
        statusLabel.backgroundColor = UIColor.red
        CreateAlert()
    }
    
    func changeStatus(curStatus : String){
        let db = Firestore.firestore()
        let newDoc = db.collection("serviceProviders").document((Auth.auth().currentUser?.email)!)
        newDoc.setData( ["status" : curStatus] , merge: true)
    }
    
    func CreateAlert(){
        // create the alert
        let alert = UIAlertController(title: "Signing Out", message: "Do you want to sign-out?", preferredStyle: UIAlertController.Style.alert)
        // add an action (button)
        let YesAction = UIAlertAction(title: "Yes", style: .default){_ in
            let SPLoginPage = self.storyboard?.instantiateViewController(identifier: "SPLoginPage") as? SPLoginViewController
            self.view.window?.rootViewController = SPLoginPage
            self.view.window?.makeKeyAndVisible()
        }
        let NoAction = UIAlertAction(title: "No", style: .cancel){_ in
            self.CurrentStatus = "online"
            self.statusLabel.text = "I'm Open To Work!"
            self.statusLabel.backgroundColor = UIColor.green
            self.changeStatus(curStatus: self.CurrentStatus)
        }
        alert.addAction(NoAction)
        alert.addAction(YesAction)
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
}
