//
//  ProfileVC.swift
//  BookKart
//
//  Created by 2022M3 on 17/04/22.
//

import UIKit

class ProfileVC: UIViewController {

    
    @IBOutlet weak var btnSignOut: UIButton!
    
    
    @IBAction func btnSignOutClick(_ sender: UIButton){
        UIApplication.shared.setStart()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.btnSignOut.layer.cornerRadius = 10.0
        
        // Do any additional setup after loading the view.
    }

}
