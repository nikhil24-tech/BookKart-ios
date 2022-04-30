//
//  HomeVC.swift
//  BookKart

import UIKit

class HomeVC: UIViewController {

    
    @IBOutlet weak var colCategory: SelfSizedCollectionView!
    @IBOutlet weak var txtSearch: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.colCategory.delegate = self
        self.colCategory.dataSource = self
        self.txtSearch.layer.borderWidth = 1.0
        self.txtSearch.layer.borderColor = UIColor.lightGray.cgColor
        self.txtSearch.layer.cornerRadius = 10.0
        // Do any additional setup after loading the view.
    }
}

extension HomeVC: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout & UINavigationControllerDelegate, UITabBarDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeBookCell", for: indexPath) as! HomeBookCell
        //let data = self.viewModel.getData(index: indexPath.row)
        //item.configCell(data: data)
        item.vwCell.tag = (indexPath.section * 1000) + indexPath.row
        item.vwCell.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer()
        tap.addAction {
            if let vc = UIStoryboard.main.instantiateViewController(withClass: BookDetailVC.self) {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        item.vwCell.addGestureRecognizer(tap)
        item.consWidth.constant = ((150/375) * UIScreen.main.bounds.width)
//        item.vwCell.addGestureRecognizer(tap)
        return item
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ((UIScreen.main.bounds.width - 50) / 2), height: ((122/812) * self.view.frame.height))
    }

}



class HomeBookCell : UICollectionViewCell{
    
    //MARK:- Outlets
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var vwCell: UIView!
    @IBOutlet weak var consWidth: NSLayoutConstraint!
    
    //MARK:- Class Variables
    
    //MARK:- Custom Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        self.applyStyle()
    }
    
    private func applyStyle(){
//        self.lblTitle.font(name: .medium, size: 14).textColor(color: .purple)
//        self.vwCell.cornerRadius(cornerRadius: 8.0, clips: true).borderColor(color: UIColor.lightGrey.withAlphaComponent(0.15), borderWidth: 1.0)
        self.vwCell.layer.borderColor = UIColor.hexStringToUIColor(hex: "#BDB9B7").cgColor
        self.vwCell.layer.borderWidth = 1.0
        self.vwCell.layer.cornerRadius = 13.0
        self.imgLogo.contentMode = .scaleAspectFit
    }
    
//    func configCell(data: CategoryModel){
//        self.lblTitle.text = data.categoryName.description
//        self.imgLogo.setImgWebUrl(url: data.categoryImage, isIndicator: true)
//    }
}
