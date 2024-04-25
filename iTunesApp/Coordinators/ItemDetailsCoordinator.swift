import UIKit

protocol ItemDetailsCoordinatorProtocol: AnyObject {
    
    func backToSearchItems()
    
}

final class ItemDetailsCoordinator: Coordinator, ItemDetailsCoordinatorProtocol {
    
    private(set) var parentCoordinator: Coordinator?
    private(set) var childCoordinators: [Coordinator] = []
    private(set) var navigationController: UINavigationController
    private let selectedItem: Item
    private let selectedMediaType: MediaType
    
    init(parentCoordinator: Coordinator, navigationController: UINavigationController, selectedMediaType: MediaType, selectedItem: Item) {
        self.parentCoordinator = parentCoordinator
        self.navigationController = navigationController
        self.selectedMediaType = selectedMediaType
        self.selectedItem = selectedItem
    }
    
    func start() {
        let presenter = ItemDetailsPresenter(coordinator: self, selectedMediaType: selectedMediaType, selectedItem: selectedItem)
        let viewController = ItemDetailsViewController(presenter: presenter)
        presenter.setView(view: viewController)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func backToSearchItems() {
        guard let parent = parentCoordinator as? SearchItemsCoordinator else { return }
        parent.childDidFinish(childCoordinator: self)
    }
    
}
