import Foundation
import  UIKit

protocol CoordinatorDelegate: class {
    func didFinish(coordinator: Coordinator)
}

extension CoordinatorDelegate {
    func didFinish(coordinator: Coordinator) {
        coordinator.parent?.pop(child: coordinator)
    }
}

class Coordinator: NSObject {
    // Coordinator's properties are force-unwrapped
    // because nothing should be referenced before
    // `start()` is called.
    var viewController: UIViewController! {
        didSet {
            guard let viewController = viewController else { return }
            if presentModally {
                navigationController.present(viewController, animated: true, completion: nil)
            } else {
                // if our nav stack is just an empty view controller, replace it
                if let first = navigationController.viewControllers.first,
                    navigationController.viewControllers.count == 1,
                    first.isMember(of: UIViewController.self) {
                    navigationController.viewControllers = [viewController]
                } else {
                    navigationController.pushViewController(viewController, animated: true)
                }
            }
        }
    }
    weak var parent: Coordinator?
    let navigationController: NavigationController
    var childCoordinators: [Coordinator] = []
    var presentModally: Bool = false
    
    required init(navigationController: NavigationController, parent: Coordinator?) {
        self.navigationController = navigationController
        super.init()
        parent?.push(child: self)
        if navigationController.viewControllers.isEmpty {
            navigationController.viewControllers = [UIViewController()]
        }
        navigationController.didShowDelegate = navigationController.didShowDelegate ?? self
    }
    
    func start() {
        fatalError("\(type(of: self)) should implement start()!")
    }
    
    func push(child: Coordinator) {
        childCoordinators.append(child)
        child.parent = self
    }
    
    func pop(child: Coordinator) {
        guard let index = childCoordinators.firstIndex(of: child) else {
            assertionFailure("Cannot pop child coordinator \(child) from non-parent \(self)")
            return
        }
        childCoordinators.remove(at: index)
        if child.presentModally {
            child.viewController.dismiss(animated: true, completion: nil)
        } else if let index = child.navigationController.viewControllers.firstIndex(of: child.viewController) {
            child.navigationController.setViewControllers(Array(child.navigationController.viewControllers.prefix(upTo: index)), animated: true)
        }
    }
}

// Make sure that when a navigation controller pops,
// we pop the corresponding coordinator as well
extension Coordinator: UINavigationControllerDelegate {
    func childCoordinatorForViewController(_ viewController: UIViewController) -> Coordinator? {
        if viewController === self.viewController { return self }
        return childCoordinators
            .compactMap({ $0.childCoordinatorForViewController(viewController) })
            .first
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let fromVC = navigationController.transitionCoordinator?.viewController(forKey: .from),
            !navigationController.viewControllers.contains(fromVC) else { return }
        if let fromCoordinator = childCoordinatorForViewController(fromVC) {
            fromCoordinator.parent?.pop(child: fromCoordinator)
        }
    }
}
