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
    
    /// Assumes that all the transforms have been made to the UIImageView passed in
    func croppedTransformedImage(sourceImageView: UIImageView, cropRect: CGRect) -> UIImage {
        
        return croppedTransformedImage(withTransform: sourceImageView.transform,
                                       sourceImage: sourceImageView.image!,
                                       sourceSize: sourceImageView.image!.size,
                                       sourceOrientation: sourceImageView.image!.imageOrientation,
                                       outputWidth: sourceImageView.image!.size.width,
                                       cropRect: cropRect,
                                       imageViewSize: sourceImageView.bounds.size)
        
    }
    
    func croppedTransformedImage(withTransform transfrom: CGAffineTransform,
                                               sourceImage: UIImage,
                                               sourceSize: CGSize,
                                               sourceOrientation: UIImageOrientation,
                                               outputWidth: CGFloat,
                                               cropRect: CGRect,
                                               imageViewSize: CGSize) -> UIImage {
        
        let sourceRef: CGImageRef = sourceImage.CGImage!
        
        let (orientationTransform, orientedSize) = transformAndSizeForOrientation(sourceSize, orientation: sourceOrientation)
        
        let aspectRatio = cropRect.size.height / cropRect.size.width
        let outputSize = CGSize(width: outputWidth, height: outputWidth * aspectRatio)
        
        let ctx = CGBitmapContextCreate(nil,
                                        Int(outputSize.width),
                                        Int(outputSize.height),
                                        CGImageGetBitsPerComponent(sourceRef),
                                        0,
                                        CGImageGetColorSpace(sourceRef),
                                        CGImageGetBitmapInfo(sourceRef).rawValue)
        
        CGContextSetFillColorWithColor(ctx, UIColor.clearColor().CGColor)
        CGContextFillRect(ctx, CGRect(origin: .zero, size: outputSize))
        
        var uiCords = CGAffineTransformMakeScale(outputSize.width / outputSize.height, outputSize.height / outputSize.width)
        uiCords = CGAffineTransformTranslate(uiCords, cropRect.size.width / 2, cropRect.size.height / 2)
        uiCords = CGAffineTransformScale(uiCords, 1, -1)
        CGContextConcatCTM(ctx, uiCords)
        
        CGContextConcatCTM(ctx, transfrom)
        CGContextScaleCTM(ctx, -1, 1)
        CGContextConcatCTM(ctx, orientationTransform)
        
        let orientedSizeRect = CGRect(x: -orientedSize.width / 2, y: -orientedSize.height / 2, width: orientedSize.width, height: orientedSize.height)
        CGContextDrawImage(ctx, orientedSizeRect, sourceRef)
        
        let resultRef = CGBitmapContextCreateImage(ctx)!
        
        return UIImage(CGImage: resultRef)
    }
    
    private func transformAndSizeForOrientation(size: CGSize, orientation: UIImageOrientation) -> (CGAffineTransform, CGSize) {
        
        var orientationTransform = CGAffineTransformIdentity
        var shouldRotate = false
    
        // rotate the image
        switch orientation {
        case .Up, .UpMirrored:
            break
        case .Down, .DownMirrored:
            orientationTransform = CGAffineTransformMakeRotation(CGFloat(M_PI))
        case .Left, .LeftMirrored:
            orientationTransform = CGAffineTransformMakeRotation(CGFloat(M_PI_2))
            shouldRotate = true
        case .Right, .RightMirrored:
            orientationTransform = CGAffineTransformMakeRotation(-CGFloat(M_PI_2))
            shouldRotate = true
        }
    
        // fix mirroring
        switch orientation {
        case .UpMirrored, .DownMirrored, .LeftMirrored, .RightMirrored:
            orientationTransform = CGAffineTransformScale(transform, -1, 1)
        default:
            break
        }
        
        let sizeForOrientation = shouldRotate ? CGSize(width: size.height, height: size.width) : size
        
        return (orientationTransform, sizeForOrientation)
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