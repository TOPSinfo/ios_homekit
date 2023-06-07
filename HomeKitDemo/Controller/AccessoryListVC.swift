//
//  AccessoryListVC.swift
//  HomeKitDemo
//
//  Created by iMac on 16/05/23.
//

import UIKit
import HomeKit

class AccessoryListVC: UICollectionViewController {
    var noDataLbl: UILabel?
    var services = [HMService]()
    var home: HMHome? {
        didSet {
            home?.delegate = HomeStore.shared
            reloadData()
        }
    }
 
    func reloadData() {
        services = []
        guard let home = home else { return }
        for accessory in home.accessories {
            accessory.delegate = HomeStore.shared
            for service in accessory.services.filter({ $0.isUserInteractive }) {
                services.append(service)
                for characteristic in service.characteristics.filter({
                    $0.properties.contains(HMCharacteristicPropertySupportsEventNotification)
                }) {
                    characteristic.enableNotification(true) { _ in }
                }
            }
        }
        
        if services.isEmpty {
            self.showNoAccessoryLabel()
        } else {
            self.removeNoAccessoryLabel()
        }

        collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpNoAccessoryLabel()
        HomeStore.shared.homeManager.delegate = self
        HomeStore.shared.addHomeDelegate(self)
        HomeStore.shared.addAccessoryDelegate(self)
        
        if let cvLayout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            cvLayout.estimatedItemSize = .zero
        }
    }
    
    deinit {
        HomeStore.shared.homeManager.delegate = nil
        HomeStore.shared.removeHomeDelegate(self)
        HomeStore.shared.removeAccessoryDelegate(self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let accessoryDetail = segue.destination as? AccessoryDetail
            if let indexpath = self.collectionView.indexPathsForSelectedItems {
                accessoryDetail?.service = services[indexpath[0].item]
                accessoryDetail?.home = home
            }
        }
    }
    
    @IBAction func tapAdd(_ sender: UIBarButtonItem) {
        home?.addAndSetupAccessories(completionHandler: { error in
            if let error = error {
                print(error)
            } else {
                self.reloadData()
            }
        })
    }

}
// MARK: - UICollectionView Delegate & DataSource
extension AccessoryListVC {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return services.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AccessoryCell", for: indexPath)
        cell.layer.cornerRadius = 10

        if let accessoryCell = cell as? AccessoryCell {
            accessoryCell.service = services[indexPath.item]
            accessoryCell.disclosureButton.tag = indexPath.item
        }

        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showDetail", sender: nil)
    }
}

// MARK: - HMHome Manager Delegate
extension AccessoryListVC: HMHomeManagerDelegate {
    func homeManagerDidUpdateHomes(_ manager: HMHomeManager) {
        setOrAddHome(manager: manager)
    }
    
    func homeManagerDidUpdatePrimaryHome(_ manager: HMHomeManager) {
        setOrAddHome(manager: manager)
    }
    
    func setOrAddHome(manager: HMHomeManager) {
        if manager.primaryHome != nil {
            home = manager.primaryHome
        } else if let firstHome = manager.homes.first {
            home = firstHome
        } else {
            let alert = UIAlertController(title: "Add a Home",
                                          message: "There aren’t any homes in the database. Create a home to work with.",
                                          preferredStyle: .alert)
            alert.addTextField { $0.placeholder = "Name" }
            alert.addAction(UIAlertAction(title: "Create", style: .default) { _ in
                if let name = alert.textFields?[0].text {
                    manager.addHome(withName: name) { home, error in
                        if let error = error {
                            print("Error adding home: \(error)")
                        } else {
                            self.home = home
                        }
                    }
                }
            })
            present(alert, animated: true)
        }
    }
}

// MARK: - HMHome Delegate
extension AccessoryListVC: HMHomeDelegate {
    func homeDidUpdateName(_ home: HMHome) {
        guard home == self.home else { return }
        title = home.name
    }

    func home(_ home: HMHome, didAdd accessory: HMAccessory) {
        guard home == self.home else { return }
        accessory.delegate = HomeStore.shared
        reloadData()
    }
    
    func home(_ home: HMHome, didUpdate room: HMRoom, for accessory: HMAccessory) {
        for service in accessory.services {
            if let item = services.firstIndex(of: service) {
                let cell = collectionView.cellForItem(at: IndexPath(item: item, section: 0)) as? AccessoryCell
                cell?.roomLabel.text = room.name
            }
        }
    }
    
    func home(_ home: HMHome, didRemove accessory: HMAccessory) {
        guard home == self.home else { return }
        navigationController?.popToRootViewController(animated: true)
        reloadData()
    }
    
    func home(_ home: HMHome, didUpdateNameFor room: HMRoom) {
        for cell in collectionView.visibleCells {
            (cell as? AccessoryCell)?.roomLabel.text = room.name
        }
    }
    
    func home(_ home: HMHome, didEncounterError error: Error, for accessory: HMAccessory) {
        print(error.localizedDescription)
    }
}

// MARK: - HMAccessory Delegate
extension AccessoryListVC: HMAccessoryDelegate {
    func accessory(_ accessory: HMAccessory, service: HMService, didUpdateValueFor characteristic: HMCharacteristic) {
        if let item = services.firstIndex(of: service) {
            let cell = collectionView.cellForItem(at: IndexPath(item: item, section: 0)) as? AccessoryCell
            cell?.redrawState()
        }
    }
    
    func accessory(_ accessory: HMAccessory, didUpdateNameFor service: HMService) {
        if let item = services.firstIndex(of: service) {
            let cell = collectionView.cellForItem(at: IndexPath(item: item, section: 0)) as? AccessoryCell
            cell?.nameLabel.text = service.name
        }
    }
}

// MARK: - No Accessory Label
extension AccessoryListVC {
    func setUpNoAccessoryLabel() {
        noDataLbl = UILabel(frame: CGRect(x: 0, y: self.view.center.y, width: UIScreen.main.bounds.size.width - 60, height: 70))
        noDataLbl?.textAlignment = .center
        noDataLbl?.font = UIFont(name: "Halvetica", size: 18.0)
        noDataLbl?.numberOfLines = 0
        noDataLbl?.text = "No Accessory found. Please add new accessory by pressing + button on top right corner."
        noDataLbl?.lineBreakMode = .byTruncatingTail
        noDataLbl?.center = self.view.center
    }
    
    func showNoAccessoryLabel() {
        self.view.addSubview(noDataLbl!)
    }
    
    func removeNoAccessoryLabel() {
        noDataLbl?.removeFromSuperview()
    }
}

extension AccessoryListVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 20, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
}
