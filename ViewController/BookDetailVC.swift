//
//  BookDetailVC.swift
//  BookKart
//
//  Created by 2022M3 on 18/04/22.
//

import UIKit

class BookDetailVC: UIViewController {

    @IBOutlet weak var tblFavList: UITableView!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var btnSorting: UIButton!
    
    
    @IBAction func setSorting(_ sender: UIButton) {
        self.setPopUp()
    }
    
    private func setPopUp(){
        
      
        let actionSheet = UIAlertController(title: "Sorting", message: "", preferredStyle: .actionSheet)
        
        let highToLow = UIAlertAction(title: "Price:High to Low", style: .default, handler: {
            (alert: UIAlertAction) -> Void in
            
            self.btnSorting.setTitle("High to Low", for: .normal)

        })
        
        let lowToHigh = UIAlertAction(title: "Price:Low to High", style: .default, handler: { [self]
            (alert: UIAlertAction) -> Void in
            self.btnSorting.setTitle("Low to High", for: .normal)
          
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction) -> Void in
            self.btnSorting.setTitle("Sorting", for: .normal)
        })
        
        if let popoverController = actionSheet.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        actionSheet.addAction(highToLow)
        actionSheet.addAction(lowToHigh)
        actionSheet.addAction(cancelAction)
        
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tblFavList.delegate = self
        self.tblFavList.dataSource = self
        self.btnSorting.layer.cornerRadius = 10.0
        self.txtSearch.layer.borderWidth = 1.0
        self.txtSearch.layer.borderColor = UIColor.lightGray.cgColor
        self.txtSearch.layer.cornerRadius = 10.0
        // Do any additional setup after loading the view.
    }
}


extension BookDetailVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath) as! BookCell
        
        cell.selectionStyle = .none
        return cell
    }
}
