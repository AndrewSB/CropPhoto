import UIKit

// private class so you can filter subviews without setting a tag
private class MaskView: UIView {}

extension CropPhoto.View {
    
    func removeMask() {
        subviews.filter { $0 is MaskView }.forEach { $0.removeFromSuperview() }
    }
    
}

extension CropPhoto.View {
    
    var defaultCropRect: CGRect {
        let fractionalWidth = self.frame.size.width * 0.85
        let fractionalHeight = fractionalWidth * 0.65
        
        return CGRect(
            origin: CGPoint(x: (self.frame.size.width - fractionalWidth) / 2, y: self.frame.size.height * 0.18),
            size: CGSize(width: fractionalWidth, height: fractionalHeight)
        )
    }
    
    func maskView(withTransparentRect rect: CGRect? = nil,
                                      backgroundColor: UIColor = UIColor(white:  0.173, alpha: 0.94),
                                      cornerRadius: CGFloat = 10)-> UIView {
        
        let coloredLargeView = MaskView(frame: self.frame)
        coloredLargeView.backgroundColor = .clear
        coloredLargeView.isUserInteractionEnabled = false
        
        let coloredPath = UIBezierPath(rect: CGRect(origin: .zero, size: CGSize(width: self.frame.width, height: self.frame.height + 40)))
        let transparentPath = UIBezierPath(roundedRect: rect ?? defaultCropRect, cornerRadius: cornerRadius)

        coloredPath.append(transparentPath)
        coloredPath.usesEvenOddFillRule = true

        let fillLayer = CAShapeLayer()
        fillLayer.path = coloredPath.cgPath
        fillLayer.fillRule = kCAFillRuleEvenOdd
        fillLayer.fillColor = backgroundColor.cgColor
        
        coloredLargeView.layer.addSublayer(fillLayer)
        return coloredLargeView
    }
    
}
