import UIKit

class ViewController: UIViewController {

    let imagePicker: UIImagePickerController = {
        $0.delegate = self
        
        return $0
    }(UIImagePickerController())
    
}

extension ViewController {
    
    @IBAction func pickPhotoButtonWasHit() {
        let cameraOrLibraryAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: .none)
        }
        let libraryAction = UIAlertAction(title: "Library", style: .default) { _ in
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true, completion: .none)
        }
        [cameraAction, libraryAction].forEach(cameraOrLibraryAlert.addAction)
        
        present(cameraOrLibraryAlert, animated: true, completion: .none)
    }
    
}

extension ViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.performSegue(withIdentifier: "toCrop", sender: pickedImage)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        if
            segue.identifier == "toCrop",
            let des = segue.destinationViewController as? CropPhotoViewController,
            let image = sender as? UIImage {
           des.input = image
        }
    }
    
}
