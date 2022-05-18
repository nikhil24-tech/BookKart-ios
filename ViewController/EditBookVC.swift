//
//  EditBookVC.swift
//  BookKart


import UIKit

class EditBookVC: UIViewController {

    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtCategory: UITextField!
    @IBOutlet weak var txtPrice: UITextField!
    @IBOutlet weak var btnAddBook: UIButton!
    
    
    var data: BookModel!
    var array = [CategoryModel]()
    let picker = UIPickerView()
    var dataCategory : CategoryModel!
    
    
    @IBAction func btnAddBookClick(_ sender: UIButton) {
        if sender == btnAddBook {
            let error = self.validation()
            if error == "" {
                self.updateBook(docID: data.docId, category: self.txtCategory.text ?? "", name: self.txtName.text ?? "", price: self.txtPrice.text ?? "")
            }else{
                Alert.shared.showAlert(message: error, completion: nil)
            }
        }else{
            UIApplication.shared.setStart()
        }
    }
    
    
    func applyStyle() {
        self.btnAddBook.layer.cornerRadius = 10.0
        picker.delegate = self
        picker.dataSource = self
        self.txtCategory.inputView = picker
    }
    
    
    func validation() -> String {
        if self.txtName.text?.trim() == "" {
            return "Please enter book name"
        }else if self.txtCategory.text?.trim() == "" {
            return "Please select category"
        }else if self.txtPrice.text?.trim() == "" {
            return "Please enter price"
        }
        
        return ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.applyStyle()
        
        if self.data != nil {
            self.txtName.text = data.name.description
            self.txtPrice.text = data.price.description
            self.txtCategory.text = data.category.description
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getData()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    func updateBook(docID: String,category: String, name:String, price:String) {
        let ref = AppDelegate.shared.db.collection(bBook).document(docID)
        ref.updateData([
            bCategory : category,
            bName: name,
            bPrice: price
        ]){ err in
            if let err = err {
                print("Error updating document: \(err)")
                self.navigationController?.popViewController(animated: true)
            } else {
                print("Document successfully updated")
                Alert.shared.showAlert(message: "Your Book has been updated successfully !!!") { (true) in
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    func getData(){
        _ = AppDelegate.shared.db.collection(bCategory).addSnapshotListener{ querySnapshot, error in
            
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            self.array.removeAll()
            if snapshot.documents.count != 0 {
                for data in snapshot.documents {
                    let data1 = data.data()
                    if let name: String = data1[bName] as? String, let image: String = data1[bImage] as? String {
                        print("Data Count : \(self.array.count)")
                        self.array.append(CategoryModel(docId: data.documentID, name: name, description: image))
                    }
                }
            }
            self.dataCategory = self.array[0]
            self.picker.delegate = self
            self.picker.dataSource = self
            self.picker.reloadAllComponents()
        }
    }

}

extension EditBookVC: UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.array.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.array[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.dataCategory = self.array[row]
        self.txtCategory.text = self.array[row].name
//        self.data = self.array[row]
    }
}
