//
//  CheckinErrorVC.swift
//  TimorAir
//
//  Created by DaoNV on 8/19/15.
//  Copyright (c) 2015 Astraler Co., Ltd. All rights reserved.
//

import UIKit

class CheckinErrorVC: BaseViewController {
  
  @IBOutlet weak var iconView: UIImageView!
  var iconViewInsets: UIEdgeInsets! {
    return UIEdgeInsets(top: 35, left: 0, bottom: 0, right: 0)
  }
  var iconViewSize: CGSize! {
    return CGSize(width: 67, height: 67)
  }
  
  @IBOutlet weak var msgLabel: UILabel!
  var msgLabelInsets: UIEdgeInsets! {
    return UIEdgeInsets(top: 21, left: 8, bottom: 0, right: 8)
  }
  
  @IBOutlet weak var backButton: UIButton!
  var backButtonInsets: UIEdgeInsets! {
    return UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
  }
  var backButtonHeight: CGFloat {
    return 45
  }
  
  private var didSetupConstraints = false
  
  override func setup() {
    title = "Check-in error".localized
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    iconView.contentMode = .Center
    iconView.image = UIImage(named: "NoFlight")
    
    var attMd = [NSString : AnyObject]()
    attMd[NSFontAttributeName] = TAFont.HelveticaNeueLTStd.Lt(18)
    attMd[NSForegroundColorAttributeName] = TAColorGray19
    
    var attLt = [NSString : AnyObject]()
    attLt[NSFontAttributeName] = TAFont.HelveticaNeueLTStd.Lt(16)
    attLt[NSForegroundColorAttributeName] = TAColorGray19
    
    var str = NSMutableAttributedString()
    str.appendString("There is no flight".localized, attributes: attMd)
    str.appendString("\n" + "Please check your reservation".localized, attributes: attLt)
    
    let style = NSMutableParagraphStyle.defaultStyle()
    style.alignment = .Center
    str.addAttribute(NSParagraphStyleAttributeName, value: style, range: str.fullRange)
      
    msgLabel.attributedText = str
    backButton.addTarget(self, action: "backToRoot:", forControlEvents: .TouchUpInside)
    
    view.resetSubviewsAutolayout()
    view.setNeedsUpdateConstraints()
    view.updateConstraintsIfNeeded()
  }
  
  override func updateViewConstraints() {
    super.updateViewConstraints()
    if didSetupConstraints == false {
      didSetupConstraints = true
      iconView.autoAlignAxisToSuperviewAxis(.Vertical)
      iconView.autoPinEdgeToSuperviewEdge(.Top, withInset: iconViewInsets.top)
      msgLabel.autoAlignAxisToSuperviewAxis(.Vertical)
      msgLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: iconView, withOffset: 21)
      msgLabel.autoPinEdgeToSuperviewEdge(.Left, withInset: msgLabelInsets.left)
      msgLabel.autoPinEdgeToSuperviewEdge(.Right, withInset: msgLabelInsets.right)
      backButton.autoPinEdgesToSuperviewEdgesWithInsets(backButtonInsets, excludingEdge: .Top)
      UIView.autoSetPriority(.FittingSizeLevel, forConstraints: { () -> Void in
        self.iconView.autoSetDimensionsToSize(self.iconViewSize)
        self.backButton.autoSetDimension(.Height, toSize: self.backButtonHeight)
      })
    }
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    msgLabel.preferredMaxLayoutWidth = CGRectGetWidth(msgLabel.frame)
  }
  
  func backButtonTapped() {
    navigationController?.popViewControllerAnimated(true)
  }
  
}
