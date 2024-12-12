

import UIKit
import CoreImage

final class CoreImageFilters {

    func applyFilter(to image: UIImage, filter: CIFilter, intensity: Float = 1.0) -> UIImage? {
        guard let inputImage = image.ciImage ?? CIImage(image: image) else { return nil }
        filter.setValue(inputImage, forKey: kCIInputImageKey)
        
        
        if filter.inputKeys.contains(kCIInputIntensityKey) {
            filter.setValue(intensity, forKey: kCIInputIntensityKey)
        }
        
        let context = CIContext()
        if let outputImage = filter.outputImage,
           let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
            return UIImage(cgImage: cgImage)
        }
        return nil
    }
    

    func generateFilterPreviews(from image: UIImage) -> [UIImage] {
        guard let ciImage = CIImage(image: image) else { return [] }
        
        let context = CIContext()
        let filters: [CIFilter] = [
            CIFilter.sepiaTone(),
            CIFilter.photoEffectMono(),
            CIFilter.colorInvert(),
            CIFilter.gaussianBlur(),
            CIFilter.vignette()
        ]
        
        return filters.compactMap { filter in
            filter.setValue(ciImage, forKey: kCIInputImageKey)
            
            if filter.inputKeys.contains(kCIInputIntensityKey) {
                filter.setValue(0.8, forKey: kCIInputIntensityKey)
            }
            
            if let outputImage = filter.outputImage,
               let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgImage)
            }
            return nil
        }
    }
    

    func applyBlur(to image: UIImage, blurType: BlurType, intensity: CGFloat) -> UIImage? {
        guard let inputImage = image.ciImage ?? CIImage(image: image) else { return nil }
        
        var filter: CIFilter?
        switch blurType {
        case .gaussian:
            filter = CIFilter.gaussianBlur()
            filter?.setValue(inputImage, forKey: kCIInputImageKey)
            filter?.setValue(intensity, forKey: kCIInputRadiusKey)
        case .box:
            filter = CIFilter.boxBlur()
            filter?.setValue(inputImage, forKey: kCIInputImageKey)
            filter?.setValue(intensity, forKey: kCIInputRadiusKey)
        case .motion:
            filter = CIFilter.motionBlur()
            filter?.setValue(inputImage, forKey: kCIInputImageKey)
            filter?.setValue(intensity, forKey: kCIInputRadiusKey)
        }
        
        if let outputImage = filter?.outputImage {
            let context = CIContext()
            if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgImage)
            }
        }
        return nil
    }
    
    // Функция для цветокоррекции
    func applyColorCorrection(to image: UIImage, correctionType: ColorCorrectionType) -> UIImage? {
        guard let inputImage = image.ciImage ?? CIImage(image: image) else { return nil }
        
        var filter: CIFilter?
        switch correctionType {
        case .adjustment:
            filter = CIFilter.colorControls()
            filter?.setValue(inputImage, forKey: kCIInputImageKey)
            filter?.setValue(1.2, forKey: kCIInputSaturationKey)
            filter?.setValue(1.2, forKey: kCIInputContrastKey)
            filter?.setValue(0.2, forKey: kCIInputBrightnessKey)
        case .colorControls:
            filter = CIFilter.colorControls()
            filter?.setValue(inputImage, forKey: kCIInputImageKey)
            filter?.setValue(1.5, forKey: kCIInputSaturationKey)
            filter?.setValue(0.5, forKey: kCIInputContrastKey)
            filter?.setValue(0.0, forKey: kCIInputBrightnessKey)
        }
        
        if let outputImage = filter?.outputImage {
            let context = CIContext()
            if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgImage) 
            }
        }
        return nil
    }
    
 
}
enum BlurType {
    case gaussian, box, motion
}

enum ColorCorrectionType {
    case adjustment, colorControls
}
