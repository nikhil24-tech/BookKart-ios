//
//  AddBookVC.swift
//  BookKart


import UIKit

class AddBookVC: UIViewController {

    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtCategory: UITextField!
    @IBOutlet weak var txtPrice: UITextField!
    @IBOutlet weak var btnAddBook: UIButton!
    
    
    @IBAction func btnAddBookClick(_ sender: UIButton) {
        if sender == btnAddBook {
            self.navigationController?.popViewController(animated: true)
        }else {
            UIApplication.shared.setStart()
        }
        
    }
    
    
    func applyStyle() {
        self.btnAddBook.layer.cornerRadius = 10.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.applyStyle()
    }
   
}
