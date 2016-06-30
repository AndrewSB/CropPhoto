import UIKit

extension CropPhoto.View {
    
    struct ImageOperationGestureRecognizers {
        static let Pan = UIPanGestureRecognizer()
        static let Pinch = UIPinchGestureRecognizer()
        static let Rotate = UIRotationGestureRecognizer()
        
        static let all = [Pan, Pinch, Rotate]
    }
    
    func resetPanCenter() {
        ImageOperationGestureRecognizers.Pan.setTranslation(.zero, inView: imageView)
    }
    
    func resetPinchScale() {
        ImageOperationGestureRecognizers.Pinch.scale = 1
    }
    
    func resetRotateRotation() {
        ImageOperationGestureRecognizers.Rotate.rotation = 0
    }
    
}

extension CropPhoto.View {
    
    func handleTouches(touches: Set<UITouch>?) {
        guard let touches = touches where touches.count > 2 else {
            self.touchCenter = .zero
            return
        }
        
        touches.forEach { touch in
            let touchLocation = touch.locationInView(self.imageView)
            self.touchCenter = CGPoint(x: touchCenter.x + touchLocation.x, y: touchCenter.y + touchLocation.y)
        }
    }
    
    override public func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.handleTouches(event?.allTouches())
    }
    
    override public func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.handleTouches(event?.allTouches())
    }
    
    override public func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?)  {
        self.handleTouches(event?.allTouches())
    }

    override public func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        self.handleTouches(event?.allTouches())
    }

}

extension CropPhoto.View {
    
    func addGestureRecognizers() {
        ImageOperationGestureRecognizers.all.forEach { $0.delegate = self }
        ImageOperationGestureRecognizers.all.forEach(addGestureRecognizer)
        
        ImageOperationGestureRecognizers.Pan.addTarget(self, action: #selector(handlePan(_:)))
        ImageOperationGestureRecognizers.Pinch.addTarget(self, action: #selector(handlePinch(_:)))
        ImageOperationGestureRecognizers.Rotate.addTarget(self, action: #selector(handleRotate(_:)))
    }
    
    func handlePan(gesture: UIPanGestureRecognizer) {
        defer { resetPanCenter() }
        
        let translation = gesture.translationInView(self)
        let panTransformation = CGAffineTransformTranslate(imageView.transform, translation.x, translation.y)
        
        if maskContainsAnyOfTransformedImage(panTransformation) {
            self.imageView.transform = panTransformation
        }
    }
    
    func handlePinch(gesture: UIPinchGestureRecognizer) {
        defer { resetPinchScale() }
        guard gesture.state != .Ended else { return }
        
        let scaleTransform = CGAffineTransformScale(self.imageView.transform, gesture.scale, gesture.scale)

        if maskContainsAnyOfTransformedImage(scaleTransform) {
            self.imageView.transform = scaleTransform
        }
    }
    
    func handleRotate(gesture: UIRotationGestureRecognizer) {
        defer { resetRotateRotation() }
        
        if gesture.state == .Began {
            self.rotationCenter = self.touchCenter
        }
        if gesture.state == .Ended {
            return
        }
        
        let dX = self.rotationCenter.x - self.imageView.bounds.size.width / 2
        let dY = self.rotationCenter.y - self.imageView.bounds.size.height / 2
        
        // this transform puts the image's rotation back to default. So up is up and down is down
        var transform = CGAffineTransformTranslate(imageView.transform, dX, dY)
        
        // perform rotation
        transform = CGAffineTransformRotate(transform, gesture.rotation)
        
        // this transform undos the default rotation translation
        transform = CGAffineTransformTranslate(transform, -dX, -dY)

        if maskContainsAnyOfTransformedImage(transform) {
            self.imageView.transform = transform
        }
    }
    
}

private extension CropPhoto.View {
    
    private func maskContainsAnyOfTheImage(translatedCenter: CGPoint) -> Bool {
        var imageViewFrame = self.imageView.frame
        imageViewFrame.center = translatedCenter
        
        return CGRectIntersectsRect(imageViewFrame, params.cropRect ?? defaultCropRect)
    }
    
    private func maskContainsAnyOfTransformedImage(transformation: CGAffineTransform) -> Bool {
        let oldTransform = self.imageView.transform
        self.imageView.transform = transformation

        let contains = CGRectIntersectsRect(params.cropRect ?? defaultCropRect, imageView.frame)
        
        imageView.transform = oldTransform
        return contains
    }
    
}

extension CropPhoto.View: UIGestureRecognizerDelegate {
    public func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}