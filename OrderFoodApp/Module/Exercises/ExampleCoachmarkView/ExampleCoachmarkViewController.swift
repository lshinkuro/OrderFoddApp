//
//  ExampleCoachmarkViewController.swift
//  OrderFoodApp
//
//  Created by Phincon on 16/01/25.
//

import UIKit
import Instructions

class ExampleCoachmarkViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var featureButton: UIButton!
    
    
    // create Instans coachmark controller
    let coachmarkVC = CoachMarksController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set data source untuk CoachMarksController
        coachmarkVC.dataSource = self
        
        // Memulai Coach Mark
        coachmarkVC.start(in: .window(over: self))

    }

}


extension ExampleCoachmarkViewController: CoachMarksControllerDataSource {
    
    func numberOfCoachMarks(for coachMarksController: Instructions.CoachMarksController) -> Int {
        return 2
    }
    
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkAt index: Int) -> CoachMark {
           switch index {
           case 0:
               // Sorot tombol fitur
               return coachMarksController.helper.makeCoachMark(for: featureButton)
           case 1:
               // Sorot gambar profil
               return coachMarksController.helper.makeCoachMark(for: profileImage)
           default:
               return coachMarksController.helper.makeCoachMark()
           }
       }
    
    func coachMarksController(_ coachMarksController: Instructions.CoachMarksController, coachMarkViewsAt index: Int, madeFrom coachMark: Instructions.CoachMark) -> (bodyView: (any UIView & Instructions.CoachMarkBodyView), arrowView: (any UIView & Instructions.CoachMarkArrowView)?) {
        
        let coachViews = coachMarksController.helper.makeDefaultCoachViews(withArrow: true, arrowOrientation: .bottom)
        coachViews.bodyView.background.innerColor = .systemBlue
        coachViews.bodyView.hintLabel.font = UIFont.boldSystemFont(ofSize: 16)
        
        switch index {
          case 0:
              coachViews.bodyView.hintLabel.text = "Klik tombol ini untuk menggunakan fitur utama."
              coachViews.bodyView.nextLabel.text = "Next"
          case 1:
              coachViews.bodyView.hintLabel.text = "Ini adalah gambar profil Anda."
              coachViews.bodyView.nextLabel.text = "Got it"
          default:
              break
          }
        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)

    }
    
}
