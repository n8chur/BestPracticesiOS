import ReactiveSwift
import Result
import Presentations

@testable import Application

class StubSelectionPresenter {

    let makeSelectionViewModelCall = MutableProperty<SelectionViewModel?>(nil)
    let selectionPresentationContext = MutableProperty<SelectionViewModel?>(nil)

}

extension StubSelectionPresenter: SelectionPresenter {

    func makeSelectionViewModel() -> SelectionViewModel {
        let viewModel = SelectionViewModel()
        makeSelectionViewModelCall.value = viewModel
        return viewModel
    }

    func selectionPresentationContext(of viewModel: SelectionViewModel) -> DismissablePresentationContext {
        selectionPresentationContext.value = viewModel
        return DismissablePresentationContext.stub()
    }

}