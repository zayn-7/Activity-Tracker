//
//  User.swift
//  Activity Tracker
//
//  Created by Zayn on 28/02/25.
//

import Foundation


struct User: Codable , Identifiable{
    let id: String
    let fullName: String
    let email: String
    
    var initial: String {
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: fullName) {
            formatter.style = .abbreviated
            return formatter.string(from: components)
        }
        return ""
    }
}


extension User {
    static var MOCK_USER: User {
        User(id: NSUUID().uuidString, fullName: "Zayn Malik", email: "zayn@example.com")
    }
}

struct UserSession {
    let id: String
    let token: String
}
