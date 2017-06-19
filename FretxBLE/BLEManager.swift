//
//  BLEDelegate.swift
//  bluetoothLE
//
//  Created by Onur Babacan on 19/06/2017.
//  Copyright © 2017 Onur Babacan. All rights reserved.
//

import Foundation
import CoreBluetooth

internal class BLEManager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate{
    
    
    internal static let sharedInstance = BLEManager()
    private let util = Utilities.sharedInstance
    
    let deviceName = "FretX"
    let rxServiceUUID = CBUUID(string: "6e400001-b5a3-f393-e0a9-e50e24dcca9e")
    let rxCharacteristicUUID = CBUUID(string: "6e400002-b5a3-f393-e0a9-e50e24dcca9e")
    
    var centralManager:CBCentralManager!
    var fretx:CBPeripheral?
    var txCharacteristic:CBCharacteristic?

    internal var isConnected = false
    internal var isScanning = false
    
    
    
    private override init() {
        super.init()
        self.centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    internal func connectToFretX(){
        centralManager.scanForPeripherals(withServices: nil, options: nil)
    }
    
    internal func sendToFretX(fretCodes:[UInt8]){
        var lightValues:[UInt8] = fretCodes;
        let data = NSData(bytes: &lightValues, length: lightValues.count )
        fretx?.writeValue(data as Data, for: txCharacteristic!, type: CBCharacteristicWriteType.withoutResponse)
        util.printMessage("Sending data to FretX")
    }
    
    internal func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        let device = (advertisementData as NSDictionary).object(forKey: CBAdvertisementDataLocalNameKey) as? NSString
        
        if device?.contains(deviceName) == true {
            self.centralManager.stopScan()
            util.printMessage("FretX Found")
            util.printMessage("RSSI: \(RSSI)")
            self.fretx = peripheral
            self.fretx?.delegate = self
            centralManager.connect(self.fretx!, options: nil)
        }
        
    }
    
    internal func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        fretx?.discoverServices([rxServiceUUID])
        isConnected = true
        util.printMessage("Connected to FretX")
        if let dlg = FretxBLE.sharedInstance.delegate{
            dlg.didConnect()
        }
    }
    
    internal func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        isConnected = false
        util.printMessage("Disconnected from FretX")
        if let dlg = FretxBLE.sharedInstance.delegate{
            dlg.didDisconnect()
        }
    }
    
    internal func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        for service in peripheral.services!{
            let thisService = service as CBService
            if service.uuid == rxServiceUUID {
                util.printMessage("Discovered RX service")
                peripheral.discoverCharacteristics([rxCharacteristicUUID], for: thisService)
            }
        }
    }
    
    internal func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        if let characteristics = service.characteristics{
            for characteristic in characteristics {
                if characteristic.uuid == rxCharacteristicUUID{
                    util.printMessage("Discovered RX characteristic \(characteristic.uuid)")
                    txCharacteristic = characteristic
                }
            }
        }
    }
    
    internal func centralManagerDidUpdateState(_ central: CBCentralManager) {
        var message = ""
        switch central.state {
        case  .poweredOff:
            message = "Bluetooth on this device is currently powered off"
        case .resetting:
            message = "BLE manager is resetting, please try again in a moment"
        case .unauthorized:
            message = "Bluetooth usage is not authorized for this app"
        case .unknown:
            message = "The BLE manager state is unknown"
        case .unsupported:
            message = "This device does not support Bluetooth Low Energy"
        case .poweredOn:
            message = "BLE is turned on and ready for communication"
        }
        util.printMessage(message)
        if let dlg = FretxBLE.sharedInstance.delegate{
            dlg.didBLEStateChange(state:central.state)
        }
    }

    
}
