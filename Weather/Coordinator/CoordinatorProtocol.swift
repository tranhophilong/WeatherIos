//
//  CoordinatorProtocol.swift
//  Weather
//
//  Created by Long Tran on 03/01/2024.
//

import Foundation


protocol Coordinator: AnyObject{
    var childCoordinators : [Coordinator] { get set }
    func start()
}

extension Coordinator {

    func store(coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }

    func free(coordinator: Coordinator) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }
}


class BaseCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var isCompleted: (() -> ())?

    func start() {
        fatalError("Children should implement `start`.")
    }
}
