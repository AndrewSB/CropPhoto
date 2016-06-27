import UIKit
import CropPhoto

class CropPhotoViewController: UIViewController {
    
    var cropPhotoView: CropPhoto.View?
    
    var input: UIImage!

}

extension CropPhotoViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        assert(input != nil, "You didn't set the input, fam")
        let params = CropPhoto.Params(input!, cropRect: nil)
        
        cropPhotoView = CropPhoto.View(params: params, frame: self.view.frame)
        view.addSubview(cropPhotoView!)
    }
    
    override func viewDidLayoutSubviews() {
        cropPhotoView?.frame = view.frame
    }
    
}

extension CropPhotoViewController {
    
    
    @IBAction func didHitSave() {
        let croppedImage = cropPhotoView!.croppedImage()
        
        let displayVC = UIViewController()
        let imageView = UIImageView(frame: displayVC.view.frame)
        imageView.contentMode = .ScaleAspectFit
        imageView.image = croppedImage
        
        presentViewController(displayVC, animated: true, completion: .None)
    }
    
}