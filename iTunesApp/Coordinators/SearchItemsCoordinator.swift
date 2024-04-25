import UIKit

protocol SearchItemsCoordinatorProtocol: AnyObject {
    
    func goToItemDetails(selectedMediaType: MediaType, selectedItem: Item)
    func childDidFinish(childCoordinator: Coordinator)
    
}

final class SearchItemsCoordinator: Coordinator, SearchItemsCoordinatorProtocol {
    
    private(set) var parentCoordinator: Coordinator?
    private(set) var childCoordinators: [Coordinator] = []
    private(set) var navigationController: UINavigationController
    
    init(parentCoordinator: Coordinator, navigationController: UINavigationController) {
        self.parentCoordinator = parentCoordinator
        self.navigationController = navigationController
    }
    
    func start() {
        let presenter = SearchItemsPresenter(coordinator: self)
        let viewController = SearchItemsViewController(presenter: presenter)
        presenter.setView(view: viewController)
        navigationController.setViewControllers([viewController], animated: false)
    }
    
    func goToItemDetails(selectedMediaType: MediaType, selectedItem: Item) {
        let itemDetailsCoordinator = ItemDetailsCoordinator(parentCoordinator: self, navigationController: navigationController, selectedMediaType: selectedMediaType, selectedItem: selectedItem)
        childCoordinators.append(itemDetailsCoordinator)
        itemDetailsCoordinator.start()
    }
    
    func childDidFinish(childCoordinator: Coordinator) {
        if let index = childCoordinators.firstIndex(where: { coordinator in
            return childCoordinator === coordinator
        }) {
            childCoordinators.remove(at: index)
        }
    }
    
}
