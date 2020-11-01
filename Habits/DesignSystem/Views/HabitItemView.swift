//
//  HabitItemView.swift
//  Habits
//
//  Created by Ацамаз Бицоев on 15.10.2020.
//

import UIKit


protocol HabitItemViewDelegate: class {
    func dayCountChanged(itemId id: String, newDayCount: Int, todayDone: Bool)
}


final class HabitItemView: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .secondaryLabel
        label.numberOfLines = 2
        return label
    }()
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private let progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.progressTintColor = UIColor.Button.accentColor
        progressView.trackTintColor = .clear
        return progressView
    }()
    private let checkboxView: RoundCheckboxView = {
        let checkboxView = RoundCheckboxView()
        checkboxView.translatesAutoresizingMaskIntoConstraints = false
        return checkboxView
    }()
    private let verticalStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        return stack
    }()
    private let horizontalStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 24
        return stack
    }()
    private let shadowView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.layer.shadowOpacity = 0.1
        view.layer.cornerRadius = 24
        return view
    }()
    
    private weak var delegate: HabitItemViewDelegate?
    private var item: HabitItem = HabitItem(id: "", name: "", image: HabitImage.sport, dayCount: 0, todayDone: false)
    private let levelColors: [UIColor] = [UIColor.Levels.first, UIColor.Levels.second, UIColor.Levels.third, UIColor.Levels.fourth]
    private var initialState: Bool = false
    private var actionToCheckboxAlreadySet = false
    
    
    init() {
        super.init(frame: .zero)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        setProgressViewConstraints()
        setHorizontalStackConstraints()
        setIconImageViewConstraints()
        setCheckboxViewConstraints()
        setShadowViewConstraints()
        super.updateConstraints()
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        newSuperview?.addSubview(shadowView)
    }
    
    
    func setItem(_ item: HabitItem, delegate: HabitItemViewDelegate? = nil) {
        self.item = item
        self.delegate = delegate
        self.initialState = item.todayDone
        
        titleLabel.text = item.name
        descriptionLabel.text = item.descriptionString
        iconImageView.image = UIImage(named: item.image.rawValue)
        let habitProgressService = HabitProgressService()
        let habitProgressInfo = habitProgressService.getProgress(daysCompleted: item.dayCount)
        let level = habitProgressInfo.0
        let progress = habitProgressInfo.1
        progressView.setProgress(progress, animated: false)
        progressView.progressTintColor = levelColors[level]
        checkboxView.setTint(color: levelColors[level])
        showFullDescription(item.isShownFullDescription)
        checkboxView.setState(item.todayDone)
        
        if !actionToCheckboxAlreadySet {
            checkboxView.setAction(checkBoxAction)
            actionToCheckboxAlreadySet = true
        }
        
        descriptionLabel.isHidden = item.descriptionString == nil
    }
    
    
    private func showFullDescription(_ show: Bool) {
        descriptionLabel.numberOfLines = show ? 0 : 2
    }
    
    private func configureView() {
        verticalStack.addArrangedSubview(titleLabel)
        verticalStack.addArrangedSubview(descriptionLabel)
        horizontalStack.addArrangedSubview(iconImageView)
        horizontalStack.addArrangedSubview(verticalStack)
        horizontalStack.addArrangedSubview(checkboxView)
        addSubview(horizontalStack)
        addSubview(progressView)
        setNeedsUpdateConstraints()
        
        layer.cornerRadius = 24
        layer.masksToBounds = true
        
    }
    
    private func setProgressViewConstraints() {
        NSLayoutConstraint.activate([
            progressView.bottomAnchor.constraint(equalTo: bottomAnchor),
            progressView.leadingAnchor.constraint(equalTo: leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: trailingAnchor),
            progressView.heightAnchor.constraint(equalToConstant: 6)
        ])
    }
    
    private func setHorizontalStackConstraints() {
        NSLayoutConstraint.activate([
            horizontalStack.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            horizontalStack.bottomAnchor.constraint(equalTo: progressView.topAnchor, constant: -16),
            horizontalStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            horizontalStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24)
        ])
    }
    
    private func setIconImageViewConstraints() {
        NSLayoutConstraint.activate([
            iconImageView.heightAnchor.constraint(equalToConstant: 32),
            iconImageView.widthAnchor.constraint(equalToConstant: 32)
        ])
    }
    
    private func setCheckboxViewConstraints() {
        NSLayoutConstraint.activate([
            checkboxView.heightAnchor.constraint(equalToConstant: 60),
            checkboxView.widthAnchor.constraint(equalToConstant: 60)
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
    
    private func checkBoxAction(_ state: Bool) {
        let habitProgressService = HabitProgressService()
        var daysCompleted: Int
        if state {
            daysCompleted = initialState ? item.dayCount : item.dayCount + 1
        } else {
            daysCompleted = initialState ? item.dayCount - 1 : item.dayCount
        }
        let habitProgressInfo = habitProgressService.getProgress(daysCompleted: daysCompleted)
        let level = habitProgressInfo.0
        let progress = habitProgressInfo.1
        progressView.setProgress(progress, animated: true)
        progressView.progressTintColor = levelColors[level]
        
        delegate?.dayCountChanged(itemId: item.id, newDayCount: daysCompleted, todayDone: checkboxView.getState())
    }
    
}
