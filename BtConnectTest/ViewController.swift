//
//  ViewController.swift
//  BtConnectTest
//
//  Created by sanghyuk on 09/01/2019.
//  Copyright © 2019 sanghyuk. All rights reserved.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    var centralManager: CBCentralManager!
    var peripheral: CBPeripheral!
    var mainCharacteristic:CBCharacteristic!
    var disconnect: CBPeripheral?
    
    var bluetoothAvailable = false
    var peripheralArr: Array<Any> = []
    var dataArr: Array<Any> = []
    let success: CustomView = UINib(nibName: "CustomView", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! CustomView
    
    @IBOutlet private weak var tableView: UITableView!
    
    @IBAction private func scanBt(_ sender: Any) {
        print("\n---------- [ Start Scan ] ----------\n")
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    @IBAction private func scanBtStop(_ sender: Any) {
        print("\n---------- [ Stop Scan ] ----------\n")
        centralManager.stopScan()
        centralManager.cancelPeripheralConnection(disconnect!)
        
    }
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        
        super.viewDidLoad()
        
        let nibName = UINib(nibName: "MyTableViewCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "tableCell")
        
    }
    
    // 상태변화 가져오기 (필수)
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("\n---------- [ Checking state ] ----------\n")
        switch (central.state)
        {
        case .poweredOff:
            print("CoreBluetooth BLE hardware is powered off")
            bluetoothAvailable = false;
            
        case .poweredOn:
            print("CoreBluetooth BLE hardware is powered on and ready")
            bluetoothAvailable = true;
            
        case .resetting:
            print("CoreBluetooth BLE hardware is resetting")
            
        case .unauthorized:
            print("CoreBluetooth BLE state is unauthorized")
            
        case .unknown:
            print("CoreBluetooth BLE state is unknown");
            
        case .unsupported:
            print("CoreBluetooth BLE hardware is unsupported on this platform");
            
        }
        
        if bluetoothAvailable == true
        {
            discoverDevices()
        }
    }
    
    
    // 스캔결과 가져오기
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        if peripheral.name != nil {
            peripheralArr.append(peripheral.name!)
            dataArr.append(peripheral)
        }
        print("peripheral: \(peripheral)")
        print("identifier: \(peripheral.identifier)")
        print("state: \(peripheral.state)")
        print("name: \(peripheral.name!)")
        print("---------------------------------------")
        
        print(peripheralArr)
        print(dataArr)
        self.tableView.reloadData()
    }

    // 성공시
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("연결 성공")
        self.view.addSubview(success)
    }
    
    // 실패시
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("연결 실패")
    }
    
    // 연결 종료 시
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("연결 종료")
    }
    
    // 스캔
    func discoverDevices() {
        print("Discovering devices")
        centralManager.scanForPeripherals(withServices: nil, options: nil)
        
    }


}

// MARK: - TableViewDelegate
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peripheralArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! MyTableViewCell

        cell.nameLabel?.text = peripheralArr[indexPath.row] as? String

        cell.nameLabel.sizeToFit()

        return cell

    }
    
    // 목록 터치 시 동작
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\n---------- [ select Row ] ----------\n")
        print(peripheralArr[indexPath.row])
        print(dataArr[indexPath.row])
        self.centralManager.connect(dataArr[indexPath.row] as! CBPeripheral, options: nil)
        disconnect = dataArr[indexPath.row] as? CBPeripheral
    }
}

