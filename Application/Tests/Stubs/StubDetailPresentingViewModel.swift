import RxCocoa

@testable import Application

class StubDetailPresentingViewModel: DetailPresentingViewModel {

    let setupViewModel = BehaviorRelay<DetailViewModel?>(value: nil)

    weak var detailPresenter: DetailPresenter?

    private(set) lazy var presentDetail = makePresentDetail(withFactory: factory) { [unowned self] (viewModel) in
        self.setupViewModel.accept(viewModel)
    }

    let isActive = BehaviorRelay<Bool>(value: false)

    let factory = StubDetailViewModelFactory()

}

class StubDetailViewModelFactory: DetailViewModelFactoryProtocol {

    let makeViewModel = BehaviorRelay<DetailViewModel?>(value: nil)

    func makeDetailViewModel() -> DetailViewModel {
        let viewModel = DetailViewModel(selectionFactory: self, foodTableFactory: self)
        makeViewModel.accept(viewModel)
        return viewModel
    }
}
