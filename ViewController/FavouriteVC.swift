//
//  FavouriteVC.swift
//  BookKart


import UIKit

class FavouriteVC: UIViewController {

    
    @IBOutlet weak var tblFavList: UITableView!
    @IBOutlet weak var sbBar: UISearchBar!

    
    var pendingItem: DispatchWorkItem?
    var pendingRequest: DispatchWorkItem?
    var array = [BookModel]()
    var arrData = [BookModel]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sbBar.layer.borderWidth = 1.0
        self.sbBar.layer.borderColor = UIColor.lightGray.cgColor
        self.sbBar.layer.cornerRadius = 10.0
        self.sbBar.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let userEmail = GFunction.user.email {
            self.getData(email: userEmail)
        }
    }
}


extension FavouriteVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.arrData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath) as! BookCell
        let data = self.arrData[indexPath.row]
        cell.config(data: data)
        cell.btnAdd.addAction(for: .touchUpInside) {
            if let userEmail = GFunction.user.email {
                self.checkCart(data: data, email: userEmail)
            }
        }
        cell.btnFav.addAction(for: .touchUpInside) {
//            if let userEmail = GFunction.user.email {
//                self.checkFav(data: data, email: userEmail)
//            }
            
            self.deleteFav(docID: data.docId)
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func cart(data: BookModel,email:String) {
        var ref : DocumentReference? = nil
        ref = AppDelegate.shared.db.collection(bCart).addDocument(data:
            [
                bName: data.name,
                bCategory : data.category,
                bAddedDate: data.addedDate,
                bPrice: data.price,
                bEmail: email
            ])
        {  err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
                Alert.shared.showAlert(message: "Your Book has been Added into cart !!!") { (true) in
                    UIApplication.shared.setTab()
                }
            }
        }
    }
    
    func deleteFav(docID:String){
        let ref = AppDelegate.shared.db.collection(bFavourite).document(docID)
        ref.delete(){ err in
            if let err = err {
                print("Error updating document: \(err)")
                self.navigationController?.popViewController(animated: true)
            } else {
                print("Document successfully updated")
                Alert.shared.showAlert(message: "Your Book has been removed from favourite !!!") { (true) in
                    UIApplication.shared.setTab()
                }
            }
        }
    }
    
    func checkFav(data: BookModel,email:String){
        _ = AppDelegate.shared.db.collection(bFavourite).whereField(bEmail, isEqualTo: email).addSnapshotListener{ querySnapshot, error in
            
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            if snapshot.documents.count != 0 {
                let docID = snapshot.documents[0].documentID
                self.deleteFav(docID: docID)
            }
        }
    }
    
    func checkCart(data: BookModel,email:String){
        _ = AppDelegate.shared.db.collection(bCart).whereField(bBookID, isEqualTo: data.docId).addSnapshotListener{ querySnapshot, error in
            
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            if snapshot.documents.count == 0 {
                self.cart(data: data, email: email)
            }else{
                Alert.shared.showAlert(message: "Book already in cart list !!!", completion: nil)
            }
        }
    }
}



class BookCell: UITableViewCell {
    @IBOutlet weak var vwCell: UIView!
    @IBOutlet weak var imgBook: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var btnFav: UIButton!
    @IBOutlet weak var btnAdd: UIButton!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.vwCell.layer.cornerRadius = 10.0
        self.vwCell.layer.borderWidth = 1.0
        self.vwCell.layer.borderColor = UIColor.lightGray.cgColor
        self.vwCell.backgroundColor = .clear
        self.btnAdd.layer.cornerRadius = 10.0
    }
    
    func config(data: BookModel){
        self.lblPrice.text = "$ \(data.price.description)"
        self.lblName.text = data.name.description
        self.lblDate.text = data.addedDate.description
    }
}


extension FavouriteVC {
    func getData(email:String){
        _ = AppDelegate.shared.db.collection(bFavourite).whereField(bEmail, isEqualTo: email).addSnapshotListener{ querySnapshot, error in
            
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            self.array.removeAll()
            if snapshot.documents.count != 0 {
                for data in snapshot.documents {
                    let data1 = data.data()
                    if let name: String = data1[bName] as? String, let addedDate: String = data1[bAddedDate] as? String, let price: String = data1[bPrice] as? String, let category: String = data1[bCategory] as? String {
                        print("Data Count : \(self.array.count)")
                        self.array.append(BookModel(docId: data.documentID, name: name, category: category, price: price, addedDate: addedDate))
                    }
                }
            }
            self.arrData = self.array
            self.tblFavList.delegate = self
            self.tblFavList.dataSource = self
            self.tblFavList.reloadData()
        }
    }
}


//MARK:- UISearchBarDelegate Delegate methods :-
extension FavouriteVC : UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        
        self.pendingRequest?.cancel()
        
        guard searchBar.text != nil else {
            return
        }
        
        if(searchText.count == 0 || (searchText == " ")){
            self.arrData = self.array
            self.tblFavList.reloadData()
            return
        }
        
        //self.isTextEdit = true
        
        self.pendingRequest = DispatchWorkItem{ [weak self] in
            
            guard let self = self else { return }
            
            self.arrData = self.array.filter({$0.name.localizedStandardContains(searchText)})
            self.tblFavList.reloadData()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300), execute: self.pendingRequest!)
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.arrData = self.array.filter({$0.name.localizedStandardContains(searchBar.text!)})
        self.tblFavList.reloadData()
        self.sbBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.arrData = self.array
        self.sbBar.resignFirstResponder()
    }
}
