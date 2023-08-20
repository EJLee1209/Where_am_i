//
//  Reactive+UIButton.swift
//  Where_Am_I
//
//  Created by 이은재 on 2023/08/20.
//

import UIKit
import RxSwift

extension Reactive where Base: UIButton {
    
    var tintColor: Binder<Bool> {
        return Binder(self.base) { button, isActive in
            button.tintColor = isActive ? .systemRed : .black
        }
    }
    
}
