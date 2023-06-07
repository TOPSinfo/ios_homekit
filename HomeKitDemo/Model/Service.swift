//
//  Service.swift
//  HomeKitDemo
//
//  Created by iMac on 16/05/23.
//

import HomeKit

extension HMService {
    enum ServiceType {
        case lightBulb, garageDoor, airProfier, fan, swtch, doorBell, door, window, security, humiditySensor, humidifier, windowCovering, unknown
    }
    
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

    var primaryControlCharacteristic: HMCharacteristic? {
        return characteristics.first { $0.characteristicType == primaryControlCharacteristicType }
    }

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
    
    var primaryDisplayCharacteristic: HMCharacteristic? {
        return characteristics.first { $0.characteristicType == primaryDisplayCharacteristicType }
    }
    
    enum KilgoCharacteristicTypes: String {
        case fadeRate = "7E536242-341C-4862-BE90-272CE15BD633"
    }

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

    var icon: UIImage? {
        let (_, icon) = stateAndIcon
        return icon
    }
    
    var state: String {
        let (state, _) = stateAndIcon
        return state
    }
    
    private var stateAndIcon: (String, UIImage?) {
        switch kilgoServiceType {
        case .garageDoor:
            return ("Unknown", #imageLiteral(resourceName: "door-closed"))
        case .lightBulb:
            return ("Unknown", #imageLiteral(resourceName: "bulb-on"))
        case .airProfier:
            return ("Unknown", #imageLiteral(resourceName: "air.purifier"))
        case .fan:
            return ("Unknown", #imageLiteral(resourceName: "fan.floor"))
        case .swtch:
            return ("Unknown", #imageLiteral(resourceName: "lightswitch.off"))
        case .doorBell:
            return ("Unknown", #imageLiteral(resourceName: "video.doorbell"))
        case .door:
            return ("Unknown", #imageLiteral(resourceName: "video.doorbell"))
        case .window:
            return ("Unknown", #imageLiteral(resourceName: "window.shade.closed"))
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
