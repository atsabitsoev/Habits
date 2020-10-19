//
//  HabitEditorView.swift
//  Habits
//
//  Created by Ацамаз Бицоев on 19.10.2020.
//

import UIKit

final class HabitEditorView: UIView, HabitEditorViewing {
    
    private let controller: HabitEditorControlling
    
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    private let mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 10
        return stack
    }()
    private let descriptionView: HTextView = {
        let view = HTextView()
        return view
    }()
    
    
    init(controller: HabitEditorControlling) {
        self.controller = controller
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        setScrollViewConstraints()
        setMainStackViewConstraints()
        super.updateConstraints()
    }
    
    
    func configureView() {
        backgroundColor = .white
        addSubview(scrollView)
        scrollView.addSubview(mainStackView)
        mainStackView.addArrangedSubview(descriptionView)
        setNeedsUpdateConstraints()
        
        addTapRecognizer()
    }
    
    
    private func setScrollViewConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    private func setMainStackViewConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 34),
            mainStackView.bottomAnchor.constraint(greaterThanOrEqualTo: scrollView.bottomAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 34),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -34)
        ])
    }
    
    private func addTapRecognizer() {
        let rec = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        addGestureRecognizer(rec)
    }
    
    
    @objc private func viewTapped() {
        endEditing(true)
    }
    
}
