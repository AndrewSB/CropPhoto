import UIKit

public extension CropPhoto {
    
    public class View: UIView {
        
        public var params: Params! {
            didSet { bind(params) }
        }
        
        let imageView: UIImageView = {
            $0.contentMode = .ScaleAspectFit
            
            return $0
        }(UIImageView())

        override init(frame: CGRect) {
            super.init(frame: frame)
            
            imageView.leftAnchor.constraintEqualToAnchor(self.leftAnchor)
            imageView.rightAnchor.constraintEqualToAnchor(self.rightAnchor)
            imageView.topAnchor.constraintEqualToAnchor(self.topAnchor)
            imageView.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor)
        }
        
        required public init?(coder aDecoder: NSCoder) {
            // you're not going to be able to
            fatalError("init(coder:) has not been implemented")
        }
        
        convenience public init(params: CropPhoto.Params, frame: CGRect) {
            self.init(frame: frame)
            
            self.params = params
        }
    }
    
}

extension CropPhoto.View {
    
    func bind(params: CropPhoto.Params) {
        bind(params.image)
        bind(params.cropRect)
    }
    
    private func bind(image: UIImage) {
        imageView.leftAnchor.constraintEqualToAnchor(self.leftAnchor)
        imageView.rightAnchor.constraintEqualToAnchor(self.rightAnchor)
        imageView.topAnchor.constraintEqualToAnchor(self.topAnchor)
        imageView.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor)
        
        imageView.image = params.image
    }
    
    private func bind(cropRect: CGRect) {
        removeMask()
        
        addSubview(maskView(withTransparentRect: cropRect))
    }
    
}