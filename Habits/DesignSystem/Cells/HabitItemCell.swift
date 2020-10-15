//
//  HabitItemCell.swift
//  Habits
//
//  Created by Ацамаз Бицоев on 15.10.2020.
//

import UIKit

final class HabitItemCell: UITableViewCell {
    
    static let identifier = "HabitItemCell"
    
    private let habitItemView: HabitItemView = {
        let view = HabitItemView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        setHabitItemViewConstraints()
        super.updateConstraints()
    }
    
    
    func setItem(_ item: HabitItem, delegate: HabitItemViewDelegate? = nil) {
        habitItemView.setItem(item, delegate: delegate)
    }
    
    
    private func configureCell() {
        contentView.addSubview(habitItemView)
        selectionStyle = .none
        clipsToBounds = false
        setNeedsUpdateConstraints()
    }
    
    private func setHabitItemViewConstraints() {
        NSLayoutConstraint.activate([
            habitItemView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            habitItemView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            habitItemView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            habitItemView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
}
