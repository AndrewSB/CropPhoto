import UIKit

class ViewController: UIViewController {

    lazy var imagePicker: UIImagePickerController = {
        $0.delegate = self
        
        return $0
    }(UIImagePickerController())
    
}

extension ViewController {
    
    @IBAction func pickPhotoButtonWasHit() {
        let cameraOrLibraryAlert = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .Default) { _ in
            self.imagePicker.sourceType = .Camera
            self.presentViewController(self.imagePicker, animated: true, completion: .None)
        }
        let libraryAction = UIAlertAction(title: "Library", style: .Default) { _ in
            self.imagePicker.sourceType = .PhotoLibrary
            self.presentViewController(self.imagePicker, animated: true, completion: .None)
        }
        [cameraAction, libraryAction].forEach(cameraOrLibraryAlert.addAction)
        
        presentViewController(cameraOrLibraryAlert, animated: true, completion: .None)
    }
    
}

extension ViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        dismissViewControllerAnimated(true, completion: {
            if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
                self.performSegueWithIdentifier("toCrop", sender: pickedImage)
            } else {
                let ohNoAlert = UIAlertController(title: "Oh no!", message: "We couldn't retrieve your selected photo 🤔", preferredStyle: .Alert)
                ohNoAlert.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: .None))
                self.presentViewController(ohNoAlert, animated: true, completion: .None)
            }
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if
            segue.identifier == "toCrop",
            let des = segue.destinationViewController as? CropPhotoViewController,
            let image = sender as? UIImage {
            des.input = image
        }
    }
    
}
