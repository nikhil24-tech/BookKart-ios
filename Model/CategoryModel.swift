//
//  CategoryModel.swift


import Foundation
class CategoryModel {
    
    var name:String
    var image: String
    var docId: String
    
    init(docId:String, name:String, description:String) {
        self.docId = docId
        self.name = name
        self.image = description
    }
}
