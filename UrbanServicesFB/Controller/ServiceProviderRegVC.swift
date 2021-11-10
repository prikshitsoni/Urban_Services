//
//  ServiceProviderRegVC.swift
//  UrbanServicesFB
//
//  Created by prikshit soni on 25/03/21.
//

import UIKit
import Foundation
import Firebase
import MobileCoreServices

class ServiceProviderRegVC: UIViewController, UIImagePickerControllerDelegate , UINavigationControllerDelegate , UIDocumentPickerDelegate {
    
    @IBOutlet weak var NameSPET: UITextField!
    @IBOutlet weak var AgeSPET: UITextField!
    @IBOutlet weak var GenderSPET: UITextField!
    @IBOutlet weak var ContactSPET: UITextField!
    @IBOutlet weak var EmailSPET: UITextField!
    @IBOutlet weak var PasswordSPET: UITextField!
    @IBOutlet weak var JobCatSPET: UITextField!
    @IBOutlet weak var JobDescSPET: UITextField!
    @IBOutlet weak var ErrorLabelSP: UILabel!
    @IBOutlet weak var SPImageView: UIImageView!
    @IBOutlet weak var AddressSPET: UITextField!
    
    var address : String = ""
    var LatRec : Double = 0.0
    var LongRec : Double = 0.0
    
