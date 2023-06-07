//
//  Characteristic.swift
//  HomeKitDemo
//
//  Created by iMac on 16/05/23.
//

import HomeKit

extension HMCharacteristic {
    var stateNames: [String] {
        switch characteristicType {
        case HMCharacteristicTypeCurrentLockMechanismState: return ["Unsecured", "Secured", "Jammed", "Unknown"]
        case HMCharacteristicTypeTargetLockMechanismState: return ["Not Locked", "Locked"]
        case HMCharacteristicTypeCurrentDoorState: return ["Open", "Closed", "Opening", "Closing", "Stopped"]
        case HMCharacteristicTypeTargetDoorState: return ["Open", "Closed"]
        default: return []
        }
    }
    
    var isWriteable: Bool {
        return properties.contains(HMCharacteristicPropertyWritable)
    }
    
    var isReadable: Bool {
        return properties.contains(HMCharacteristicPropertyReadable)
    }
    
    var isReadWrite: Bool {
        return isReadable && isWriteable
    }
    
    var isFloat: Bool {
        return metadata?.format == HMCharacteristicMetadataFormatFloat
    }
    
    var isInt: Bool {
        return metadata?.format == HMCharacteristicMetadataFormatInt
    }
    
    var isUInt: Bool {
        return metadata?.format == HMCharacteristicMetadataFormatUInt8
            || metadata?.format == HMCharacteristicMetadataFormatUInt16
            || metadata?.format == HMCharacteristicMetadataFormatUInt32
            || metadata?.format == HMCharacteristicMetadataFormatUInt64
        
    }
    
    var isNumeric: Bool {
        return isInt || isFloat || isUInt
    }
    
    var isBool: Bool {
        return metadata?.format == HMCharacteristicMetadataFormatBool
    }
    
    var span: Decimal {
        guard let max = metadata?.maximumValue?.decimalValue,
            let min = metadata?.minimumValue?.decimalValue  else {
                return 1.0
        }
        return max - min
    }
    
    var floatValue: Float? {
        return (value as? NSNumber)?.floatValue
    }
    
    var decimalValue: Decimal? {
        return (value as? NSNumber)?.decimalValue
    }
    
    func valueFor(fraction: Float) -> Decimal {
        let interval = metadata?.stepValue?.decimalValue ?? 1.0
        var inVal = (Decimal(Double(fraction)) * span) / interval
        var outVal: Decimal = 0.0
        NSDecimalRound(&outVal, &inVal, 0, .plain)
        return outVal * interval
    }
    
    var displayName: String {
        return metadata?.manufacturerDescription ?? localizedDescription
    }
    
    var formattedValueString: String {
        guard
            let value = value,
            let metadata = metadata else { return "—" }
        
        switch metadata.format {
        case HMCharacteristicMetadataFormatString:
            return value as? String ?? "—"
            
        case HMCharacteristicMetadataFormatInt,
             HMCharacteristicMetadataFormatUInt8,
             HMCharacteristicMetadataFormatUInt16,
             HMCharacteristicMetadataFormatUInt32,
             HMCharacteristicMetadataFormatUInt64:
            guard let intValue = value as? Int else { return "—" }
            guard stateNames.isEmpty else { return stateNames[intValue] }
            return String(intValue)
            
        case HMCharacteristicMetadataFormatFloat:
            guard let floatValue = floatValue else { return "—" }
            return String(format: "%.1f", floatValue)
            
        case HMCharacteristicMetadataFormatBool:
            guard let boolValue = value as? Bool else { return "—" }
            return boolValue ? "YES" : "NO"
            
        default:
            return "—"
        }
    }
}
