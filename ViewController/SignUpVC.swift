//
//  SignUpVC.swift
//  BookKart

import UIKit

class SignUpVC: UIViewController {

    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    
    @IBAction func btnSignUpClick(_ sender: UIButton) {
        if sender == btnLogin {
            if let vc  = UIStoryboard.main.instantiateViewController(withClass: LoginVC.self) {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else if sender == btnSignUp {
            let err = self.validation()
            if err == "" {
                UIApplication.shared.setTab()
            }else{
                Alert.shared.showAlert(message: err, completion: nil)
            }
        }
    }
    
    func applyStyle(){
        self.btnSignUp.layer.cornerRadius = 16
    }
    
    
    func validation() -> String {
        if self.txtName.text?.trim() == "" {
            return "Please enter name"
        }else if self.txtEmail.text?.trim() == "" {
            return "Please enter email"
        }else if self.txtPhone.text?.trim() == "" {
            return "Please enter phone number"
        }else if self.txtPhone.text?.trim().count ?? 0 < 10 {
            return "Please enter 10 digit phone number"
        }else if self.txtAddress.text?.trim() == "" {
            return "Please enter address"
        }else if self.txtPassword.text?.trim() == "" {
            return "Please enter password"
        }else if self.txtConfirmPassword.text?.trim() == "" {
            return "Please enter confirm password"
        }else if self.txtPassword.text != self.txtConfirmPassword.text {
            return "Password mismatched"
        }
        return ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.applyStyle()
        // Do any additional setup after loading the view.
    }

   
}
