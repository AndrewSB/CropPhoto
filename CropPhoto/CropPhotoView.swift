import UIKit

public extension CropPhoto.View {
    
    override open var frame: CGRect {
        didSet {
            self.imageView.frame = frame
        }
    }
    
    convenience public init(params: CropPhoto.Params, frame: CGRect) {
        self.init(frame: frame)
        
        self.params = params
        bind(params: params)
    }
    
}

public extension CropPhoto.View {
    
    public func croppedImage() -> UIImage {
        return self.croppedTransformedImage(sourceImageView: self.imageView, cropRect: params.cropRect ?? defaultCropRect)
    }
    
}

extension CropPhoto.View {
    
    func bind(params: CropPhoto.Params) {
        imageView.image = params.image
        maskRectView = buildMaskView(withTransparentRect: params.cropRect)
    }
    
}
