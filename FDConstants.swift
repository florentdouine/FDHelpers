//
//  FDConstants.swift
//  WebMii
//
//  Created by Florent Douine on 27/10/2015.
//  Copyright © 2015 Florent Douine. All rights reserved.
//

import Foundation

func FDLocalized(s: String?)->String{
  
  return NSLocalizedString(s ?? "", tableName: "FDLocalizable", bundle: NSBundle.mainBundle(), value: s ?? "", comment: "")
  
}

