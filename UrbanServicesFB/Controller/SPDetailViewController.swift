//
//  SPDetailViewController.swift
//  UrbanServicesFB
//
//  Created by prikshit soni on 05/04/21.
//

import UIKit
import Firebase
import FirebaseStorage
import MessageUI

class SPDetailViewController: UIViewController , MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {}
    
    var recEmail = String()
    var FromTableView :Bool = false
    
    @IBOutlet weak var Name: UITextField!
    @IBOutlet weak var Age: UITextField!
    @IBOutlet weak var Gender: UITextField!
    @IBOutlet weak var Contact: UITextField!
    @IBOutlet weak var Address: UITextField!
    @IBOutlet weak var Category: UILabel!
    @IBOutlet weak var Description: UILabel!
    @IBOutlet weak var SPImage: UIImageView!
    @IBOutlet weak var SPError: UILabel!
    @IBOutlet weak var SPEmail: UITextField!
    
    var name = String()
    var age = String()
    var gender = String()
    var contact = String()
    var address = String()
    var category = String()
    var descrip = String()
    var email = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SPError.alpha = 0
    }
    override func viewWillAppear(_ animated: Bool) {
        if(FromTableView){
            Name.text = name
            Age.text = age
            Gender.text = gender
            Contact.text = contact
            SPEmail.text = email
            Address.text = address
            Category.text = category
            Description.text = descrip
            fetchImage()
        }
    }
 
    //Call Button
    @IBAction func CallBTN(_ sender: UIButton) {
        //For Simulator
        performSegue(withIdentifier: "MoveToDialer", sender: SPDetailViewController.self)
        //For Device
        if  let url = URL(string: "tel://\(contact)"), UIApplication.shared.canOpenURL(url)  {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func MessegeBTN(_ sender: UIButton) {
        //For Simulator
        performSegue(withIdentifier: "MoveToSMS", sender: SPDetailViewController.self)
        //ForDevice
        displayMessageInterface()
    }
    //For SMS
    func displayMessageInterface() {
        let composeVC = MFMessageComposeViewController()
        composeVC.messageComposeDelegate = self
        // Configure the fields of the interface.
        composeVC.recipients = ["\(contact)"]
        // Present the view controller modally.
        if MFMessageComposeViewController.canSendText() {
            self.present(composeVC, animated: true, completion: nil)
        } else {
            print("Can't send messages.")
        }
    }
    
    //For Email
    @IBAction func EmailBTN(_ sender: UIButton) {
        //For Simulator
        performSegue(withIdentifier: "MoveToEmail", sender: SPDetailViewController.self)
        //For Deive
        if let url = URL(string: "mailto:\(email)") {
            UIApplication.shared.open(url)
        }
    }
    
    //Download Resume Button
    @IBAction func DownloadResumeBTN(_ sender: Any) {
        //Download resume
        fetchResume()
    }
    
    //fetch resume
    func fetchResume() {
        let ref = Storage.storage().reference(withPath: "ServiceProviderResume"+"/"+"Resume"+email)
        let localURL = URL(string: "file:///Users/prikshitsoni/Library/Developer/CoreSimulator/Devices/675AC157-7CCA-4D52-B8CD-8713C5B26502/data/Containers/Data/Downloads/Resume\(email).pdf")!
        // Download to the local filesystem
        let downloadTask = ref.write(toFile: localURL) { url, error in
          if let error = error {
            print(error)
          } else {
            print("saved")
          }
        }
    }
    
    //fetch image
    func fetchImage(){
        let ref = Storage.storage().reference(withPath: "ServiceProviderImages"+"/"+"image"+email)
        ref.getData(maxSize: (1*2048*2048)) { (data, error) in
            if error != nil{
                print(error!)
                self.SPError.alpha = 1
                self.SPError.text = "cannot fetch image"
            }
            else{
                self.SPImage.image = UIImage(data: data!)
            }
        }
    }
}
