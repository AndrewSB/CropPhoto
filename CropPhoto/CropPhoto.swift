import UIKit

open class CropPhoto {
    open class View: UIView {
        open var params: Params! {
            didSet { bind(params: params) }
        }
        
        let imageView: UIImageView = {
            $0.contentMode = .scaleAspectFit
            
            return $0
        }(UIImageView())
        
        var maskRectView: UIView? = nil {
            didSet {
                removeMask()
                insertSubview(maskRectView!, aboveSubview: imageView)
            }
        }
        
        /// a sink for touches
        var touchCenter: CGPoint!
        var rotationCenter: CGPoint!
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            addSubview(imageView)
            addGestureRecognizers()
        }
        
        required public init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}

public extension CropPhoto {
    
    public struct Params {
        public let image: UIImage
        public let cropRect: CGRect?
        
        public init(image: UIImage, cropRect: CGRect?) {
            self.image = image
            self.cropRect = cropRect
        }
    }
    
}

