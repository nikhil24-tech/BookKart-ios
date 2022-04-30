//
//  StartVC.swift
//  BookKart


import UIKit

class StartVC: UIViewController {

    
    @IBOutlet weak var btnEmail: UIButton!
    @IBOutlet weak var btnGoogle: UIButton!
    @IBOutlet weak var btnFaceBook: UIButton!
    @IBOutlet weak var btnSignIn: UIButton!
    
    @IBAction func btnClick(_ sender: UIButton) {
        if sender == btnSignIn {
            if let vc = UIStoryboard.main.instantiateViewController(withClass: LoginVC.self) {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else {
            Alert.shared.showAlert(message: "Comming Soon", completion: nil)
        }
    }
    
    
    func applyStyle() {
        self.btnEmail.layer.cornerRadius = 16
        self.btnGoogle.layer.cornerRadius = 16
        self.btnFaceBook.layer.cornerRadius = 16
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.applyStyle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
}
