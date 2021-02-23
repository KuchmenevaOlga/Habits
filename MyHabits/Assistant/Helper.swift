//
//  Helper.swift
//  MyHabits
//
//  Created by Ольга Кучменева on 03.11.2020.
//  Copyright © 2020 Olga Kuchmeneva. All rights reserved.
//

import UIKit

extension UIView {
    func toAutoLayout(){
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}

enum ActionWithHabit {
    case create
    case edit
}

extension Float {
    func rounded(toPlaces places:Int) -> Float {
        let divisor = pow(10.0, Float(places))
        return (self * divisor).rounded() / divisor
    }
}
