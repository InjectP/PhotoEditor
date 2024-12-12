

import SwiftUI
import PencilKit
import CoreImage

final class CanvasViewModel: ObservableObject {
    
    @Published var image: UIImage?
    @Published var originalCopyImage: UIImage?
    @Published var filterPreviews: [UIImage] = []
    
    @Published var canvasView = PKCanvasView()
    @Published var drawing = PKDrawing()
    
    @Published var rotationAngle: Angle = .zero
    @Published var showFilterMenu = false
    
    
    @Published var text = "Введите текст"
    @Published var textPosition = CGPoint(x: 100, y: 100)
    @Published var textSize: CGFloat = 24
    @Published var textColor: Color = .blue
    @Published var texts: [TextItem] = []
    @Published var selectedTextIndex: Int? = nil
    
    
    
    private let coreImageFilters = CoreImageFilters()
    
    init() {
        resetObjects()
    }
    //MARK: Reset objects
    func resetObjects() {
        image = nil
        originalCopyImage = nil
        filterPreviews = []
        canvasView = PKCanvasView()
        drawing = PKDrawing()
        rotationAngle = .zero
        showFilterMenu = false
        resetTexts()
    }
    
    private func resetTexts() {
        text = "Введите текст"
        textPosition = CGPoint(x: 100, y: 100)
        textSize = 24
        texts = []
        selectedTextIndex = nil
    }
    
    
    //MARK: Rotate Picture
    func rotateCanvas(by angle: Angle) {
        rotationAngle += angle
    }
    
    //MARK: Share Photo With Friends
    func sharePhoto() {
        if let image = image {
            let result = ImageProcessingService().generateCombinedImage(image: image, canvasView: canvasView, rotationAngle: rotationAngle)
            ShareService().shareImage(image: result)
        }
        
    }
    
    
    //MARK: Save Image Into Gallery
    func saveImage() {
        if let image = image {
            let result = ImageProcessingService().generateCombinedImage(image: image, canvasView: canvasView, rotationAngle: rotationAngle)
            SaveService().saveImageToGallery(image: result)
        }
    }
    
    //MARK: Clean Canvas
    func cleanDrawing() {
        rotationAngle = .zero
        drawing = PKDrawing()
    }
    
    //MARK: Core Image
    func generateFilterPreviews() -> [UIImage] {
        guard let image = originalCopyImage else { return [] }
        return coreImageFilters.generateFilterPreviews(from: image)
        
    }
    
    func applyFilter(filter: CIFilter, intensity: Float = 1.0) {
        guard let image = self.originalCopyImage else { return }
        if let filteredImage = coreImageFilters.applyFilter(to: image, filter: filter, intensity: intensity) {
            self.image = filteredImage
        }
    }
    
    func applyFilterByIndex(_ index: Int) {
        guard self.originalCopyImage != nil else { return }
        
        let filters: [CIFilter] = [
            CIFilter.sepiaTone(),
            CIFilter.photoEffectMono(),
            CIFilter.colorInvert(),
            CIFilter.gaussianBlur(),
            CIFilter.vignette()
        ]
        
        if index < filters.count {
            applyFilter(filter: filters[index], intensity: 0.8)
        }
    }
    
    func applyBlur(blurType: BlurType, intensity: CGFloat) {
        guard let image = self.originalCopyImage else { return }
        if let blurredImage = coreImageFilters.applyBlur(to: image, blurType: blurType, intensity: intensity) {
            self.image = blurredImage
        }
    }
    
    func applyColorCorrection(correctionType: ColorCorrectionType) {
        guard let image = self.originalCopyImage else { return }
        if let correctedImage = coreImageFilters.applyColorCorrection(to: image, correctionType: correctionType) {
            self.image = correctedImage
        }
    }
    
    func resetToOriginal() {
        if let originalImage = self.originalCopyImage {
            self.image = originalImage
        }
    }
    
    
    
    func setImageFromCamera() {
        let normalized = image?.normalizedImage()
        self.image = normalized
        self.originalCopyImage = normalized
    }
    
}
