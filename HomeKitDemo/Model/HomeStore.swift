//
//  HomeStore.swift
//  HomeKitDemo
//
//  Created by iMac on 16/05/23.
//

import UIKit
import HomeKit

class HomeStore: NSObject {
    /// A singleton that can be used anywhere in the app to access the home manager.
    static var shared = HomeStore()
    
    /// The one and only home manager that belongs to the home store singleton.
    let homeManager = HMHomeManager()
    
    /// A set of objects that want to receive home delegate callbacks.
    var homeDelegates = Set<NSObject>()
    
    /// A set of objects that want to receive accessory delegate callbacks.
    var accessoryDelegates = Set<NSObject>()
    
}

// Actions performed by a given client that change HomeKit state don't generate
//  delegate callbacks in the same client. These convenience methods each
//  perform a particular update and make the corresponding delegate call.
extension HomeStore {
    
    /// Updates the name of a service and informs all accessory delegates.
    func updateService(_ service: HMService, name: String) {
        service.updateName(name) { error in
            if let error = error {
                print(error)
            } else if let accessory = service.accessory {
                self.accessory(accessory, didUpdateNameFor: service)
            }
        }
    }
    
    /// Moves an accessory to a given room and informs all the home delegates.
    func move(_ accessory: HMAccessory, in home: HMHome, to room: HMRoom) {
        home.assignAccessory(accessory, to: room) { error in
            if let error = error {
                print(error)
            } else {
                self.home(home, didUpdate: room, for: accessory)
            }
        }
    }
    
    /// Removes an accessory from a home and informs all the home delegates.
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
    /// Registers an object as a home delegate.
    func addHomeDelegate(_ delegate: NSObject) {
        homeDelegates.insert(delegate)
    }
    
    /// Deregisters a particular home delegate.
    func removeHomeDelegate(_ delegate: NSObject) {
        homeDelegates.remove(delegate)
    }
    
    /// Deregisters all home delegates.
    func removeAllHomeDelegates() {
        homeDelegates.removeAll()
    }
}

// MARK: - HMHome Delegate
extension HomeStore: HMHomeDelegate {
    
    // The home store's only interest in the home updates is distributing them
    //  to the objects that have registered as home delegates. Each of these
    //  methods therefore simply passes along the call to all the items in the set,
    //  after first ensuring that the item is in fact a home delegate.
    
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
    /// Registers an object as an accessory delegate.
    func addAccessoryDelegate(_ delegate: NSObject) {
        accessoryDelegates.insert(delegate)
    }
    
    /// Deregisters a particular accessory delegate.
    func removeAccessoryDelegate(_ delegate: NSObject) {
        accessoryDelegates.remove(delegate)
    }
    
    /// Deregisters all accessory delegates.
    func removeAllAccessoryDelegates() {
        accessoryDelegates.removeAll()
    }
}

// MARK: - HMAccessory Delegate
extension HomeStore: HMAccessoryDelegate {
    
    // The home store's only interest in the accessory updates is distributing them
    //  to the objects that have registered as accessory delegates. Each of these
    //  methods therefore simply passes along the call to all the items in the set,
    //  after first ensuring that the item is in fact an accessory delegate.
    
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
