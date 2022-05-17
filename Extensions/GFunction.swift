//
//  GFunction.swift


import Foundation


class GFunction {
    
    static let shared: GFunction = GFunction()
    static var user : UserModel!
    
    //Firebase Authentication Login
    func firebaseRegister(data: String) {
        FirebaseAuth.Auth.auth().signIn(withEmail: data, password: "123123") { [weak self] authResult, error in
            guard self != nil else { return }
            //return if any error find
            if error != nil {
                FirebaseAuth.Auth.auth().createUser(withEmail: data, password: "123123") { authResult, error in
                    //Return if error find
                    if error != nil {
                        return
                    }else{
                        FirebaseAuth.Auth.auth().signIn(withEmail: data, password: "123123") { [weak self] authResult, error in
                            guard self != nil else { return }
                        }
                    }
                }
            }
        }
    }
    
    func getDate() -> String {
        let date = Date()
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date / server String
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let myString = formatter.string(from: date) // string purpose I add here
        let yourDate = formatter.date(from: myString)!  // convert your string to date
        formatter.dateFormat = "dd MMMM, yyyy"
        return formatter.string(from: yourDate)
    }
    
}

