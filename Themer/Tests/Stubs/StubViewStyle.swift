import Foundation
import Themer
import RxSwift

struct StubViewStyle: Style {
    typealias Styleable = StubView

    let themeName: String

    init(theme: StubTheme) {
        switch theme {
        case .light:
            themeName = "light"
        case .dark:
            themeName = "dark"
        }
    }

    func apply(to styleable: StubView) {
        styleable.themeName = themeName
    }

}

class StubView: ReactiveCompatible {
    var themeName: String?
}
