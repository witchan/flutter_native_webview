//
//  FLTransitionAnimation.swift
//  my_webview
//
//  Created by wit on 2021/1/20.
//

import Foundation
import UIKit

enum FLTransitionAnimationType : Int {
    case present
    case dismiss
}

// present direction
enum FLPresentDirectionType : Int {
    case fromLeft
    case fromRight
}

// present direction
enum FLDismissDirectionType : Int {
    case fromLeft
    case fromRight
}

class FLTransitionAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    
    var duration = 0.3
    
    var fl_transitionAnimationType: FLTransitionAnimationType?
    var fl_presentDirectionType: FLPresentDirectionType?
    var fl_dismissDirectionType: FLDismissDirectionType?
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    //  Converted to Swift 5.3 by Swiftify v5.3.21043 - https://swiftify.com/
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if fl_transitionAnimationType == .present {
            // 1.get toView
            let toView = transitionContext.view(forKey: .to)
            // 2.change frame
            var tempFrame = toView?.frame
            if fl_presentDirectionType == .fromRight {
                tempFrame?.origin.x = toView?.frame.size.width ?? 0.0
            } else if fl_presentDirectionType == .fromLeft {
                tempFrame?.origin.x = -(toView?.frame.size.width ?? 0.0)
            }
            toView?.frame = tempFrame ?? CGRect.zero
            // 3.begin animation
            UIView.animate(withDuration: duration, animations: {
                tempFrame?.origin.x = 0
                toView?.frame = tempFrame ?? CGRect.zero
            }) { finished in
                // 4.Tell context that we completed
                transitionContext.completeTransition(true)
            }
        } else         if fl_transitionAnimationType == .dismiss {
            // 1.get toView
            let fromView = transitionContext.view(forKey: .from)
            // 2.change frame
            var tempFrame = fromView?.frame
            // 3.begin animation
            UIView.animate(withDuration: duration, animations: { [self] in
                if fl_dismissDirectionType == .fromRight {
                    tempFrame?.origin.x = -(fromView?.frame.size.width ?? 0.0)
                } else if fl_dismissDirectionType == .fromLeft {
                    tempFrame?.origin.x = fromView?.frame.size.width ?? 0.0
                }
                fromView?.frame = tempFrame ?? CGRect.zero
            }) { finished in
                // 4.Tell context that we completed
                transitionContext.completeTransition(true)
            }
        }
        
    }
}
