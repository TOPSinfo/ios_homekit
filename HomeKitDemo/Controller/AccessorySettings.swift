//
//  AccessorySettings.swift
//  HomeKitDemo
//
//  Created by iMac on 25/05/23.
//

import UIKit
import HomeKit

class AccessorySettings: UITableViewController {
    
    /// The list of characteristics to display.
    var characteristics = [HMCharacteristic]()
    
    /// The service that owns the characteristics to display.
    var service: HMService? {
        didSet {
            // Capture a curated list of characteristics.
            characteristics = service?.characteristics ?? []
        }
    }
    
    /// Registers this instance to receive accessory delegate callbacks.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        HomeStore.shared.addAccessoryDelegate(self)
    }
    
    /// Deregisters this instance as an accessory delegate.
    deinit {
        HomeStore.shared.removeAccessoryDelegate(self)
    }

    // MARK: - Table view data source

    /// Tells the table view to create one cell for each characteristic.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characteristics.count
    }

    /// Supplies the table view with configured cells.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CharacteristicCell", for: indexPath)

        if let characteristicCell = cell as? CharacteristicCell {
            characteristicCell.characteristic = characteristics[indexPath.row]
        }
        
        return cell
    }

}
