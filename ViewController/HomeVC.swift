//
//  HomeVC.swift
//  BookKart

import UIKit

class HomeVC: UIViewController {

    
    @IBOutlet weak var colCategory: SelfSizedCollectionView!
    @IBOutlet weak var sbBar: UISearchBar!
    
    var pendingItem: DispatchWorkItem?
    var pendingRequest: DispatchWorkItem?
    var arrData = [CategoryModel]()
    var array = [CategoryModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sbBar.layer.borderWidth = 1.0
        self.sbBar.layer.borderColor = UIColor.lightGray.cgColor
        self.sbBar.layer.cornerRadius = 10.0
        self.sbBar.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getData()
    }
}

extension HomeVC: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout & UINavigationControllerDelegate, UITabBarDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.arrData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeBookCell", for: indexPath) as! HomeBookCell
        let data = self.arrData[indexPath.row]
        item.configCell(data: data)
        item.vwCell.tag = (indexPath.section * 1000) + indexPath.row
        item.vwCell.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer()
        tap.addAction {
            if let vc = UIStoryboard.main.instantiateViewController(withClass: BookDetailVC.self) {
                vc.dataCat = data
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        item.vwCell.addGestureRecognizer(tap)
        item.consWidth.constant = ((150/375) * UIScreen.main.bounds.width)
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
        
        self.vwCell.layer.borderColor = UIColor.hexStringToUIColor(hex: "#BDB9B7").cgColor
        self.vwCell.layer.borderWidth = 1.0
        self.vwCell.layer.cornerRadius = 13.0
        self.imgLogo.contentMode = .scaleAspectFit
    }
    
    func configCell(data: CategoryModel){
        self.lblTitle.text = data.name.description
//        self.imgLogo.setImgWebUrl(url: data.categoryImage, isIndicator: true)
    }
}

extension HomeVC {
    func getData(){
        _ = AppDelegate.shared.db.collection(bCategory).addSnapshotListener{ querySnapshot, error in
            
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            self.array.removeAll()
            if snapshot.documents.count != 0 {
                for data in snapshot.documents {
                    let data1 = data.data()
                    if let name: String = data1[bName] as? String, let image: String = data1[bImage] as? String {
                        print("Data Count : \(self.array.count)")
                        self.array.append(CategoryModel(docId: data.documentID, name: name, description: image))
                    }
                }
                self.arrData = self.array
                self.colCategory.delegate = self
                self.colCategory.dataSource = self
                self.colCategory.reloadData()
            }else{
                Alert.shared.showAlert(message: "No Data Found !!!", completion: nil)
            }
        }
    }

}


//MARK:- UISearchBarDelegate Delegate methods :-
extension HomeVC : UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        
        self.pendingRequest?.cancel()
        
        guard searchBar.text != nil else {
            return
        }
        
        if(searchText.count == 0 || (searchText == " ")){
            self.arrData = self.array
            self.colCategory.reloadData()
            return
        }
        
        //self.isTextEdit = true
        
        self.pendingRequest = DispatchWorkItem{ [weak self] in
            
            guard let self = self else { return }
            
            self.arrData = self.array.filter({$0.name.localizedStandardContains(searchText)})
            self.colCategory.reloadData()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300), execute: self.pendingRequest!)
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.arrData = self.array.filter({$0.name.localizedStandardContains(searchBar.text!)})
        self.colCategory.reloadData()
        self.sbBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.arrData = self.array
        self.sbBar.resignFirstResponder()
    }
}
