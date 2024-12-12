

import FirebaseAuth



final class AuthService {
    static let shared = AuthService(); private init() {}
    
    let auth = Auth.auth()
    
 
    //MARK: Get Authenticated User
    func checkIfUserIsAuthenticated() -> FirebaseAuth.User? {
        return auth.currentUser
    }
     
    //MARK: Register
    func registerUser(email: String, password: String) async throws {
        do {
            let result = try await auth.createUser(withEmail: email, password: password)
            try await sendVerificationEmail(user: result.user)
        } catch {
            throw error
        }
    }
    
    //MARK: SignIn
    func loginUser(email: String, password: String) async throws -> User {
        let result = try await auth.signIn(withEmail: email, password: password).user
        return result
    }
    
    //MARK: SignOut
    func signOut() {
        try? auth.signOut()
    }
    
    //MARK: Reset Password
    func resetPassword(email: String) async throws {
        do {
            try await Auth.auth().sendPasswordReset(withEmail: email)
        } catch {
            throw error
        }
    }
    
    //MARK: Send Verification Letter
    private func sendVerificationEmail(user: User) async throws {
            try await user.sendEmailVerification()
    }
    
    
    //MARK: Check Verification
    func checkEmailVerification() async -> Bool {
        guard let user = auth.currentUser else { return false }
        do {
            try await user.reload()
            return user.isEmailVerified
        } catch {
            return false
        }
    }
    
    //MARK: SignIn With Google
    @discardableResult
    func signInWithGoogle(tokens: GoogleSignInResultModel) async throws -> User {
        let credential = GoogleAuthProvider.credential(withIDToken: tokens.idToken,
                                                       accessToken: tokens.accessToken)
        let result = try await auth.signIn(with: credential).user
        
        return result
    }
    
    
}

//extension AuthService {
//    
//    @discardableResult
//    func signInWithGoogle(tokens: GoogleSignInResultModel) async throws -> User {
//        let credential = GoogleAuthProvider.credential(withIDToken: tokens.idToken,
//                                                       accessToken: tokens.accessToken)
//        let result = try await auth.signIn(credential: credential)
//    }
    
    
//    func signIn(credential: AuthCredential) async throws -> User {
//        let result = try await auth.signIn(with: credential).user
//        return result
//    }
//}








