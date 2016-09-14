//
//  BookingReviewViewController.swift
//  TimorAir
//
//  Copyright (c) 2015 Astraler Co., Ltd. All rights reserved.
//

import UIKit

class BookingReviewViewController: BaseViewController {

  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var totalAmountLabel: UILabel!
  @IBOutlet weak var continueButton: UIButton!
  @IBOutlet weak var scrollContaintView: UIView!
  @IBOutlet weak var bottomTopConstraint: NSLayoutConstraint!
  @IBOutlet weak var bottomView: UIView!
  
  var departView: BookingReview!
  var returnView: BookingReview!
  var allInFareView: AllInFareView!
  var allInFareReturnView: AllInFareView!
  
  override func viewDidLoad() {
    super.viewDidLoad()

    self.navigationItem.title = "Review".localized
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    setupUI()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  private func setupUI() {
    
    var booking = BookingInteractor.sharedInstance.bookingFlight
    
    // Continue button
    continueButton.setBackgroundImage(UIImage(named: "continue-btn-1px"), forState: UIControlState.Normal);
    continueButton.layer.cornerRadius = 5.0
    continueButton.clipsToBounds = true
    
    // Depart result
    departView = NSBundle.mainBundle().loadNibNamed("BookingReview", owner: nil, options: nil)[0] as! BookingReview
    departView.delegate = self
    departView.frame = CGRectMake(0, 0, scrollView.frame.size.width, departView.frame.size.height)
    
    departView.setBookingReviewData(booking)
    
    //log.debug("\(self.departView.frame)")
    scrollContaintView.addSubview(departView)
    var tmpView = departView
    // Return result
    if booking.returnDate != nil {
      returnView = NSBundle.mainBundle().loadNibNamed("BookingReview", owner: nil, options: nil)[0] as! BookingReview
      returnView.delegate = self
      returnView.frame = CGRectMake(0, CGRectGetHeight(departView.frame) + departView.flightLabelHeight, scrollView.frame.size.width, returnView.frame.size.height)
      
      returnView.isReturnFlight = true
      returnView.setBookingReviewData(booking)
      
      scrollContaintView.addSubview(returnView)
      tmpView = returnView
    }

    // All In Fare
    var totalAmount = Double(0)
    var titleAllInFare = UILabel(frame: CGRectMake(8, tmpView.frame.origin.y + CGRectGetHeight(tmpView.frame) + tmpView.flightLabelHeight + 10, scrollView.frame.size.width - 16, 40))
    titleAllInFare.font = TAFont.HelveticaNeue.Bold(23.0)

    titleAllInFare.text = "ALL-IN FARE".localized
    
    scrollContaintView.addSubview(titleAllInFare)
    
    allInFareView = NSBundle.mainBundle().loadNibNamed("AllInFareView", owner: nil, options: nil)[0] as! AllInFareView
    allInFareView.allInFareTitle.text = "DEPARTURE FLIGHT".localized
    allInFareView.isReturnFlight = false
    allInFareView.setBookingReviewData(booking)
    allInFareView.frame = CGRectMake(0, titleAllInFare.frame.origin.y + CGRectGetHeight(titleAllInFare.frame), scrollView.frame.size.width, allInFareView.frame.size.height)
    var tmpFare = allInFareView
    scrollContaintView.addSubview(allInFareView)
    totalAmount = allInFareView.totalCost
    
    if booking.returnDate != nil {
      allInFareReturnView = NSBundle.mainBundle().loadNibNamed("AllInFareView", owner: nil, options: nil)[0] as! AllInFareView
      
      allInFareReturnView.allInFareTitle.text = "RETURN FLIGHT".localized
      allInFareReturnView.isReturnFlight = true
      allInFareReturnView.setBookingReviewData(booking)
      allInFareReturnView.frame = CGRectMake(0, allInFareView.frame.origin.y + CGRectGetHeight(allInFareView.frame), scrollView.frame.size.width, allInFareReturnView.frame.size.height)
      scrollContaintView.addSubview(allInFareReturnView)
      totalAmount += allInFareReturnView.totalCost
      tmpFare = allInFareReturnView
    }
        
    bottomTopConstraint.constant = tmpFare.frame.origin.y + CGRectGetHeight(tmpFare.frame)
    scrollContaintView.layoutIfNeeded()
    totalAmountLabel.text = totalAmount.dollar
    scrollContaintView.bringSubviewToFront(bottomView)
  }
}

extension BookingReviewViewController {
  
  @IBAction func continueAction(sender: AnyObject) {
    var controller = PaymentDetailViewController(nibName: "PaymentDetailViewController", bundle: nil)
    self.navigationController?.pushViewController(controller, animated: true)
  }
}

extension BookingReviewViewController: BookingReviewProtocol {

  func infoDidTouch(sender: AnyObject) {
    
    var booking = BookingInteractor.sharedInstance.bookingFlight
    // Goto fare class scene
    if let review = sender as? BookingReview  {
      var controller = FlightDefineViewController(nibName: "FlightDefineViewController", bundle: nil)
      
      var legsData: LegOption!
      if review.isReturnFlight == true {
        legsData = review.bookingFlight!.returnOption?.legs[0]
      } else {
        legsData = review.bookingFlight!.departOption?.legs[0]
      }
      
      if let leg = legsData {
        controller.segmentOptions = leg.segmentOptions
        self.navigationController?.pushViewController(controller, animated: true)
      }
    }
  }
  
  func rowInfoDidTouch(sender: AnyObject) {
    
    var code = ""
    if let view = sender as? BookingReview {
      if view.isReturnFlight == true {
        code = view.bookingFlight!.returnFareOption?.fareClass ?? ""
      } else {
        code = view.bookingFlight!.departFareOption?.fareClass ?? ""
      }
    }
    
    // Goto fare class scene
    var controller = FareClassViewController(nibName: "FareClassViewController", bundle: nil)
    controller.fareCode = code
    controller.fareType = .JowType
    self.navigationController?.pushViewController(controller, animated: true)
  }
}
