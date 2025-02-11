//
//  Coachmark.swift
//  OrderFoodApp
//
//  Created by Phincon on 16/01/25.
//

import Foundation
import UIKit

class CoachMarks {
    private var overlayView: UIView!
    private var hintLabel: UILabel!
    private var currentStep = 0
    private var steps: [(CGRect, String)] = []
    private var view: UIView!

    init(on view: UIView) {
        self.view = view
    }

    func setSteps(_ steps: [(CGRect, String)]) {
        self.steps = steps
    }

    func start() {
        guard !steps.isEmpty else { return }
        currentStep = 0
        showStep()
    }

    private func showStep() {
        // Hapus overlay sebelumnya
        overlayView?.removeFromSuperview()
        hintLabel?.removeFromSuperview()

        guard currentStep < steps.count else {
            // Selesai
            overlayView?.removeFromSuperview()
            hintLabel?.removeFromSuperview()
            return
        }

        let (highlightFrame, hintText) = steps[currentStep]

        // Buat overlay
        overlayView = UIView(frame: view.bounds)
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        view.addSubview(overlayView)

        // Buat highlight area
        let path = UIBezierPath(rect: overlayView.bounds)
        let highlightPath = UIBezierPath(roundedRect: highlightFrame, cornerRadius: 8)
        path.append(highlightPath.reversing())

        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        overlayView.layer.mask = maskLayer

        // Tambahkan label petunjuk
        hintLabel = UILabel(frame: CGRect(x: 20, y: highlightFrame.maxY + 10, width: view.bounds.width - 40, height: 60))
        hintLabel.textColor = .white
        hintLabel.numberOfLines = 0
        hintLabel.textAlignment = .center
        hintLabel.text = hintText
        view.addSubview(hintLabel)

        // Tambahkan gesture untuk langkah berikutnya
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(nextStep))
        overlayView.addGestureRecognizer(tapGesture)
    }

    @objc private func nextStep() {
        currentStep += 1
        showStep()
    }
}
