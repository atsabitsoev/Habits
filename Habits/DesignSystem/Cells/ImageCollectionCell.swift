//
//  ImageCollectionCell.swift
//  Habits
//
//  Created by Ацамаз Бицоев on 01.11.2020.
//

import UIKit

final class ImageCollectionCell: UICollectionViewCell {
    
    static let identifier = "ImageCollectionCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var heightConstraint = imageView.heightAnchor.constraint(equalToConstant: 40)
    private lazy var widthConstraint = imageView.widthAnchor.constraint(equalToConstant: 40)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        setImageViewConstraints()
        super.updateConstraints()
    }
    
    override var isSelected: Bool {
        didSet {
            setSelected(isSelected)
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            setSelected(isHighlighted && !isSelected)
        }
    }
    
    
    func setImage(_ image: HabitImage) {
        imageView.image = UIImage(named: image.rawValue)
    }
    
    
    private func configureCell() {
        contentView.backgroundColor = .systemBackground
        contentView.addSubview(imageView)
        setNeedsUpdateConstraints()
    }
    
    private func setSelected(_ selected: Bool) {
        if isSelected {
            heightConstraint.constant = 25
            widthConstraint.constant = 25
        } else {
            heightConstraint.constant = 40
            widthConstraint.constant = 40
        }
    }
    
}

// MARK: - Constraints
extension ImageCollectionCell {
    private func setImageViewConstraints() {
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            heightConstraint,
            widthConstraint
        ])
    }
}
