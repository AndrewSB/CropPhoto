import UIKit

public class CropPhoto {
    
}

public extension CropPhoto {
    
    public struct Params {
        public let input: UIImage
        public let cropRect: CGRect
    }
    
}

public extension CropPhoto.Params {
    
    public init(_ input: UIImage, cropRect: CGRect) {
        self.input = input
        self.cropRect = cropRect
    }
    
}