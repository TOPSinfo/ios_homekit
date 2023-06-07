//
//  AccessoryCell.swift
//  HomeKitDemo
//
//  Created by iMac on 16/05/23.
//

import UIKit
import HomeKit

class AccessoryCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var roomLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var disclosureButton: UIButton!
    
    var service: HMService? {
        didSet {
            print(service?.icon)
            imageView.image = service?.icon == nil ? UIImage.init(systemName: "questionmark") : service?.icon
            if service?.icon == nil {
                imageView.tintColor = .white
            }
            roomLabel.text = service?.accessory?.room?.name
            nameLabel.text = service?.name
            stateLabel.text = "Updating..."

            readAndRedraw(characteristic: service?.primaryDisplayCharacteristic, animated: true)
        }
    }
    
    func readAndRedraw(characteristic: HMCharacteristic?, animated: Bool) {
        guard
            let characteristic = characteristic,
            characteristic.properties.contains(HMCharacteristicPropertyReadable),
            let accessory = characteristic.service?.accessory,
            accessory.isReachable else {
                stateLabel.text = "Unreachable"
                return
        }
        
        characteristic.readValue { error in
            self.redrawState(error: error)
        }
    }
    
    func redrawState(error: Error? = nil) {
        imageView.image = service?.icon

        if let error = error {
            print(error.localizedDescription)
            stateLabel.text = "Update error!"
        } else {
            stateLabel.text = service?.state
        }
    }
    
    func tap() {
        if let characteristic = service?.primaryControlCharacteristic,
            let value = characteristic.value as? Bool {
            bounce()
            characteristic.writeValue(!value) { error in
                self.redrawState(error: error)
            }
        }
    }

    private func bounce() {
        UIView.animate(withDuration: 0.05, animations: {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) {_ in
            UIView.animate(withDuration: 0.10, animations: {
                self.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
            }) {_ in
                UIView.animate(withDuration: 0.15, animations: {
                    self.transform = .identity
                })
            }
        }
    }
}
