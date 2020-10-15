//
//  HabitListView.swift
//  Habits
//
//  Created by Ацамаз Бицоев on 16.10.2020.
//

import UIKit

final class HabitListView: UIView, HabitListViewing {
    
    private unowned let controller: HabitListControlling
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private var habitItems = [
        HabitItem(
            id: 1,
            name: "Тренировка",
            description: "Карина самая красивая девочка на планете Земля",
            image: .sport,
            dayCount: 2,
            todayDone: false
        ),
        HabitItem(
            id: 2,
            name: "Учеба",
            description: "Учебу я люблю очень сильно и карину (еще сильнее)",
            image: .sport,
            dayCount: 30,
            todayDone: false
        )
    ]
    
    
    init(controller: HabitListControlling) {
        self.controller = controller
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        setTableViewConstraints()
        super.updateConstraints()
    }
    
    
    func configureView() {
        backgroundColor = .white
        setNeedsUpdateConstraints()
        configureTableView()
    }
    
    
    private func configureTableView() {
        addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(HabitItemCell.self, forCellReuseIdentifier: HabitItemCell.identifier)
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
    }
    
    private func setTableViewConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
}


extension HabitListView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return habitItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentItem = habitItems[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: HabitItemCell.identifier) as! HabitItemCell
        cell.setItem(currentItem, delegate: self)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentItem = habitItems[indexPath.row]
        var newItem = currentItem
        newItem.isShownFullDescription = !newItem.isShownFullDescription
        habitItems[indexPath.row] = newItem
        tableView.reloadRows(at: [indexPath], with: .fade)
    }
    
}


extension HabitListView: HabitItemViewDelegate {
    func dayCountChanged(itemId id: Int, newDayCount: Int, todayDone: Bool) {
        if let indexOfChangedItem = habitItems.firstIndex(where: { (item) -> Bool in
            return item.id == id
        }) {
            let currentItem = habitItems[indexOfChangedItem]
            var newItem = currentItem
            newItem.dayCount = newDayCount
            newItem.todayDone = todayDone
            habitItems[indexOfChangedItem] = newItem
        }
    }
}
