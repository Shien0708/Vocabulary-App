//
//  Spinner.swift
//  Vocabulary App
//
//  Created by Shien on 2022/6/30.
//

import Foundation
import UIKit

class Animation {
    func startRotate(with view: UIView) {
        let animation = CABasicAnimation(keyPath: "transform.rotation.y")
        animation.fromValue = 0
        animation.toValue = CGFloat.pi
        animation.duration = 0.2
        view.layer.add(animation, forKey: nil)
    }
    
    func fall(with view: UIView, by distance: Int) {
        let animation = UIViewPropertyAnimator(duration: 1, curve: .linear) {
            view.transform = CGAffineTransform(translationX: 0, y: CGFloat(distance*10))
            print("drop")
        }
        animation.startAnimation()
    }
}
