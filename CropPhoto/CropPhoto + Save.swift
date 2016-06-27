//
//  CropPhoto + Save.swift
//  CropPhoto
//
//  Created by Andrew Breckenridge on 6/27/16.
//  Copyright © 2016 Andrew Breckenridge. All rights reserved.
//

import UIKit

// better implement this https://github.com/heitorfr/ios-image-editor/blob/master/ImageEditor/HFImageEditorViewController.m
extension CropPhoto.View {
    
    typealias Radians = CGFloat
    var imageViewRotation: Radians {
        return imageView.transform.b
    }
    
    var imageViewScaleFactor: CGFloat {
        assert(imageView.transform.xScale == imageView.transform.yScale)
        return imageView.transform.xScale
    }

    func croppedImage(withFrame: CGRect) -> UIImage {
        let ctx = CGBitmapContextCreate(nil,
                                        Int(imageView.frame.size.width),
                                        Int(imageView.frame.size.height),
                                        CGImageGetBitsPerComponent(imageView.image!.CGImage),
                                        0,
                                        CGImageGetColorSpace(imageView.image!.CGImage),
                                        CGImageGetBitmapInfo(imageView.image!.CGImage).rawValue
        )
        
        CGContextTranslateCTM(ctx, imageView.frame.size.width / 2, imageView.frame.size.height / 2)
        CGContextConcatCTM(ctx, imageView.transform)
        
        CGContextDrawImage(ctx, CGRect(x: -(imageView.frame.size.width / 2), y: -(imageView.frame.size.height / 2), width: imageView.frame.size.width, height: imageView.frame.size.height), imageView.image!.CGImage)
        
        let resultRef = CGBitmapContextCreateImage(ctx)!
        
        return UIImage(CGImage: resultRef)
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