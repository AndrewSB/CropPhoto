import UIKit

public extension CropPhoto.View {
    
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
    
    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        self.imageView.frame = self.frame
    }
    
    
    func bind(params: CropPhoto.Params) {
        imageView.image = params.image
        maskRectView = buildMaskView(withTransparentRect: params.cropRect)
    }
    
}
