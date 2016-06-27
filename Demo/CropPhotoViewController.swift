import UIKit
import CropPhoto

class CropPhotoViewController: UIViewController {
    
    @IBOutlet weak var cropPhotoView: CropPhotoView! {
        didSet {
            cropPhotoView.params = CropPhoto.Params(self.input!, cropRect: .zero)
        }
    }
    var input: UIImage!

}

extension CropPhotoViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}