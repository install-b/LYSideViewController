//
//  SideViewController.swift
//  PhotoGallery
//
//  Created by Shangen Zhang on 2019/9/26.
//  Copyright © 2019 Mi Cheng. All rights reserved.
//

import UIKit

// MARK: - MCSideViewControllerDelegate protocol
@objc public protocol SideViewControllerDelegate: NSObjectProtocol {
    
    // MARK: left view show and dissmiss action
    // will show
    @objc optional func sideViewWillShowLeftView(_ sideVc: SideViewController, _ leftVc: UIViewController, animaDuration: TimeInterval)
    // did show
    @objc optional func sideViewDidShowLeftView(_ sideVc: SideViewController, _ leftVc: UIViewController, progress: CGFloat)
    // will dissmiss
    @objc optional func sideViewWillDismissLeftView(_ sideVc: SideViewController, _ leftVc: UIViewController, animaDuration: TimeInterval)
    // did dissmiss
    @objc optional func sideViewDidDismissLeftView(_ sideVc: SideViewController, _ leftVc: UIViewController)
    
    // MARK: right view show and dissmiss action
    // will show
    @objc optional func sideViewWillShowRightView(_ sideVc: SideViewController, _ rightVc: UIViewController, animaDuration: TimeInterval)
    // did show
    @objc optional func sideViewDidShowRightView(_ sideVc: SideViewController, _ rightVc: UIViewController, progress: CGFloat)
    // will dissmiss
    @objc optional func sideViewWillDismissRightView(_ sideVc: SideViewController, _ rightVc: UIViewController, animaDuration: TimeInterval)
    // did dissmiss
    @objc optional func sideViewDidDismissRightView(_ sideVc: SideViewController, _ rightVc: UIViewController)
    
    // MARK: toch event
    @objc optional func sideViewTapGestureShouldReceiveTouch(_ sideVc: SideViewController, _ tap: UITapGestureRecognizer, _ touch: UITouch) -> Bool
    @objc optional func sideViewPanGestureShouldReceiveTouch(_ sideVc: SideViewController, _ pan: UIPanGestureRecognizer, _ touch: UITouch) -> Bool
    
    @objc optional func sideViewPanGestureshouldBeRequired(_ sideVc: SideViewController, _ pan: UIPanGestureRecognizer, toFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool
}

private let animaDuration: TimeInterval = 0.25


open class SideViewController: UIViewController {
     
     // MARK: property
     // publcik
    @objc public var leftContentOffset: CGFloat = 0
    @objc public var rightContentOffset: CGFloat = 0
    @objc public var panEnable: Bool = true
     
     
    @objc weak public var delegate: SideViewControllerDelegate?
    
     // 控制器
     public private(set) var mainViewController: UIViewController!
     public private(set) var leftViewController: UIViewController?
     public private(set) var rightViewController: UIViewController?
     public private(set) var currentViewContoller: UIViewController? {
         didSet {
            if currentViewContoller == oldValue {
                return
            }
             setNeedsStatusBarAppearanceUpdate()
         }
     }
     /// 拖拽速度
     private var panSpeed: PanSpeed?
     public var startPoint: CGPoint? {
         return panSpeed?.lastPoint
     }
     
     // override
    open override func viewDidLoad() {
         super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(deviceChangeOriention(_:)), name: UIDevice.orientationDidChangeNotification, object: nil)
        
         // 初始化子视图
         setUpSubVcViews()
         
         // 添加手势
         setUpGestures()
     }
    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        mainViewController.view.bounds = view.bounds
        
        leftViewController?.view.bounds = view.bounds
        leftViewController?.frameY = 0
        
