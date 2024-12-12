

import SwiftUI

struct FilterMenu: View {
    @EnvironmentObject private var canvasVM: CanvasViewModel
    @State private var filterPreviews: [UIImage] = []
    let previewSize: CGFloat = 100
    
    var body: some View {
        VStack {
            Text("Выберите фильтр")
            if let image = canvasVM.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .rotationEffect(canvasVM.rotationAngle)
            }
            
            Spacer()
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(filterPreviews.indices, id: \.self) { index in
                        Button(action: {
                            canvasVM.applyFilterByIndex(index)
                        }) {
                            Image(uiImage: filterPreviews[index])
                                .resizable()
                                .rotationEffect(canvasVM.rotationAngle)
                                .frame(width: previewSize, height: previewSize)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.white, lineWidth: 1)
                                        .rotationEffect(canvasVM.rotationAngle)
                                )
                                
                        }
                      
                    }
                   
                }
                .padding()
            }
            
            Button("Вернуть оригинал") {
                if let original = canvasVM.originalCopyImage {
                    canvasVM.image = original
                }
            }
            
        }
        .onAppear {
            filterPreviews = canvasVM.generateFilterPreviews()
        }
    }
    
}
