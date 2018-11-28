import Core

/// A factory for creating view models for detail flow.
///
/// This class' purpose is mainly to clean up dependency injection by taking that reponsibility from classes that should
/// not have knowledge of each of its view model's dependencies.
class DetailViewModelFactory {

    func makeDetailNavigationModel() -> DetailNavigationModel {
        return DetailNavigationModel()
    }

    func makeDetailViewModel() -> DetailViewModel {
        return DetailViewModel()
    }

    func makeSelectionViewModel() -> SelectionViewModel {
        return SelectionViewModel()
    }

}
