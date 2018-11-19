import UIKit
import SnapKit
import Core

class DetailView: UIView {

    let requiresConstraintBasedLayout = true

    let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    let button: UIButton = {
        let button = UIButton()
        button.setTitleColor(.blue, for: .normal)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .white

        addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalTo(self)
            // Allow label to expand up to leading/trailing margins.
            make.leading.greaterThanOrEqualTo(self.snp.leadingMargin)
            make.trailing.lessThanOrEqualTo(self.snp.trailingMargin)
            // Allow label to expand up to bottom and bottom of safe area.
            make.top.greaterThanOrEqualTo(self.safeAreaLayoutGuide.snp.top)
            make.bottom.lessThanOrEqualTo(self.safeAreaLayoutGuide.snp.bottom)
        }

        addSubview(button)
        button.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.top.equalTo(label.snp.bottom).offset(10)
        }
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) { fatalError("\(#function) not implemented.") }

}