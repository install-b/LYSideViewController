//
//  UIViewController-SideView.swift
//  PhotoGallery
//
//  Created by Shangen Zhang on 2019/9/26.
//  Copyright © 2019 Mi Cheng. All rights reserved.
//

import Foundation


extension UIViewController {
    public var frameX: CGFloat {
        set {
            var frame = view.frame
            frame.origin.x = newValue
            view.frame = frame
        }
        get {
            view.frame.origin.x
        }
    }
    public var frameY: CGFloat {
        set {
            var frame = view.frame
            frame.origin.y = newValue
            view.frame = frame
        }
        get {
            view.frame.origin.y
        }
    }
}
/// convince operation
extension UIViewController {
    public var sideRootViewController: SideViewController? {
        var vc: UIViewController? = self.parent
        while vc != nil {
            if (vc?.isKind(of: SideViewController.self))! {
                return (vc! as! SideViewController)
            } else if (vc?.parent != nil)  && (vc!.parent != vc!) {
                vc = vc?.parent
            } else {
                vc = nil
            }
        }
        return nil
    }
    
    @objc public func showLeftSideViewController(_ sender: Any? = nil) {
        sideRootViewController?.showLeftViewController()
    }
    
    @objc public func showrRightSideViewController(_ sender: Any? = nil) {
        sideRootViewController?.showRightViewController()
    }
    
    @objc public func showMainViewController(_ sender: Any? = nil) {
        sideRootViewController?.showMainViewController()
    }
}
