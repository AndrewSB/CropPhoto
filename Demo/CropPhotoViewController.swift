import UIKit
import CropPhoto

class ImportedCropPhotoView: CropPhoto.View {}

class CropPhotoViewController: UIViewController {
    
    @IBOutlet weak var cropPhotoView: CropPhoto.View!

    var input: UIImage!

}

extension CropPhotoViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        assert(input != nil, "You didn't set the input, fam")
//        cropPhotoView.params = CropPhoto.Params(image: input, cropRect: nil)
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
