import UIKit

public typealias CropPhotoView = CropPhoto.View

public extension CropPhoto {
    
    public class View: UIView {
        
        var params: Params! {
            didSet { bind(params: params) }
        }
        
        let imageView: UIImageView = {
            $0.contentMode = .scaleAspectFit
            
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
        
        imageView.leftAnchor.constraint(equalTo: self.leftAnchor)
        imageView.rightAnchor.constraint(equalTo: self.rightAnchor)
        imageView.topAnchor.constraint(equalTo: self.topAnchor)
        imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        
        imageView.image = params.input
        
    }
}
