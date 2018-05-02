//
//  XLViewController.swift
//  RelaxSwift
//
//  Created by xx11dragon on 16/6/22.
//  Copyright © 2016年 xx11dragon. All rights reserved.
//

import UIKit

class XLTabbarController: UIViewController {
    
    
    fileprivate var selectedController: UIViewController?
    
    
    var selectedIndex:NSInteger {
        willSet {
            if self.viewControllers.count != 0 && newValue < self.viewControllers.count {
                let viewController = self.viewControllers[newValue]
                
                self.addChildViewController(viewController)
                viewController.view.frame = self.view.bounds
                self.view .addSubview(viewController.view)
                viewController .didMove(toParentViewController: self)
                
                selectedController = viewController
            }
        }
    }
    


    
    var viewControllers:Array<UIViewController> {
        willSet {
            if (self.viewControllers.count != 0) {
                for viewController in self.viewControllers {
                    viewController.willMove(toParentViewController: nil)
                    viewController.view .removeFromSuperview()
                    viewController.removeFromParentViewController()
                    
                }
            }
        }
        
        didSet {
            if (self.viewControllers.count != 0) {
                self.selectedIndex = 0
            }
        }
    }
    

    
    init() {
        self.selectedIndex = 0
        self.viewControllers=[]
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = UIColor.white
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
