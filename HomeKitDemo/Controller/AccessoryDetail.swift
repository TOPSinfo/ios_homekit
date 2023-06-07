//
//  AccessoryDetail.swift
//  HomeKitDemo
//
//  Created by iMac on 23/05/23.
//

import UIKit
import HomeKit

class AccessoryDetail: UITableViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var roomLabel: UILabel!
    @IBOutlet weak var modelLabel: UILabel!
    @IBOutlet weak var firmwareLabel: UILabel!
    var service: HMService?
    var home: HMHome?

    func reloadData() {
        title = service?.name ?? "Accessory Detail"
        nameLabel.text = service?.name
        roomLabel.text = service?.accessory?.room?.name
        modelLabel.text = service?.accessory?.model
        firmwareLabel.text = service?.accessory?.firmwareVersion
        
        print(service?.accessory?.manufacturer ?? "")
    }
    
    @IBAction func btnRemoveAccessoryTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Remove Accessory",
                                      message: "Are you sure you want to remove this accessory?",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Remove", style: .destructive) { _ in
            if let accessory = self.service?.accessory,
                let home = self.home {
                HomeStore.shared.remove(accessory, from: home)
            }
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
        })
        present(alert, animated: true)
    }
    
    /// Registers this view controller to receive various delegate callbacks.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        HomeStore.shared.addHomeDelegate(self)
        HomeStore.shared.addAccessoryDelegate(self)
        
        reloadData()
    }
    
    /// Deregisters this view controller as various kinds of delegate.
    deinit {
        HomeStore.shared.removeHomeDelegate(self)
        HomeStore.shared.removeAccessoryDelegate(self)
    }

    /// Prepares to show one of the child views of this view.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        /*
        if let controller = segue.destination as? NameEditor {
            controller.service = service
            
        } else if let controller = segue.destination as? RoomPicker {
            controller.service = service
            controller.home = home

        } else if let controller = segue.destination as? AccessorySettings {
            controller.service = service
        }
        */
        
        if let controller = segue.destination as? AccessorySettings {
            controller.service = service
        }
    }
    
    /// Handles table view cell taps.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath == IndexPath(row: 0, section: 2) {
            let alert = UIAlertController(title: "Remove Accessory",
                                          message: "Are you sure you want to remove this accessory?",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Remove", style: .destructive) { _ in
                if let accessory = self.service?.accessory,
                    let home = self.home {
                    HomeStore.shared.remove(accessory, from: home)
                }
            })
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
                self.tableView.deselectRow(at: indexPath, animated: true)
            })
            present(alert, animated: true)
        }
    }
}
