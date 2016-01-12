//
//  SampleModel.swift
//  RxSwiftDemo
//
//  Created by C on 16/1/12.
//  Copyright © 2016年 YoungKook. All rights reserved.
//

import UIKit
import SwiftyJSON
struct SampleModel {
  var id: String
  var image: String
  var title: String
  init(json: JSON) {
    self.id = json["id"].stringValue ?? ""
    self.image = json["images"].arrayValue.first?.stringValue ?? ""
    self.title = json["title"].stringValue ?? ""
  }
}
