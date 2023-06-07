//
//  HomeStore.swift
//  HomeKitDemo
//
//  Created by iMac on 16/05/23.
//

import UIKit
import HomeKit

class HomeStore: NSObject {
    static var shared = HomeStore()
    let homeManager = HMHomeManager()
    var homeDelegates = Set<NSObject>()
    var accessoryDelegates = Set<NSObject>()
}

extension HomeStore {
    func updateService(_ service: HMService, name: String) {
        service.updateName(name) { error in
            if let error = error {
                print(error)
            } else if let accessory = service.accessory {
                self.accessory(accessory, didUpdateNameFor: service)
            }
        }
    }
    
    func move(_ accessory: HMAccessory, in home: HMHome, to room: HMRoom) {
        home.assignAccessory(accessory, to: room) { error in
            if let error = error {
                print(error)
            } else {
                self.home(home, didUpdate: room, for: accessory)
            }
        }
    }
    
    func remove(_ accessory: HMAccessory, from home: HMHome) {
        home.removeAccessory(accessory) { error in
            if let error = error {
                print(error)
            } else {
                self.home(home, didRemove: accessory)
            }
        }
    }
}

extension HomeStore {
    func addHomeDelegate(_ delegate: NSObject) {
        homeDelegates.insert(delegate)
    }
    
    func removeHomeDelegate(_ delegate: NSObject) {
        homeDelegates.remove(delegate)
    }
    
    func removeAllHomeDelegates() {
        homeDelegates.removeAll()
    }
}

// MARK: - HMHome Delegate
extension HomeStore: HMHomeDelegate {
    func homeDidUpdateName(_ home: HMHome) {
        homeDelegates.forEach {
            guard let delegate = $0 as? HMHomeDelegate else { return }
            delegate.homeDidUpdateName?(home)
        }
    }

    func home(_ home: HMHome, didAdd accessory: HMAccessory) {
        homeDelegates.forEach {
            guard let delegate = $0 as? HMHomeDelegate else { return }
            delegate.home?(home, didAdd: accessory)
        }
    }
    
    func home(_ home: HMHome, didUpdate room: HMRoom, for accessory: HMAccessory) {
        homeDelegates.forEach {
            guard let delegate = $0 as? HMHomeDelegate else { return }
            delegate.home?(home, didUpdate: room, for: accessory)
        }
    }
    
    func home(_ home: HMHome, didRemove accessory: HMAccessory) {
        homeDelegates.forEach {
            guard let delegate = $0 as? HMHomeDelegate else { return }
            delegate.home?(home, didRemove: accessory)
        }
    }
    
    func home(_ home: HMHome, didAdd room: HMRoom) {
        homeDelegates.forEach {
            guard let delegate = $0 as? HMHomeDelegate else { return }
            delegate.home?(home, didAdd: room)
        }
    }
    
    func home(_ home: HMHome, didUpdateNameFor room: HMRoom) {
        homeDelegates.forEach {
            guard let delegate = $0 as? HMHomeDelegate else { return }
            delegate.home?(home, didUpdateNameFor: room)
        }
    }

    func home(_ home: HMHome, didRemove room: HMRoom) {
        homeDelegates.forEach {
            guard let delegate = $0 as? HMHomeDelegate else { return }
            delegate.home?(home, didRemove: room)
        }
    }

    func home(_ home: HMHome, didEncounterError error: Error, for accessory: HMAccessory) {
        homeDelegates.forEach {
            guard let delegate = $0 as? HMHomeDelegate else { return }
            delegate.home?(home, didEncounterError: error, for: accessory)
        }
   }
}

extension HomeStore {
    func addAccessoryDelegate(_ delegate: NSObject) {
        accessoryDelegates.insert(delegate)
    }
    
    func removeAccessoryDelegate(_ delegate: NSObject) {
        accessoryDelegates.remove(delegate)
    }
    
    func removeAllAccessoryDelegates() {
        accessoryDelegates.removeAll()
    }
}

// MARK: - HMAccessory Delegate
extension HomeStore: HMAccessoryDelegate {
    func accessory(_ accessory: HMAccessory, didUpdateNameFor service: HMService) {
        accessoryDelegates.forEach {
            guard let delegate = $0 as? HMAccessoryDelegate else { return }
            delegate.accessory?(accessory, didUpdateNameFor: service)
        }
    }
    
    func accessoryDidUpdateReachability(_ accessory: HMAccessory) {
        accessoryDelegates.forEach {
            guard let delegate = $0 as? HMAccessoryDelegate else { return }
            delegate.accessoryDidUpdateReachability?(accessory)
        }
    }
    
    func accessoryDidUpdateServices(_ accessory: HMAccessory) {
        accessoryDelegates.forEach {
            guard let delegate = $0 as? HMAccessoryDelegate else { return }
            delegate.accessoryDidUpdateServices?(accessory)
        }
    }
    
    func accessory(_ accessory: HMAccessory, service: HMService, didUpdateValueFor characteristic: HMCharacteristic) {
        accessoryDelegates.forEach {
            guard let delegate = $0 as? HMAccessoryDelegate else { return }
            delegate.accessory?(accessory, service: service, didUpdateValueFor: characteristic)
        }
    }
}
