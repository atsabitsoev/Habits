//
//  CongratulationView.swift
//  Habits
//
//  Created by Ацамаз Бицоев on 09.11.2020.
//

import UIKit

final class CongratulationView: UIView {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "champagne"))
        //imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    private let verticalStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 36
        stack.alignment = .center
        return stack
    }()
    
    
    init(congratulation: String) {
        super.init(frame: .zero)
        label.text = congratulation
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        setVerticalStackConstraints()
        //setImageViewConstraints()
        super.updateConstraints()
    }
    
    
    private func configureView() {
        backgroundColor = .white
        addSubview(verticalStack)
        verticalStack.addArrangedSubview(imageView)
        verticalStack.addArrangedSubview(label)
        setNeedsUpdateConstraints()
    }
    
}

// MARK: - Constraints
extension CongratulationView {
    private func setVerticalStackConstraints() {
        NSLayoutConstraint.activate([
            verticalStack.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            verticalStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24),
            verticalStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            verticalStack.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
