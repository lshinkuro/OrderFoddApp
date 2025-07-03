//
//  DetailPackageCell.swift
//  OrderFoodApp
//
//  Created by Phincon on 18/03/25.
//

import UIKit
import SnapKit

class DetailPackageCell: UITableViewCell {
    
    private let containerView: GradientView = GradientView()
    private let segmentedControl = SegmentedControlView()
    private let detailView = DetailView()
    
    var onHeightChange: (() -> Void)? // Callback untuk update tinggi cell
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        selectionStyle = .none
        self.backgroundColor = .clear
        contentView.backgroundColor = .clear
        contentView.addSubview(containerView)
        containerView.add(segmentedControl, detailView)
        
        containerView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        segmentedControl.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }
        
        detailView.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalToSuperview().inset(16)
        }
        
        segmentedControl.onSegmentChanged = { [weak self] index in
            self?.detailView.updateView(for: index)
            self?.onHeightChange?() // Panggil callback untuk update tinggi cell
        }
    }
}


class DetailView: UIView {
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.isHidden = false
        table.register(DetailCell.self, forCellReuseIdentifier: "DetailCell")
        return table
    }()
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.isHidden = true
        textView.font = UIFont.systemFont(ofSize: 14)
        return textView
    }()
    
    private var detailItems: [String] = []
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(tableView)
        addSubview(textView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        textView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func updateView(for index: Int) {
        switch index {
        case 0:
            // Detail List
            detailItems = ["Kuota Utama: 10GB", "Kuota Malam: 5GB", "Masa Berlaku: 30 Hari"]
            tableView.reloadData()
            tableView.isHidden = false
            textView.isHidden = true
        case 1:
            // Deskripsi Paket
            textView.text = """
               Deskripsi Paket:
               - Kuota internet untuk semua jaringan.
               - Kuota OMG! untuk aplikasi tertentu.
               - Langganan Prime Video 1 bulan.
               """
            tableView.isHidden = true
            textView.isHidden = false
        case 2:
            // Syarat & Ketentuan
            textView.text = "Syarat & Ketentuan berlaku untuk paket ini."
            tableView.isHidden = true
            textView.isHidden = false
        default:
            break
        }
        
        self.superview?.superview?.setNeedsLayout()
        self.superview?.superview?.layoutIfNeeded()
    }
}

extension DetailView: UITableViewDataSource, UITableViewDelegate {
    // MARK: - UITableViewDataSource & UITableViewDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath) as? DetailCell else {
            return UITableViewCell()
        }
        cell.configure(with: detailItems[indexPath.row])
        return cell
    }
}



import UIKit

class DetailCell: UITableViewCell {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview().inset(8)
        }
    }
    
    func configure(with text: String) {
        titleLabel.text = text
    }
}
