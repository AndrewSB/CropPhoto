import UIKit
import CropPhoto

class CropPhotoViewController: UIViewController {
    
    var cropPhotoView: CropPhoto.View!
    
    var input: UIImage! {
        didSet {
            let params = CropPhoto.Params(input!, cropRect: .zero)
            cropPhotoView = CropPhoto.View(params: params, frame: self.view.frame)
            cropPhotoView.backgroundColor = .redColor()
            self.view.addSubview(cropPhotoView)
        }
    }

}

extension CropPhotoViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
}