import UIKit
import ProgressHUD

final class UIBlockingProgressHUD {
    
    private static var window: UIWindow? {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        return window
    }
    
    static func show() {
            window?.isUserInteractionEnabled = false
            ProgressHUD.show()
    }
    
    static func dismiss() {
       
            window?.isUserInteractionEnabled = true
                  ProgressHUD.dismiss()
                
    }
    
}
