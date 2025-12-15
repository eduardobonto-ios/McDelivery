//
//  AuthViewModel.swift
//  McdDelivery
//
//  Created by Mac on 2025-12-15.
//

import Foundation
import FirebaseAuth
internal import Combine

@MainActor
class AuthViewModel: ObservableObject {

    @Published var user: User?
    @Published var errorMessage: String?
    @Published var isLoading = false

    init() {
        user = Auth.auth().currentUser
    }

    // MARK: - Email Login
    func signIn(email: String, password: String) async -> Bool {
        isLoading = true
        defer { isLoading = false }

        do {
            let result = try await Auth.auth().signIn(
                withEmail: email,
                password: password
            )
            user = result.user
            return true
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
    }

    // MARK: - Email Signup
    func signUp(email: String, password: String) async -> Bool {
        isLoading = true
        defer { isLoading = false }

        do {
            let result = try await Auth.auth().createUser(
                withEmail: email,
                password: password
            )
            user = result.user
            return true
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
    }

    // MARK: - Guest Login
    func signInAnonymously() async -> Bool {
        isLoading = true
        defer { isLoading = false }

        do {
            let result = try await Auth.auth().signInAnonymously()
            user = result.user
            return true
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
    }

    // MARK: - Logout
    func signOut() {
        try? Auth.auth().signOut()
        user = nil
    }
}
