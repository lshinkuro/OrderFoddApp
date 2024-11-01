//
//  FloatingPanelLayout.swift
//  OrderFoodApp
//
//  Created by Phincon on 23/10/24.
//

import Foundation
import FloatingPanel
import UIKit

class BaseFloatingPanelLayout: FloatingPanelLayout {
    private var heightOfContent: CGFloat!
    private var isAnchorToSafeArea: Bool!
    
    init(heightOfContent: CGFloat, isAnchorToSafeArea: Bool = false) {
        self.heightOfContent = heightOfContent
        self.isAnchorToSafeArea = isAnchorToSafeArea
    }
    
    var position: FloatingPanelPosition = .bottom
    
    var initialState: FloatingPanelState = .half
    
    var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] {
        let screenHeight = CGFloat(UIScreen.main.bounds.size.height)
        if isAnchorToSafeArea {
            return [
                .full: FloatingPanelLayoutAnchor(absoluteInset:  16.0, edge: .top, referenceGuide: .safeArea),
                .half: FloatingPanelLayoutAnchor(absoluteInset:  self.heightOfContent, edge: .bottom, referenceGuide: .safeArea),
                .tip : FloatingPanelLayoutAnchor(absoluteInset:  30, edge: .bottom, referenceGuide: .safeArea),
            ]
        } else {
            return [
                .full: FloatingPanelLayoutAnchor(absoluteInset:  screenHeight - self.heightOfContent, edge: .top, referenceGuide: .superview),
                .half: FloatingPanelLayoutAnchor(absoluteInset:  screenHeight - self.heightOfContent, edge: .top, referenceGuide: .superview),
                .tip : FloatingPanelLayoutAnchor(absoluteInset:  screenHeight - 30, edge: .top, referenceGuide: .superview),
            ]
        }
    }
    
    func backdropAlpha(for state: FloatingPanelState) -> CGFloat {
        return 0.5
    }
}

class FloatingPanelContentFitLayout: BaseFloatingPanelLayout {}

class FloatingPanelContentFitLayoutBlurred: BaseFloatingPanelLayout {
    override func backdropAlpha(for state: FloatingPanelState) -> CGFloat {
        return 1
    }

    func backdropBlur(for state: FloatingPanelState) -> UIBlurEffect? {
        return UIBlurEffect(style: .dark)
    }
}
