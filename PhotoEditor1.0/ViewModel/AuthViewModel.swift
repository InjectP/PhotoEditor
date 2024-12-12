

import SwiftUI
import FirebaseAuth
//import GoogleSignInSwift
import GoogleSignIn

@MainActor
final class AuthViewModel: ObservableObject {
    @Published var gameId = UUID()
    func reset() {
        gameId = UUID()
      }
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String?
    
    @Published var isRequestInProgress = false
    @Published var isAuthenticated = false
    @Published var isVerified = false
    
    
    
    //MARK: Register
    func register(email: String, password: String) async {
        guard !email.isEmpty, !password.isEmpty else { self.errorMessage = "Please fill in all fields"; return }
        guard !isRequestInProgress else { return }
        self.isRequestInProgress = true
        
        do {
            try await AuthService.shared.registerUser(email: email, password: password)
            self.errorMessage = "Verification email sent. Please check your inbox."
        } catch let error as NSError{
            self.errorMessage = AuthErrorHand().AuthErrorHandler(error)
        }
        self.isRequestInProgress = false
    }
    
    //MARK: SignIn
    func login(email: String, password: String) async {
        guard !email.isEmpty, !password.isEmpty else { self.errorMessage = "Please fill in all fields"; return }
        guard !isRequestInProgress else { return }
        self.isRequestInProgress = true
        
        do {
            let user = try await AuthService.shared.loginUser(email: email, password: password)
            await self.checkVerification(user: user)
          
        } catch let error as NSError {
            self.errorMessage = AuthErrorHand().AuthErrorHandler(error)
        }
        self.isRequestInProgress = false
    }
    
    //MARK: SignOut
    func signOut() {
        try? AuthService.shared.auth.signOut()
        self.isAuthenticated = false
    }
    
    
    //MARK: Update Params
    func updateParams() {
        self.email = ""
        self.password = ""
        self.errorMessage = nil
    }
    
    //MARK: Reset Password
    func sendResetPassword(email: String) async {
        guard !email.isEmpty else { self.errorMessage = "Enter email"; return }
        guard !isRequestInProgress else { return }
        self.isRequestInProgress = true
        do {
            try await AuthService.shared.resetPassword(email: email)
            self.errorMessage = "Password reset email sent successfully. Please check your inbox."
        } catch let error as NSError {
            self.errorMessage = AuthErrorHand().AuthErrorHandler(error)
        }
        self.isRequestInProgress = false
    }
    
    //MARK: Check Verification
    private func checkVerification(user: User) async {
        let isVerified = await AuthService.shared.checkEmailVerification()
        if isVerified {
            self.isAuthenticated = true
            self.isVerified = true
        } else {
            self.isAuthenticated = false
            self.errorMessage = "Please verify your email."
            
        }
    }
    
    //MARK: SignIn With Google
    func signInGoogle() async throws  {
        guard let topVC = TopViewControllerFinder.shared.topViewController() else { throw URLError(.cannotFindHost) }
        
        let gidSignInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: topVC)
        
        guard let idToken = gidSignInResult.user.idToken?.tokenString else  {
            throw URLError(.badServerResponse)
        }
        
        let accessToken: String = gidSignInResult.user.accessToken.tokenString
        
        let tokens =  GoogleSignInResultModel(idToken: idToken, accessToken: accessToken)
        try await AuthService.shared.signInWithGoogle(tokens: tokens)
    }
    
    //MARK: Check Auth
     func checkAuth() {
        let authUser = AuthService.shared.checkIfUserIsAuthenticated()
        self.isAuthenticated = authUser != nil
        print(self.isAuthenticated)
    }

    
}

