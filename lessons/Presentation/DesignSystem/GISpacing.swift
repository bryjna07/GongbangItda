import CoreGraphics

enum GISpacing {
    // MARK: - Base (4pt 단위)

    /// Extra Small: 4pt
    static let xs: CGFloat = 4

    /// Small: 8pt
    static let sm: CGFloat = 8

    /// Medium: 12pt
    static let md: CGFloat = 12

    /// Large: 16pt
    static let lg: CGFloat = 16

    /// Extra Large: 20pt
    static let xl: CGFloat = 20

    /// Extra Extra Large: 24pt
    static let xxl: CGFloat = 24

    /// Extra Extra Extra Large: 32pt
    static let xxxl: CGFloat = 32

    /// Section: 36pt
    static let section: CGFloat = 36

    // MARK: - Screen

    /// 화면 좌우 여백: 16pt
    static let screenHorizontal: CGFloat = 16

    /// 화면 상단 여백: 16pt
    static let screenTop: CGFloat = 16

    // MARK: - Component

    /// 셀 가로 간격: 8pt
    static let cellGapHorizontal: CGFloat = 8

    /// 셀 세로 간격: 12pt
    static let cellGapVertical: CGFloat = 12

    /// 섹션 헤더 하단 간격: 8pt
    static let sectionHeaderGap: CGFloat = 8

    /// 버튼 가로 패딩: 16pt
    static let buttonPaddingH: CGFloat = 16

    /// 버튼 세로 패딩: 12pt
    static let buttonPaddingV: CGFloat = 12
}
