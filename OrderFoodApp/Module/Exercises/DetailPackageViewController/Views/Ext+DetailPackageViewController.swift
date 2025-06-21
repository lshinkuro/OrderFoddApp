//
//  Ext+DetailPackageViewController.swift
//  OrderFoodApp
//
//  Created by Phincon on 20/03/25.
//

import Foundation
import UIKit
import SnapKit

extension DetailPackageViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return 1
        case 3:
            return 1
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return createSectionPackageCell(tableView: tableView, indexPath: indexPath)
        case 1:
            return createSctionExtraQuotaCell(tableView: tableView, indexPath: indexPath)
        case 2:
            return createSctionPurchaseCell(tableView: tableView, indexPath: indexPath)
        case 3:
            return createSctionAddOnCell(tableView: tableView, indexPath: indexPath)
        default:
            return UITableViewCell()
        }
        
    }
    
    
    func createSectionProfileEkycCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as ProfileekycCell
        cell.configure(text: "title", with: [
            CustomProfileInputField(title: "Nama",
                                    placeholder: "Nama", text: viewModel.fullName),
            CustomProfileInputFieldWithImage(title: "Alamat",
                                             placeholder: "Alamat",
                                             imageName: "chevron.right",
                                             onButtonClicked: {[weak self] in
                                                 guard let self else { return }
                                                 self.addAlert(title: "Sukses \(viewModel.fullName.value)", message: "Berhasil membuat akun" ) {
                                                     let vc = LoginViewController()
                                                     self.navigationController?.pushViewController(vc, animated: true)
                                                 }
                                             })
        ])
        return cell
    }
    
    func createSectionPackageCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as PackageDetailCell
        cell.configure(with: [
            PackageItem(iconName: "globe", title: "Internet", subtitle: "kuota internet seluruh jaringan", value: "15GB"),
            PackageItem(iconName: "globe", title: "Internet", subtitle: "kuota internet seluruh jaringan", value: "15GB"),
            PackageItem(iconName: "globe", title: "Internet", subtitle: "kuota internet seluruh jaringan", value: "15GB"),
            
        ])
        return cell

    }
    
    func createSctionPurchaseCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as PurchaseOptionCell
        return cell
        
    }
    
    func createSctionAddOnCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as AddOnTableViewCell
        let item = viewModel.addOns
        cell.configure(with: item )
        return cell
        
    }
    
    func createSctionExtraQuotaCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as ExtraQuotaCell
        let item = viewModel.dataQuotaExtra[indexPath.row]
              cell.configure(with: item.0, subtitle: item.1, quota: item.2, icon: item.3)
        return cell
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let tableView = scrollView as? UITableView else { return }
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let tableHeight = scrollView.frame.size.height

        if offsetY + tableHeight >= contentHeight {
            tableView.contentInset.bottom = 100
        } else {
            tableView.contentInset.bottom = 0
        }
    }
    
    
}
