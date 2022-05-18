//
//  AdminHomeVC.swift
//  BookKart

import UIKit

class AdminHomeVC: UIViewController {

    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var btnLogout: UIButton!
    @IBOutlet weak var tblBookList: UITableView!
    
    var array = [BookModel]()
    
    @IBAction func btnClick(_ sender: UIButton) {
        if sender == btnAdd {
            if let vc = UIStoryboard.main.instantiateViewController(withClass: AddBookVC.self) {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else if sender == btnLogout {
            UIApplication.shared.setStart()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblBookList.delegate = self
        self.tblBookList.dataSource  = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getData()
        self.navigationController?.navigationBar.isHidden = true
    }

}


extension AdminHomeVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AdminAddBookCell", for: indexPath) as! AdminAddBookCell
        cell.selectionStyle = .none
        cell.configCell(data: self.array[indexPath.row])
        cell.btnAdd.addAction(for: .touchUpInside) {
            if let vc = UIStoryboard.main.instantiateViewController(withClass: EditBookVC.self) {
                vc.data = self.array[indexPath.row]
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        cell.btnDelete.addAction(for: .touchUpInside) {
            Alert.shared.showAlert("BookKart", actionOkTitle: "Delete", actionCancelTitle: "Cancel", message: "Are you sure you want to delete this book? ") { (true) in
                self.deleteAction(docID: self.array[indexPath.row].docId)
            }
        }
        
        cell.lblPrice.isHidden = false
        return cell
    }
    
    func deleteAction(docID: String){
        let ref = AppDelegate.shared.db.collection(bBook).document(docID)
        ref.delete(){ err in
            if let err = err {
                print("Error updating document: \(err)")
                self.navigationController?.popViewController(animated: true)
            } else {
                print("Document successfully updated")
                Alert.shared.showAlert(message: "Your Book has been deleted successfully!!!") { (true) in
                    self.getData()
                }
            }
        }
    }
    
    func getData(){
        _ = AppDelegate.shared.db.collection(bBook).addSnapshotListener{ querySnapshot, error in
            
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
            self.tblBookList.delegate = self
            self.tblBookList.dataSource = self
            self.tblBookList.reloadData()
        }
    }
}


class AdminBookCell: UITableViewCell {
    @IBOutlet weak var vwCell: UIView!
    @IBOutlet weak var imgBook: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
//    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.vwCell.layer.cornerRadius = 10.0
        self.vwCell.layer.borderWidth = 1.0
        self.vwCell.layer.borderColor = UIColor.lightGray.cgColor
        self.vwCell.backgroundColor = .clear
//        self.btnAdd.layer.cornerRadius = 10.0
        self.btnDelete.layer.cornerRadius = 10.0
    }
    
    
    func configCell(data: BookModel) {
        self.lblName.text = data.name.description
        self.lblDate.text = data.addedDate.description
        self.lblPrice.text = "$ \(data.price.description)"
    }
}


class AdminAddBookCell: UITableViewCell {
    @IBOutlet weak var vwCell: UIView!
    @IBOutlet weak var imgBook: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.vwCell.layer.cornerRadius = 10.0
        self.vwCell.layer.borderWidth = 1.0
        self.vwCell.layer.borderColor = UIColor.lightGray.cgColor
        self.vwCell.backgroundColor = .clear
        self.btnAdd.layer.cornerRadius = 10.0
        self.btnDelete.layer.cornerRadius = 10.0
    }
    
    
    func configCell(data: BookModel) {
        self.lblName.text = data.name.description
        self.lblDate.text = data.addedDate.description
        self.lblPrice.text = "$ \(data.price.description)"
    }
}
