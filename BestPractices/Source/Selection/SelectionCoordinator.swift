import UIKit
import Core
import ReactiveSwift
import Result

class SelectionCoordinator: Coordinator {

    typealias ViewModel = SelectionViewModel
    typealias StartError = SelectionPresentError

    private weak var presentingViewController: UIViewController?

    init(presentingViewController: UIViewController) {
        self.presentingViewController = presentingViewController
    }

    private(set) lazy var start = Action<ViewModel, (), StartError> { [weak self] viewModel in
        return SignalProducer<SelectionViewController, NoError> { SelectionViewController(viewModel: viewModel) }
            .map(UINavigationController.init)
            .flatMap(.merge) { navigationController -> SignalProducer<(), ActionError<NoError>> in
                guard
                    let strongSelf = self,
                    let presentingViewController = strongSelf.presentingViewController else {
                        fatalError()
                }

                let dismissOnSubmission = viewModel.submit.values
                    .take(first: 1)
                    .producer
                    .then(navigationController.reactive.dismiss.apply(true))
                    .then(SignalProducer(value: navigationController))

                let didDismiss = navigationController.reactive
                    .didDismiss
                    .take(first: 1)
                    .producer

                let dismissal = SignalProducer
                    .merge([
                        didDismiss.promoteError(ActionError<NoError>.self),
                        dismissOnSubmission,
                    ])
                    .take(first: 1)
                    .ignoreValues()

                return presentingViewController.reactive.present.apply((navigationController, true))
                    .then(dismissal)
            }
            .mapError { _ in return .unknown }
    }
}

extension SelectionCoordinator {

    static func selectionPresentation(over viewController: UIViewController, for viewModel: SelectionViewModel) -> SignalProducer<(), SelectionPresentationError> {
        return SignalProducer<SelectionCoordinator, NoError> { SelectionCoordinator(presentingViewController: viewController) }
            .flatMap(.merge) { coordinator in
                return coordinator.start.apply(viewModel)
                    .untilDisposal(retain: coordinator)
            }
            .ignoreValues()
            .mapError { _ in return .unknown }
    }

}
