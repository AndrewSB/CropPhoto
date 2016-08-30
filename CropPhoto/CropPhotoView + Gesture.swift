import UIKit

extension CropPhoto.View {
    
    struct ImageOperationGestureRecognizers {
        static let Pan = UIPanGestureRecognizer()
        static let Pinch = UIPinchGestureRecognizer()
        static let Rotate = UIRotationGestureRecognizer()
        
        static let all = [Pan, Pinch, Rotate]
    }
    
    func resetPanCenter() {
        ImageOperationGestureRecognizers.Pan.setTranslation(.zero, in: imageView)
    }
    
    func resetPinchScale() {
        ImageOperationGestureRecognizers.Pinch.scale = 1
    }
    
    func resetRotateRotation() {
        ImageOperationGestureRecognizers.Rotate.rotation = 0
    }
    
}

extension CropPhoto.View {
    
    func handleTouches(_ touches: Set<UITouch>?) {
        guard let touches = touches , touches.count > 2 else {
            self.touchCenter = .zero
            return
        }
        
        touches.forEach { touch in
            let touchLocation = touch.location(in: self.imageView)
            self.touchCenter = CGPoint(x: touchCenter.x + touchLocation.x, y: touchCenter.y + touchLocation.y)
        }
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.handleTouches(event?.allTouches)
    }
    
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.handleTouches(event?.allTouches)
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)  {
        self.handleTouches(event?.allTouches)
    }

    override public func touchesCancelled(_ touches: Set<UITouch>?, with event: UIEvent?) {
        self.handleTouches(event?.allTouches)
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
    
    func handlePan(_ gesture: UIPanGestureRecognizer) {
        defer { resetPanCenter() }
        
        let translation = gesture.translation(in: self)
        let panTransformation = imageView.transform.translatedBy(x: translation.x, y: translation.y)
        
        if maskContainsAnyOfTransformedImage(panTransformation) {
            self.imageView.transform = panTransformation
        }
    }
    
    func handlePinch(_ gesture: UIPinchGestureRecognizer) {
        defer { resetPinchScale() }
        guard gesture.state != .ended else { return }
        
        let scaleTransform = self.imageView.transform.scaledBy(x: gesture.scale, y: gesture.scale)

        if maskContainsAnyOfTransformedImage(scaleTransform) {
            self.imageView.transform = scaleTransform
        }
    }
    
    func handleRotate(_ gesture: UIRotationGestureRecognizer) {
        defer { resetRotateRotation() }
        
        if gesture.state == .began {
            self.rotationCenter = self.touchCenter
        }
        if gesture.state == .ended {
            return
        }
        
        let dX = self.rotationCenter.x - self.imageView.bounds.size.width / 2
        let dY = self.rotationCenter.y - self.imageView.bounds.size.height / 2
        
        // this transform puts the image's rotation back to default. So up is up and down is down
        var transform = imageView.transform.translatedBy(x: dX, y: dY)
        
        // perform rotation
        transform = transform.rotated(by: gesture.rotation)
        
        // this transform undos the default rotation translation
        transform = transform.translatedBy(x: -dX, y: -dY)

        if maskContainsAnyOfTransformedImage(transform) {
            self.imageView.transform = transform
        }
    }
    
}

private extension CropPhoto.View {
    
    func maskContainsAnyOfTheImage(_ translatedCenter: CGPoint) -> Bool {
        var imageViewFrame = self.imageView.frame
        imageViewFrame.center = translatedCenter
        
        return imageViewFrame.intersects(params.cropRect ?? defaultCropRect)
    }
    
    func maskContainsAnyOfTransformedImage(_ transformation: CGAffineTransform) -> Bool {
        let oldTransform = self.imageView.transform
        self.imageView.transform = transformation

        let contains = (params.cropRect ?? defaultCropRect).intersects(imageView.frame)
        
        imageView.transform = oldTransform
        return contains
    }
    
}

extension CropPhoto.View: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
