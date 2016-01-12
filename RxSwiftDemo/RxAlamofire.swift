//
//  RxAlamofire.swift
//  
//
//  Created by C on 16/1/12.
//
//

import Foundation
import Alamofire
import RxSwift

extension Request {
  public func rx_responseJSON(options: NSJSONReadingOptions = .AllowFragments, cancelOnDispose: Bool = false) -> Observable<AnyObject> {
    return Observable.create({ (observer) -> Disposable in
      self.responseJSON(options: options) { responseData in
        let result = responseData.result
        let response = responseData.response
        
        switch result {
          case .Success(let data):
            if 200 ..< 300 ~= response?.statusCode ?? 0 {
              observer.onNext(data)
              observer.onCompleted()
            } else {
              observer.onError(NSError(domain: "Wrong status code, expected 200 - 206, got \(response?.statusCode ?? -1)",
                code: -1,
                userInfo: nil))
          }
          case .Failure(let error):
            observer.onError(error)
        }
      }
      return AnonymousDisposable {
        if cancelOnDispose {
          self.cancel()
        }
      }
    })
  }
}