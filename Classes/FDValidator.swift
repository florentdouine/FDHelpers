//
//  FDValidator.swift
//  WebMii
//
//  Created by Florent Douine on 27/10/2015.
//  Copyright © 2015 Florent Douine. All rights reserved.
//

import Foundation
import UIKit

protocol FDValidity{
  func isValid(value: String?)->Bool
  func translatedMessage(name: String, value: String)->String
}

enum FDNSStringValidity: FDValidity{
  case NotEmpty
  case Alphanumeric
  case ContainSpaces(Int)
  case Name
  case LessThan(Int)
  case greaterThan(Int)
  case Email
  
  func isValid(value: String?) -> Bool{
    
    guard let v = value else{
      return false
    }
    
    switch self {
    case .NotEmpty :
      return v.characters.count>0
      
    case ContainSpaces(let numberOfSpaces) :
      return v.componentsSeparatedByString(" ").count-1 >= numberOfSpaces
      
    case Name :
      let nameRegex: String = "[\\p{Letter} '-]+"
      let nameTest: NSPredicate = NSPredicate(format: "SELF MATCHES %@", nameRegex)
      return (nameTest.evaluateWithObject(v))
      
    case .Alphanumeric :
      let alphaRegex: String = "[A-Z0-9a-z]+"
      let alphaTest: NSPredicate = NSPredicate(format: "SELF MATCHES %@", alphaRegex)
      return (alphaTest.evaluateWithObject(v))
      
    case LessThan(let numberOfCharacters) :
      return v.characters.count < numberOfCharacters
      
    case greaterThan(let numberOfCharacters) :
      return v.characters.count > numberOfCharacters
      
    case .Email :
      let emailRegex: String = "[A-Z0-9a-z.%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
      let emailTest: NSPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
      return (emailTest.evaluateWithObject(v))
    }
    
  }
  
  
  func translatedMessage(name: String, value: String)->String{
    
    switch self{
    case .NotEmpty :
      return String(format: FDLocalized("error.required"), name)
    case .Alphanumeric:
      return String(format: FDLocalized("error.invalid_alpha"), name)
    case .ContainSpaces(let numberOfCharacters):
      return String(format: FDLocalized("error.contain_spaces"), name, numberOfCharacters)
    case .Name:
      return String(format: FDLocalized("error.incorrect_name"), name)
    case .LessThan(let numberOfCharacters):
      return String(format: FDLocalized("error.less_than"), name, numberOfCharacters-1)
    case .greaterThan(let numberOfCharacters):
      return String(format: FDLocalized("error.greater_than"), name, numberOfCharacters+1)
    case .Email:
      return String(format: FDLocalized("error.invalid_email"), value)
    }
    
    
  }
  
  
}

class FDField {
  
  var required: Bool = true
  
  var name: String
  
  var value: String
  
  var validities: [FDValidity]
  
  var overrideErrorMessage: String?
  
  var errorMessage: String{
    
    if let message = overrideErrorMessage{
      return message
    }
    
    var translatedMessage: [String] = []
    validities.forEach({ (validity) -> () in
      if(!validity.isValid(self.value)){
        translatedMessage.append(validity.translatedMessage(self.name, value: self.value))
      }
    })
    
    return translatedMessage.joinWithSeparator("\n")
  }
  
  var isValid: Bool {
    
    if(value.isEmpty && !required){
      return true
    }
    
    for validity in self.validities{
      if(!validity.isValid(value)){
        return false
      }
    }
    return true
  }
  
  init(displayName: String, andValue value: String, andValidity stringValidities: FDValidity...) {
    self.name = displayName
    self.value = value
    self.validities = stringValidities
    
  }
}

class FDValidator {
  var fields: [FDField]? = []
  
  var returnOnFirstError = false
  
  init(fields: [FDField]){
    self.fields = fields
  }
  
  
  func checkValidity() -> Bool {
    
    guard let _fields = fields else{
      return true
    }
    
    for field: FDField in _fields {
      if(!field.isValid){
        return false
      }
    }
    return true
  }
  
  
  func checkValidity(success success:()->(), failed: (String, UIAlertController, [FDField])->()) {
    
    guard let _fields = fields else{
      success()
      return
    }
    
    var fieldsInError: [FDField] = []
    
    var translatedMessage: [String] = []
    
    for field: FDField in _fields {
      if(!field.isValid){
        fieldsInError.append(field)
        translatedMessage.append(field.errorMessage)
      }
    }
    
    if(fieldsInError.isEmpty){
      success()
      return
    }
    
    
    var message = translatedMessage.joinWithSeparator("\n")
    if(returnOnFirstError){
      message = message.componentsSeparatedByString("\n")[0]
    }
    
    //let title = localized("global_error") ?? FDLocalized("global.error")
    let alertController = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.Alert)
    alertController.addAction(UIAlertAction(title: FDLocalized("global.ok"), style: UIAlertActionStyle.Default, handler: nil))
    
    failed(message, alertController, fieldsInError);
    
  }
  
  
  
  
  
}