//
//  DemoCell.swift
//  FoldingCell
//
//  Created by Alex K. on 25/12/15.
//  Copyright © 2015 Alex K. All rights reserved.
//

import UIKit
import FoldingCell

class DemoCell: FoldingCell {
  
  @IBOutlet weak var closeNumberLabel: UILabel!
  @IBOutlet weak var openNumberLabel: UILabel!
 
    @IBOutlet weak var lblMatchStatus: UILabel!
    
    @IBOutlet weak var lblMatchState: UILabel!
    
    @IBOutlet weak var lblMatchSource: UILabel!
    @IBOutlet weak var lblMatchDesc: UILabel!
    
    @IBOutlet weak var lblBowlTwoStats: UILabel!
    @IBOutlet weak var lblBowlOneStats: UILabel!
    @IBOutlet weak var lblBowlTwo: UILabel!
    @IBOutlet weak var lblBowlOne: UILabel!
    @IBOutlet weak var lblBatTwoRuns: UILabel!
    @IBOutlet weak var lblBatOneRuns: UILabel!
    @IBOutlet weak var lblBatTwo: UILabel!
    @IBOutlet weak var lblBatOne: UILabel!
    @IBOutlet weak var lblOvers: UILabel!
    @IBOutlet weak var lblScore: UILabel!
    //  var number: Int = 0 {
//    didSet {
//      closeNumberLabel.text = String(number)
//      openNumberLabel.text = String(number)
//    }
//  }
    
    var matchType: String = "" {
        didSet {
          closeNumberLabel.text = matchType
          openNumberLabel.text = matchType
        }
      }

  
  override func awakeFromNib() {
    foregroundView.layer.cornerRadius = 10
    foregroundView.layer.masksToBounds = true

    super.awakeFromNib()
  }
  
  override func animationDuration(_ itemIndex: NSInteger, type: FoldingCell.AnimationType) -> TimeInterval {
    let durations = [0.26, 0.2, 0.2]
    return durations[itemIndex]
  }
  
}

// MARK: - Actions ⚡️
extension DemoCell {
  
  @IBAction func buttonHandler(_ sender: AnyObject) {
    print("tap")
//    self.contentView.isHidden = true

  }

  
}
extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}
extension UIColor {
    static func random() -> UIColor {
        return UIColor(red:   .random(),
                       green: .random(),
                       blue:  .random(),
                       alpha: 1.0)
    }
}
