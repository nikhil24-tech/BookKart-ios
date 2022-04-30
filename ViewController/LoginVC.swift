//
//  LoginVC.swift
//  BookKart


import UIKit

class LoginVC: UIViewController {

    
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBAction func btnLogin(_ sender: UIButton) {
        if sender == btnLogin {
            let err = self.validation()
            if err == "" {
                if self.txtEmail.text == "Admin@gmail.com" && self.txtPassword.text == "Admin@123" {
                    UIApplication.shared.setAdmin()
                }else{
                    UIApplication.shared.setTab()
                }
                
            }else{
                Alert.shared.showAlert(message: err, completion: nil)
            }
        } else {
            if let vc = UIStoryboard.main.instantiateViewController(withClass: SignUpVC.self) {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func validation() -> String {
       if self.txtEmail.text?.trim() == "" {
            return "Please enter email"
        }else if self.txtPassword.text?.trim() == "" {
            return "Please enter password"
        }
        return ""
    }
    
    func applyStyle() {
        self.btnLogin.layer.cornerRadius = 16
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.applyStyle()
        // Do any additional setup after loading the view.
    }
}
