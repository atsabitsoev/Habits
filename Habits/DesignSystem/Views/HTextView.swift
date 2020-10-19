//
//  HTextView.swift
//  Habits
//
//  Created by Ацамаз Бицоев on 20.10.2020.
//

import UIKit

final class HTextView: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.adjustsFontSizeToFitWidth = true
        label.text = "Описание"
        return label
    }()
    private let textView: UITextView = {
        let view = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9529411765, alpha: 1)
        view.layer.cornerRadius = 12
        view.font = .systemFont(ofSize: 14)
        view.textContainerInset = UIEdgeInsets(top: 14, left: 16, bottom: 14, right: 16)
        return view
    }()
    
    private lazy var textViewMinimumHeightConstraint = textView.heightAnchor.constraint(greaterThanOrEqualToConstant: 44)
    
    
    init() {
        super.init(frame: .zero)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        setTitleLabelConstraints()
        setTextViewConstraints()
        super.updateConstraints()
    }
    
    
    private func configureView() {
        addSubview(titleLabel)
        addSubview(textView)
        setNeedsUpdateConstraints()
        
        textView.delegate = self
    }
    
    private func setTitleLabelConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            titleLabel.heightAnchor.constraint(equalToConstant: 19)
        ])
    }
    
    private func setTextViewConstraints() {
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            textView.leadingAnchor.constraint(equalTo: leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor),
            textView.bottomAnchor.constraint(equalTo: bottomAnchor),
            textViewMinimumHeightConstraint
        ])
    }
    
    
}


extension HTextView: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        let contentHeight = textView.contentSize.height
        textViewMinimumHeightConstraint.constant = contentHeight
    }
    
}
