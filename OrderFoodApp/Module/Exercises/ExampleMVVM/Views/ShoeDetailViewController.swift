//
//  ShoeDetailViewController.swift
//  OrderFoodApp
//
//  Created by Phincon on 21/01/25.
//

import Foundation

import UIKit

class ShoeDetailViewController: UIViewController {
    private let viewModel: ShoeDetailViewModel
    private let descriptionLabel = UILabel()
    private let favoriteButton = UIButton(type: .system)

    init(viewModel: ShoeDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
    }
}

extension ShoeDetailViewController {
    private func setupUI() {
        view.backgroundColor = .white
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        favoriteButton.setTitle("Toggle Favorite", for: .normal)

        view.addSubview(descriptionLabel)
        view.addSubview(favoriteButton)

        descriptionLabel.frame = CGRect(x: 20, y: 100, width: view.bounds.width - 40, height: 100)
        favoriteButton.frame = CGRect(x: 20, y: 220, width: view.bounds.width - 40, height: 50)

        favoriteButton.addTarget(self, action: #selector(toggleFavorite), for: .touchUpInside)
    }

    private func setupData() {
        descriptionLabel.text = viewModel.shoeItem.description
        updateFavoriteButton()
    }

    private func updateFavoriteButton() {
        let title = viewModel.shoeItem.isFavorite ? "Remove from Favorite" : "Add to Favorite"
        favoriteButton.setTitle(title, for: .normal)
    }

    @objc private func toggleFavorite() {
        viewModel.toggleFavorite()
        updateFavoriteButton()
    }
}

