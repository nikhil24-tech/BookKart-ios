//
//  ProfileVC.swift

import UIKit

class ProfileVC: UIViewController {

    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var btnSignOut: UIButton!
    
    
    @IBAction func btnSignOutClick(_ sender: UIButton){
        UIApplication.shared.setStart()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.btnSignOut.layer.cornerRadius = 10.0
        if GFunction.user != nil {
            self.lblName.text = GFunction.user.name
            self.lblAddress.text = GFunction.user.address
            self.lblEmail.text = GFunction.user.email
        }
        // Do any additional setup after loading the view.
    }

}
