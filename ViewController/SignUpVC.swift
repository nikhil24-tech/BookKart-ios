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
    
    
    var flag: Bool = true
    var socialData: SocialLoginDataModel!
    
    @IBAction func btnSignUpClick(_ sender: UIButton) {
        if sender == btnLogin {
            if let vc  = UIStoryboard.main.instantiateViewController(withClass: LoginVC.self) {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else if sender == btnSignUp {
            let err = self.validation()
            if err == "" {
                self.getExistingUser(email: self.txtEmail.text ?? "", phone: self.txtPhone.text ?? "", name: self.txtName.text ?? "", password: self.txtPassword.text ?? "", address: self.txtAddress.text ?? "")
            }else{
                Alert.shared.showAlert(message: err, completion: nil)
            }
        }
    }
    
    func applyStyle(){
        self.btnSignUp.layer.cornerRadius = 16
        
        if socialData != nil {
            self.txtName.text = socialData.firstName
            self.txtEmail.text = socialData.email
            self.txtEmail.isUserInteractionEnabled = false
            self.txtPhone.isUserInteractionEnabled = true
            self.txtAddress.isUserInteractionEnabled = true
            self.txtPassword.isUserInteractionEnabled = true
            self.txtConfirmPassword.isUserInteractionEnabled = true
        }
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


//MARK:- Extension for Login Function
extension SignUpVC {

    func createAccount(email: String, phone:String, name:String, password:String,address: String) {
        var ref : DocumentReference? = nil
        ref = AppDelegate.shared.db.collection(bUser).addDocument(data:
            [
              bPhone: phone,
              bEmail: email,
              bName: name,
              bPassword : password,
              bAddress: address,
            ])
        {  err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
                GFunction.shared.firebaseRegister(data: email)
                
                GFunction.user = UserModel(docId: (ref?.documentID.description)!, name: name, email: email, phone: phone, password: password, address: address)
                UIApplication.shared.setTab()
                self.flag = true
            }
        }
    }

    func getExistingUser(email: String, phone:String, name:String, password:String,address:String) {

        _ = AppDelegate.shared.db.collection(bUser).whereField(bEmail, isEqualTo: email).addSnapshotListener{ querySnapshot, error in

            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }

            if snapshot.documents.count == 0 {
                self.createAccount(email: email, phone:phone, name:name, password:password, address: address)
                self.flag = true
            }else{
                if !self.flag {
                    Alert.shared.showAlert(message: "Email is already exist !!!", completion: nil)
                    self.flag = true
                }
            }
        }
    }
}
