

import PencilKit
import SwiftUI
import Combine


struct CanvasView: UIViewRepresentable {
    
    @Binding var toolPickerShows: Bool
    @Binding var drawing: PKDrawing
    
    @Binding var canvasView: PKCanvasView
    
    private let toolPicker = PKToolPicker()
    
    
    func makeUIView(context: Context) -> PKCanvasView {
        self.canvasView.isOpaque = false
        canvasView.delegate = context.coordinator
        canvasView.drawingPolicy = .anyInput
        toolPicker.setVisible(toolPickerShows, forFirstResponder: canvasView)
        toolPicker.addObserver(canvasView)

        if toolPickerShows {
            canvasView.becomeFirstResponder()
        }
        
        return canvasView
    }
    
    func updateUIView(_ canvasView: PKCanvasView, context: Context) {

        toolPicker.setVisible(toolPickerShows, forFirstResponder: canvasView)
        toolPicker.addObserver(canvasView)
        if toolPickerShows {
            canvasView.becomeFirstResponder()
        } else {
            canvasView.resignFirstResponder()
        }
        
        if drawing != canvasView.drawing {
                 canvasView.drawing = drawing
             }
  
   
              
    }
    
    class Coordinator: NSObject, PKCanvasViewDelegate {
        var drawing: Binding<PKDrawing>
        
        init(drawing: Binding<PKDrawing>) {
            self.drawing = drawing
        }
        
        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            DispatchQueue.main.async {
                self.drawing.wrappedValue = canvasView.drawing
            }
            
            
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(drawing: $drawing)
    }
       
       
}



