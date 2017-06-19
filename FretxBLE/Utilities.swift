//
//  Utilities.swift
//  bluetoothLE
//
//  Created by Onur Babacan on 19/06/2017.
//  Copyright © 2017 Onur Babacan. All rights reserved.
//

import Foundation

internal class Utilities{
    var verbose = false
    
    internal static let sharedInstance = Utilities()
    
    private init() {
        
    }
    
    internal func printMessage(_ message:String){
        if verbose {
            print(message)
        }
        
    }
}
