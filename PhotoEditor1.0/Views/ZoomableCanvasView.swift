
import SwiftUI


struct ZoomableCanvasView: View {
    @EnvironmentObject private var canvasVM: CanvasViewModel


    @Binding var scale: CGFloat
    @Binding var offset: CGSize
    @Binding var toolDrawShows: Bool
    
    
    @State private var currentScale: CGFloat = 1.0
    @State private var lastOffset: CGSize = .zero
    @State private var isScaling: Bool = false
    @State private var rotationAngle: CGFloat = 0
    
    //    @State private var showFilterMenu = false
    //    @State private var originalImage: UIImage? = nil
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if let image = canvasVM.image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .scaleEffect(scale * currentScale)
                        .rotationEffect(canvasVM.rotationAngle)
                        .offset(x: offset.width + lastOffset.width, y: offset.height + lastOffset.height)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    if !isScaling {
                                        lastOffset = CGSize(width: value.translation.width, height: value.translation.height)
                                    }
                                }
                                .onEnded { value in
                                    if !isScaling {
                                        offset.width += value.translation.width
                                        offset.height += value.translation.height
                                        lastOffset = .zero
                                    }
                                }
                        )
                    
                    
                    
                }
                
                CanvasView(toolPickerShows: $toolDrawShows, drawing: $canvasVM.drawing, canvasView: $canvasVM.canvasView)
                    .scaleEffect(scale * currentScale)
                    .rotationEffect(canvasVM.rotationAngle)
                    .offset(x: offset.width + lastOffset.width, y: offset.height + lastOffset.height)
                    .allowsHitTesting(!isScaling)
                if let index = canvasVM.selectedTextIndex {
                    AddText(text: $canvasVM.texts[index].text)
                }
            
                
            }
            .gesture(
                MagnificationGesture()
                    .onChanged { value in
                        isScaling = true
                        currentScale = value
                    }
                    .onEnded { value in
                        scale *= value
                        currentScale = 1.0
                        isScaling = false
                    }
            )
            .sheet(isPresented: $canvasVM.showFilterMenu) {
                FilterMenu()
            }
            .onAppear {
                canvasVM.canvasView.frame = geometry.frame(in: .local)
            }
            .onChange(of: canvasVM.image) { _ in
                canvasVM.cleanDrawing()
            }
        }
        
    }
    
    
    
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
    
    
}


