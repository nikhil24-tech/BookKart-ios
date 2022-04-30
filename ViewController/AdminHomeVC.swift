//
//  AdminHomeVC.swift
//  BookKart

import UIKit

class AdminHomeVC: UIViewController {

    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var btnLogout: UIButton!
    @IBOutlet weak var tblBookList: UITableView!
    
    
    
    @IBAction func btnClick(_ sender: UIButton) {
        if sender == btnAdd {
            if let vc = UIStoryboard.main.instantiateViewController(withClass: AddBookVC.self) {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else if sender == btnLogout {
            UIApplication.shared.setStart()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblBookList.delegate = self
        self.tblBookList.dataSource  = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }

}


extension AdminHomeVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AdminBookCell", for: indexPath) as! AdminBookCell
        cell.selectionStyle = .none
        
        cell.btnAdd.addAction(for: .touchUpInside) {
            if let vc = UIStoryboard.main.instantiateViewController(withClass: EditBookVC.self) {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        return cell
    }
}


class AdminBookCell: UITableViewCell {
    @IBOutlet weak var vwCell: UIView!
    @IBOutlet weak var imgBook: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.vwCell.layer.cornerRadius = 10.0
        self.vwCell.layer.borderWidth = 1.0
        self.vwCell.layer.borderColor = UIColor.lightGray.cgColor
        self.vwCell.backgroundColor = .clear
        self.btnAdd.layer.cornerRadius = 10.0
        self.btnDelete.layer.cornerRadius = 10.0
    }
}
