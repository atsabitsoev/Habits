//
//  HabitEditorView.swift
//  Habits
//
//  Created by Ацамаз Бицоев on 19.10.2020.
//

import UIKit

final class HabitEditorView: UIView, HabitEditorViewing {
    
    private unowned let controller: HabitEditorControlling
    
    
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
        view.setNewDetail("Пн Вт Ср Чт Пт Сб Вс")
        return view
    }()
    private let notificationsView: OptionView = {
        let view = OptionView(title: "Уведомлять")
        return view
    }()
    
    private var selectWeekDayView = WeekdaysStackView(weekDays: [0,1,2,3,4,5,6], checkedWeekDays: [0,1,2,3,4,5,6])
    private let selectImageView = SelectImageView()
    
    
    private lazy var weekDaysViewDetail = weekDaysView.getDetail()
    
    
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
        backgroundColor = .systemBackground
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
        pictureButton.addTarget(self, action: #selector(pictureButtonTapped), for: .touchUpInside)
        nameView.tag = 1
        descriptionView.tag = 2
        nameView.delegate = self
        descriptionView.delegate = self
        selectImageView.delegate = self
        
        selectWeekDayView.setAction { [weak self] (weekDay, checked) in
            self?.selectWeekDayViewAction(weekDay: weekDay, checked: checked)
        }
        weekDaysView.setAction { [weak self] in
            self?.weekDaysViewAction()
        }
        notificationsView.setAction { [weak self] in
            self?.notificationsViewAction()
        }
    }
    
    func setValues(
        name: String?,
        description: String?,
        image: HabitImage,
        weekDays: [Int]?,
        notificationValueString: String?
        ) {
        if let name = name {
            nameView.setText(name)
        }
        if let description = description {
            descriptionView.setText(description)
        }
        pictureButton.setImage(UIImage(named: image.rawValue), for: .normal)
        selectImageView.setSelectedImage(image)
        weekDaysView.setNewDetail(getWeekDaysString(fromInts: weekDays ?? []))
        selectWeekDayView.setCheckedWeekDays(weekDays ?? [])
        notificationsView.setNewDetail(notificationValueString ?? "Нет")
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
    
    
    private func weekDaysViewAction() {
        let alert = AlertContainerViewController(mainView: self.selectWeekDayView, title: "Повтор")
        alert.modalPresentationStyle = .overCurrentContext
        alert.modalTransitionStyle = .crossDissolve
        self.controller.navigationController?.present(alert, animated: true, completion: nil)
    }
    
    private func notificationsViewAction() {
        let picker = UIDatePicker()
        picker.datePickerMode = .time
        picker.locale = Locale(identifier: "ru_RU")
        picker.tintColor = UIColor.label
        if #available(iOS 13.4, *) {
            picker.preferredDatePickerStyle = .wheels
        }
        let alert = AlertContainerViewController(mainView: picker, title: "Уведомлять")
        alert.modalPresentationStyle = .overCurrentContext
        alert.modalTransitionStyle = .crossDissolve
        alert.setOkAction(title: "Выбрать") { [weak self] in
            let timeString = picker.date.timeString()
            self?.controller.setNotificationTime(timeString)
            self?.notificationsView.setNewDetail(timeString)
        }
        alert.setDestructiveAction(title: "Не уведомлять") { [weak self] in
            self?.controller.setNotificationTime(nil)
            self?.notificationsView.setNewDetail("Нет")
        }
        picker.date = notificationsView.getDetail().timeDate() ?? Date()
        self.controller.navigationController?.present(alert, animated: true, completion: nil)
        
    }
    
    private func selectWeekDayViewAction(weekDay: Int, checked: Bool) {
        let weekDaysStrings = ["Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"]
        if checked {
            self.controller.addWeekDayToRepeat(weekDay)
            let currentWeekDayString = weekDaysStrings[weekDay]
            var oldWeekDayStrings = self.weekDaysViewDetail.split(separator: " ").map({String($0)})
            oldWeekDayStrings.append(currentWeekDayString)
            self.weekDaysViewDetail = oldWeekDayStrings.sorted(by: {(weekDaysStrings.firstIndex(of: $0) ?? 0) < (weekDaysStrings.firstIndex(of: $1) ?? 0)}).joined(separator: " ")
            self.weekDaysView.setNewDetail(self.weekDaysViewDetail)
        } else {
            self.controller.deleteWeekDayToRepeat(weekDay)
            var oldWeekDayStrings = self.weekDaysViewDetail.split(separator: " ").map({String($0)})
            oldWeekDayStrings.remove(at: oldWeekDayStrings.firstIndex(of: weekDaysStrings[weekDay])!)
            self.weekDaysViewDetail = oldWeekDayStrings.joined(separator: " ")
            self.weekDaysView.setNewDetail(self.weekDaysViewDetail)
        }
    }
    
    private func getWeekDaysString(fromInts weekDaysInts: [Int]) -> String {
        if weekDaysInts.count == 0 { return "Никогда" }
        let weekDaysStrings = weekDaysInts.compactMap { (weekDayInt) -> String? in
            switch weekDayInt {
            case 0:
                return "Пн"
            case 1:
                return "Вт"
            case 2:
                return "Ср"
            case 3:
                return "Чт"
            case 4:
                return "Пт"
            case 5:
                return "Сб"
            case 6:
                return "Вс"
            default:
                return nil
            }
        }
        return weekDaysStrings.joined(separator: " ")
    }
    
    
    @objc private func viewTapped() {
        endEditing(true)
    }
    
    @objc private func pictureButtonTapped() {
        let alert = AlertContainerViewController(mainView: selectImageView, title: "Иконка")
        alert.modalTransitionStyle = .crossDissolve
        alert.modalPresentationStyle = .overCurrentContext
        self.controller.navigationController?.present(alert, animated: true, completion: nil)
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

// MARK: - SelectImageView Delegate
extension HabitEditorView: SelectImageViewDelegate {
    func imageSelected(_ image: HabitImage) {
        controller.setImage(image)
        pictureButton.setImage(UIImage(named: image.rawValue), for: .normal)
    }
}
