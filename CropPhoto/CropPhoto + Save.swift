//
//  CropPhoto + Save.swift
//  CropPhoto
//
//  Created by Andrew Breckenridge on 6/27/16.
//  Copyright © 2016 Andrew Breckenridge. All rights reserved.
//

import UIKit

extension CropPhoto.View {
    
    var imageViewRotation: CGFloat {
        return imageView.transform.b
    }
    
    var imageViewScaleFactor: CGFloat {
        assert(imageView.transform.xScale == imageView.transform.yScale)
        return imageView.transform.xScale
    }

    func croppedImage(withFrame: CGRect) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(imageView.frame.size, true, imageViewScaleFactor)
        
        let ctx = UIGraphicsGetCurrentContext()!
        
        let croppingImageView = UIImageView(image: imageView.image)
        
        croppingImageView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, imageViewRotation * (CGFloat(M_PI) / 180))
        let rotatedRect = CGRectApplyAffineTransform(croppingImageView.bounds, croppingImageView.transform)
        
        let containerView = UIView(frame: CGRect(origin: .zero, size: rotatedRect.size))
        containerView.addSubview(croppingImageView)
        croppingImageView.center = containerView.center
        
        CGContextTranslateCTM(ctx, -imageView.frame.origin.x, -imageView.frame.origin.y)
        containerView.layer.renderInContext(ctx)
        
        let croppedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return UIImage(CGImage: croppedImage.CGImage!, scale: UIScreen.mainScreen().scale, orientation: .Up)
    }
    
}

private extension CGAffineTransform {
    
    var xScale: CGFloat {
        return sqrt(a * a + c * c)
    }
    
    var yScale: CGFloat {
        return sqrt(b * b + d * d)
    }
    
}