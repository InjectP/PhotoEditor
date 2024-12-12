import SwiftUI

struct CustomToolBar: View {
    @State private var lineThickness: CGFloat = 2.0
    
    var body: some View {
        VStack {

            ZStack {
                Rectangle()
                    .fill(Color.toolPanel)
                    .frame(maxWidth: .infinity, maxHeight: 70)
                    .overlay(
                        Rectangle()
                            .frame(height: lineThickness)
                            .foregroundColor(.gray), alignment: .bottom)
            }
        }
    }
}

struct ContentView: View {
    var body: some View {
        CustomToolBar()
    }
}


#Preview{
    ZStack {
        Color.black.opacity(0.3)
            .ignoresSafeArea()
        ContentView()
    }
 
}
