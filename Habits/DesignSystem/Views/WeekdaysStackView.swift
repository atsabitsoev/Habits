//
//  StackCheckItemView.swift
//  Habits
//
//  Created by Ацамаз Бицоев on 28.10.2020.
//

import UIKit

final class WeekdaysStackView: UIStackView {
    // TODO: заменить на enum
    private let weekDaysTitles = ["Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Суббота", "Воскресенье"]
    
    private let weekDays: [Int]
    private var checkedWeekDays: [Int]
    
    private var weekDayCheckedAction: ((Int, Bool) -> ())?
    
    
    init(weekDays: [Int], checkedWeekDays: [Int]) {
        self.weekDays = weekDays
        self.checkedWeekDays = checkedWeekDays
        super.init(frame: .zero)
        configureView()
        setupArrangedSubviews()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setAction(_ action: @escaping ((Int, Bool) -> ())) {
        self.weekDayCheckedAction = action
    }
    
    func setCheckedWeekDays(_ weekDays: [Int]) {
        self.checkedWeekDays = weekDays
        setupArrangedSubviews()
    }
    
    
    private func configureView() {
        backgroundColor = .systemBackground
        axis = .vertical
        spacing = 0
    }
    
    private func setupArrangedSubviews() {
        arrangedSubviews.forEach { (view) in
            removeArrangedSubview(view)
        }
        for weekDay in weekDays {
            let checkItemView = CheckItemView(
                CheckItemView.Value(
                    title: weekDaysTitles[weekDay],
                    isChecked: checkedWeekDays.contains(weekDay)
                ),
                delegate: self
            )
            addArrangedSubview(checkItemView)
        }
    }
}

// MARK: CheckItemView Delegate
extension WeekdaysStackView: CheckItemViewDelegate {
    func checkboxChanged(newValue: CheckItemView.Value) {
        guard let changedWeekDay = weekDaysTitles.firstIndex(of: newValue.title) else { return }
        weekDayCheckedAction?(changedWeekDay, newValue.isChecked)
    }
    
    
}
