import CoreGraphics

enum GIRadius {
    // MARK: - Base

    /// Extra Small: 4pt (뱃지, 태그)
    static let xs: CGFloat = 4

    /// Small: 8pt (버튼, 입력 필드)
    static let sm: CGFloat = 8

    /// Medium: 12pt (카드)
    static let md: CGFloat = 12

    /// Large: 16pt (큰 카드, 모달)
    static let lg: CGFloat = 16

    /// Extra Large: 20pt (바텀 시트)
    static let xl: CGFloat = 20

    /// Full: 9999pt (원형)
    static let full: CGFloat = 9999

    // MARK: - Semantic

    /// 카드: 12pt
    static let card: CGFloat = 12

    /// 버튼: 8pt
    static let button: CGFloat = 8

    /// 입력 필드: 8pt
    static let input: CGFloat = 8

    /// 뱃지: 4pt
    static let badge: CGFloat = 4

    /// 이미지: 8pt
    static let image: CGFloat = 8

    /// 탭 아이템: 16pt
    static let tabItem: CGFloat = 16
}
