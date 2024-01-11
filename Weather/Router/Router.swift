//
//  Router.swift
//  Weather
//
//  Created by Long Tran on 03/01/2024.
//

import UIKit


class Router : NSObject, RouterProtocol {
    func presentFull(_ drawable: Drawable, isAnimated: Bool, onNavigateBack closure: NavigationBackClosure?) {
        guard let viewController = drawable.viewController else {
            return
        }

//        let searchNav = UINavigationController(rootViewController: viewController)
//        searchNav.modalPresentationStyle = .fullScreen
//        searchNav.modalTransitionStyle = .crossDissolve
        
        viewController.modalTransitionStyle = .crossDissolve
        viewController.modalPresentationStyle = .fullScreen
        
        if let closure = closure {
            closures.updateValue(closure, forKey: viewController.description)
        }
        
        navigationController.present(viewController, animated: true)
    }
    
    
    func pop(_ isAnimated: Bool) {
        print("pop")
    }
    
    func popToRoot(_ isAnimated: Bool) {
        print("Pop to root")
    }
    

    let navigationController: UINavigationController
    private var closures: [String: NavigationBackClosure] = [:]

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        super.init()
        self.navigationController.delegate = self
    }

    func push(_ drawable: Drawable, isAnimated: Bool, onNavigateBack closure: NavigationBackClosure?) {
        guard let viewController = drawable.viewController else {
            return
        }

        if let closure = closure {
            closures.updateValue(closure, forKey: viewController.description)
        }
        navigationController.pushViewController(viewController, animated: isAnimated)
        
    }
    
    func present(_ drawable: Drawable, isAnimated: Bool, onNavigateBack closure: NavigationBackClosure?){
        guard let viewController = drawable.viewController else {
            return
        }
        
        if let closure = closure {
            closures.updateValue(closure, forKey: viewController.description)
        }
        
        viewController.modalTransitionStyle = .crossDissolve
        viewController.modalPresentationStyle = .fullScreen
        
        navigationController.present(viewController, animated: true)
    }

    private func executeClosure(_ viewController: UIViewController) {
        guard let closure = closures.removeValue(forKey: viewController.description) else { return }
        closure()
    }
}

extension Router: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        
        guard let previousController = navigationController.transitionCoordinator?.viewController(forKey: .from),
              !navigationController.viewControllers.contains(previousController) else {
            return
        }
        
        executeClosure(previousController)
    }
}
