//
//  PackageDetailCell.swift
//  OrderFoodApp
//
//  Created by Phincon on 20/03/25.
//

import UIKit
import SnapKit

class PackageDetailCell: UITableViewCell {
    static let reuseIdentifier = "PackageDetailCell"
    
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        view.drawDottedBorder()
        return view
    }()
    

    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        return label
    }()
    
    let dataLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    let durationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    let originalPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
        label.textAlignment = .right
        return label
    }()
    
    let currentPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textColor = .black
        label.textAlignment = .right
        return label
    }()
    
    
    private let tabView = CustomTabView()
    
    private var packageItems: [PackageItem] = []
    let textDesc = """
                    Paket Internet OMG! Berlaku untuk 30 hari, dengan detail sebagai berikut:

                    • Kuota Internet dengan akses di semua jaringan (2G/3G/4G)
                    • Kuota 2 GB OMG! untuk akses Youtube, Facebook, Instagram, MAXstream, VIU, Klik Film berlaku 30 hari
                    • Langganan Prime Video Mobile 1 bulan. Prime Video Mobile hanya dapat diakses pada aplikasi Prime Video melalui handphone.
                    """
    let textSK = """
        • Harga belum termasuk PPN 11% Biaya paket akan dikenakan proporsional (prorata).
        • Paket merupakan paket utama yang bersifat berlangganan (otomatis diperpanjang pada periode tagihan selanjutnya). 
        • Kuota data dapat digunakan di seluruh jaringan Telkomsel tanpa berbatas pada aplikasi maupun waktu tertentu.
        • Kuota telepon & SMS berlaku untuk seluruh operator domestik (tidak berlaku untuk panggilan internasional yang akan dikenakan biaya terpisah) Apabila pelanggan memiliki Paket Ekstra Kuota atau Ekstra Nelpon, kuota Ekstra Kuota atau Ekstra Nelpon akan dikonsumsi terlebih dahulu sebelum kuota Paket Utama.
        • Setelah kuota internet habis, aktifkan paket Ekstra Kuota untuk tetap dapat mengakses internet.
        • Kuota Roaming Halo akan aktif bersamaan dengan Paket Halo+ , masa berlaku kuota mengikuti periode tagihan dan otomatis diperpanjang.
        """
    
    private let stackView = UIStackView().configure{
        $0.axis = .vertical
        $0.spacing = 8
        $0.distribution = .fill
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        selectionStyle = .none
        self.backgroundColor = .clear
        contentView.backgroundColor = .clear
        contentView.addSubview(containerView)
        contentView.backgroundColor = .clear
        
        containerView.add(titleLabel,dataLabel,durationLabel, originalPriceLabel, currentPriceLabel, tabView, stackView)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalToSuperview().inset(16)
            make.trailing.equalTo(originalPriceLabel.snp.leading).offset(-8)
        }

        dataLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().inset(16)
        }

        durationLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalTo(dataLabel.snp.trailing)
        }
        
        originalPriceLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.top)
            make.trailing.equalToSuperview().offset(-16)
        }

        currentPriceLabel.snp.makeConstraints { make in
            make.top.equalTo(originalPriceLabel.snp.bottom).offset(4)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        tabView.snp.makeConstraints { make in
            make.top.equalTo(dataLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(tabView.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalToSuperview().inset(16)
        }
        
        tabView.delegate = self
    }
    
    func configure(with items: [PackageItem]) {
        titleLabel.text = "Nonton Sport Platinum"
        dataLabel.text = "Masa berlaku paket "
        durationLabel.text = "31 hari"
        originalPriceLabel.text = "Rp54.000"
        currentPriceLabel.text = "Rp55.000"
        
        
        packageItems = items
        updateView(for: 0) // Default tab "Detail"
    }
}

extension PackageDetailCell: CustomTabViewDelegate {
    func tabSelected(index: Int) {
        updateView(for: index)
    }
    
    private func updateView(for index: Int) {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        switch index {
        case 0: // Tab "Detail"
            for item in packageItems {
                let packageView = PackageItemListView(item: item)
                stackView.addArrangedSubview(packageView)
            }
        case 1: // Tab "Deskripsi" dan "S&K"
            let descView = CustomDescriptionView(text: textDesc)
            stackView.addArrangedSubview(descView)
        case 2:
            let descView = CustomDescriptionView(text: textSK)
            stackView.addArrangedSubview(descView)
        default:
            break
        }
        
        self.layoutIfNeeded()
        
        // Force table view to update height
        DispatchQueue.main.async {
            if let tableView = self.superview as? UITableView {
                tableView.beginUpdates()
                tableView.endUpdates()
            }
        }
    }
}




