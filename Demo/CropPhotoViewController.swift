import UIKit
import CropPhoto

class CropPhotoViewController: UIViewController {
    
    var cropPhotoView: CropPhoto.View?
    
    var input: UIImage!

}

extension CropPhotoViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        assert(input != nil, "You didn't set the input fam, fam")
        let params = CropPhoto.Params(input!, cropRect: .zero)
        
        cropPhotoView = CropPhoto.View(params: params, frame: self.view.frame)
        view.addSubview(cropPhotoView!)
    }
    
    override func viewDidLayoutSubviews() {
        cropPhotoView?.frame = view.frame
    }
    
}