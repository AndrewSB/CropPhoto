import UIKit

public extension CropPhoto {
    
    public class View: UIView {
        
        open var params: Params! {
            didSet { bind(params) }
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
        
        convenience public init(params: CropPhoto.Params, frame: CGRect) {
            self.init(frame: frame)
            
            self.params = params
            bind(params)
        }
        
    }
}

public extension CropPhoto.View {
    
    public func croppedImage() -> UIImage {
        return self.croppedTransformedImage(sourceImageView: self.imageView, cropRect: params.cropRect ?? defaultCropRect)
    }
    
}

extension CropPhoto.View {
    
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        self.imageView.frame = self.frame
    }
    
    
    func bind(_ params: CropPhoto.Params) {
        imageView.image = params.image
        maskRectView = maskView(withTransparentRect: params.cropRect)
    }
    
}