    private let storage = Storage.storage().reference()
    var imageData = Data()
    var resumeURL = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ErrorLabelSP.alpha = 0
    }
    override func viewWillAppear(_ animated: Bool) {
        AddressSPET.text = address
    }
    
    //Document picker delegate methods
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let myURL = urls.first else {
            return
        }
        resumeURL = myURL.absoluteString
    }
    
    //check if all fields are filled
    func valicateFields() -> String?{
        if (NameSPET.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || AgeSPET.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || GenderSPET.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || ContactSPET.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || EmailSPET.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || PasswordSPET.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""||JobCatSPET.text?.trimmingCharacters(in: .whitespaces) == "" || JobDescSPET.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || AddressSPET.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""){
            return "Please fill in all fields"
        }
        
        //check if password is secure
        let cleanPassword = PasswordSPET.text!.trimmingCharacters(in: .whitespaces)
        if Utilities.isPasswordValid(cleanPassword) == false {
            return "Please enter passeord with atleast 8 characters , a special character and a number"
        }
        //check if email is properly formatted
        let cleanEmail = EmailSPET.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if Utilities.isEmailValid(cleanEmail) == false {
            return "please enter a valid email addess"
        }
        return nil
    }
    
    //Select gender Button
    @IBAction func GenderBtnTapped(_ sender: UIButton) {
        // create the alert
        let alert = UIAlertController(title: "Gender Picker", message: "Pick your Gender ", preferredStyle:.actionSheet)
        let MaleAction = UIAlertAction(title: "Male", style: .default, handler: { (alert: UIAlertAction!) -> Void in self.GenderSPET.text = "Male"})
        let FemaleAction = UIAlertAction(title: "Female", style: .default, handler: { (alert: UIAlertAction!) -> Void in self.GenderSPET.text = "Female"})
        let TransAction = UIAlertAction(title: "Transgender", style: .default, handler: { (alert: UIAlertAction!) -> Void in self.GenderSPET.text = "Transgender"})
        
        alert.addAction(MaleAction)
        alert.addAction(FemaleAction)
        alert.addAction(TransAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    //Select Job Category Button
    @IBAction func JobCatBtnTapped(_ sender: UIButton) {
        // create the alertsheet
        let alert = UIAlertController(title: "Job Category", message: "Pick your job Category ", preferredStyle:.actionSheet)
        let Plumber = UIAlertAction(title: "Plumber", style: .default, handler: { (alert: UIAlertAction!) -> Void in self.JobCatSPET.text = "Plumber"})
        let Electrician = UIAlertAction(title: "Electrician", style: .default, handler: { (alert: UIAlertAction!) -> Void in self.JobCatSPET.text = "Electrician"})
        let Cook = UIAlertAction(title: "Cook", style: .default, handler: { (alert: UIAlertAction!) -> Void in self.JobCatSPET.text = "Cook"})
        let Driver = UIAlertAction(title: "Driver", style: .default, handler: { (alert: UIAlertAction!) -> Void in self.JobCatSPET.text = "Driver"})
        let Babysitter = UIAlertAction(title: "Babysitter", style: .default, handler: { (alert: UIAlertAction!) -> Void in self.JobCatSPET.text = "Babysitter"})
        let Maid = UIAlertAction(title: "Maid", style: .default, handler: { (alert: UIAlertAction!) -> Void in self.JobCatSPET.text = "Maid"})
        let Mechanic = UIAlertAction(title: "Mechanic", style: .default, handler: { (alert: UIAlertAction!) -> Void in self.JobCatSPET.text = "Mechanic"})
        let Carpenter = UIAlertAction(title: "Carpenter", style: .default, handler: { (alert: UIAlertAction!) -> Void in self.JobCatSPET.text = "Carpenter"})
        let Builder = UIAlertAction(title: "Builder", style: .default, handler: { (alert: UIAlertAction!) -> Void in self.JobCatSPET.text = "Builder"})
        let Roofing = UIAlertAction(title: "Roofing", style: .default, handler: { (alert: UIAlertAction!) -> Void in self.JobCatSPET.text = "Roofing"})
        let Gardner = UIAlertAction(title: "Gardner", style: .default, handler: { (alert: UIAlertAction!) -> Void in self.JobCatSPET.text = "Gardner"})
        //adding action to alertsheet
        alert.addAction(Plumber)
        alert.addAction(Electrician)
        alert.addAction(Cook)
        alert.addAction(Driver)
        alert.addAction(Babysitter)
        alert.addAction(Maid)
        alert.addAction(Mechanic)
        alert.addAction(Carpenter)
        alert.addAction(Builder)
        alert.addAction(Roofing)
        alert.addAction(Gardner)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    //Upload Resume button
    @IBAction func UploadResumeBTN(_ sender: UIButton) {
        let documentPicker = UIDocumentPickerViewController(documentTypes: [kUTTypePDF as String], in: .import)
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .formSheet
        self.present(documentPicker, animated: true, completion: nil)
    }
    
    //Image Tapped gesture
    @IBAction func SPImageTapped(_ sender: UITapGestureRecognizer) {
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
        SPImageView.image = image
        imageData = image.pngData()!
    }
    
    //Image Picker Delegate method
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        picker.dismiss(animated: true, completion: nil)
    }
    
    //Register button pressed
    @IBAction func RegisterTapped(_ sender: UIButton) {
        //validate the fields
        let error = valicateFields()
        if error != nil{
            showErrorMessage(error!)
        }
        else{
            //create clean version of data
            let fullname = NameSPET.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let contact = ContactSPET.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let age = AgeSPET.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let gender = GenderSPET.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = EmailSPET.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = PasswordSPET.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let address = AddressSPET.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let jobCategory = JobCatSPET.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let jobDescription = JobDescSPET.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            //create the ServiceSeeker
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                if err != nil{
                    //there is some error
                    self.showErrorMessage(err!.localizedDescription)
                }
                else{
                    let db = Firestore.firestore()
                    let newDoc = db.collection("serviceProviders").document("\(email)")
                    newDoc.setData(["fullName" : fullname,"age" : age , "gender" : gender,"contact":contact,"email":email,"password":password,"jobCategory" : jobCategory,"jobDescription" : jobDescription ,"id":newDoc.documentID , "address" : address ,"latitude" : self.LatRec , "longitude" : self.LongRec])
                    
                    //Uploading Image
                    self.storage.child("ServiceProviderImages/image"+newDoc.documentID)
                        .putData(self.imageData, metadata: nil, completion:{_, error in
                                    guard error == nil else {
                                        self.ErrorLabelSP.text?.append(" Failed to upload Image")
                                        return }})
                    
                    //Uploading resume
                    self.storage.child("ServiceProviderResume/Resume"+newDoc.documentID).putFile(from: URL(string: self.resumeURL)!, metadata: nil)
                    {(downloadmetadata, error) in
                        if let error = error {
                            print(" there is a error\(error)")
                            return }
                        print(" there is a completing task of file \(String(describing : downloadmetadata))")}
                    
                    //changing root controller to SPHomeTabBarController
                    let SPHomeViewController = self.storyboard?.instantiateViewController(identifier: "ServiceProviderHome") as? SPHomeTabBarController
                    self.view.window?.rootViewController = SPHomeViewController
                    self.view.window?.makeKeyAndVisible()
                    
                    self.showErrorMessage("Saved")
                }
            }
        }
    }
    
    func showErrorMessage(_ messege: String){
        ErrorLabelSP.text = messege
        ErrorLabelSP.alpha = 1
    }
    
}
