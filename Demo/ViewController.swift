import UIKit

class ViewController: UIViewController {

    lazy var imagePicker: UIImagePickerController = {
        $0.delegate = self
        
        return $0
    }(UIImagePickerController())
    
}

extension ViewController {
    
    @IBAction func pickPhotoButtonWasHit() {
        let cameraOrLibraryAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true, completion: .none)
        }
        let libraryAction = UIAlertAction(title: "Library", style: .default) { _ in
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: .none)
        }
        [cameraAction, libraryAction].forEach(cameraOrLibraryAlert.addAction)
        
        present(cameraOrLibraryAlert, animated: true, completion: .none)
    }
    
}

extension ViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true, completion: {
            if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
                self.performSegue(withIdentifier: "toCrop", sender: pickedImage)
            } else {
                let ohNoAlert = UIAlertController(title: "Oh no!", message: "We couldn't retrieve your selected photo 🤔", preferredStyle: .alert)
                ohNoAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: .none))
                self.present(ohNoAlert, animated: true, completion: .none)
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if
            segue.identifier == "toCrop",
            let des = segue.destination as? CropPhotoViewController,
            let image = sender as? UIImage {
            des.input = image
        }
    }
    
    @IBAction func unwindToViewController(segue: UIStoryboardSegue) {}
    
}
