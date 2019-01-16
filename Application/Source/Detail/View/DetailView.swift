import UIKit
import SnapKit

class DetailView: UIView {

    let title = UILabel.centeredLabel()
    let button = UIButton()
    let selectionResult = UILabel.centeredLabel()

    private let spacingView: UIView = {
        let view = UIView()
        view.snp.makeConstraints { $0.height.equalTo(35) }
        return view
    }()

    let contentsListTitle = UILabel.centeredLabel()
    let contentsButton = UIButton()

    private(set) lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            title,
            button,
            selectionResult,
            spacingView,
            contentsListTitle,
            contentsButton
        ])
        stackView.axis = .vertical
        stackView.alignment = .center
        return stackView
    }()

    let requiresConstraintBasedLayout = true

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.center.equalTo(self)
        }
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) { fatalError("\(#function) not implemented.") }

}
