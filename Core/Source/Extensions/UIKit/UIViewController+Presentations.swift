import UIKit
import ReactiveCocoa
import ReactiveSwift
import Result

public extension UIViewController {

    public func makeModalPresentation<ViewController: UIViewController>(of viewController: ViewController) -> DismissablePresentation<ViewController> {
        let present: DismissablePresentation<ViewController>.MakePresent = { [weak self] (viewController, animated) in
            guard let self = self else { fatalError() }

            return self.reactive.present.apply((viewController, animated))
                .flatMapError { _ in return SignalProducer<Never, NoError>.empty }
        }

        let dismiss: DismissablePresentation<ViewController>.MakeDismiss = { (viewController, animated) in
            return viewController.reactive.dismiss.apply(animated)
                .flatMapError { _ in return SignalProducer<Never, NoError>.empty }
        }

        let didDismiss = viewController.reactive.didDismiss.map { _ in return () }

        let presentation = DismissablePresentation(
            presentedViewController: viewController,
            present: present,
            dismiss: dismiss,
            didDismiss: didDismiss)

        // Retain the presentation for its lifecycle.
        presentation.didDismiss.producer
            .untilDisposal(retain: presentation)
            .take(duringLifetimeOf: viewController)
            .take(duringLifetimeOf: self)
            .start()

        return presentation
    }

}

public extension DismissablePresentation {

    /// Sets the left navigation item to be a cancel button that executes the dimiss action.
    ///
    /// - Parameter animated: The view controller to add the navigation item to.
    /// - Parameter animated: The Bool value to execute the dismiss action with when the cancel button is pressed.
    public func addCancelBarButtonItem(to viewController: UIViewController, animated: Bool) {
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: nil)
        cancelButton.reactive.pressed = CocoaAction(dismiss, input: animated)
        viewController.navigationItem.leftBarButtonItem = cancelButton
    }

}
