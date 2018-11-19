import ReactiveSwift
import Result
import Core

protocol DetailPresentingViewModel: class {

    var presenter: DetailPresenter? { get set }

    var presentDetails: Action<(), DetailViewModel, NoError> { get }

}

protocol DetailPresenter: class {

    func presentDetails(_ viewModel: DetailViewModel) -> SignalProducer<DetailViewModel, NoError>

}