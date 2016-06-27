import UIKit
import CropPhoto

class CropPhotoViewController: UIViewController {
    
    @IBOutlet weak var cropPhotoView: CropPhotoView! {
        didSet {
            cropPhotoView.params = CropPhoto.Params(input: self.input!, cropRect: .zero)
        }
    }
    var input: UIImage!

}
