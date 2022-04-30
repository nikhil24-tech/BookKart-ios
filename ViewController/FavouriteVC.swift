//
//  FavouriteVC.swift
//  BookKart


import UIKit

class FavouriteVC: UIViewController {

    
    @IBOutlet weak var tblFavList: UITableView!
    @IBOutlet weak var txtSearch: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tblFavList.delegate = self
        self.tblFavList.dataSource = self
        self.txtSearch.layer.borderWidth = 1.0
        self.txtSearch.layer.borderColor = UIColor.lightGray.cgColor
        self.txtSearch.layer.cornerRadius = 10.0
        // Do any additional setup after loading the view.
    }
}


extension FavouriteVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath) as! BookCell
        
        cell.selectionStyle = .none
        return cell
    }
}



class BookCell: UITableViewCell {
    @IBOutlet weak var vwCell: UIView!
    @IBOutlet weak var imgBook: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var btnFav: UIButton!
    @IBOutlet weak var btnAdd: UIButton!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.vwCell.layer.cornerRadius = 10.0
        self.vwCell.layer.borderWidth = 1.0
        self.vwCell.layer.borderColor = UIColor.lightGray.cgColor
        self.vwCell.backgroundColor = .clear
        self.btnAdd.layer.cornerRadius = 10.0
    }
}
