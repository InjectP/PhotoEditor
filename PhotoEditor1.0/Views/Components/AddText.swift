
import SwiftUI

struct AddText: View {
    @EnvironmentObject private var canvasVM: CanvasViewModel
    @Binding var text: String
    var body: some View {
        ForEach(canvasVM.texts.indices, id: \.self) {index in
//            TextField("",text: $text)
            Text(canvasVM.texts[index].text)
                .font(.system(size: canvasVM.texts[index].size))
                .foregroundColor(canvasVM.texts[index].color)
                .position(canvasVM.texts[index].position)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            
                            canvasVM.texts[index].position = CGPoint(x: value.location.x, y: value.location.y)
                            if canvasVM.selectedTextIndex == index {
                                canvasVM.texts[index].color = canvasVM.textColor
                                canvasVM.texts[index].size = canvasVM.textSize
                            }
                        }
                )
                .onTapGesture {
                    
                    canvasVM.selectedTextIndex = index
                    
                    canvasVM.texts[index].size = canvasVM.textSize
                    canvasVM.texts[index].color = canvasVM.textColor
                }
        }
    }
}


//#Preview {
//    AddText()
//}
