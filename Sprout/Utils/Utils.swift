//
//  Utils.swift
//  Sprout
//
//  Created by Blanc on 2022/11/10.
//  Copyright © 2022 Blanc. All rights reserved.
//

import UIKit
import Foundation

func APP_WIDTH() -> CGFloat {
    return UIScreen.main.bounds.size.width
}

func APP_HEIGHT() -> CGFloat {
    return UIScreen.main.bounds.size.height
}

func APP_VERSION() -> String{
    return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
}

func OS_VERSION() -> String{
    return UIDevice.current.systemVersion
}

func DEVICE_MODEL() -> String{
    return UIDevice.current.name
}

func DEBUG_LOG(_ msg: Any, file: String = #file, function: String = #function, line: Int = #line) {
    #if DEBUG
        let fileName = file.split(separator: "/").last ?? ""
        let funcName = function.split(separator: "(").first ?? ""
        print("[\(fileName)] \(funcName)(\(line)): \(msg)")
    #endif
}
