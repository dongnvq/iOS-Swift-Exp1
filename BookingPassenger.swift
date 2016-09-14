//
//  BookingPassenger.swift
//  TimorAir
//
//  Copyright (c) 2015 Astraler Co., Ltd. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

enum BookingPassengerAgeCategory: String {
  case adult = "Adult"
  case child = "Child"
  case usingTitle = "UsingTitle"
}

class BookingPassenger: NSObject {
  
  var Title = ""
  var Gender = "Male"
  var DateOfBirth = NSDateZero
  var AgeCategory = BookingPassengerAgeCategory.usingTitle
  var Lastname = ""
  var Firstname = ""
  var passport: GuestPassport?
  var PersonalContact: Contact?
  var Mobile = ""
  var Email = ""
  var ProfileUsername = ""
  var ProfilePassword = ""
  var national: Country?
  var Infants = [Infant]()
  var FlightSSRs = []
  
  required convenience init?(_ map: Map) {
    self.init()
    mapping(map)
  }
  
  func getGender() -> String {
    if !self.Title.isEmpty && self.Title == "Mr" {
      return "Male"
    }
    return "Female"
  }
  
  func getAgeCategory() -> String {
    if self.Title == "Child" {
      return "Child"
    } else if self.Title == "Infant" {
      return "Infant"
    }
    
    return "Adult"
  }
}

extension BookingPassenger: Mappable {
  func mapping(map: Map) {
    Title           <- map["Title"]
    Gender          <- map["Gender"]
    AgeCategory     <- map["AgeCategory"]
    Lastname        <- map["Lastname"]
    Firstname       <- map["Firstname"]
    passport        <- map["Passport"]
    Mobile          <- map["Mobile"]
    Email           <- map["Email"]
    ProfileUsername <- map["ProfileUsername"]
    ProfilePassword <- map["ProfilePassword"]
    PersonalContact <- map["PersonalContact"]
    FlightSSRs      <- map["FlightSSRs"]
    Infants         <- map["Infants"]
  }
  
  static func newInstance(map: Map) -> Mappable? {
    return BookingPassenger()
  }
}
