//
//  AlertContainerViewController.swift
//  Habits
//
//  Created by Ацамаз Бицоев on 28.10.2020.
//

import UIKit

final class AlertContainerViewController: UIViewController {
    
    private lazy var alertView: AlertContainerView = { [weak self] in
        guard let self = self else { return AlertContainerView(mainView: UIView(), title: "") }
        let view = AlertContainerView(mainView: self.mainView, title: self.titleString)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let mainView: UIView
    private let titleString: String
    
    
    init(mainView: UIView, title: String) {
        self.mainView = mainView
        self.titleString = title
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateViewConstraints() {
        setBackgroundViewConstraints()
        setAlertViewConstraints()
        super.updateViewConstraints()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTapRecognizer()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.addSubview(backgroundView)
        view.addSubview(alertView)
        view.setNeedsUpdateConstraints()
        
        alertView.setAction { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    private func setAlertViewConstraints() {
        NSLayoutConstraint.activate([
            alertView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            alertView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            alertView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 36)
        ])
    }
    
    private func setBackgroundViewConstraints() {
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupTapRecognizer() {
        let tapRec = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        backgroundView.addGestureRecognizer(tapRec)
    }
    

    @objc private func viewTapped() {
        dismiss(animated: true, completion: nil)
    }
    
}
