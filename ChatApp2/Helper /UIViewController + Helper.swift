
import UIKit

extension UIViewController {
static func createViewController (with storyboard: String) -> Self? {
    let storyboard = UIStoryboard(name: storyboard, bundle: Bundle.main)
    let identifierOfTheClassSelf = String(describing: self)
    let viewController = storyboard.instantiateViewController(withIdentifier: identifierOfTheClassSelf) as? Self
    return viewController
}
    
    static func viewControllerWithStoryboard () -> Self? {
        return createViewController(with: "Main")
    }
    
    
    
}
