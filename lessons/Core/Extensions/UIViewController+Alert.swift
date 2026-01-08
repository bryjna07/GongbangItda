//
//  UIViewController+Alert.swift
//  lessons
//
//  Created by Watson22_YJ on 12/19/25.
//

import UIKit

// MARK: - Alert

extension UIViewController {

    /// 기본 알럿 표시 (확인 버튼만)
    /// - Parameters:
    ///   - title: 알럿 제목
    ///   - message: 알럿 메시지
    ///   - confirmTitle: 확인 버튼 제목 (기본값: "확인")
    ///   - confirmHandler: 확인 버튼 탭 시 실행할 클로저
    func showAlert(
        title: String?,
        message: String?,
        confirmTitle: String = "확인",
        confirmHandler: (() -> Void)? = nil
    ) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )

        let confirmAction = UIAlertAction(title: confirmTitle, style: .default) { _ in
            confirmHandler?()
        }
        alert.addAction(confirmAction)

        present(alert, animated: true)
    }

    /// 취소/확인 알럿 표시
    /// - Parameters:
    ///   - title: 알럿 제목
    ///   - message: 알럿 메시지
    ///   - cancelTitle: 취소 버튼 제목 (기본값: "취소")
    ///   - confirmTitle: 확인 버튼 제목 (기본값: "확인")
    ///   - confirmStyle: 확인 버튼 스타일 (기본값: .default)
    ///   - cancelHandler: 취소 버튼 탭 시 실행할 클로저
    ///   - confirmHandler: 확인 버튼 탭 시 실행할 클로저
    func showConfirmAlert(
        title: String?,
        message: String?,
        cancelTitle: String = "취소",
        confirmTitle: String = "확인",
        confirmStyle: UIAlertAction.Style = .default,
        cancelHandler: (() -> Void)? = nil,
        confirmHandler: (() -> Void)? = nil
    ) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )

        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel) { _ in
            cancelHandler?()
        }
        alert.addAction(cancelAction)

        let confirmAction = UIAlertAction(title: confirmTitle, style: confirmStyle) { _ in
            confirmHandler?()
        }
        alert.addAction(confirmAction)

        present(alert, animated: true)
    }

    /// 커스텀 액션 알럿 표시
    /// - Parameters:
    ///   - title: 알럿 제목
    ///   - message: 알럿 메시지
    ///   - actions: 커스텀 UIAlertAction 배열
    func showAlertWithActions(
        title: String?,
        message: String?,
        actions: [UIAlertAction]
    ) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )

        actions.forEach { alert.addAction($0) }

        present(alert, animated: true)
    }

    /// 액션 시트 표시 (여러 선택지)
    /// - Parameters:
    ///   - title: 액션 시트 제목
    ///   - message: 액션 시트 메시지
    ///   - actions: 액션 배열
    ///   - includeCancel: 취소 버튼 포함 여부 (기본값: true)
    func showActionSheet(
        title: String?,
        message: String?,
        actions: [UIAlertAction],
        includeCancel: Bool = true
    ) {
        let actionSheet = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .actionSheet
        )

        actions.forEach { actionSheet.addAction($0) }

        if includeCancel {
            let cancelAction = UIAlertAction(title: GIStrings.Common.cancel, style: .cancel)
            actionSheet.addAction(cancelAction)
        }

        present(actionSheet, animated: true)
    }
}
