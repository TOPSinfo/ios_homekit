//
//  Service.swift
//  HomeKitDemo
//
//  Created by iMac on 16/05/23.
//

import HomeKit

extension HMService {
    
    /// The service types that garage doors support.
    enum ServiceType {
        case lightBulb, garageDoor, airProfier, fan, swtch, doorBell, door, window, security, humiditySensor, humidifier, windowCovering, unknown
    }
    
    /// The Kilgo service type for this service.
    var kilgoServiceType: ServiceType {
        switch serviceType {
        case HMServiceTypeLightbulb: return .lightBulb
        case HMServiceTypeGarageDoorOpener: return .garageDoor
        case HMServiceTypeAirPurifier: return .airProfier
        case HMServiceTypeFan: return .fan
        case HMServiceTypeSwitch: return .swtch
        case HMServiceTypeDoorbell: return .doorBell
        case HMServiceTypeDoor: return .door
        case HMServiceTypeWindow: return .window
        case HMServiceTypeSecuritySystem: return .security
        case HMServiceTypeHumiditySensor: return .humiditySensor
        case HMServiceTypeHumidifierDehumidifier: return .humidifier
        case HMServiceTypeWindowCovering: return .windowCovering
        default: return .unknown
        }
    }
    
    /// The primary characteristic type to be controlled, given the service type.
    var primaryControlCharacteristicType: String? {
        switch kilgoServiceType {
        case .lightBulb: return HMCharacteristicTypePowerState
        case .garageDoor: return HMCharacteristicTypeTargetDoorState
        case .airProfier: return HMCharacteristicTypeTargetAirPurifierState
        case .fan: return HMCharacteristicTypeTargetFanState
        case .swtch: return HMCharacteristicTypeOutputState
        case .doorBell: return HMCharacteristicTypeTargetDoorState
        case .door: return HMCharacteristicTypeTargetDoorState
        case .window: return HMCharacteristicTypeCurrentPosition
        case .security: return HMCharacteristicTypeTargetSecuritySystemState
        case .humiditySensor: return HMCharacteristicTypeTargetRelativeHumidity
        case .humidifier: return HMCharacteristicTypeTargetHumidifierDehumidifierState
        case .windowCovering: return HMCharacteristicTypeSwingMode
        case .unknown: return nil
        }
    }

    /// The primary characteristic controlled by tapping the accessory cell in the accessory list.
    var primaryControlCharacteristic: HMCharacteristic? {
        return characteristics.first { $0.characteristicType == primaryControlCharacteristicType }
    }

    /// The primary characteristic type to be displayed, given the service type.
    var primaryDisplayCharacteristicType: String? {
        switch kilgoServiceType {
        case .lightBulb: return HMCharacteristicTypePowerState
        case .garageDoor: return HMCharacteristicTypeCurrentDoorState
        case .airProfier: return HMCharacteristicTypeCurrentAirPurifierState
        case .fan: return HMCharacteristicTypeCurrentFanState
        case .swtch: return HMCharacteristicTypeOutputState
        case .doorBell: return HMCharacteristicTypeCurrentDoorState
        case .door: return HMCharacteristicTypeCurrentDoorState
        case .window: return HMCharacteristicTypeCurrentPosition
        case .security: return HMCharacteristicTypeCurrentSecuritySystemState
        case .humiditySensor: return HMCharacteristicTypeCurrentRelativeHumidity
        case .humidifier: return HMCharacteristicTypeCurrentHumidifierDehumidifierState
        case .windowCovering: return HMCharacteristicTypeSwingMode
        case .unknown: return nil
        }
    }
    
    /// The primary characteristic visible in the accessory cell in the accessory list.
    var primaryDisplayCharacteristic: HMCharacteristic? {
        return characteristics.first { $0.characteristicType == primaryDisplayCharacteristicType }
    }
    
    /// The custom displayable characteristic types specific to Kilgo devices.
    enum KilgoCharacteristicTypes: String {
        case fadeRate = "7E536242-341C-4862-BE90-272CE15BD633"
    }

    /// The list of characteristics to display in the UI.
    var displayableCharacteristics: [HMCharacteristic] {
        let characteristicTypes = [HMCharacteristicTypePowerState,
                                   HMCharacteristicTypeBrightness,
                                   HMCharacteristicTypeHue,
                                   HMCharacteristicTypeSaturation,
                                   HMCharacteristicTypeTargetDoorState,
                                   HMCharacteristicTypeCurrentDoorState,
                                   HMCharacteristicTypeObstructionDetected,
                                   HMCharacteristicTypeTargetLockMechanismState,
                                   HMCharacteristicTypeCurrentLockMechanismState,
                                   HMCharacteristicTypeCurrentAirPurifierState,
                                   HMCharacteristicTypeCurrentFanState,
                                   HMCharacteristicTypeCurrentPosition,
                                   HMCharacteristicTypeHumidifierThreshold,
                                   HMCharacteristicTypeCurrentHumidifierDehumidifierState,
                                   HMCharacteristicTypeTargetHumidifierDehumidifierState,
                                   HMCharacteristicTypeTargetRelativeHumidity,
                                   HMCharacteristicTypeCurrentRelativeHumidity,
                                   HMCharacteristicTypeSwingMode,
                                   KilgoCharacteristicTypes.fadeRate.rawValue]
        
        return characteristics.filter { characteristicTypes.contains($0.characteristicType) }
    }

