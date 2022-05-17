//
//  StartVC.swift
//  BookKart


import UIKit

class StartVC: UIViewController {

    
    @IBOutlet weak var btnEmail: UIButton!
    @IBOutlet weak var btnGoogle: UIButton!
    @IBOutlet weak var btnFaceBook: UIButton!
    @IBOutlet weak var btnSignIn: UIButton!
    
    
    
    private let socialLoginManager: SocialLoginManager = SocialLoginManager()
    
    
    @IBAction func btnClick(_ sender: UIButton) {
        if sender == btnSignIn {
            if let vc = UIStoryboard.main.instantiateViewController(withClass: LoginVC.self) {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else if sender == btnGoogle {
            self.socialLoginManager.performGoogleLogin(vc: self)
        }
    }
    
    
    func applyStyle() {
        self.btnFaceBook.isHidden = true
        self.btnEmail.layer.cornerRadius = 16
        self.btnGoogle.layer.cornerRadius = 16
        self.btnFaceBook.layer.cornerRadius = 16
        self.socialLoginManager.delegate = self
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


extension StartVC: SocialLoginDelegate {

    func socialLoginData(data: SocialLoginDataModel) {
        print("Social Id==>", data.socialId ?? "")
        print("First Name==>", data.firstName ?? "")
        print("Last Name==>", data.lastName ?? "")
        print("Email==>", data.email ?? "")
        print("Login type==>", data.loginType ?? "")
        self.loginUser(email: data.email, password: data.socialId,data: data)
    }

    func loginUser(email:String,password:String,data: SocialLoginDataModel) {
        
        _ = AppDelegate.shared.db.collection(bUser).whereField(bEmail, isEqualTo: email).addSnapshotListener{ querySnapshot, error in
            
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            
            if snapshot.documents.count != 0 {
                if let vc = UIStoryboard.main.instantiateViewController(withClass:  LoginVC.self) {
                    vc.socialData = data
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }else{
                if let vc = UIStoryboard.main.instantiateViewController(withClass:  SignUpVC.self) {
                    vc.socialData = data
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
        
    }
}
