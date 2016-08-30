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
        let params = CropPhoto.Params(image: input, cropRect: nil)
        
        cropPhotoView = CropPhoto.View(params: params, frame: self.view.frame)
        view.insertSubview(cropPhotoView!, at: 0)
    }
    
    override func viewDidLayoutSubviews() {
        cropPhotoView?.frame = view.frame
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if
            let des = segue.destination as? ResultViewController,
            let image = sender as? UIImage {
            des.result = image
        }
        
    }
}

extension CropPhotoViewController {
    
    @IBAction func didHitSave() {
        let croppedImage = cropPhotoView!.croppedImage()

        performSegue(withIdentifier: "toDisplay", sender: croppedImage)
    }    
    
}
