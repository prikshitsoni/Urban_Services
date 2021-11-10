//
//  UserProfileVC.swift
//  UrbanServicesFB
//
//  Created by prikshit soni on 26/03/21.
//

import UIKit
import Firebase
import FirebaseStorage

class UserProfileVC: UIViewController , UIImagePickerControllerDelegate ,UINavigationControllerDelegate {
    
    @IBOutlet weak var UPNameET: UITextField!
    @IBOutlet weak var UPAgeET: UITextField!
    @IBOutlet weak var UPGenderET: UITextField!
    @IBOutlet weak var UPContactET: UITextField!
    @IBOutlet weak var UPErrorLabel: UILabel!
    @IBOutlet weak var UPImageView: UIImageView!
    @IBOutlet weak var UPUpdateBtn: UIButton!
    @IBOutlet weak var AddressET: UITextField!
    
    private var ref : DocumentReference!
    private let storage = Storage.storage().reference()
    
    var imageData = Data()
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        UPErrorLabel.text = ""
        super.viewDidLoad()
        UPErrorLabel.isHidden = true
        getCurUserData()
    }
    override func viewWillAppear(_ animated: Bool) {
        UPErrorLabel.text = ""
        getCurUserData()
    }
    
    //Select gender Button
    @IBAction func GenderBtnTapped(_ sender: UIButton) {
        // create the alert
        let alert = UIAlertController(title: "Gender Picker", message: "Pick your Gender ", preferredStyle:.actionSheet)
        let MaleAction = UIAlertAction(title: "Male", style: .default, handler: { (alert: UIAlertAction!) -> Void in self.UPGenderET.text = "Male"})
        let FemaleAction = UIAlertAction(title: "Female", style: .default, handler: { (alert: UIAlertAction!) -> Void in self.UPGenderET.text = "Female"})
        let TransAction = UIAlertAction(title: "Transgender", style: .default, handler: { (alert: UIAlertAction!) -> Void in self.UPGenderET.text = "Transgender"})
        
        alert.addAction(MaleAction)
        alert.addAction(FemaleAction)
        alert.addAction(TransAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    //Getting data from fireStore
    func getCurUserData(){
        let curUserEmail = Auth.auth().currentUser?.email
        ref = db.collection("users").document("\(curUserEmail!)")
        ref.getDocument {(document, error) in
            if let document = document {
                let data = document.data()!
                let name = data["fullName"] as? String
                let age = data["age"] as? String
                let contact = data["contact"] as? String
                let gender = data["gender"] as? String
                let address = data["address"] as? String
                
                self.populateFields(name: name!, age: age!, contact: contact!, gender: gender!,address: address!)
                
                //Getting image from the fireStore
                let ref = Storage.storage().reference(withPath: "userImages"+"/"+"image"+curUserEmail!)
                ref.getData(maxSize: (1*2048*2048)) { (data, error) in
                    if error != nil{
                        print(error!)
                        self.UPErrorLabel.text = "cannot fetch image"
                    }
                    else{
                        self.UPImageView.image = UIImage(data: data!)
                    }
                }
            }
            else{
                print("Document does not exist in cache")
            }
            
        }
    }
    
    //Populating the Fields
    func populateFields(name:String,age:String,contact:String,gender:String,address:String){
        UPNameET.text = name
        UPAgeET.text = age
        UPContactET.text = contact
        UPGenderET.text = gender
        AddressET.text = address
    }
    
    //ImageView Tapped Gesture
    @IBAction func imageViewTapped(_ sender: UITapGestureRecognizer) {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    //Image Picker Delegate method
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        UPImageView.image = image
        imageData = image.pngData()!
    }
    //Image Picker Delegate method
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        picker.dismiss(animated: true, completion: nil)
    }
    
    //Update Button
    @IBAction func UpdateBtnPressed(_ sender: UIButton) {
        let fullname = UPNameET.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let contact = UPContactET.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let age = UPAgeET.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let gender = UPGenderET.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let address = AddressET.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let db = Firestore.firestore()
        let newDoc = db.collection("users").document((Auth.auth().currentUser?.email)!)
        newDoc.setData( ["fullName" : fullname,"age" : age , "gender" : gender,"contact":contact , "address" : address] , merge: true)
        
        //Updating Image
        self.storage.child("userImages/image"+newDoc.documentID)
            .putData(self.imageData, metadata: nil, completion: {_, error in
                        guard error == nil else {
                            self.UPErrorLabel.text?.append(" Failed to upload Image")
                            return }})
        

        UPErrorLabel.text = "Updated"
    }
    
    //Sign Out Button
    @IBAction func SignOutBTN(_ sender: UIButton) {
        // create the alert
        let alert = UIAlertController(title: "Signing Out", message: "Do you want to sign-out?", preferredStyle: UIAlertController.Style.alert)
        // add an action (button)
        let YesAction = UIAlertAction(title: "Yes", style: .default){_ in
            let SSLoginPage = self.storyboard?.instantiateViewController(identifier: "SSLoginPage") as? LoginViewController
            self.view.window?.rootViewController = SSLoginPage
            self.view.window?.makeKeyAndVisible()
        }
        let NoAction = UIAlertAction(title: "No", style: .cancel)
        alert.addAction(NoAction)
        alert.addAction(YesAction)
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
}
