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
    
    private let placeholder: String
    private lazy var isPlaceholderShown = true {
        didSet {
            setPlaceholder(isPlaceholderShown)
        }
    }
    
    
    init(title: String, placeholder: String) {
        titleLabel.text = title
        self.placeholder = placeholder
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
    
    
    func setText(_ text: String) {
        textView.text = text
    }
    
    
    private func configureView() {
        addSubview(titleLabel)
        addSubview(textView)
        setNeedsUpdateConstraints()
        setPlaceholder(true)
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
    
    private func setPlaceholder(_ isPlaceholderShown: Bool) {
        if isPlaceholderShown {
            textView.textColor = .placeholderText
            textView.text = placeholder
        } else {
            textView.text = ""
            textView.textColor = .label
        }
    }
    
}


extension HTextView: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        let contentHeight = textView.contentSize.height
        textViewMinimumHeightConstraint.constant = contentHeight
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        isPlaceholderShown = false
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        isPlaceholderShown = textView.text.isEmpty
    }
    
}
