//
//  FavoriteCell.swift
//  Where_Am_I
//
//  Created by 이은재 on 2023/08/20.
//

import UIKit

final class FavoriteCell : UITableViewCell {
    
    //MARK: - Properties
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()
    
    private let latLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = .boldSystemFont(ofSize: 14)
        return label
    }()
    
    private let lonLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = .boldSystemFont(ofSize: 14)
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [nameLabel, latLabel, lonLabel])
        sv.axis = .vertical
        sv.spacing = 8
        sv.alignment = .leading
        sv.distribution = .fill
        return sv
    }()
    
    static let identity = "FavoriteCell"
    var viewModel: FavoriteCellViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            bindViewModel(viewModel: viewModel)
        }
    }
    
    //MARK: - LifeCycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    private func configureUI() {
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(12)
        }
    }
    private func bindViewModel(viewModel: FavoriteCellViewModel) {
        nameLabel.text = viewModel.name
        latLabel.text = viewModel.latitude
        lonLabel.text = viewModel.longitude
    }
}
