

import SwiftUI

final class SaveService {
  
    func saveImageToGallery(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        print("Image saved!")
    }
}
