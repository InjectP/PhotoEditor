


import SwiftUI
import PencilKit

final class ImageProcessingService {

//    func generateCombinedImage(image: UIImage, canvasView: PKCanvasView, rotationAngle: Angle) -> UIImage {
//        let imageSize = image.size
//        let canvasSize = canvasView.bounds.size
//        let aspectRatio = imageSize.width / imageSize.height
//        
//      
//        var renderSize: CGSize
//        if imageSize.width > imageSize.height {
//            renderSize = CGSize(width: canvasSize.width, height: canvasSize.width / aspectRatio)
//        } else {
//            renderSize = CGSize(width: canvasSize.height * aspectRatio, height: canvasSize.height)
//        }
//        
//        let renderer = UIGraphicsImageRenderer(size: renderSize)
//        let finalImage = renderer.image { context in
//            let cgContext = context.cgContext
//            
//         
//            cgContext.translateBy(x: renderSize.width / 2, y: renderSize.height / 2)
//            cgContext.rotate(by: CGFloat(rotationAngle.radians)) 
//            
//         
//            cgContext.translateBy(x: -renderSize.width / 2, y: -renderSize.height / 2)
//            
//      
//            image.draw(in: CGRect(origin: .zero, size: renderSize))
//        
//            canvasView.drawing.image(from: canvasView.bounds, scale: UIScreen.main.scale)
//                .draw(in: CGRect(origin: .zero, size: renderSize))
//        }
//        
//        return finalImage
//    }
    
    func generateCombinedImage(image: UIImage, canvasView: PKCanvasView, rotationAngle: Angle, texts: [TextItem]) -> UIImage {
        let imageSize = image.size
        let canvasSize = canvasView.bounds.size
        let aspectRatio = imageSize.width / imageSize.height
        
        var renderSize: CGSize
        if imageSize.width > imageSize.height {
            renderSize = CGSize(width: canvasSize.width, height: canvasSize.width / aspectRatio)
        } else {
            renderSize = CGSize(width: canvasSize.height * aspectRatio, height: canvasSize.height)
        }
        
        let renderer = UIGraphicsImageRenderer(size: renderSize)
        let finalImage = renderer.image { context in
            let cgContext = context.cgContext
            
            // Поворот контекста
            cgContext.translateBy(x: renderSize.width / 2, y: renderSize.height / 2)
            cgContext.rotate(by: CGFloat(rotationAngle.radians))
            cgContext.translateBy(x: -renderSize.width / 2, y: -renderSize.height / 2)
            
            // Рисуем изображение
            image.draw(in: CGRect(origin: .zero, size: renderSize))
            
            // Рисуем канвас
            canvasView.drawing.image(from: canvasView.bounds, scale: UIScreen.main.scale)
                .draw(in: CGRect(origin: .zero, size: renderSize))
            
            // Рисуем текст
            for textItem in texts {
                let attributes: [NSAttributedString.Key: Any] = [
                    .font: textItem.text, // Используйте шрифт из TextItem
                    .foregroundColor: textItem.color // Используйте цвет из TextItem
                ]
                let textSize = (textItem.text as NSString).size(withAttributes: attributes)
                // Убедитесь, что позиция текста правильно масштабируется
                let textRect = CGRect(x: textItem.position.x * renderSize.width,
                                      y: textItem.position.y * renderSize.height,
                                      width: textSize.width,
                                      height: textSize.height)
                textItem.text.draw(in: textRect, withAttributes: attributes)
            }
        }
        
        return finalImage
    }
}




