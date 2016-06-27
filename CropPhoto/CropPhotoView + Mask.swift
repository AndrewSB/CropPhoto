import UIKit

// private class so you can filter subviews without setting a tag
private class MaskView: UIView {}

extension CropPhoto.View {
    
    func removeMask() {
        subviews.filter { $0 is MaskView }.forEach { $0.removeFromSuperview() }
    }
    
}

extension CropPhoto.View {
    
    func maskView(withTransparentRect rect: CGRect,
                                      backgroundColor: UIColor = UIColor(white:  0.173, alpha: 0.94),
                                      cornerRadius: CGFloat = 10)-> UIView {
        
        let coloredLargeView = MaskView(frame: self.frame)
        coloredLargeView.backgroundColor = .clearColor()
        coloredLargeView.userInteractionEnabled = false
        
        let coloredPath = UIBezierPath(rect: CGRect(origin: .zero, size: CGSize(width: self.frame.width, height: self.frame.height + 40)))
        let transparentPath = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)

        coloredPath.appendPath(transparentPath)
        coloredPath.usesEvenOddFillRule = true

        let fillLayer = CAShapeLayer()
        fillLayer.path = coloredPath.CGPath
        fillLayer.fillRule = kCAFillRuleEvenOdd
        fillLayer.fillColor = backgroundColor.CGColor
        
        return coloredLargeView
    }
    
}