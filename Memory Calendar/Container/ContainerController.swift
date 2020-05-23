//
//  ContainerController.swift
//  Memory Calendar
//
//  Created by Денис Дубовиков on 23.05.2020.
//  Copyright © 2020 Денис Дубовиков. All rights reserved.
//

import UIKit

class ContainerController: UIViewController {

//    var menuController: MenuController!
    var centerController: UIViewController!
    var historyController = HistoryController()
    var isExpanded = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        configureViewController()
    }
    
    
    func configureViewController() {
//        viewController.myDelegate = self
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        historyController = storyboard.instantiateViewController(withIdentifier: "historyVC") as! HistoryController
        
        centerController = UINavigationController(rootViewController: historyController)
        
        view.addSubview(centerController.view)
        addChild(centerController)
        centerController.didMove(toParent: self)
    }
    
//    func configureMenuController() {
//        if menuController == nil {
//            menuController = MenuController()
//            menuController.myDelegate = self
//            view.insertSubview(menuController.view, at: 0)
//            addChild(menuController)
//
//            menuController.didMove(toParent: self)
//
//            print("Menu controller")
//        }
//    }
//
//    func showMenuController(shouldExpand: Bool) {
//
//        if shouldExpand {
//            //show
//
//            viewController.view.isUserInteractionEnabled = false
//
//            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
//                    self.centerController.view.frame.origin.x = self.centerController.view.frame.width - 100
//            }, completion: nil)
//        } else {
//            //hide
//
//            viewController.view.isUserInteractionEnabled = true
//
//            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
//                    self.centerController.view.frame.origin.x = 0
//            }, completion: nil)
//        }
//
//        animateStatusBar()
//
//    }
//
//    func animateStatusBar() {
//        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
//            self.setNeedsStatusBarAppearanceUpdate()
//        }, completion: nil)
//    }
    
}

/*
extension ContainerController: ViewControllerDelegate {
    func handleMenuToggle(forMenuOption menuOption: String?) {
        if !isExpanded {
            configureMenuController()
        }
        
        isExpanded = !isExpanded
        showMenuController(shouldExpand: isExpanded)
        
        if !isExpanded {
            if menuOption != nil {
                if menuOption == "Profile" {
                    viewController.buttonAccountPressed()
                }
                
                if menuOption == "Saved" {
                    viewController.savedNewsButtonPressed()
                }
            }
        }
    }
}*/
