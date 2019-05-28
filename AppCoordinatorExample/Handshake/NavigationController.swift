//
//  NavigationController.swift
//  Handshake
//
//  Created by Daniel Burke on 6/5/17.
//  Copyright © 2017 Handshake. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {
    
    var previousSnapshot: UIView?
    
    public weak var panGesture: UIGestureRecognizer?
    
    fileprivate var viewControllerThatHidTabBar: UIViewController?
    fileprivate var previousSnapshots = [UIView]()
    fileprivate var interactionController: UIPercentDrivenInteractiveTransition?
    
    weak var didShowDelegate: UINavigationControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNeedsStatusBarAppearanceUpdate()
        delegate = self
        let pan = UIPanGestureRecognizer()
        pan.addTarget(self, action: #selector(handlePan(gesture:)))
        view.addGestureRecognizer(pan)
        self.panGesture = pan
    }
    
    @objc func handlePan(gesture: UIPanGestureRecognizer) {
        let percent = gesture.translation(in: UIApplication.shared.keyWindow).x / gesture.view!.bounds.size.width
        
        switch gesture.state {
        case .began:
            interactionController = UIPercentDrivenInteractiveTransition()
            popViewController(animated: true)
        case .changed:
            interactionController?.update(percent)
        case .cancelled, .ended:
            if percent > 0.5 || gesture.velocity(in: view).x > 50 {
                interactionController?.finish()
            } else {
                interactionController?.cancel()
            }
            interactionController = nil
        case .possible, .failed: ()
        }
    }
    
    func hideBottomSeparator(){
        navigationBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        navigationBar.shadowImage = UIImage()
    }
    
    func showBottomSeparator(){
        navigationBar.setBackgroundImage(nil, for: .default)
        navigationBar.shadowImage = nil
    }
}

extension NavigationController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .pop {
            return BackTransition()
        } else {
            return nil
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactionController
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        didShowDelegate?.navigationController?(navigationController, didShow: viewController, animated: animated)
    }
}

fileprivate class BackTransition: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to),
            let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
            else { return }
        
        //Set initial frames
        var snapshotFrame = transitionContext.finalFrame(for: toVC)
        snapshotFrame.origin.x = -snapshotFrame.width/3
        
        //Add content to transition container
        let container = transitionContext.containerView
        container.backgroundColor = .black
        
        container.addSubview(toVC.view)
        toVC.view.frame = snapshotFrame
        toVC.view.alpha = 0.2
        
        //Only change the frame of the tabBar if the popped
        //VC hid it. Also, we're gonna temporarily add the
        //tabBar to the transition container so it will slide
        //behind the popped VC 😳
        var tabBar: UITabBar?, tabBarFrame: CGRect = .zero
        var tabBarParent: UIView?
        if let bar = toVC.tabBarController?.tabBar, fromVC.hidesBottomBarWhenPushed {
            //Update the frame of the tab bar
            tabBarFrame = bar.frame
            tabBarFrame.origin.x = snapshotFrame.origin.x
            bar.frame = tabBarFrame
            tabBar = bar
            tabBar?.alpha = 0.2
            
            //Snag the former parent so we can put tabBar back later...
            tabBarParent = tabBar?.superview
            container.addSubview(bar)
        }
        
        container.addSubview(fromVC.view)
        
        //Set final frames
        var fromVCFrame = fromVC.view.frame
        fromVCFrame.origin.x = snapshotFrame.width
        
        snapshotFrame.origin.x = 0
        tabBarFrame.origin.x = 0
        
        //Trigger animation
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animateKeyframes(
            withDuration: duration,
            delay: 0,
            options: .calculationModeCubic,
            animations: {
                toVC.view.alpha = 1
                toVC.view.frame = snapshotFrame
                fromVC.view.frame = fromVCFrame
                
                //Only change the frame of the tabBar if the popped
                //VC hid it
                if fromVC.hidesBottomBarWhenPushed {
                    tabBar?.frame = tabBarFrame
                    tabBar?.alpha = 1
                }
        },
            completion: { _ in
                container.backgroundColor = .clear
                
                //Let's put that bar back 😉
                if let bar = tabBar {
                    tabBarParent?.addSubview(bar)
                }
                
                if transitionContext.transitionWasCancelled {
                    transitionContext.completeTransition(false)
                    return
                }
                
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
