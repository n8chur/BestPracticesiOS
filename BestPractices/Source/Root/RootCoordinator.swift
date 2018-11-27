import UIKit
import Core
import ReactiveCocoa
import ReactiveSwift
import Result

/// The flow coordinator for the root of the application.
///
/// This class is responsible for:
/// - Instantiating the root tab bar controller
/// - Handling presentation of views controllers in the navigation controller
/// - Forwarding view model creation to the view model factory it was initialized with
/// - Forwarding view controller creation to the view controller factory it was initialized with
class RootCoordinator {

    let tabBarController: RootTabBarController

    private let factory: RootCoordinatorFactory
    private let homeCoordinator: HomeCoordinator

    init(factory: RootCoordinatorFactory) {
        self.factory = factory

        homeCoordinator = factory.makeHomeCoordinator()

        let viewModel = factory.viewModel.makeRootTabBarViewModel()
        tabBarController = factory.viewController.makeRootTabBarController(viewModel: viewModel, homeNavigationController: homeCoordinator.navigationController)
    }

}
