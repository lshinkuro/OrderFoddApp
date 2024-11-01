//
//  OnboardModel.swift
//  OrderFoodApp
//
//  Created by Phincon on 04/10/24.
//

import Foundation
import UIKit

struct OnboardingItem: Equatable {
    let image: UIImage?
    let title: String
}

let onboardsData: [OnboardingItem] = [
    .init(image: UIImage(named: "onboard_1"), title: "Order from your favourite stores or vendors"),
    .init(image: UIImage(named: "onboard_2"), title: "Choose from a wide range of  delicious meals"),
    .init(image: UIImage(named: "onboard_3"), title: "Enjoy instant delivery and payment")
]
