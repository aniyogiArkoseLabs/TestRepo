import UIKit

@available(iOSApplicationExtension, unavailable)
extension UIViewController {

    static func topViewController(_ viewController: UIViewController? = nil) -> UIViewController? {
        let keyWindow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .compactMap({$0 as? UIWindowScene})
                .first?.windows
                .filter({$0.isKeyWindow}).first
        let viewController = viewController ?? keyWindow?.rootViewController

        if let navigationController = viewController as? UINavigationController,
            !navigationController.viewControllers.isEmpty
        {
            return self.topViewController(navigationController.viewControllers.last)

        } else if let tabBarController = viewController as? UITabBarController,
            let selectedController = tabBarController.selectedViewController
        {
            return self.topViewController(selectedController)

        } else if let presentedController = viewController?.presentedViewController {
            return self.topViewController(presentedController)
            
        }

        return viewController
    }
}