        rightViewController?.view.bounds = view.bounds
        rightViewController?.frameY = 0
    }
    
    @objc func deviceChangeOriention(_ noti: Notification) {
        if let vc = leftViewController, vc == currentViewContoller{
            showMainViewController()
        }
        
        if let vc = rightViewController, vc == currentViewContoller {
            showMainViewController()
        }
    }
    required public init?(coder aDecoder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
    @objc public init(mainViewController: UIViewController, leftViewController: UIViewController?, rightViewController: UIViewController?) {
        // 父类调用
         super.init(nibName: nil, bundle: nil)
         
         // 初始化
         setUpVc(mainViewController: mainViewController,
               leftViewController: leftViewController,
               rightViewController: rightViewController)
     }
     
     // MARK: setups
     @objc public func setUpVc(mainViewController: UIViewController, leftViewController: UIViewController?, rightViewController: UIViewController?) {
         self.mainViewController = mainViewController
         self.leftViewController = leftViewController
         self.rightViewController = rightViewController
         currentViewContoller = mainViewController
         addChild(mainViewController)
         
         if let vc = leftViewController {
             addChild(vc)
         }
         if let vc = rightViewController {
             addChild(vc)
         }
     }
     
     func setUpSubVcViews() {
         // 添加主视图
         view.addSubview(mainViewController.view)
         // 加载侧边视图
         _ = leftViewController?.view
         _ = rightViewController?.view
     }
     
      func setUpGestures() {
         let tapSEL = #selector(gestureRecognizer(tap:))
         let tap = UITapGestureRecognizer.init(target: self, action: tapSEL)
         view.addGestureRecognizer(tap)
         tap.delegate = self
         
         let panSEL = #selector(gestureRecognizer(pan:))
         let pan = UIPanGestureRecognizer.init(target: self, action: panSEL)
         pan.maximumNumberOfTouches = 1
         view.addGestureRecognizer(pan)
         pan.delegate = self
     }
}

extension SideViewController {
    //public showMainView
    public func showMainViewController() {
        
        if let leftVc = leftViewController, leftVc.view.superview != nil {
            delegate?.sideViewWillDismissLeftView?(self, leftVc, animaDuration: animaDuration)
            
            animateAddjust(frameX: 0, isLeft: true) { (_ : Bool) in
                leftVc.view.removeFromSuperview()
                self.delegate?.sideViewDidDismissLeftView?(self, leftVc)
                self.currentViewContoller = self.mainViewController
            }
        
        } else if let rightVc = rightViewController, rightVc.view.superview != nil {
            delegate?.sideViewWillDismissRightView?(self, rightVc, animaDuration: animaDuration)
            animateAddjust(frameX: 0, isLeft: false) { (_ : Bool) in
                rightVc.view.removeFromSuperview()
                self.delegate?.sideViewDidDismissRightView?(self, rightVc)
                self.currentViewContoller = self.mainViewController
            }
        }
    }
    
    public func showLeftViewController() {
       
        guard let leftVc = leftViewController else {
            return
        }
        let frameX = leftVc.frameX
        let w = view.bounds.size.width
        guard frameX != -(w - leftContentOffset) else {
            self.currentViewContoller = leftVc
            return
        }
        
        if leftVc.view.superview == nil {
            view.insertSubview(leftVc.view, aboveSubview: mainViewController.view)
            leftVc.frameX = -w
        }
        
        delegate?.sideViewWillShowLeftView?(self, leftVc, animaDuration: animaDuration)
        
        animateAddjust(frameX: leftContentOffset, isLeft: true) { (_) in
            self.delegate?.sideViewDidShowLeftView?(self, leftVc, progress: 1.0)
            self.rightViewController?.view.removeFromSuperview()
            self.currentViewContoller = leftVc
        }
        
    }
    
    public func showRightViewController() {
        
        guard let rightVc = rightViewController else {
            return
        }
        let frameX = rightVc.frameX
        let w = view.bounds.size.width
        guard frameX != (w - rightContentOffset) else {
            currentViewContoller = rightVc
            return
        }
        
        if rightVc.view.superview == nil {
            view.insertSubview(rightVc.view, aboveSubview: mainViewController.view)
            rightVc.frameX = (w)
        }
        
        delegate?.sideViewWillShowRightView?(self, rightVc, animaDuration: animaDuration)
        
        animateAddjust(frameX: rightContentOffset, isLeft: false) { (_) in
            self.delegate?.sideViewDidShowRightView?(self, rightVc, progress: 1.0)
            self.leftViewController?.view.removeFromSuperview()
            self.currentViewContoller = rightVc
        }
    }
    
    private func animateAddjust(frameX: CGFloat, isLeft: Bool, completion: ((Bool) -> Void)? = nil) {
        let w = view.bounds.width
        UIView.animate(withDuration: animaDuration, animations: {
            if isLeft {
                self.leftViewController?.frameX = frameX - w
            } else {
                self.rightViewController?.frameX = w - frameX
            }
            self.view.layoutIfNeeded()
        }, completion: completion)
        
    }
}

extension SideViewController {
    private func dealOffset(left: CGFloat, vc: UIViewController) {
        let w = view.bounds.width
        let maxX = leftContentOffset - view.bounds.width
        
        var frameX = vc.frameX + left
        
        frameX = (frameX > maxX) ?  maxX : frameX
        
        vc.frameX = (frameX)
        
        delegate?.sideViewDidShowLeftView?(self, vc, progress: ((frameX + w) / leftContentOffset))
    }
    
