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
        
        let sourceRef: CGImage = sourceImage.cgImage!
        
        let (orientationTransform, orientedSize) = transformAndSizeForOrientation(sourceSize, orientation: sourceOrientation)
        
        let aspectRatio = cropRect.size.height / cropRect.size.width
        let outputSize = CGSize(width: outputWidth, height: outputWidth * aspectRatio)
        
        let ctx = CGContext(data: nil,
                                        width: Int(outputSize.width),
                                        height: Int(outputSize.height),
                                        bitsPerComponent: sourceRef.bitsPerComponent,
                                        bytesPerRow: 0,
                                        space: sourceRef.colorSpace!,
                                        bitmapInfo: sourceRef.bitmapInfo.rawValue)!
        
        ctx.setFillColor(UIColor.clear.cgColor)
        ctx.fill(CGRect(origin: .zero, size: outputSize))
        
        var uiCords = CGAffineTransform(scaleX: outputSize.width / outputSize.height, y: outputSize.height / outputSize.width)
        uiCords = uiCords.translatedBy(x: cropRect.size.width / 2, y: cropRect.size.height / 2)
        uiCords = uiCords.scaledBy(x: 1, y: -1)
        ctx.concatenate(uiCords)
        
        ctx.concatenate(transfrom)
        ctx.scaleBy(x: -1, y: 1)
        ctx.concatenate(orientationTransform)
        
        let orientedSizeRect = CGRect(x: -orientedSize.width / 2, y: -orientedSize.height / 2, width: orientedSize.width, height: orientedSize.height)
        ctx.draw(sourceRef, in: orientedSizeRect)
        
        let resultRef = ctx.makeImage()!
    
        return UIImage(cgImage: resultRef)
    }
    
    fileprivate func transformAndSizeForOrientation(_ size: CGSize, orientation: UIImageOrientation) -> (CGAffineTransform, CGSize) {
        
        var orientationTransform = CGAffineTransform.identity
        var shouldRotate = false
    
        // rotate the image
        switch orientation {
        case .up, .upMirrored:
            break
        case .down, .downMirrored:
            orientationTransform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
        case .left, .leftMirrored:
            orientationTransform = CGAffineTransform(rotationAngle: CGFloat(M_PI_2))
            shouldRotate = true
        case .right, .rightMirrored:
            orientationTransform = CGAffineTransform(rotationAngle: -CGFloat(M_PI_2))
            shouldRotate = true
        }
    
        // fix mirroring
        switch orientation {
        case .upMirrored, .downMirrored, .leftMirrored, .rightMirrored:
            orientationTransform = transform.scaledBy(x: -1, y: 1)
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
