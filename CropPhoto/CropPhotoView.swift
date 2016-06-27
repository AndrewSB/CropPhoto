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

        var maskRectView: UIView? = nil {
            didSet {
//                removeMask()
                print(maskRectView!.frame)
                insertSubview(maskRectView!, aboveSubview: imageView)
            }
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)

            addSubview(imageView)
        }
        
        required public init?(coder aDecoder: NSCoder) {
            // you're not going to be able to
            fatalError("init(coder:) has not been implemented")
        }
        
        convenience public init(params: CropPhoto.Params, frame: CGRect) {
            self.init(frame: frame)
            
            self.params = params
            bind(params)
        }
        
        public override func layoutSubviews() {
            super.layoutSubviews()
            
            imageView.frame = self.frame
            sendSubviewToBack(imageView)
            print(maskRectView?.frame)
        }
    }
    
}

extension CropPhoto.View {
    
    func bind(params: CropPhoto.Params) {
        imageView.image = params.image
        maskRectView = maskView(withTransparentRect: params.cropRect)
    }
    
}