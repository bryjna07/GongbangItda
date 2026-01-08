//
//  SplashViewController.swift
//  lessons
//
//  Created by Watson22_YJ on 12/23/25.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit
import SnapKit
import Then

/// Splash 화면
/// - 앱 로고 표시 및 토큰 유효성 검증 수행
final class SplashViewController: BaseViewController, View {

    // MARK: - Properties
    var disposeBag = DisposeBag()

    /// 화면 전환 완료 콜백
    var onAuthResult: ((Bool) -> Void)?

    // MARK: - UI Components

    private let logoImageView = UIImageView().then {
        $0.image = .icon(GIIcons.bookFill)
        $0.tintColor = .deepSeafoam
        $0.contentMode = .scaleAspectFit
    }

    private let titleLabel = UILabel().then {
        $0.text = "공방잇다"
        $0.font = GIFonts.paperlogyTitle1
        $0.textColor = .gray90
        $0.textAlignment = .center
    }

    private let activityIndicator = UIActivityIndicatorView(style: .medium).then {
        $0.color = .gray60
        $0.hidesWhenStopped = true
    }

    // MARK: - Initialization
    init(reactor: SplashReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 화면 표시 후 토큰 검증 시작
        reactor?.action.onNext(.checkAuthState)
    }

    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .gray0

        view.addSubview(logoImageView)
        view.addSubview(titleLabel)
        view.addSubview(activityIndicator)

        logoImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-40)
            $0.size.equalTo(100)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(logoImageView.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
        }

        activityIndicator.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(32)
            $0.centerX.equalToSuperview()
        }

        activityIndicator.startAnimating()
    }

    // MARK: - Bind
    func bind(reactor: SplashReactor) {
        // 인증 결과에 따라 화면 전환
        reactor.pulse(\.$authResult)
            .compactMap { $0 }
            .asDriver(onErrorDriveWith: .empty())
            .drive(with: self) { owner, isAuthenticated in
                owner.activityIndicator.stopAnimating()
                owner.onAuthResult?(isAuthenticated)
            }
            .disposed(by: disposeBag)
    }
}
