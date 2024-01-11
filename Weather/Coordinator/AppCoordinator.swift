//
//  File.swift
//  Weather
//
//  Created by Long Tran on 03/01/2024.
//

import UIKit


class AppCoordinator: BaseCoordinator{
    
    
    let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
        super.init()
    }
    
    override func start() {
        let masterCoordinator = MasterCoordinator(window: self.window)
        masterCoordinator.start()
        self.store(coordinator: masterCoordinator)
        masterCoordinator.isCompleted = { [weak self] in
            print("free masterCoordinator")
            self?.free(coordinator: masterCoordinator)
        }

    }
}
