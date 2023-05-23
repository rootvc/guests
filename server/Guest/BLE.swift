//
//  BLE.swift
//  Guest
//
//  Created by Yasyf Mohamedali on 5/22/23.
//

import Foundation
import CoreLocation
import CoreBluetooth


enum Reserved: String, CaseIterable {
    // Services
    case GuestService = "9b5397cb-c6b3-4f53-9182-741b79f5c920"
    case DeviceInformationService = "0x180A"
    // Characteristics
    case DeviceName = "0x2A00"
    case UserId = "0x2AC3"
    case AccessCode = "e9b4a846-e002-4097-9210-10da573e6ce5"
}

class BLE: NSObject, CBPeripheralManagerDelegate {
    static let Name = "RootVC Guest Server"
    
    var clients: [CBCentral: User] = [:]
    var peripheral: CBPeripheralManager?
    
    func isStarted() -> Bool {
        self.peripheral != nil
    }
    
    func id(_ val: Reserved) -> CBUUID {
        CBUUID(string: val.rawValue)
    }
    
    func char(forReading type: Reserved, withValue val: String? = nil) -> CBMutableCharacteristic {
        CBMutableCharacteristic(type: id(type), properties: .read, value: val?.data(using: .utf8), permissions: .readable)
    }
    
    func char(forWriting type: Reserved) -> CBMutableCharacteristic {
        CBMutableCharacteristic(type: id(type), properties: .write, value: nil, permissions: .writeable)
    }
    
    func service(_ type: Reserved, chars: [CBMutableCharacteristic] = []) -> CBUUID {
        let service = CBMutableService(type: id(type), primary: true)
        service.characteristics = chars
        self.peripheral!.add(service)
        return id(type)
    }
    
    
    func advertise() {
        let services = [
            service(.GuestService, chars: [char(forWriting: .UserId), char(forReading: .AccessCode)]),
            service(.DeviceInformationService, chars: [char(forReading: .DeviceName, withValue: Self.Name)])
        ]
        self.peripheral!.startAdvertising([CBAdvertisementDataLocalNameKey: Self.Name, CBAdvertisementDataServiceUUIDsKey: services])
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
            print(peripheral.state)
        }
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
        for request in requests {
            if (request.characteristic.uuid != id(.UserId)) {
                peripheral.respond(to: request, withResult: CBATTError.Code.requestNotSupported)
            }
            
            self.clients[request.central] = User(id: UUID(uuidString: String(decoding: request.value!, as: UTF8.self))!)
        }
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveRead request: CBATTRequest) {
        if request.characteristic.uuid != id(.AccessCode) {
            request.value = request.characteristic.value
            peripheral.respond(to: request, withResult: CBATTError.Code.success)
            return
        }
        
        // Check for name on Clerk, and create code
        if let user = clients[request.central] {
            request.value = user.code;
            peripheral.respond(to: request, withResult: CBATTError.Code.success)
        } else {
            peripheral.respond(to: request, withResult: CBATTError.Code.insufficientAuthentication)
        }
    }
}
