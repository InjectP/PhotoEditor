

import SwiftUI

struct PassResetView: View {
    @EnvironmentObject private var vm: AuthViewModel
    @State private var emailForReset: String = ""
    @State private var shakeOffset: CGFloat = 0
    @Binding var isPresented: Bool
    var body: some View {
        ZStack {
            Color.black.opacity(0.5).ignoresSafeArea()
            
            VStack {
                Text("Enter your email to reset password")
                    .padding()
                
                CustomTextField(placeholder: "Email", text: $emailForReset)
                    .padding(.horizontal)
                
                if let errorMessage = vm.errorMessage {
                    Text(errorMessage)
                        .foregroundStyle(.red)
                        .padding(.horizontal, 8)
                }
                
                Button("Send Reset Email") {
                    Task {
                        vm.email = emailForReset
                        await vm.sendResetPassword(email: vm.email)
                        
                        if vm.errorMessage != nil {
                            withAnimation {
                                shakeOffset = 10
                            }
                            shakeOffset = 0
                        }
                    }
                }
                
                .padding()
                
                Button("Close") {

                    vm.updateParams()
                    isPresented = false
                }
                .padding()
            }
            .background(Color.white)
            .cornerRadius(12)
            .shadow(radius: 20)
            .padding()
            .offset(x: shakeOffset)
            .animation(
                .default.repeatCount(vm.errorMessage != nil ? 3 : 0, autoreverses: true),
                value: shakeOffset
            )
        }
    }

}

#Preview {
    PassResetView(isPresented: .constant(false))
        .environmentObject(AuthViewModel())
}
