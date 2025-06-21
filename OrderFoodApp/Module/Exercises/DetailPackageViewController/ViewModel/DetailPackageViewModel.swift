//
//  Detail.swift
//  OrderFoodApp
//
//  Created by Phincon on 19/03/25.
//

import Foundation
import RxSwift
import RxRelay
import UIKit

// Sample data structure
struct AddOnItem {
    let title: String
    let data: String
    let duration: String
    let description: String
    let originalPrice: String
    let currentPrice: String
    var isSelected: Bool
    let hasBestValueBadge: Bool
}

class DetailPackageViewModel {
    
    let fullName = BehaviorRelay<String>(
        value: ""
    )
    
    var addOns: [AddOnItem] = [
        AddOnItem(
            title: "Carry Over Kuota",
            data: "10 GB",
            duration: "30 Hari",
            description: "Cukup Rp5.000, sisa kuota bulan ini bisa kamu pakai lagi",
            originalPrice: "Rp10.000",
            currentPrice: "+Rp5.000",
            isSelected: true,
            hasBestValueBadge: true
        ),
        AddOnItem(
            title: "Internet OMG! Ekstra",
            data: "5 GB",
            duration: "30 Hari",
            description: "Cukup tambah Rp5.000 dapat ekstra 5 GB 30 Hari",
            originalPrice: "Rp10.000",
            currentPrice: "+Rp5.000",
            isSelected: true,
            hasBestValueBadge: true
        ),
        AddOnItem(
            title: "YouTube 3.5 GB",
            data: "2.5 GB",
            duration: "7 Hari",
            description: "",
            originalPrice: "Rp10.000",
            currentPrice: "+Rp25.000",
            isSelected: true,
            hasBestValueBadge: false
        ),
        AddOnItem(
            title: "FreeFire Diamond",
            data: "77 Diamond",
            duration: "7 Hari",
            description: "",
            originalPrice: "Rp10.000",
            currentPrice: "+Rp20.000",
            isSelected: false,
            hasBestValueBadge: false
        ),
        AddOnItem(
            title: "Mobile Security",
            data: "2.5 GB",
            duration: "7 Hari",
            description: "",
            originalPrice: "Rp10.000",
            currentPrice: "+Rp36.000",
            isSelected: false,
            hasBestValueBadge: false
        )
    ]
    
    var dataQuotaExtra = [
           ("Nonton", "Dapat menggunakan internet lain saat kuota nonton habis.", "1 GB", UIImage(systemName: "globe"))
       ]
}
