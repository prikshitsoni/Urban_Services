//
//  ServiceProviderProfileVC.swift
//  UrbanServicesFB
//
//  Created by prikshit soni on 30/03/21.
//

import UIKit
import Firebase
import FirebaseStorage
import MobileCoreServices

class ServiceProviderProfileVC: UIViewController ,UIImagePickerControllerDelegate , UINavigationControllerDelegate , UIDocumentPickerDelegate {
    
    @IBOutlet weak var SPNameET: UITextField!
    @IBOutlet weak var SPAgeET: UITextField!
    @IBOutlet weak var SPGenderET: UITextField!
    @IBOutlet weak var SPContactET: UITextField!
    @IBOutlet weak var SPCategoryET: UITextField!
    @IBOutlet weak var SPDescription: UITextField!
    @IBOutlet weak var SPImageView: UIImageView!
    @IBOutlet weak var SPErrorLabel: UILabel!
    @IBOutlet weak var SPAddressET: UITextField!
    
    private var ref : DocumentReference!
    private let storage = Storage.storage().reference()
    var resumeURL = String()
    var imageData = Data()
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        SPErrorLabel.text = ""
        super.viewDidLoad()
        getCurUserData()
        SPErrorLabel.alpha = 0
    }
    override func viewWillAppear(_ animated: Bool) {
        SPErrorLabel.text = ""
        getCurUserData()
    }
    
    //Document picker delegate methods
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let myURL = urls.first else {
            return
        }
        print(myURL)
        resumeURL = myURL.absoluteString
    }
    
    //Getting data from fireStore
    func getCurUserData(){
        let curUserEmail = Auth.auth().currentUser?.email
        ref = db.collection("serviceProviders").document("\(curUserEmail!)")
        ref.getDocument{(document, error) in
            if let document = document {
                let data = document.data()!
                let name = data["fullName"] as? String
                let age = data["age"] as? String
                let contact = data["contact"] as? String
                let gender = data["gender"] as? String
                let jobCat = data["jobCategory"] as? String
                let JobDesc = data["jobDescription"] as? String
                let address = data["address"] as? String
                
                self.populateFields(name: name!, age: age!, contact: contact!, gender: gender!, jobCat: jobCat!, jobDesc: JobDesc!,address : address!)
                
                //getting Service provider image back
                let ref = Storage.storage().reference(withPath: "ServiceProviderImages"+"/"+"image"+curUserEmail!)
                ref.getData(maxSize: (1*2048*2048)) { (data, error) in
                    if error != nil{
                        print(error!)
                        self.SPErrorLabel.text = "cannot fetch image"
                    }
                    else{
                        self.SPImageView.image = UIImage(data: data!)
                    }
                }
            }
            else{
                print("Document does not exist in cache")
            }
        }
    }
    
    //Populating Fields
    func populateFields(name:String,age:String,contact:String,gender:String,jobCat:String,jobDesc:String,address:String){
        SPNameET.text = name
        SPAgeET.text = age
        SPContactET.text = contact
        SPGenderET.text = gender
        SPCategoryET.text = jobCat
        SPDescription.text = jobDesc
        SPAddressET.text = address
    }
    
    //Select gender button
    @IBAction func GenderBtnPressed(_ sender: UIButton) {
        // create the alert
        let alert = UIAlertController(title: "Gender Picker", message: "Pick your Gender ", preferredStyle:.actionSheet)
        let MaleAction = UIAlertAction(title: "Male", style: .default, handler: { (alert: UIAlertAction!) -> Void in self.SPGenderET.text = "Male"})
        let FemaleAction = UIAlertAction(title: "Female", style: .default, handler: { (alert: UIAlertAction!) -> Void in self.SPGenderET.text = "Female"})
        let TransAction = UIAlertAction(title: "Transgender", style: .default, handler: { (alert: UIAlertAction!) -> Void in self.SPGenderET.text = "Transgender"})
        
        alert.addAction(MaleAction)
        alert.addAction(FemaleAction)
        alert.addAction(TransAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    //Select Job Category button
    @IBAction func JobCatBtnTapped(_ sender: UIButton) {
        // create the alert
        let alert = UIAlertController(title: "Job Category", message: "Pick your job Category ", preferredStyle:.actionSheet)
        let Plumber = UIAlertAction(title: "Plumber", style: .default, handler: { (alert: UIAlertAction!) -> Void in self.SPCategoryET.text = "Plumber"})
        let Electrician = UIAlertAction(title: "Electrician", style: .default, handler: { (alert: UIAlertAction!) -> Void in self.SPCategoryET.text = "Electrician"})
        let Cook = UIAlertAction(title: "Cook", style: .default, handler: { (alert: UIAlertAction!) -> Void in self.SPCategoryET.text = "Cook"})
        let Driver = UIAlertAction(title: "Driver", style: .default, handler: { (alert: UIAlertAction!) -> Void in self.SPCategoryET.text = "Driver"})
        let Babysitter = UIAlertAction(title: "Babysitter", style: .default, handler: { (alert: UIAlertAction!) -> Void in self.SPCategoryET.text = "Babysitter"})
        let Maid = UIAlertAction(title: "Maid", style: .default, handler: { (alert: UIAlertAction!) -> Void in self.SPCategoryET.text = "Maid"})
        let Mechanic = UIAlertAction(title: "Mechanic", style: .default, handler: { (alert: UIAlertAction!) -> Void in self.SPCategoryET.text = "Mechanic"})
        let Carpenter = UIAlertAction(title: "Carpenter", style: .default, handler: { (alert: UIAlertAction!) -> Void in self.SPCategoryET.text = "Carpenter"})
        let Builder = UIAlertAction(title: "Builder", style: .default, handler: { (alert: UIAlertAction!) -> Void in self.SPCategoryET.text = "Builder"})
        let Roofing = UIAlertAction(title: "Roofing", style: .default, handler: { (alert: UIAlertAction!) -> Void in self.SPCategoryET.text = "Roofing"})
        let Gardner = UIAlertAction(title: "Gardner", style: .default, handler: { (alert: UIAlertAction!) -> Void in self.SPCategoryET.text = "Gardner"})
        
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
    
    //ImageView tapped gesture
    @IBAction func ImageViewPressed(_ sender: UITapGestureRecognizer) {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    //Image Picker delegate method
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        SPImageView.image = image
        imageData = image.pngData()!
    }
    //Image Picker delegate method
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        picker.dismiss(animated: true, completion: nil)
    }
    
    //Update Resume button
    @IBAction func UpdateResumeBTN(_ sender: UIButton) {
        let documentPicker = UIDocumentPickerViewController(documentTypes: [kUTTypePDF as String], in: .import)
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .formSheet
        self.present(documentPicker, animated: true, completion: nil)
    }
    
    //Update data button
    @IBAction func updateBtnPressed(_ sender: UIButton) {
        let fullname = SPNameET.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let contact = SPContactET.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let age = SPAgeET.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let gender = SPGenderET.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let jobCat = SPCategoryET.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let jobDesc = SPDescription.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let address = SPAddressET.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let db = Firestore.firestore()
        let newDoc = db.collection("serviceProviders").document((Auth.auth().currentUser?.email)!)
        newDoc.setData( ["fullName" : fullname,"age" : age , "gender" : gender,"contact":contact ,"jobCategory" : jobCat , "jobDescription" : jobDesc , "address":address] , merge: true)
        
        //Updating Service Provider image
        self.storage.child("ServiceProviderImages/image"+newDoc.documentID).putData(self.imageData, metadata: nil, completion: {_, error in
            guard error == nil else {
                self.SPErrorLabel.text?.append(" Failed to upload Image")
                return
            }
        })
        
        //Updating resume
        self.storage.child("ServiceProviderResume/Resume"+newDoc.documentID).putFile(from: URL(string: self.resumeURL)!, metadata: nil)
        {(downloadmetadata, error) in
            if let error = error {
                print(" there is a error\(error)")
                return }
            print(" there is a completing task of file \(String(describing : downloadmetadata))")}
        SPErrorLabel.text = "Updated"

    }
}
