//
//  BLE.swift
//  Guest
//
//  Created by Yasyf Mohamedali on 5/22/23.
//

import Foundation
import CoreLocation
import CoreBluetooth

class BLE: NSObject, CBPeripheralManagerDelegate {
    static let ID = (name: "vc.root.guest", uuid: UUID(uuidString: "39ED98FF-2900-441A-802F-9C398FC199D2")!)
    static let VERSION = (major: CLBeaconMajorValue(1), minor: CLBeaconMinorValue(0))
    
    let region: CLBeaconRegion
    var peripheral: CBPeripheralManager?
    
    override init() {
        self.region = CLBeaconRegion(uuid: Self.ID.uuid, major: Self.VERSION.major, minor: Self.VERSION.minor, identifier: Self.ID.name)
    }
    
    func isStarted() -> Bool {
        self.peripheral != nil
    }
    
    func advertise() {
        let peripheralData = self.region.peripheralData(withMeasuredPower: nil)
        self.peripheral!.startAdvertising((peripheralData as! [String : Any]))
    }
    
    func start() {
        self.peripheral = CBPeripheralManager(delegate:self, queue: nil)
    }
    
    func stop() {
        self.peripheral?.stopAdvertising()
        self.peripheral = nil
    }
    
    func toggle() {
        self.isStarted() ? stop() : start()
    }
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        switch peripheral.state {
        case .poweredOn:
            self.advertise()
        default:
            break
        }
    }
}
