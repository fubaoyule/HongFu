//
//  XLSliderController.swift
//  RelaxSwift
//
//  Created by xx11dragon on 16/6/21.
//  Copyright © 2016年 xx11dragon. All rights reserved.
//

import UIKit


let DefaultOffset: Float = Float(UIScreen.main.bounds.size.width/3)
let OpenAnimationTime: Double = 0.3;

class XLSliderController: UIViewController {
    // 预加载视图控制器
    fileprivate var preloadViewController: UIViewController?
    // 主视图控制器
    fileprivate var rootViewController: UIViewController
    // 滑动偏移
    fileprivate var offset: Float = 0.0
    // 是否打开状态
    var isOpen: Bool {
        get {
            return self.rootViewController.view.frame.origin.x > 0
        }
    }
//   滑动手势
    fileprivate var panGesture: UIPanGestureRecognizer?
//   rootViewController首次触摸坐标
    fileprivate var touchBeginOffset: CGPoint = CGPoint.zero

    init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
        super.init(nibName: nil, bundle: nil)
        self.addGesturesToCenterController(rootViewController)
        self.addChildViewController(rootViewController)
        self.view.addSubview(rootViewController.view)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addPreloadViewController(_ preloadViewController: UIViewController, offset: Float) {
        self.preloadViewController = preloadViewController
        self.offset = offset;
        self.addChildViewController(preloadViewController)
        self.view.insertSubview(preloadViewController.view, at: 0)
    }
    
//    打开视图
    func openCompletelyAnimated(_ animated: Bool) {
        if self.isOpen {
            return;
        }
        if animated {
            UIView.animate(withDuration: OpenAnimationTime, animations: {
                self.rootViewController.view.frame = self.getRect(self.maxOffsetX())
                }, completion: { (finished:Bool) in
                    self.panGesture?.isEnabled = (self.isOpen && finished)
            })
        }else {
            self.rootViewController.view.frame = self.getRect(self.maxOffsetX())
            self.panGesture?.isEnabled = self.isOpen
        }

    }
    
    func closeCompletelyAnimated(_ animated: Bool) {
        if !self.isOpen {
            return;
        }
        if animated {
            UIView.animate(withDuration: OpenAnimationTime, animations: {
                self.rootViewController.view.frame = self.getRect(0)
                }, completion: { (finished:Bool) in
                    self.panGesture?.isEnabled = (self.isOpen && finished)
            })
        }else {
            self.rootViewController.view.frame = self.getRect(0)
            self.panGesture?.isEnabled = self.isOpen
        }
        
    }

//    添加手势
    fileprivate func addGesturesToCenterController(_ viewController: UIViewController) {
        
        //    添加滑动手势
        func addPanGestureToController(_ view: UIView) {
            if (self.panGesture == nil) {
                let panGesture = UIPanGestureRecognizer(target: self, action: #selector(gestureRecognizerDidPan))
                panGesture.isEnabled = false
                view.addGestureRecognizer(panGesture)
                self.panGesture = panGesture
            }
        }

        //    添加侧边滑动手势
        func addEdgePanGestureRecognizer(_ view: UIView) {
            let edgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(gestureRecognizerDidPan))
            edgeGesture.edges = .left
            
            view.addGestureRecognizer(edgeGesture)
        }
        //    添加点击手势
        func addTapGestureToController(_ view: UIView) {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(gestureRecognizerDidTap))
            view.addGestureRecognizer(tapGesture)
        }
        
        addEdgePanGestureRecognizer(viewController.view)
        addTapGestureToController(viewController.view)
        addPanGestureToController(viewController.view)
    }
    
//    tap点击事件
    @objc func gestureRecognizerDidTap(_ sender:UITapGestureRecognizer) {
        UIView.animate(withDuration: OpenAnimationTime, animations: {
            self.rootViewController.view.frame = self.getRect(0)
        });
        self.removeShadow()
    }
    
//    pan手势事件
    @objc func gestureRecognizerDidPan(_ sender:UIPanGestureRecognizer) {
        if (self.preloadViewController == nil) {
            return
        }
        switch sender.state {
        case .began:
            self.view.isUserInteractionEnabled = false
            self.touchBeginOffset = sender.location(in: sender.view)
            
            
        case .changed:
            
            var offset = sender.location(in: self.view)
            offset = CGPoint(x: offset.x-self.touchBeginOffset.x, y: offset.y-self.touchBeginOffset.y)
            
            let x = max(0, min(self.maxOffsetX(), Float(offset.x)))
            let y = sender.view!.frame.origin.y
            let width = sender.view!.frame.size.width
            let height = sender.view!.frame.size.height
            sender.view!.frame = CGRect(x: CGFloat(x), y: y, width: width, height: height);
            
        case .ended, .cancelled:
            
            let offset = sender.location(in: self.view)
            self.view.isUserInteractionEnabled = true
            
            UIView.animate(withDuration: OpenAnimationTime, animations: {
                self.rootViewController.view.frame = self.getRect(Float(offset.x))
                }, completion: { (finished:Bool) in
                    self.panGesture?.isEnabled = (self.isOpen && finished)
            })
            
            
        default: break
        }
    }
    
//    返回视图Frame
    func getRect(_ offset: Float) -> CGRect {
        let bounds = self.view.bounds
        if offset < DefaultOffset {
//            self.removeShadow()
            return bounds;
        }else{
//            self.addShadow()
            return CGRect(x: CGFloat(self.maxOffsetX()), y: 0, width: bounds.size.width, height: bounds.size.height)
        }
    }
//    水平最大移动值
    func maxOffsetX() -> Float {
        return Float(UIScreen.main.bounds.size.width) - self.offset
    }
    var maskView:UIView!
//    视图添加阴影
    func addShadow() {
//        let view = self.rootViewController.view
//        view?.layer.shadowOffset = CGSize.zero
//        view?.layer.shadowOpacity = 0.75
//        view?.layer.shadowRadius = 10.0;
//        view?.layer.shadowColor = UIColor.black.cgColor
//        view?.layer.shadowPath = UIBezierPath(rect: (view?.layer.bounds)!).cgPath
//        view?.clipsToBounds = false
        let maskView = UIView(frame: self.rootViewController.view.frame)
        maskView.backgroundColor = UIColor.black
        maskView.alpha = 0.5
        self.rootViewController.view.addSubview(maskView)
        self.maskView = maskView
    }
//    视图删除阴影
    func removeShadow() {
//        let view = self.rootViewController.view
//        view?.layer.shadowPath = nil
//        view?.layer.shadowOpacity = 0.0
//        view?.layer.shadowRadius = 0.0
//        view?.layer.shadowColor = nil
        if self.maskView == nil {
            return
        }
        self.maskView.removeFromSuperview()
        self.maskView = nil
    }
}
