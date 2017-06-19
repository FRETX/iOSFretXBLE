//
//  fretxBLE.swift
//  bluetoothLE
//
//  Created by Onur Babacan on 19/06/2017.
//  Copyright © 2017 Onur Babacan. All rights reserved.
//

import Foundation
import CoreBluetooth

public protocol FretxProtocol{
    func didConnect()
    func didDisconnect()
    func didBLEStateChange(state:CBManagerState)
}

public class FretxBLE: NSObject {
    
    public static let sharedInstance = FretxBLE()
    private let bleManager = BLEManager.sharedInstance
    private let util = Utilities.sharedInstance
    
    public var delegate:FretxProtocol?
    
    public var isScanning:Bool {
        get {return bleManager.isScanning}
    }
    public var isConnected:Bool {
        get {return bleManager.isConnected}
    }
    
    internal override init() {
        super.init()
        print("FretX init -- verbose mode OFF")
    }
    
    
    
    public func connect(){
        bleManager.connectToFretX()
    }
    
    public func connectKeepTrying(){
        
    }
    
    public func send(fretCodes:[UInt8]){
        bleManager.sendToFretX(fretCodes: fretCodes)
    }
    
    
    
    
    //UTIL
    public func verboseOff(){
        util.verbose = false
    }
    
    public func verboseOn(){
        util.verbose = true
    }

    
}
