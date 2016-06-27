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
        view.insertSubview(cropPhotoView!, atIndex: 0)
    }
    
    override func viewDidLayoutSubviews() {
        cropPhotoView?.frame = view.frame
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if
            let des = segue.destinationViewController as? ResultViewController,
            let image = sender as? UIImage {
            des.result = image
        }
        
    }
}

extension CropPhotoViewController {
    
    @IBAction func didHitSave() {
        let croppedImage = cropPhotoView!.croppedImage()

        performSegueWithIdentifier("toDisplay", sender: croppedImage)
    }
    
}