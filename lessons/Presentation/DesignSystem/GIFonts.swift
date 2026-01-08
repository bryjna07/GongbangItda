import UIKit

enum GIFonts {
    // MARK: - Font Names

    private enum FontName {
        static let pretendardBold = "Pretendard-Bold"
        static let pretendardSemiBold = "Pretendard-SemiBold"
        static let pretendardMedium = "Pretendard-Medium"
        static let pretendardRegular = "Pretendard-Regular"
        static let paperlogyBlack = "Paperlogy-9Black"
    }

    // MARK: - Pretendard

    /// Pretendard Bold 20pt
    static let pretendardTitle1 = font(FontName.pretendardBold, size: 20, fallback: .bold)

    /// Pretendard Medium 16pt
    static let pretendardBody1 = font(FontName.pretendardMedium, size: 16, fallback: .medium)

    /// Pretendard Medium 14pt
    static let pretendardBody2 = font(FontName.pretendardMedium, size: 14, fallback: .medium)

    /// Pretendard Medium 13pt
    static let pretendardBody3 = font(FontName.pretendardMedium, size: 13, fallback: .medium)
    
    /// Pretendard Bold 13pt
    static let pretendardBody3Bold = font(FontName.pretendardBold, size: 13, fallback: .medium)

    /// Pretendard Regular 12pt
    static let pretendardCaption1 = font(FontName.pretendardRegular, size: 12, fallback: .regular)
    
    /// Pretendard SemiBold 12pt
    static let pretendardCaption1SemiBold = font(FontName.pretendardSemiBold, size: 12, fallback: .regular)
    
    /// Pretendard Medium 12pt
    static let pretendardCaption1Medium = font(FontName.pretendardMedium, size: 12, fallback: .regular)
    
    /// Pretendard Regular 10pt
    static let pretendardCaption2 = font(FontName.pretendardRegular, size: 10, fallback: .regular)

    /// Pretendard Regular 8pt
    static let pretendardCaption3 = font(FontName.pretendardRegular, size: 8, fallback: .regular)

    // MARK: - Paperlogy

    /// Paperlogy Black 26pt
    static let paperlogyTitle1 = font(FontName.paperlogyBlack, size: 26, fallback: .bold)

    /// Paperlogy Black 22pt
    static let paperlogyBody1 = font(FontName.paperlogyBlack, size: 22, fallback: .bold)

    /// Paperlogy Black 14pt
    static let paperlogyCaption1 = font(FontName.paperlogyBlack, size: 14, fallback: .bold)

    // MARK: - Semantic (기본 Pretendard 사용)

    /// 제목 1: Pretendard Bold 20pt
    static let title1 = pretendardTitle1

    /// 본문 1: Pretendard Medium 16pt
    static let body1 = pretendardBody1

    /// 본문 2: Pretendard Medium 14pt
    static let body2 = pretendardBody2

    /// 본문 3: Pretendard Medium 13pt
    static let body3 = pretendardBody3
    
    /// 본문 3: Pretendard Bold 13pt
    static let body3Bold = pretendardBody3Bold

    /// 캡션 1 SemiBold: Pretendard SemiBold 12pt
    static let caption1SemiBold = pretendardCaption1SemiBold
    
    /// 캡션 1: Pretendard Medium 12pt
    static let caption1Medium = pretendardCaption1Medium
    
    /// 캡션 1: Pretendard Regular 12pt
    static let caption1 = pretendardCaption1
    
    /// 캡션 2: Pretendard Regular 10pt
    static let caption2 = pretendardCaption2

    /// 캡션 3: Pretendard Regular 8pt
    static let caption3 = pretendardCaption3

    // MARK: - Helper

    /// 폰트 생성 헬퍼 (폰트가 없으면 시스템 폰트로 폴백)
    private static func font(_ name: String, size: CGFloat, fallback weight: UIFont.Weight) -> UIFont {
        return UIFont(name: name, size: size) ?? .systemFont(ofSize: size, weight: weight)
    }
}
