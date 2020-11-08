//
//  CheckItemView.swift
//  Habits
//
//  Created by Ацамаз Бицоев on 28.10.2020.
//

import UIKit

protocol CheckItemViewDelegate {
    func checkboxChanged(newValue: CheckItemView.Value)
}

 
final class CheckItemView: UIView {
    
    struct Value {
        var title: String
        var isChecked: Bool
    }
    
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    private let checkView: RoundCheckboxView = {
        let view = RoundCheckboxView(state: false)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let mainButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let title: String
    private let delegate: CheckItemViewDelegate?
    
    
    init(_ value: Value, delegate: CheckItemViewDelegate? = nil) {
        self.title = value.title
        titleLabel.text = value.title
        checkView.setState(value.isChecked)
        self.delegate = delegate
        super.init(frame: .zero)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        setTitleLabelConstraints()
        setCheckViewConstraints()
        setMainButtonConstraints()
        super.updateConstraints()
    }
    
    
    private func configureView() {
        backgroundColor = .systemBackground
        addSubview(titleLabel)
        addSubview(checkView)
        addSubview(mainButton)
        checkView.setAction(checkboxChanged(_:))
        mainButton.addTarget(self, action: #selector(mainButtonTapped), for: .touchUpInside)
        setNeedsUpdateConstraints()
    }
    
    
    private func checkboxChanged(_ newValue: Bool) {
        delegate?.checkboxChanged(newValue: Value(title: title, isChecked: newValue))
    }
    
    
    @objc private func mainButtonTapped() {
        Vibration.medium.vibrate()
        checkView.setState(!checkView.getState())
    }
    
}

// MARK: - Constraints
extension CheckItemView {
    private func setTitleLabelConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: checkView.leadingAnchor, constant: -8),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])
    }
    
    private func setCheckViewConstraints() {
        NSLayoutConstraint.activate([
            checkView.heightAnchor.constraint(equalToConstant: 24),
            checkView.widthAnchor.constraint(equalToConstant: 24),
            checkView.trailingAnchor.constraint(equalTo: trailingAnchor),
            checkView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    private func setMainButtonConstraints() {
        NSLayoutConstraint.activate([
            mainButton.topAnchor.constraint(equalTo: topAnchor),
            mainButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            mainButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainButton.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
