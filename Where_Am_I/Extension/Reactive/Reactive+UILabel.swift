//
//  Reactive+UILabel.swift
//  Where_Am_I
//
//  Created by 이은재 on 2023/08/19.
//

import UIKit
import RxSwift
import CoreLocation

extension Reactive where Base: UILabel {
    
    var latitude: Binder<CLLocation> {
        return Binder(self.base) { label, location in
            let attributedText = NSMutableAttributedString(string: "Latitude(위도) : ", attributes: [.font: UIFont.systemFont(ofSize: 14)])
            attributedText.append(NSAttributedString(string: "\(location.coordinate.latitude)", attributes: [.font: UIFont.boldSystemFont(ofSize: 18)]))
            label.attributedText = attributedText
        }
    }
    
    var longitude: Binder<CLLocation> {
        return Binder(self.base) { label, location in
            let attributedText = NSMutableAttributedString(string: "Longitude(경도) : ", attributes: [.font: UIFont.systemFont(ofSize: 14)])
            attributedText.append(NSAttributedString(string: "\(location.coordinate.longitude)", attributes: [.font: UIFont.boldSystemFont(ofSize: 18)]))
            label.attributedText = attributedText
        }
    }
    
}
