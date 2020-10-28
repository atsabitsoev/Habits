//
//  OptionView.swift
//  Habits
//
//  Created by Ацамаз Бицоев on 25.10.2020.
//

import UIKit

final class OptionView: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    private let detailLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.secondaryLabel
        label.text = "Нет"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .right
        return label
    }()
    private let arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "arrowRight")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .secondaryLabel
        return imageView
    }()
    private let horizontalStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 8
        return stack
    }()
    private let mainButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private let shadowView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 8
        view.layer.shadowOpacity = 0.1
        view.layer.cornerRadius = 12
        return view
    }()
    
    private var action: (() -> ())?
    
    
    init(title: String) {
        titleLabel.text = title
        super.init(frame: .zero)
        configureView()
    }
    
    
    func getDetail() -> String {
        return detailLabel.text ?? ""
    }
    
    func setNewDetail(_ detail: String) {
        detailLabel.text = detail
    }
    
    func setAction(_ action: @escaping () -> ()) {
        self.action = action
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        setHorizontalStackConstraints()
        setShadowViewConstraints()
        setMainButtonConstraints()
        setArrowImageViewConstraints()
        super.updateConstraints()
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        newSuperview?.addSubview(shadowView)
    }
    
    
    private func configureView() {
       layer.cornerRadius = 12
        horizontalStackView.addArrangedSubview(titleLabel)
        horizontalStackView.addArrangedSubview(detailLabel)
        horizontalStackView.addArrangedSubview(arrowImageView)
        addSubview(horizontalStackView)
        addSubview(mainButton)
        setNeedsUpdateConstraints()
        
        mainButton.addTarget(self, action: #selector(mainButtonTapped), for: .touchUpInside)
    }
    
    
    @objc private func mainButtonTapped() {
        action?()
    }
    
}

// MARK: - Constraints
extension OptionView {
    private func setHorizontalStackConstraints() {
        NSLayoutConstraint.activate([
            horizontalStackView.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            horizontalStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
            horizontalStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            horizontalStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
    
    private func setShadowViewConstraints() {
        NSLayoutConstraint.activate([
            shadowView.topAnchor.constraint(equalTo: topAnchor),
            shadowView.bottomAnchor.constraint(equalTo: bottomAnchor),
            shadowView.leadingAnchor.constraint(equalTo: leadingAnchor),
            shadowView.trailingAnchor.constraint(equalTo: trailingAnchor)
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
    
    private func setArrowImageViewConstraints() {
        NSLayoutConstraint.activate([
            arrowImageView.widthAnchor.constraint(equalToConstant: 10)
        ])
    }
}
