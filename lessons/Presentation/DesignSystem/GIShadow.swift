import UIKit

enum GIShadow {
    /// 카드 그림자 적용
    /// - Parameter view: 그림자를 적용할 뷰
    static func card(_ view: UIView) {
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.08
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 8
    }

    /// 버튼 그림자 적용
    /// - Parameter view: 그림자를 적용할 뷰
    static func button(_ view: UIView) {
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.15
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 8
    }
}
