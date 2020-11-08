//
//  RoundCheckboxView.swift
//  Habits
//
//  Created by Ацамаз Бицоев on 14.10.2020.
//

import UIKit

final class RoundCheckboxView: UIView {
    
    private lazy var mainButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private lazy var selectionView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    private var state: Bool
    private var selectionColor: UIColor
    private var action: ((Bool) -> ())?
    
    
    init(
        state: Bool = false,
        selectionColor: UIColor = UIColor.Button.accent
    ) {
        self.state = state
        self.selectionColor = selectionColor
        super.init(frame: .zero)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        roundViews()
    }
    
    override func updateConstraints() {
        setupMainButtonConstraints()
        setupSelectionViewConstraints()
        super.updateConstraints()
    }
    
    func getState() -> Bool {
        return state
    }
    
    func setState(_ state: Bool) {
        self.state = state
        setupState()
        action?(state)
    }
    
    func setAction(_ action: @escaping (Bool) -> ()) {
        self.action = action
    }
    
    func setTint(color: UIColor) {
        selectionView.backgroundColor = color
    }
    
    
    private func configureView() {
        addSubview(selectionView)
        addSubview(mainButton)
        setNeedsUpdateConstraints()
        
        backgroundColor = #colorLiteral(red: 0.9254901961, green: 0.9254901961, blue: 0.9254901961, alpha: 1)
        selectionView.backgroundColor = selectionColor
        setupState()
        mainButton.addTarget(self, action: #selector(mainButtonTapped), for: .touchUpInside)
    }
    
    private func setupMainButtonConstraints() {
        NSLayoutConstraint.activate([
            mainButton.topAnchor.constraint(equalTo: topAnchor),
            mainButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            mainButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainButton.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    private func setupSelectionViewConstraints() {
        NSLayoutConstraint.activate([
            selectionView.centerXAnchor.constraint(equalTo: centerXAnchor),
            selectionView.centerYAnchor.constraint(equalTo: centerYAnchor),
            selectionView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.7),
            selectionView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.7)
        ])
    }
    
    private func setupState() {
        selectionView.isHidden = !state
    }
    
    private func roundViews() {
        layer.cornerRadius = bounds.height / 2
        selectionView.layer.cornerRadius = selectionView.bounds.height / 2
    }
    
    
    @objc private func mainButtonTapped() {
        state = !state
        setupState()
        Vibration.medium.vibrate()
        action?(state)
    }
    
}
