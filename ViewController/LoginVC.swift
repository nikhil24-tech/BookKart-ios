//
//  LoginVC.swift
//  BookKart


import UIKit

class LoginVC: UIViewController {

    
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    
    var flag: Bool = true
    var socialData: SocialLoginDataModel!
    
    @IBAction func btnLogin(_ sender: UIButton) {
        if sender == btnLogin {
            let err = self.validation()
            if err == "" {
                if self.txtEmail.text == "Admin@gmail.com" && self.txtPassword.text == "Admin@123" {
                    UIApplication.shared.setAdmin()
                }else{
                    self.loginUser(email: self.txtEmail.text ?? "", password: self.txtPassword.text ?? "")
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
    
        if socialData != nil {
            self.txtEmail.text = socialData.email
            self.txtEmail.isUserInteractionEnabled = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.applyStyle()
        // Do any additional setup after loading the view.
    }
}


//MARK:- Extension for Login Function
extension LoginVC {
    func loginUser(email:String,password:String) {
        
        _ = AppDelegate.shared.db.collection(bUser).whereField(bEmail, isEqualTo: email).whereField(bPassword, isEqualTo: password).addSnapshotListener{ querySnapshot, error in
            
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            
            if snapshot.documents.count != 0 {
                let data1 = snapshot.documents[0].data()
                let docId = snapshot.documents[0].documentID
                if let address : String = data1[bAddress] as? String, let name: String = data1[bName] as? String, let phone: String = data1[bPhone] as? String, let email: String = data1[bEmail] as? String, let password: String = data1[bPassword] as? String {
                    GFunction.user = UserModel(docId: docId, name: name, email: email, phone: phone, password: password, address: address)
                }
                GFunction.shared.firebaseRegister(data: email)
                UIApplication.shared.setTab()
                
            }else{
                if !self.flag {
                    Alert.shared.showAlert(message: "Please check your credentials !!!", completion: nil)
                    self.flag = true
                }
            }
        }
        
    }
}
