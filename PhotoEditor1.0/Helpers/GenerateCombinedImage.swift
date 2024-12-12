


import SwiftUI
import PencilKit

final class ImageProcessingService {

    func generateCombinedImage(image: UIImage, canvasView: PKCanvasView, rotationAngle: Angle) -> UIImage {
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


            cgContext.translateBy(x: renderSize.width / 2, y: renderSize.height / 2)
            cgContext.rotate(by: CGFloat(rotationAngle.radians))


            cgContext.translateBy(x: -renderSize.width / 2, y: -renderSize.height / 2)


            image.draw(in: CGRect(origin: .zero, size: renderSize))

            canvasView.drawing.image(from: canvasView.bounds, scale: UIScreen.main.scale)
                .draw(in: CGRect(origin: .zero, size: renderSize))
        }

        return finalImage
    }
    
    
}




