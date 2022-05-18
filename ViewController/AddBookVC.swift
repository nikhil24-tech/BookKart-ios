//
//  AddBookVC.swift
//  BookKart


import UIKit

class AddBookVC: UIViewController {

    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtCategory: UITextField!
    @IBOutlet weak var txtPrice: UITextField!
    @IBOutlet weak var btnAddBook: UIButton!
    
    
    var array = [CategoryModel]()
    let picker = UIPickerView()
    var data : CategoryModel!
    
    @IBAction func btnAddBookClick(_ sender: UIButton) {
        if sender == btnAddBook {
            let addedDate = GFunction.shared.getDate()
            let error = self.validation()
            if error == "" {
                self.addBook(category: self.txtCategory.text ?? "", name: self.txtName.text ?? "", addedDate: addedDate, price: self.txtPrice.text ?? "")
            }else{
                Alert.shared.showAlert(message: error, completion: nil)
            }
        }else {
            UIApplication.shared.setStart()
        }
        
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
    
    func applyStyle() {
        self.btnAddBook.layer.cornerRadius = 10.0
        //picker
        self.getData()
        picker.delegate = self
        picker.dataSource = self
        self.txtCategory.inputView = picker
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.applyStyle()
    }
   
}


extension AddBookVC {
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
            self.data = self.array[0]
            self.picker.delegate = self
            self.picker.dataSource = self
            self.picker.reloadAllComponents()
        }
    }
    
    func addBook(category: String, name:String, addedDate: String, price:String) {
        var ref : DocumentReference? = nil
        ref = AppDelegate.shared.db.collection(bBook).addDocument(data:
            [
              bName: name,
              bCategory : category,
              bAddedDate: addedDate,
              bPrice: price,
              bCategoryID: self.data.docId
            ])
        {  err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
                Alert.shared.showAlert(message: "Your Book Has been Added") { (true) in
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
}

extension AddBookVC: UIPickerViewDelegate,UIPickerViewDataSource {
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
        self.data = self.array[row]
        self.txtCategory.text = self.array[row].name
//        self.data = self.array[row]
    }
}
