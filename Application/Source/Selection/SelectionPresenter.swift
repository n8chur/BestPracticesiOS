import RxSwift
import Action
import Presentations

protocol SelectionPresentingViewModel: AnyObject, PresentingViewModel {
    var selectionPresenter: SelectionPresenter? { get set }
    var presentSelection: Action<Bool, SelectionViewModel> { get }
}

extension SelectionPresentingViewModel {

    /// Makes an action that is suitable to be set as the presentSelection action.
    ///
    /// - Parameter factory: A factory to be used to generate the presented view model.
    /// - Parameter defaultValue: A closure that provides the default value of the selection input.
    /// - Parameter setupViewModel: This closure will be called with the presented view model when a present action
    ///             is executed. Consumers can use this to observe changes to the presented view model if necessary.
    func makePresentSelection(
        withFactory factory: SelectionViewModelFactoryProtocol,
        defaultValue: (() -> String?)? = nil,
        setupViewModel: ((SelectionViewModel) -> Void)? = nil
    ) -> Action<Bool, SelectionViewModel> {
        return makePresentAction { [weak self] animated -> DismissablePresentationContext<SelectionViewModel>? in
            guard
                let self = self,
                let presenter = self.selectionPresenter else {
                    return nil
            }

            let value = defaultValue?()
            let viewModel = factory.makeSelectionViewModel(withDefaultValue: value)

            setupViewModel?(viewModel)

            let presentation = presenter.selectionPresentation(of: viewModel)

            return ResultPresentationContext(presentation: presentation, viewModel: viewModel, presentAnimated: animated)
        }
    }

}

protocol SelectionPresenter: AnyObject {
    func selectionPresentation(of viewModel: SelectionViewModel) -> DismissablePresentation
}
