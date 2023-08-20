//
//  Reactive+UIImageView.swift
//  Where_Am_I
//
//  Created by 이은재 on 2023/08/20.
//

import UIKit
import RxSwift

extension Reactive where Base: UIImageView {
    
    var isHidden: Binder<Bool> {
        return Binder(self.base) { iv, isActive in
            iv.isHidden = !isActive
        }
    }
    
    
}
