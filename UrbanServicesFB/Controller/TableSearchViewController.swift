//
//  TableSearchViewController.swift
//  UrbanServicesFB
//
//  Created by prikshit soni on 31/03/21.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage
import CoreLocation

class TableSearchViewController: UITableViewController ,UISearchBarDelegate{
    
    @IBOutlet weak var SearchBar: UISearchBar!
    
    private var ref : DocumentReference!
    private let storage = Storage.storage().reference()
    let db = Firestore.firestore()
    var selectedIndex = Int()
    var IsSearching = false
    private var service: UserService?
    
    private var allusers = [appUser]() {
        didSet {
            DispatchQueue.main.async {
                self.users = self.allusers
            }
        }
    }
    
    //Array to hold all structured data from FireBase
    var users = [appUser]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    //Array for searched elements
    var SearchedUsers = [appUser]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    func loadData() {
        service = UserService()
        service?.get(collectionID: "serviceProviders") { users in
            self.allusers = users
        }
    }
    
    //tranferring data along with segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! SPDetailViewController
        destVC.FromTableView = true
        if(IsSearching){
            destVC.name = SearchedUsers[selectedIndex].fullName!
            destVC.age = SearchedUsers[selectedIndex].age!
            destVC.gender = SearchedUsers[selectedIndex].gender!
            destVC.contact = SearchedUsers[selectedIndex].contact!
            destVC.address = SearchedUsers[selectedIndex].address!
            destVC.category = SearchedUsers[selectedIndex].jobCat!
            destVC.descrip = SearchedUsers[selectedIndex].jobDesc!
            destVC.email = SearchedUsers[selectedIndex].email!
        }
        else{
            destVC.name = users[selectedIndex].fullName!
            destVC.age = users[selectedIndex].age!
            destVC.gender = users[selectedIndex].gender!
            destVC.contact = users[selectedIndex].contact!
            destVC.address = users[selectedIndex].address!
            destVC.category = users[selectedIndex].jobCat!
            destVC.descrip = users[selectedIndex].jobDesc!
            destVC.email = users[selectedIndex].email!
        }
    }
    
    //SearchBar Delegate method
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchText == ""){
            //not searching
            IsSearching = false
            self.tableView.reloadData()
        }
        else{
            //searching
            print("")
            IsSearching = true
            self.tableView.reloadData()
            FillSearchUser(SearchedText: searchText)
            self.tableView.reloadData()
        }
    }
    //SearchBar Delegate method
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        IsSearching = false
        self.tableView.reloadData()
        SearchBar.text = ""
    }
    
    //Performing search and filling SearchedUsers
    func FillSearchUser(SearchedText : String){
       db.collection("serviceProviders").whereField("jobCategory", isEqualTo: SearchedText).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.SearchedUsers.removeAll()
                for document in querySnapshot!.documents {
                    self.SearchedUsers.append(appUser(fullName: document["fullName"] as? String ?? "", age: document["age"] as? String ?? "", contact: document["contact"] as? String ?? "", gender: document["gender"] as? String ?? "", jobCat: document["jobCategory"] as? String ?? "", jobDesc: document["jobDescription"] as? String ?? "", email: document["email"] as? String ?? "", status: document["status"] as? String ?? "" , address: document["address"] as? String ?? "" , Latitude: document["latitude"] as? Double ?? 0.0, Longitude: document["longitude"] as? Double ?? 0.0))
                }
            }
        }
    }

    
    // TableView Delegate method
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(IsSearching){
            return SearchedUsers.count
        }
        else{
            return users.count
        }
        
    }
    
    // TableView Delegate method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "MoveToSPDetail", sender: TableSearchViewController.self)
    }
    
    // TableView Delegate method
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(IsSearching && SearchedUsers.count == 0){
            //show Nil Cell
            let cell  = (tableView.dequeueReusableCell(withIdentifier: "Cell",for: indexPath)) as! CustomTableViewCell
            return cell
        }
        else{
            let cell  = (tableView.dequeueReusableCell(withIdentifier: "Cell",for: indexPath)) as! CustomTableViewCell
            if (IsSearching){
                return ChooseList(cell: cell, List: SearchedUsers[indexPath.row])
            }
            else{
                return ChooseList(cell: cell, List: users[indexPath.row])
            }
        }
    }
    
    func ChooseList(cell : CustomTableViewCell, List : appUser) -> UITableViewCell {
        let currentStatus = List.status
        switch currentStatus {
        case "online":
            cell.CellStatus.backgroundColor = UIColor.green
        case "break":
            cell.CellStatus.backgroundColor = UIColor.orange
        case "offline":
            cell.CellStatus.backgroundColor = UIColor.red
        default:
            cell.CellStatus.text = "Not available"
            cell.CellStatus.backgroundColor = UIColor.white
        }
        cell.CellName.text = List.fullName
        cell.CellAge.text = List.age
        cell.CellGender.text = List.gender
        cell.CellJobCat.text = List.jobCat
        cell.CellContact.text = List.contact
        cell.CellStatus.text = List.status
        
        let ref = Storage.storage().reference(withPath: "ServiceProviderImages"+"/"+"image"+List.email!)
        ref.getData(maxSize: (1*2048*2048)) { (data, error) in
            if error != nil{
                print(error!)
            }
            else{
                cell.CellImageView.image = UIImage(data: data!)
            }
        }
        return cell
    }
}