    /// A graphical representation of the service, given its current state.
    var icon: UIImage? {
        let (_, icon) = stateAndIcon
        return icon
    }
    
    /// A textual representation of the current state of the service.
    var state: String {
        let (state, _) = stateAndIcon
        return state
    }
    
    /// A tuple containing a string and icon representing the current state of the service.
    private var stateAndIcon: (String, UIImage?) {
        switch kilgoServiceType {
        case .garageDoor:
            return ("Unknown", #imageLiteral(resourceName: "door-closed"))
            /*
            if let value = primaryDisplayCharacteristic?.value as? Int,
                let doorState = HMCharacteristicValueDoorState(rawValue: value) {
                switch doorState {
                case .open: return ("Open", #imageLiteral(resourceName: "door-open"))
                case .closed: return ("Closed", #imageLiteral(resourceName: "door-closed"))
                case .opening: return ("Opening", #imageLiteral(resourceName: "door-opening"))
                case .closing: return ("Closing", #imageLiteral(resourceName: "door-closing"))
                case .stopped: return ("Stopped", #imageLiteral(resourceName: "door-closed"))
                @unknown default: return ("Unknown", nil)
                }
            } else {
                return ("Unknown", #imageLiteral(resourceName: "door-closed"))
            }
            */
        case .lightBulb:
            return ("Unknown", #imageLiteral(resourceName: "bulb-on"))
            /*
            if let value = primaryDisplayCharacteristic?.value as? Bool {
                if value {
                    return ("On", #imageLiteral(resourceName: "bulb-on"))
                } else {
                    return ("Off", #imageLiteral(resourceName: "bulb-off"))
                }
            } else {
                return ("Unknown", #imageLiteral(resourceName: "bulb-off"))
            }
            */
        case .airProfier:
            return ("Unknown", #imageLiteral(resourceName: "air.purifier"))
            /*
            if let value = primaryDisplayCharacteristic?.value as? Bool {
                if value {
                    return ("On", #imageLiteral(resourceName: "air.purifier.fill"))
                } else {
                    return ("Off", #imageLiteral(resourceName: "air.purifier"))
                }
            } else {
                return ("Unknown", #imageLiteral(resourceName: "air.purifier"))
            }
             */
        case .fan:
            return ("Unknown", #imageLiteral(resourceName: "fan.floor"))
            /*
            if let value = primaryDisplayCharacteristic?.value as? Bool {
                if value {
                    return ("On", #imageLiteral(resourceName: "fan.floor.fill"))
                } else {
                    return ("Off", #imageLiteral(resourceName: "fan.floor"))
                }
            } else {
                return ("Unknown", #imageLiteral(resourceName: "fan.floor"))
            }
            */
        case .swtch:
            return ("Unknown", #imageLiteral(resourceName: "lightswitch.off"))
            /*
            if let value = primaryDisplayCharacteristic?.value as? Bool {
                if value {
                    return ("On", #imageLiteral(resourceName: "lightswitch.on"))
                } else {
                    return ("Off", #imageLiteral(resourceName: "lightswitch.off"))
                }
            } else {
                return ("Unknown", #imageLiteral(resourceName: "lightswitch.off"))
            }
            */
        case .doorBell:
            return ("Unknown", #imageLiteral(resourceName: "video.doorbell"))
            /*
            if let value = primaryDisplayCharacteristic?.value as? Bool {
                if value {
                    return ("On", #imageLiteral(resourceName: "video.doorbell.fill"))
                } else {
                    return ("Off", #imageLiteral(resourceName: "video.doorbell"))
                }
            } else {
                return ("Unknown", #imageLiteral(resourceName: "video.doorbell"))
            }
            */
        case .door:
            return ("Unknown", #imageLiteral(resourceName: "video.doorbell"))
            /*
            if let value = primaryDisplayCharacteristic?.value as? Bool {
                if value {
                    return ("On", #imageLiteral(resourceName: "video.doorbell.fill"))
                } else {
                    return ("Off", #imageLiteral(resourceName: "video.doorbell"))
                }
            } else {
                return ("Unknown", #imageLiteral(resourceName: "video.doorbell"))
            }
            */
        case .window:
            return ("Unknown", #imageLiteral(resourceName: "window.shade.closed"))
            /*
            if let value = primaryDisplayCharacteristic?.value as? Bool {
                if value {
                    return ("On", #imageLiteral(resourceName: "window.shade.open"))
                } else {
                    return ("Off", #imageLiteral(resourceName: "window.shade.closed"))
                }
            } else {
                return ("Unknown", #imageLiteral(resourceName: "window.shade.closed"))
            }
            */
        case .security:
            return ("Unknown", #imageLiteral(resourceName: "lock.shield"))
        case .humiditySensor:
            return ("Unknown", #imageLiteral(resourceName: "sensor"))
        case .humidifier:
            return ("Unknown", #imageLiteral(resourceName: "dehumidifier.fill"))
        case .windowCovering:
            return ("Unknown", #imageLiteral(resourceName: "window.shade.closed"))
        case .unknown:
            return ("Unknown", nil)
        }
    }
}
