import UIKit

protocol Coordinator: AnyObject {
    
    var parentCoordinator: Coordinator? { get }
    var childCoordinators: [Coordinator] { get }
    var navigationController: UINavigationController { get }
    func start()
    
}
