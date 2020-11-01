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
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.Button.accentColor
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        return button
    }()
    private let destructiveButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .red
        button.isHidden = true
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        return button
    }()
    private let actionButtonsStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 0
        return stack
    }()
    
    private var okAction: (() -> ())?
    private var destructiveAction: (() -> ())?
    
    
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
        setActionButtonsStackConstraints()
        setActionButtonsConstraints()
        super.updateConstraints()
    }
    
    
    func setOkAction(title: String, _ action: @escaping () -> ()) {
        okButton.setTitle(title, for: .normal)
        self.okAction = action
    }
    
    func setDestructiveAction(title: String, _ action: @escaping () -> ()) {
        destructiveButton.setTitle(title, for: .normal)
        self.destructiveAction = action
        destructiveButton.isHidden = false
    }
    
    
    private func configureView() {
        backgroundColor = .systemBackground
        layer.cornerRadius = 28
        clipsToBounds = true
        
        addSubview(titleLabel)
        addSubview(mainView)
        mainView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(actionButtonsStack)
        actionButtonsStack.addArrangedSubview(okButton)
        actionButtonsStack.addArrangedSubview(destructiveButton)
        setNeedsUpdateConstraints()
        
        okButton.addTarget(self, action: #selector(okButtonTapped), for: .touchUpInside)
        destructiveButton.addTarget(self, action: #selector(destructiveButtonTapped), for: .touchUpInside)
    }
    
    
    @objc private func okButtonTapped() {
        okAction?()
    }
    
    @objc private func destructiveButtonTapped() {
        destructiveAction?()
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
    
    private func setActionButtonsStackConstraints() {
        NSLayoutConstraint.activate([
            actionButtonsStack.bottomAnchor.constraint(equalTo: bottomAnchor),
            actionButtonsStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            actionButtonsStack.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    private func setActionButtonsConstraints() {
        NSLayoutConstraint.activate([
            okButton.heightAnchor.constraint(equalToConstant: 40),
            destructiveButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
