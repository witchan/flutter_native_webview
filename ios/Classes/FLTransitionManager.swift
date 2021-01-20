//
//  FLTransitionManager.swift
//  my_webview
//
//  Created by wit on 2021/1/20.
//

import Foundation

enum FLPresentType : Int {
    case fromLeft
    case fromRight
}

// present direction
enum FLDismissType : Int {
    case fromLeft
    case fromRight
}

class FLTransitionManager: NSObject, UIViewControllerTransitioningDelegate{
    var fl_presentType: FLPresentType = .fromRight
    var fl_dismissType: FLDismissType = .fromLeft
    static let shared = FLTransitionManager()
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let presentA = FLTransitionAnimation()
        presentA.fl_transitionAnimationType = .present
        if fl_presentType == .fromLeft {
            presentA.fl_presentDirectionType = .fromLeft
        } else {
            presentA.fl_presentDirectionType = .fromRight
        }
        return presentA
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let dismissA = FLTransitionAnimation()
        dismissA.fl_transitionAnimationType = .dismiss
        if fl_dismissType == .fromLeft {
            dismissA.fl_dismissDirectionType = .fromLeft
        } else if fl_dismissType == .fromRight {
            dismissA.fl_dismissDirectionType = .fromRight
        }
        return dismissA
    }

    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return FLPresentationController(presentedViewController: presented, presenting: presenting)
    }}
