//
//  ResultViewController.swift
//  CropPhoto
//
//  Created by Andrew Breckenridge on 6/27/16.
//  Copyright © 2016 Andrew Breckenridge. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {
    
    var result: UIImage!

    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            imageView.image = result
        }
    }
    
}

extension ResultViewController {
    
    @IBAction func doneButtonWasHit(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: .none)
    }
    
}
