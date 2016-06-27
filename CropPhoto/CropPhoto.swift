import UIKit

public class CropPhoto {
    
}

public extension CropPhoto {
    
    public struct Params {
        public let image: UIImage
        public let cropRect: CGRect?
    }
    
}

public extension CropPhoto.Params {
    
    public init(_ image: UIImage, cropRect: CGRect? = nil) {
        self.image = image
        self.cropRect = cropRect
    }
    
}