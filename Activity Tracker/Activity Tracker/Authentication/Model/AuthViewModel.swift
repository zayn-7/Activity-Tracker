//
//  AuthViewModel.swift
//  Activity Tracker
//
//  Created by Zayn on 28/02/25.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
import SwiftUI


class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    
    // initilizer
    init () {
        self.userSession = Auth.auth().currentUser
        Task {
            await fetchUser()
        }
    }
    
    //sign in
    func signIn(email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            
            await fetchUser()
            print("Successfully signed in")
        } catch {
            print("Error signing in: \(error.localizedDescription)")
            throw error
        }
    }
    
    //sign up
    func createUser(withEmail email: String, password: String, fullName: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(id: result.user.uid, fullName: fullName, email: email)
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            self.userSession = result.user
            
            await fetchUser()
        } catch {
            print("Failed to create user: \(error.localizedDescription)")
        }
    }
    
    //sign out
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.userSession = nil
              
        } catch {
            print("Signed out failed")
        }
    }
    
    
    //fetch user
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else { return }
        DispatchQueue.main.async {
            self.currentUser = try? snapshot.data(as: User.self)
        }
    }
}
