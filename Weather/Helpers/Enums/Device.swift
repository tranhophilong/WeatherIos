//
//  Device.swift
//  AdaptiveLayoutUIKit
//
//  Created by Родион on 11.07.2020.
//  Copyright © 2020 Rodion Artyukhin. All rights reserved.
//

import UIKit

import UIKit

enum Device {
    case iPhone8
    case iPhone8Plus
    case iphoneX
    case iPhone11Pro
    case iPhone11ProMax
    case iPhone12
    case iPhone12ProMax
    case iphone15Pro
    
    static let baseScreenSize: Device = .iphone15Pro
}

extension Device: RawRepresentable {
    typealias RawValue = CGSize
    
    init?(rawValue: CGSize) {
        switch rawValue {
        case CGSize(width: 375, height: 667):
            self = .iPhone8
        case CGSize(width: 414, height: 736):
            self = .iPhone8Plus
        case CGSize(width: 375, height: 812):
            self = .iPhone11Pro
        case CGSize(width: 375, height: 812):
            self = .iphoneX
        case CGSize(width: 414, height: 896):
            self = .iPhone11ProMax
        case CGSize(width: 390, height: 844):
            self = .iPhone12
        case CGSize(width: 428, height: 926):
            self = .iPhone12ProMax
        case CGSize(width: 393, height: 852):
            self = .iphone15Pro
       
        default:
            return nil
        }
    }
    
    var rawValue: CGSize {
        switch self {
        case .iPhone8:
            return CGSize(width: 375, height: 667)
        case .iPhone8Plus:
            return CGSize(width: 414, height: 736)
        case .iPhone11Pro:
            return CGSize(width: 375, height: 812)
        case .iPhone11ProMax:
            return CGSize(width: 414, height: 896)
        case .iPhone12:
            return CGSize(width: 390, height: 844)
        case .iPhone12ProMax:
            return CGSize(width: 428, height: 926)
        case .iphone15Pro:
            return CGSize(width: 393, height: 852)
        case .iphoneX:
            return CGSize(width: 375, height: 812)
        }
    }
}
