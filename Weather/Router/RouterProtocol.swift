//
//  RouterProtocol.swift
//  Weather
//
//  Created by Long Tran on 03/01/2024.
//

import UIKit

protocol Drawable {
    var viewController: UIViewController? { get }
}

extension UIViewController: Drawable {
    var viewController: UIViewController? { return self }
}

typealias NavigationBackClosure = (() -> ())

protocol RouterProtocol: AnyObject{
    func push(_ drawable: Drawable, isAnimated: Bool, onNavigateBack: NavigationBackClosure?)
    func pop(_ isAnimated: Bool)
    func popToRoot(_ isAnimated: Bool)
    func presentFull(_ drawable: Drawable, isAnimated: Bool, onNavigateBack: NavigationBackClosure?)
    func present(_ drawable: Drawable, isAnimated: Bool, onNavigateBack: NavigationBackClosure?)
}


