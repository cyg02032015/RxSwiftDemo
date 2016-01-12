//
//  CustomCell.swift
//  RxSwiftDemo
//
//  Created by C on 16/1/12.
//  Copyright © 2016年 YoungKook. All rights reserved.
//

import UIKit
import SnapKit

class CustomCell: UITableViewCell {

  var imgView: UIImageView!
  var titleLabel: UILabel!
  var contentLabel: UILabel!
  
  func setupUI() {
    imgView = UIImageView()
    imgView.backgroundColor = UIColor.yellowColor()
    contentView.addSubview(imgView)
    titleLabel = UILabel()
    titleLabel.font = UIFont.boldSystemFontOfSize(17)
    contentView.addSubview(titleLabel)
    
    contentLabel = UILabel()
    contentLabel.numberOfLines = 0
    contentView.addSubview(contentLabel)
    
    imgView.snp_makeConstraints { make in
      make.top.equalTo(contentView).offset(10)
      make.left.equalTo(contentView).offset(10)
      make.width.height.equalTo(80)
      make.bottom.lessThanOrEqualTo(contentView.snp_bottom).offset(-10)
    }
    
    titleLabel.snp_makeConstraints { make in
      make.left.equalTo(imgView.snp_right).offset(8)
      make.top.equalTo(imgView.snp_top)
      make.right.equalTo(contentView).offset(-10)
      make.height.equalTo(17)
    }

    contentLabel.snp_makeConstraints { make in
      make.top.equalTo(titleLabel.snp_bottom).offset(8)
      make.left.equalTo(titleLabel.snp_left)
      make.right.equalTo(titleLabel.snp_right)
      make.bottom.lessThanOrEqualTo(contentView.snp_bottom).offset(-8)
    }
  }
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupUI()
  }
  
  required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setupUI()
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
  }
}
