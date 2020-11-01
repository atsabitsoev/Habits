//
//  SelectImageView.swift
//  Habits
//
//  Created by Ацамаз Бицоев on 01.11.2020.
//

import UIKit

protocol SelectImageViewDelegate {
    func imageSelected(_ image: HabitImage)
}

final class SelectImageView: UIView {
    
    var delegate: SelectImageViewDelegate?
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 40, height: 40)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    private let allImages: [HabitImage] = [.sport, .book, .water, .writing, .yoga, .handshake, .money, .phone, .atom, .languages, .lunges]
    private var selectedImage: HabitImage?
    
    
    init(selectedImage: HabitImage = .sport) {
        self.selectedImage = selectedImage
        super.init(frame: .zero)
        configureView()
        configureCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        setCollectionViewConstraints()
        super.updateConstraints()
    }
    
    
    func setSelectedImage(_ image: HabitImage) {
        let index = allImages.firstIndex(of: image)
        collectionView.selectItem(at: IndexPath(row: index ?? 0, section: 0), animated: true, scrollPosition: .top)
    }
    
    
    private func configureView() {
        backgroundColor = .systemBackground
        setNeedsUpdateConstraints()
    }
    
    private func configureCollectionView() {
        addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ImageCollectionCell.self, forCellWithReuseIdentifier: ImageCollectionCell.identifier)
    }
    
}

// MARK: - Constraints
extension SelectImageView {
    private func setCollectionViewConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 120)
        ])
    }
}

// MARK: - CollectionView Delegate
extension SelectImageView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let currentImage = allImages[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionCell.identifier, for: indexPath) as! ImageCollectionCell
        cell.setImage(currentImage)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let currentItem = allImages[indexPath.row]
        selectedImage = currentItem
        delegate?.imageSelected(selectedImage!)
    }
    
}
