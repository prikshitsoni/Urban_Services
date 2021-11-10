//
//  ServiceSeekerRegVC.swift
//  UrbanServicesFB
//
//  Created by prikshit soni on 24/03/21.
//

import UIKit
import Firebase
import FirebaseStorage

class ServiceSeekerRegVC: UIViewController , UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    @IBOutlet weak var NameET: UITextField!
    @IBOutlet weak var AgeET: UITextField!
    @IBOutlet weak var GenderET: UITextField!
    @IBOutlet weak var ContactET: UITextField!
    @IBOutlet weak var EmailET: UITextField!
    @IBOutlet weak var PasswordET: UITextField!
    @IBOutlet weak var RegisterBtn: UIButton!
    @IBOutlet weak var ErrorLabel: UILabel!
    @IBOutlet weak var UserImage: UIImageView!
    @IBOutlet weak var AddressET: UITextField!
    
    var address : String = ""
    var LatRec : Double = 0.0
    var LongRec : Double = 0.0
    
    private let storage = Storage.storage().reference()
    var imageData = Data()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ErrorLabel.alpha = 0
    }
    override func viewWillAppear(_ animated: Bool) {
        AddressET.text = address
    }
    
    //validating Input Fields
    func valicateFields() -> String?{
        if(NameET.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            AgeET.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            GenderET.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            ContactET.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            EmailET.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            PasswordET.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            AddressET.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""){
            return "Please fill in all fields"
        }
        
        //check if password is secure
        let cleanPassword = PasswordET.text!.trimmingCharacters(in: .whitespaces)
        if Utilities.isPasswordValid(cleanPassword) == false {
            return "Please enter passeord with atleast 8 characters , a special character and a number"
        }
        //check if email is properly formatted
        let cleanEmail = EmailET.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if Utilities.isEmailValid(cleanEmail) == false {
            return "please enter a valid email addess"
        }
        return nil
    }
    
    //Select gender Button Action
    @IBAction func SelectGenderBtn(_ sender: UIButton) {
        // create the alertSheet
        let alert = UIAlertController(title: "Gender Picker", message: "Pick your Gender ", preferredStyle:.actionSheet)
        let MaleAction = UIAlertAction(title: "Male", style: .default, handler: { (alert: UIAlertAction!) -> Void in self.GenderET.text = "Male"})
        let FemaleAction = UIAlertAction(title: "Female", style: .default, handler: { (alert: UIAlertAction!) -> Void in self.GenderET.text = "Female"})
        let TransAction = UIAlertAction(title: "Transgender", style: .default, handler: { (alert: UIAlertAction!) -> Void in self.GenderET.text = "Transgender"})
        //Adding actions to alertsheet
        alert.addAction(MaleAction)
        alert.addAction(FemaleAction)
        alert.addAction(TransAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    //ImageView Tapped Gesture
    @IBAction func UserImageTapped(_ sender: UITapGestureRecognizer) {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    //Image picker delegate method
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        UserImage.image = image
        imageData = image.pngData()!
    }
    //Image picker deligate method
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        picker.dismiss(animated: true, completion: nil)
    }
    
    //Register button OnClick
    @IBAction func RegisterBtnTapped(_ sender: UIButton) {
        //validate the fields
        let error = valicateFields()
        if error != nil{
            showErrorMessage(error!)
        }
        else{
            //create clean version of data
            let fullname = NameET.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let contact = ContactET.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let age = AgeET.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let gender = GenderET.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = EmailET.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = PasswordET.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let Address = AddressET.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            //create the user
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                if err != nil{
                    //there is some error
                    self.showErrorMessage(err!.localizedDescription)
                }
                else{
                    let db = Firestore.firestore()
                    let newDoc = db.collection("users").document("\(email)")
                    newDoc.setData(["fullName" : fullname,"age" : age , "gender" : gender,"contact":contact,"email":email,"password":password,"id": newDoc.documentID,"address" : Address ,"latitude":self.LatRec , "longitude" : self.LongRec])
                    
                    //Saving Image
                    self.storage.child("userImages/image"+newDoc.documentID).putData(self.imageData, metadata: nil, completion: {_, error in
                        guard error == nil else {
                            self.ErrorLabel.text?.append(" Failed to upload Image")
                            return
                        }})
                    
                    //changin root view Controller to UserHomeTabBarController
                    let userHomeViewController = self.storyboard?.instantiateViewController(identifier: "userHome") as? UserHomeTabBarController
                    self.view.window?.rootViewController = userHomeViewController
                    self.view.window?.makeKeyAndVisible()
                    
                    self.showErrorMessage("Saved")
                    
                }
            }
        }
    }
    
    func showErrorMessage(_ messege: String){
        ErrorLabel.text = messege
        ErrorLabel.alpha = 1
    }
}
