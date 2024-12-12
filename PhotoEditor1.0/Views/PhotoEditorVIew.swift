

import SwiftUI
import PencilKit
import CoreImage
import CoreImage.CIFilterBuiltins


struct PKCanvasRepresentable: UIViewRepresentable {
    @Binding var canvasView: PKCanvasView
    
    func makeUIView(context: Context) -> PKCanvasView {
        return canvasView
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {

    }
}


struct PhotoEditorVIew: View {
    
    @EnvironmentObject private var canvasVM: CanvasViewModel
    
    @EnvironmentObject private var vm: AuthViewModel
    @Environment(\.dismiss) private var dismiss
    
    
    @State private var toolDrawShows: Bool = false
    @State private var customBarShow: Bool = false
    
    @State private var showImagePickerForGallery: Bool = false
    @State private var showImagePickerForCamera: Bool = false
    @State private var showAlert: Bool = false
    
    @State private var scale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var photoIsAdded: Bool = false
    
    
    var body: some View {
        ZStack{
            ZoomableCanvasView(scale: $scale, offset: $offset, toolDrawShows: $toolDrawShows)
            VStack {
                HStack {
                    Spacer()
                    Button{
                        withAnimation(.spring()) {
                            toggleCustomBar()
                        }
                    }label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title)
                    }
                 
                    
                }
                                .disabled(canvasVM.image == nil)
                .opacity(0.7)
            
                .padding(.trailing)
                Spacer()
                if customBarShow {
                    customBar()
                }
                
            }
            .onChange(of:  photoIsAdded) {newVal in
                canvasVM.originalCopyImage = canvasVM.image
                photoIsAdded = false
                canvasVM.setImageFromCamera()
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Success"),
                message: Text("Your picture was saved"),
                dismissButton: .default(Text("OK")) {
                    
                }
            )
        }
        .sheet(isPresented: $showImagePickerForGallery) {
            ImagePicker(isImagePickerPresented: $showImagePickerForGallery, selectedImage: $canvasVM.image, finish: $photoIsAdded)
        }
        .sheet(isPresented: $showImagePickerForCamera) {
            ImagePicker(sourceType: .camera ,isImagePickerPresented: $showImagePickerForCamera, selectedImage: $canvasVM.image, finish: $photoIsAdded)
        }
        
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Menu {
                    Button("Exit") {
                        vm.updateParams()
                        dismiss()
                        vm.signOut()
                        canvasVM.resetObjects()
                    }
                } label: {
                    Label("Show Menu", systemImage: "person.crop.square")
                        .font(.title)
                }
            }
            
            ToolbarItem(placement: .topBarLeading) {
                Menu {
                    Button("Add photo") { showImagePickerForGallery .toggle() }
                    Button("Take a picture") { showImagePickerForCamera.toggle() }
                } label: {
                    Label("Load Photo", systemImage: "photo.on.rectangle.angled")
                        .font(.title)
                }
                
            }
            
            ToolbarItem(placement: .topBarLeading) {
                Button("Save drawing", systemImage: "arrow.down.doc") {
                    toolDrawShows = false
                    canvasVM.saveImage()
                    showAlert = true
                }
                .disabled(canvasVM.image == nil)
                
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button("Share", systemImage: "square.and.arrow.up") {
                    canvasVM.sharePhoto()
                }
                .disabled(canvasVM.image == nil)
            }
            
            
            
            ToolbarItem(placement: .topBarTrailing) {
                Button("Hide Panel", systemImage: "wrench.adjustable") {
                    toggleToolDraw()
                }
                .disabled(canvasVM.image == nil)
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button("Clean", systemImage: "trash") {
                    canvasVM.cleanDrawing()
                }
                .disabled(canvasVM.image == nil)
            }
        }
        
        
    }
    
    @ViewBuilder func customBar() -> some View {
        VStack {
            if let selectedTextIndex = canvasVM.selectedTextIndex {
                Slider(value: $canvasVM.textSize, in: 10...100, step: 1)
                    .padding()
                    .onChange(of: canvasVM.textSize) { newValue in
                        canvasVM.texts[selectedTextIndex].size = newValue
                    }
            }
            CustomToolBar()
                .overlay(
                    HStack (spacing: 16){
                        Button{
                            canvasVM.rotateCanvas(by: .degrees(-90))
                        }label: {
                            Image(systemName: "arrow.uturn.down.square")
                                .font(.title)
                        }
                        Button{
                            canvasVM.rotateCanvas(by: .degrees(90))
                        }label: {
                            Image(systemName: "arrow.uturn.down.square")
                                .scaleEffect(x: -1, y: 1)
                                .font(.title)
                        }
                        Button{
                            canvasVM.showFilterMenu.toggle()
                        }label: {
                            Image(systemName: "circle.dotted.circle")

                                .font(.title)
                        }
                        
//                        Button("Текст") {
//               
//                            if let selectedTextIndex = canvasVM.selectedTextIndex {
//                    
//                                canvasVM.texts[selectedTextIndex].text = "Новый текст"
//                            }
//                        }
                        
                        Button{
                            let newTextItem = TextItem(text: canvasVM.text, position: canvasVM.textPosition, size: canvasVM.textSize, color: canvasVM.textColor)
                            canvasVM.texts.append(newTextItem)
                            canvasVM.selectedTextIndex = canvasVM.texts.count - 1
                        }label: {
                            Image(systemName: "highlighter")
                                .font(.title)
                        }
                     
                            if let selectedTextIndex = canvasVM.selectedTextIndex {
                                ColorPicker("", selection: $canvasVM.textColor)
                                    .padding()
                                    .onChange(of: canvasVM.textColor) { newValue in
                                        
                                        canvasVM.texts[selectedTextIndex].color = newValue
                                    }
                            }
                        
                   
                    }
                        .padding(.horizontal, 20)
                )
                .transition(.move(edge: .bottom))
        }
    }
    

    private func toggleToolDraw() {
        if !toolDrawShows {
            toolDrawShows = true
            customBarShow = false
        } else {
            toolDrawShows = false
        }
    }
    
    private func toggleCustomBar() {
        if !customBarShow {
            customBarShow = true
            toolDrawShows = false
        } else {
            customBarShow = false
        }
    }
    
}

#Preview {
    NavigationView {
        PhotoEditorVIew()
            .environmentObject(AuthViewModel())
            .environmentObject(CanvasViewModel())
    }
    
}


