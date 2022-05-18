//
//  BookModel.swift


import Foundation
class BookModel {
    
    var name:String
    var category: String
    var docId: String
    var price: String
    var addedDate: String
    
    init(docId:String, name:String, category:String, price: String, addedDate:String) {
        self.docId = docId
        self.name = name
        self.category = category
        self.price = price
        self.addedDate = addedDate
    }
}
