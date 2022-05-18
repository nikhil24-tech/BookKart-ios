//
//  CartVC.swift
//  BookKart
//
//  Created by 2022M3 on 18/04/22.
//

import UIKit

class CartVC: UIViewController {

    @IBOutlet weak var tblCartList: SelfSizedTableView!
    @IBOutlet weak var txtPromocode: UITextField!
    @IBOutlet weak var btnApply: UIButton!
    @IBOutlet weak var btnCheckOut: UIButton!
    @IBOutlet weak var lblSubTotal: UILabel!
    @IBOutlet weak var lblTax: UILabel!
    @IBOutlet weak var lblDelivery: UILabel!
    @IBOutlet weak var lblDiscount: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var vwDiscount: UIView!
    @IBOutlet weak var vwTotal: UIView!
    @IBOutlet weak var btnSelectType: UIButton!
    
    var array = [BookModel]()
    var subTotal : Float = 0.0
    var applyCode : Bool = false
    var tax : Float = 0.0
    var delivery : Float = 0.0
    var discount : Float = 0.0
    var total : Float = 0.0
  
    
    func applyStyle(){
        self.btnCheckOut.layer.cornerRadius = 10.0
        self.btnApply.layer.cornerRadius = 8.0
        self.tblCartList.delegate = self
        self.tblCartList.dataSource = self
    }
    
    @IBAction func btnApply(_ sender: Any) {
        self.applyCode.toggle()
        if self.applyCode && self.txtPromocode.text != "" {
            self.btnApply.setTitle("Applied", for: .normal)
        }else{
            self.txtPromocode.text = ""
            self.btnApply.setTitle("Apply", for: .normal)
        }
        self.calculateAmount()
    }
    
    
    @IBAction func btnTypeClick(_ sender: UIButton) {
        self.setPopUp()
    }
    private func setPopUp(){
        
      
        let actionSheet = UIAlertController(title: "Select Delivery Type", message: "", preferredStyle: .actionSheet)
        
        let highToLow = UIAlertAction(title: "Home Delivery", style: .default, handler: {
            (alert: UIAlertAction) -> Void in
            self.btnSelectType.setTitle("Home Delivery", for: .normal)
        })
        
        let lowToHigh = UIAlertAction(title: "Pick UP", style: .default, handler: { [self]
            (alert: UIAlertAction) -> Void in
            
            self.btnSelectType.setTitle("Pick UP", for: .normal)
          
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction) -> Void in
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
    @IBAction func btnCheckOutClick(_ sender: UIButton) {
        
        
        let date = GFunction.shared.getDate()
        self.placeOrder(data: self.array, tax: String(self.tax), discount: String(self.discount), delivery: String(self.delivery), subTotal: String(self.subTotal), total: String(self.total), date: date, promocode: self.txtPromocode.text ?? "")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.applyStyle()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.vwTotal.isHidden = true
        self.vwDiscount.isHidden = true
        self.btnCheckOut.isHidden = true
        if let userEmail = GFunction.user.email {
            self.getData(email: userEmail)
        }
    }

    func calculateAmount(){
        self.tax = (self.subTotal*0.20)
        self.delivery = (self.subTotal*0.10)
        self.discount = (self.subTotal*0)
        if self.txtPromocode.text == "ABC123" && self.applyCode {
            discount = (self.subTotal*0.10)
        }
        self.total = (self.subTotal+tax+delivery-discount)
        self.lblSubTotal.text = "$\(self.subTotal)"
        self.lblTax.text = "$\(tax)"
        self.lblDelivery.text = "$\(delivery)"
        self.lblTotal.text = "$\(total)"
        self.lblDiscount.text = "$\(discount)"
    }
}


extension CartVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AdminBookCell", for: indexPath) as! AdminBookCell
        cell.selectionStyle = .none
        let data = self.array[indexPath.row]
        cell.configCell(data: data)
        cell.btnDelete.addAction(for: .touchUpInside) {
            self.deleteAction(docID: data.docId)
        }
        return cell
    }
    
    func getData(email:String){
        self.vwTotal.isHidden = false
        self.vwDiscount.isHidden = false
        self.btnCheckOut.isHidden = false
        _ = AppDelegate.shared.db.collection(bCart).whereField(bEmail, isEqualTo: email).addSnapshotListener{ querySnapshot, error in
            
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
                        self.subTotal += Float(price) ?? 0.0
                    }
                }
                self.calculateAmount()
            }else{
               // Alert.shared.showAlert(message: "No Data found in cart") { (true) in
                    self.vwTotal.isHidden = true
                    self.vwDiscount.isHidden = true
                    self.btnCheckOut.isHidden = true
                //}
            }
            self.tblCartList.delegate = self
            self.tblCartList.dataSource = self
            self.tblCartList.reloadData()
        }
    }
    
    func placeOrder(data:[BookModel],tax:String, discount:String,delivery:String, subTotal:String, total:String, date:String,promocode:String) {
        var ref : DocumentReference? = nil
        ref = AppDelegate.shared.db.collection(bBooking).addDocument(data:
            [
              bItem: data.description,
              bTax : tax,
              bAddedDate: date,
              bSubTotal: subTotal,
              bTotal: total,
              bDelivery: delivery,
              bDiscount: discount,
              bPromoCode: promocode
              
            ])
        {  err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
                Alert.shared.showAlert(message: "Your Book Order has been Placed !!!") { (true) in
                    for data1 in data {
                        self.deleteAction(docID: data1.docId)
                    }
                    sleep(1)
                    UIApplication.shared.setTab()
                }
            }
        }
    }
    
    
    func deleteAction(docID: String){
        let ref = AppDelegate.shared.db.collection(bCart).document(docID)
        ref.delete(){ err in
            if let err = err {
                print("Error updating document: \(err)")
                self.navigationController?.popViewController(animated: true)
            } else {
                print("Document successfully deleted")
//                UIApplication.shared.setTab()
            }
        }
    }
}

