

import SwiftUI

struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    
    var body: some View {
        Group {
            if isSecure {
                SecureField(placeholder, text: $text)
            } else {
                TextField(placeholder, text: $text)
            }
        }
        .cornerRadius(12)
        .autocapitalization(.none)
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .shadow(color: .black, radius: 2, x: 0, y: 1)

    }
}


struct testText: View {
    @State var text: String = ""
    
    var body: some View {
        CustomTextField(placeholder: "Password", text: $text)
    }
}

#Preview {
    testText()
}
