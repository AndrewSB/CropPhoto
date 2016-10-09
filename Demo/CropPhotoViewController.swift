import UIKit
import CropPhoto

class CropPhotoViewController: UIViewController {
    
    var cropPhotoView: CropPhoto.View!
    @IBOutlet weak var cropPhotoContainerView: UIView!

    var input: UIImage!

}

extension CropPhotoViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        assert(input != nil, "You didn't set the input, fam")
        let params = CropPhoto.Params(image: input, cropRect: CGRect(x: 0, y: 0, width: 44, height: 44))
        
        self.cropPhotoView = CropPhoto.View(params: params, frame: cropPhotoContainerView.frame)
        cropPhotoContainerView.addSubview(cropPhotoView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        cropPhotoView.frame = cropPhotoContainerView.frame
        cropPhotoView.params = CropPhoto.Params(image: input, cropRect: cropPhotoView.defaultCropRect)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let des = segue.destination as? ResultViewController
            , let image = sender as? UIImage {
            des.result = image
        }
        
    }
}

extension CropPhotoViewController {
    
    @IBAction func didHitSave() {
        let croppedImage = self.cropPhotoView!.croppedImage()

        performSegue(withIdentifier: "toDisplay", sender: croppedImage)
    }
    
}
