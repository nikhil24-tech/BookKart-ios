//
//  CartVC.swift
//  BookKart
//
//  Created by 2022M3 on 18/04/22.
//

import UIKit

class CartVC: UIViewController {

    @IBOutlet weak var tblCartList: SelfSizedTableView!
    @IBOutlet weak var txtPromocode: UITextField!
    @IBOutlet weak var btnApply: UIButton!
    @IBOutlet weak var btnCheckOut: UIButton!
    
    
    
    func applyStyle(){
        self.btnCheckOut.layer.cornerRadius = 10.0
        self.btnApply.layer.cornerRadius = 8.0
        self.tblCartList.delegate = self
        self.tblCartList.dataSource = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.applyStyle()
        // Do any additional setup after loading the view.
    }

}


extension CartVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AdminBookCell", for: indexPath) as! AdminBookCell
        cell.selectionStyle = .none
        
        cell.btnAdd.addAction(for: .touchUpInside) {
//            if let vc = UIStoryboard.main.instantiateViewController(withClass: EditBookVC.self) {
//                self.navigationController?.pushViewController(vc, animated: true)
//            }
        }
        return cell
    }
}
