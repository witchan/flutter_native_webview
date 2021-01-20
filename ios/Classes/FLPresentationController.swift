//
//  FLPresentationController.swift
//  my_webview
//
//  Created by wit on 2021/1/20.
//

import Foundation
import UIKit

class FLPresentationController: UIPresentationController {
    lazy var coverView: UIView = {
        let aView = UIView()
        aView.backgroundColor = .red
        aView.alpha = 0
        return aView
    }()
    
    override func presentationTransitionWillBegin() {
        // 简单添加效果
        coverView.frame = containerView?.bounds ?? CGRect.zero
        containerView?.addSubview(coverView)
        
        // 最重要的 最重要的 最重要的 添加要present的view到容器里面，不然无法present，因为系统都不知道present什么，而且一定要最后添加
        if let presentedView = presentedView {
            containerView?.addSubview(presentedView)
        }
        
        weak var coordinator = presentingViewController.transitionCoordinator
        
        coordinator?.animate(alongsideTransition: { context in
            self.coverView.alpha = 1
        })
        
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        if !completed {
            coverView.removeFromSuperview()
        }
    }
    
    override func dismissalTransitionWillBegin() {
        weak var coordinator = presentingViewController.transitionCoordinator
        
        coordinator?.animate(alongsideTransition: { context in
            self.coverView.alpha = 0.0
        })
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            coverView.removeFromSuperview()
        }
    }
}
