

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift

struct LogInView: View {
    @EnvironmentObject private var vm: AuthViewModel

    @State private var showAlert: Bool = false
    @State private var PassResetPresented: Bool = false
    
    var body: some View {
        
        NavigationView {
            ZStack {
                Color.bg.ignoresSafeArea()
         
                hearder()
                
                VStack(spacing: 30) {
                    authForms()
                    
                    actionButtons()
                        .padding(.top)
                }
                .padding()
                
                if vm.isRequestInProgress {
                    progressLoader()
                }
                
                if PassResetPresented {
                        PassResetView(isPresented: $PassResetPresented)
                }
                
                NavigationLink(destination: PhotoEditorVIew().navigationBarBackButtonHidden(), isActive: $vm.isAuthenticated) {
                    EmptyView()
                }
                
            }
            .disabled(vm.isRequestInProgress)
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text(vm.errorMessage ?? ""),
                    dismissButton: .default(Text("OK")) {
                        vm.errorMessage = nil
                    }
                )
            }
            .onAppear{
                vm.checkAuth()
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Login")
                        .font(.headline)
                        .foregroundColor(.white)
                }
            }
        }      .navigationViewStyle(StackNavigationViewStyle())
  
        
        
          
    }
    
    @ViewBuilder func hearder() -> some View {
        VStack {
            Rectangle()
                .fill(Color.blueHeader)
                .frame(maxWidth: .infinity,maxHeight: 120)
            Spacer()
        }
        .ignoresSafeArea()
    }
    
    
    @ViewBuilder func authForms() -> some View {
        CustomTextField(placeholder: "Email", text: $vm.email)
        CustomTextField(placeholder: "Password", text: $vm.password, isSecure: true)
    }
    
    @ViewBuilder func actionButtons() -> some View {
        HStack {
            Button("Sign Up") {
                Task {
                    await vm.register(email: vm.email, password: vm.password)
                    checkErrorMessage()
                }
            }
            Spacer()
            Button("Forgot Password?") {
                    PassResetPresented = true
            }
            
        }
        
        Button("Login") {
            Task {
                await vm.login(email: vm.email, password: vm.password)
                checkErrorMessage()
            }
            
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.gray, lineWidth: 2)
                .shadow(radius: 2)
        )
        
        GoogleSignInButton(viewModel: GoogleSignInButtonViewModel(scheme: .dark, style: .wide, state: .normal)) {
            Task {
                do {
                    try await vm.signInGoogle()
                    vm.isAuthenticated = true
                    vm.isVerified = true
                } catch {
                    checkErrorMessage()
                }
            }
        }
            .padding(.horizontal)
        
    }
    
    @ViewBuilder func progressLoader() -> some View {
        ZStack {
            Color.black.opacity(0.2)
            ProgressView()
                .tint(.blueHeader)
                .scaleEffect(2)
        }
        .ignoresSafeArea()
    }
    
    private func checkErrorMessage() {
        if vm.errorMessage != nil {
            showAlert = true
        }
    }
    
    
    
}//View

#Preview {
    NavigationView {
        LogInView()
    }
    .environmentObject(AuthViewModel())
}
