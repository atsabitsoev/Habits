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
        stack.spacing = 20
        return stack
    }()
    private let nameView: HTextView = {
        let view = HTextView(title: "Название", placeholder: "Тренировка")
        return view
    }()
    private let pictureButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "runningIcon"), for: .normal)
        return button
    }()
    private let namePictureStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 24
        stack.alignment = .bottom
        return stack
    }()
    private let descriptionView: HTextView = {
        let view = HTextView(title: "Описание", placeholder: "3 подхода по 5 раз")
        return view
    }()
    private let weekDaysView: OptionView = {
        let view = OptionView(title: "Повтор")
        return view
    }()
    private let notificationsView: OptionView = {
        let view = OptionView(title: "Уведомлять")
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
        setPictureButtonConstraints()
        super.updateConstraints()
    }
    
    
    func configureView() {
        backgroundColor = .white
        addSubview(scrollView)
        scrollView.addSubview(mainStackView)
        namePictureStackView.addArrangedSubview(nameView)
        namePictureStackView.addArrangedSubview(pictureButton)
        mainStackView.addArrangedSubview(namePictureStackView)
        mainStackView.setCustomSpacing(10, after: namePictureStackView)
        mainStackView.addArrangedSubview(descriptionView)
        mainStackView.addArrangedSubview(weekDaysView)
        mainStackView.addArrangedSubview(notificationsView)
        
        setNeedsUpdateConstraints()
        addTapRecognizer()
        nameView.tag = 1
        descriptionView.tag = 2
        nameView.delegate = self
        descriptionView.delegate = self
    }
    
    func setValues(
        name: String,
        description: String,
        weekDaysString: String,
        notificationValueString: String
        ) {
        nameView.setText(name)
        descriptionView.setText(description)
        weekDaysView.setNewDetail(weekDaysString)
        notificationsView.setNewDetail(notificationValueString)
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
    
    private func setPictureButtonConstraints() {
        NSLayoutConstraint.activate([
            pictureButton.heightAnchor.constraint(equalToConstant: 40),
            pictureButton.widthAnchor.constraint(equalToConstant: 40)
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

// MARK: - HTextView Delegate
extension HabitEditorView: HTextViewDelegate {
    func textChanged(_ newText: String, tag: Int) {
        switch tag {
        case 1:
            controller.setName(newText)
        case 2:
            controller.setDescription(newText)
        default:
            break
        }
    }
}
