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
        var imageViewTransform: CGAffineTransform!
    }
    
}

public extension CropPhoto.View {
    convenience init(params: CropPhoto.Params, frame: CGRect) {
        self.init(frame: frame)
        
        self.params = params
    }
    
    func bind(params: CropPhoto.Params) {
        imageView.leftAnchor.constraintEqualToAnchor(self.leftAnchor)
        imageView.rightAnchor.constraintEqualToAnchor(self.rightAnchor)
        imageView.topAnchor.constraintEqualToAnchor(self.topAnchor)
        imageView.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor)
        
        imageView.image = params.input
        
    }
}
