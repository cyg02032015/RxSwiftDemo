//
//  Log.swift
//  RxSwiftDemo
//
//  Created by C on 16/1/9.
//  Copyright © 2016年 YoungKook. All rights reserved.
//

import Foundation


class Log {
  static func YGLog<T>(message: T, function: String = __FUNCTION__, line: Int = __LINE__) {
      #if DEBUG
      print("\(function)-[\(line)]:==> \(message)")
      #endif
  }
}