//
//  AlertContainerView.swift
//  Habits
//
//  Created by Ацамаз Бицоев on 28.10.2020.
//

import UIKit

final class AlertContainerView: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    private let mainView: UIView
    private let okButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Выбрать", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .green
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        return button
    }()
    
    private var okAction: (() -> ())?
    
    
    init(mainView: UIView, title: String) {
        titleLabel.text = title
        self.mainView = mainView
        super.init(frame: .zero)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        setTitleLabelConstraints()
        setMainViewConstraints()
        setActionButtonConstraints()
        super.updateConstraints()
    }
    
    
    func setAction(_ action: @escaping () -> ()) {
        self.okAction = action
    }
    
    
    private func configureView() {
        backgroundColor = .white
        layer.cornerRadius = 28
        clipsToBounds = true
        
        addSubview(titleLabel)
        addSubview(mainView)
        mainView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(okButton)
        setNeedsUpdateConstraints()
        
        okButton.addTarget(self, action: #selector(okButtonTapped), for: .touchUpInside)
    }
    
    
    @objc private func okButtonTapped() {
        okAction?()
    }
    
}

// MARK: - Constraints
extension AlertContainerView {
    private func setTitleLabelConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }
    
    private func setMainViewConstraints() {
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            mainView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            mainView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            mainView.bottomAnchor.constraint(equalTo: okButton.topAnchor, constant: -24),
        ])
    }
    
    private func setActionButtonConstraints() {
        NSLayoutConstraint.activate([
            okButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            okButton.heightAnchor.constraint(equalToConstant: 40),
            okButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            okButton.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
