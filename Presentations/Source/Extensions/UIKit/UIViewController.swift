import UIKit
import RxCocoa
import RxSwift
import Action

extension Reactive where Base: UIViewController {

    /// Indicates whether the view controller's lifecycle is in between viewWillAppear and viewDidDisappear.
    ///
    /// Replays the last value.
    ///
    /// Initializes with a value determined by base.view.window != nil.
    public var isAppeared: Signal<Bool> {
        let trueOnAppearance = methodInvoked(#selector(UIViewController.viewWillAppear(_:)))
            .map { _ in return true }

        let falseOnDisappearance = methodInvoked(#selector(UIViewController.viewDidDisappear(_:)))
            .map { _ in return false }

        let appearance = Observable
            .deferred { [weak base] () -> Observable<Bool> in
                guard let base = base else {
                    return Observable<Bool>.empty()
                }

                let initial = base.view.window != nil

                return Observable
                    .merge([
                        trueOnAppearance,
                        falseOnDisappearance,
                    ])
                    .startWith(initial)
            }

        return appearance
            .replay(1)
            .asSignal(onErrorRecover: { _ in Signal.empty() })
    }

    /// Sends the UIViewController when the view controller's parent view controller becomes nil.
    public var didMoveToNilParent: Signal<Base> {
        return methodInvoked(#selector(UIViewController.didMove(toParent:)))
            .map { $0.first }
            .filter {
                type(of: $0) == NSNull.self
            }
            .map { [weak base] _ in
                return base
            }
            .filter { $0 != nil }.map { $0! }
            .asSignal(onErrorRecover: { _ in Signal.empty() })
    }

    /// Sends the UIViewController when the view is being dismissed.
    public var didDismiss: Signal<Base> {
        return methodInvoked(#selector(UIViewController.viewWillDisappear(_:)))
            .map { [weak base] _ in
                return base
            }
            .filter { $0 != nil }.map { $0! }
            .filter { $0.isBeingDismissed }
            .asSignal(onErrorRecover: { _ in Signal.empty() })
    }

    /// Sends the UIViewController whenever the view controller's viewDidLoad method is called.
    public var viewDidLoad: Signal<Base> {
        let observer = Observable<Base>.create { [weak base] observer in
            guard let viewController = base else {
                observer.onCompleted()
                return Disposables.create()
            }

            if viewController.isViewLoaded {
                observer.onNext(viewController)
                observer.onCompleted()
                return Disposables.create()
            }

            return self.methodInvoked(#selector(UIViewController.viewDidLoad))
                .take(1)
                .map { [weak viewController] _ in
                    return viewController
                }
                .filter { $0 != nil }.map { $0! }
                .subscribe(observer)
        }

        return observer.asSignal(onErrorRecover: { _ in Signal.empty() })
    }

    /// Sends the UIViewController when the view controller's view's window becomes nil.
    public var didMoveToNilWindow: Signal<Base> {
        return viewDidLoad
            .flatMap { viewController -> Signal<Base> in
                return viewController.view.rx.methodInvoked(#selector(UIView.didMoveToWindow))
                    .map { _ in return viewController }
                    .filter { $0.view.window == nil }
                    .asSignal(onErrorRecover: { _ in Signal.empty() })
            }
    }

    /// The execution signal completes when the view controller's presentation has completed.
    public var present: CompletableAction<(UIViewController, animated: Bool)> {
        let baseViewController = base
        return CompletableAction { (viewController, animated) in
            return Observable.create { [weak baseViewController] observer in
                guard let baseViewController = baseViewController else {
                    observer.onCompleted()
                    return Disposables.create()
                }

                baseViewController.present(viewController, animated: animated, completion: {
                    observer.onCompleted()
                })
                return Disposables.create()
            }

        }
    }

    /// Executed with a Bool representing whether the dismissal should be animated.
    ///
    /// The execution signal completes when the view controller's dismissal has completed.
    public var dismiss: CompletableAction<Bool> {
        let baseViewController = base
        return CompletableAction { animated in
            return Observable.create { [weak baseViewController] observer in
                guard let baseViewController = baseViewController else {
                    observer.onCompleted()
                    return Disposables.create()
                }

                baseViewController.dismiss(animated: animated, completion: {
                    observer.onCompleted()
                })
                return Disposables.create()
            }

        }
    }
}