    private func dealOffset(right: CGFloat, vc: UIViewController) {
        let w = view.bounds.width
        
        let minX = w - rightContentOffset
        
        var frameX = vc.frameX + right
        frameX = (frameX > minX) ? frameX : minX
        
        vc.frameX = (frameX)
        
        delegate?.sideViewDidShowRightView?(self, vc, progress: ((frameX - w) / rightContentOffset))
    }
    
    private func show(left offset: CGFloat) {
        guard let leftVc = leftViewController else { return }
        let w = view.bounds.width
        view.insertSubview(leftVc.view, aboveSubview: mainViewController.view)
        leftVc.frameX = (-w)
        dealOffset(left: offset, vc: leftVc)
    }
    
    private func show(right offset: CGFloat) {
        guard let rightVc = rightViewController else  { return }
        view.insertSubview(rightVc.view, aboveSubview: mainViewController.view)
        rightVc.frameX = (view.bounds.width)
        dealOffset(right: offset, vc: rightVc)
    }
}


extension SideViewController {
    
     // 点击变化
     func touchMoved(offset: CGFloat) {
         if let vc = leftViewController, vc.view.superview != nil {
            return dealOffset(left: offset, vc: vc)
         }
         
         if let vc = rightViewController, vc.view.superview != nil {
            return dealOffset(right: offset, vc: vc)
         }
         return (offset > 0) ? show(left: offset) : show(right: offset)
     }
     
     // 结束点击
     func touchEnd() {
         
         if leftViewController?.view.superview != nil {
             let w = view.bounds.size.width
             let speed = (panSpeed?.speed ?? 0)
             if leftViewController!.frameX > (leftContentOffset * 0.5 - w) {
                 return (speed < -200) ? showMainViewController() : showLeftViewController()
             } else {
                 return (speed > 200) ? showLeftViewController() : showMainViewController()
             }
         }
         
         if rightViewController?.view.superview != nil {
             let w = view.bounds.size.width
             let speed = (panSpeed?.speed ?? 0)
             if rightViewController!.frameX < (-rightContentOffset * 0.5 + w) {
                 return (speed > 200) ? showMainViewController() : showRightViewController()
             } else {
                 return (speed < -200) ? showRightViewController() : showMainViewController()
             }
         }
         // 展示主页面,
         showMainViewController()
     }
}


extension SideViewController {
    @objc func gestureRecognizer(tap: UITapGestureRecognizer) {
        showMainViewController()
    }
    
    @objc func gestureRecognizer(pan: UIPanGestureRecognizer) {
        switch pan.state {
        case .began :
            let p = pan.location(in: view)
            panSpeed = .init(start: p)
         case .changed :
             let p = pan.location(in: view)
             if let offset = panSpeed?.panDidChange(point: p) {
                touchMoved(offset: offset)
             }
        case .ended, .cancelled, .failed:
            touchEnd()
            panSpeed = nil
        default: break
        }
    }
}

// MARK: - UIGestureRecognizerDelegate
extension SideViewController: UIGestureRecognizerDelegate {
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
 
        if let tap = gestureRecognizer as? UITapGestureRecognizer {
            if let isRecevie = delegate?.sideViewTapGestureShouldReceiveTouch?(self, tap, touch) {
                return isRecevie
            }
         
            let w = view.bounds.width
            
            if let leftV = leftViewController?.view, leftV.superview != nil {
                let leftX = leftV.frame.origin.x
                let p = touch.location(in: tap.view)
                return  (p.x > leftContentOffset) && (leftX == (leftContentOffset - w))
            }
            
            if let rightV = rightViewController?.view, rightV.superview != nil {
                let righX = rightV.frame.origin.x
                 let p = touch.location(in: tap.view)
                return (p.x < rightContentOffset) && (righX == (-rightContentOffset + w))
            }
            
        }
        
        if let pan = gestureRecognizer as? UIPanGestureRecognizer {
            if panEnable == false {
                return false
            }
            return delegate?.sideViewPanGestureShouldReceiveTouch?(self, pan, touch) ?? true
        }
        
        return false
    }
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if let pan = gestureRecognizer as? UIPanGestureRecognizer {
            return delegate?.sideViewPanGestureshouldBeRequired?(self, pan, toFailBy: otherGestureRecognizer) ?? true
        }
        return false
    }
}
