import UIKit

extension UIColor {
    convenience init(red: CUnsignedInt, green: CUnsignedInt, blue: CUnsignedInt, a:CUnsignedInt) {
        assert(a >= 0 && a <= 255, "Invalid alpha component")
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: CGFloat(a) / 255.0)
    }
    
    convenience init(colorHex:CUnsignedInt) {
        self.init(red:(colorHex >> 24) & 0xFF, green:(colorHex >> 16) & 0xFF, blue:(colorHex >> 8) & 0xFF, a:(colorHex) & 0xFF)
    }
}
