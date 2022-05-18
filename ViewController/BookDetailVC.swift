//
//  BookDetailVC.swift


import UIKit

class BookDetailVC: UIViewController {

    @IBOutlet weak var tblFavList: UITableView!
    @IBOutlet weak var sbBar: UISearchBar!
    @IBOutlet weak var btnSorting: UIButton!
    
    var pendingItem: DispatchWorkItem?
    var pendingRequest: DispatchWorkItem?
    var dataCat : CategoryModel!
    var array = [BookModel]()
    var arrData = [BookModel]()
    
    
    @IBAction func setSorting(_ sender: UIButton) {
        self.setPopUp()
    }
    
    private func setPopUp(){
        
      
        let actionSheet = UIAlertController(title: "Sorting", message: "", preferredStyle: .actionSheet)
        
        let highToLow = UIAlertAction(title: "Price:High to Low", style: .default, handler: {
            (alert: UIAlertAction) -> Void in
            self.btnSorting.setTitle("High to Low", for: .normal)
            self.arrData = self.array.sorted(by: {(Double($0.price) ?? 0.0 > Double($1.price) ?? 0.0)})
            self.tblFavList.reloadData()
        })
        
        let lowToHigh = UIAlertAction(title: "Price:Low to High", style: .default, handler: { [self]
            (alert: UIAlertAction) -> Void in
            self.arrData = self.array.sorted(by: {(Double($0.price) ?? 0.0 < Double($1.price) ?? 0.0)})
            self.tblFavList.reloadData()
            self.btnSorting.setTitle("Low to High", for: .normal)
          
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction) -> Void in
            self.arrData = self.array
            self.btnSorting.setTitle("Sorting", for: .normal)
        })
        
        if let popoverController = actionSheet.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        actionSheet.addAction(highToLow)
        actionSheet.addAction(lowToHigh)
        actionSheet.addAction(cancelAction)
        
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnSorting.layer.cornerRadius = 10.0
        self.sbBar.layer.borderWidth = 1.0
        self.sbBar.layer.borderColor = UIColor.lightGray.cgColor
        self.sbBar.layer.cornerRadius = 10.0
        self.sbBar.delegate = self
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if dataCat != nil {
            self.getData()
        }
    }
}


extension BookDetailVC: UITableViewDelegate, UITableViewDataSource {
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
            if let userEmail = GFunction.user.email {
                self.checkFav(data: data, email: userEmail)
            }
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func addToFav(data: BookModel,email:String){
        var ref : DocumentReference? = nil
        ref = AppDelegate.shared.db.collection(bFavourite).addDocument(data:
            [
                bName: data.name,
                bCategory : data.category,
                bAddedDate: data.addedDate,
                bPrice: data.price,
                bEmail: email,
                bBookID: data.docId
            ])
        {  err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
                Alert.shared.showAlert(message: "Your Book has been Added as favourite !!!") { (true) in
                    UIApplication.shared.setTab()
                }
            }
        }
    }
    
    func checkFav(data: BookModel,email:String){
        _ = AppDelegate.shared.db.collection(bFavourite).whereField(bBookID, isEqualTo: data.docId).addSnapshotListener{ querySnapshot, error in
            
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            if snapshot.documents.count == 0 {
                self.addToFav(data: data, email: email)
            }else{
                Alert.shared.showAlert(message: "Book already in favourite list !!!", completion: nil)
            }
        }
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
    
    func getData(){
        _ = AppDelegate.shared.db.collection(bBook).whereField(bCategory, isEqualTo: dataCat.name).addSnapshotListener{ querySnapshot, error in
            
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
extension BookDetailVC : UISearchBarDelegate{
    
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
