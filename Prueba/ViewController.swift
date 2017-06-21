//
//  ViewController.swift
//  Prueba
//
//  Created by Ayoze on 16/6/17.
//  Copyright © 2017 Ayoze. All rights reserved.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController, CBCentralManagerDelegate,CBPeripheralDelegate, UITableViewDataSource, UITableViewDelegate{
    var dispositivos: [String] = []
   var manager: CBCentralManager!
    var peripheral:CBPeripheral!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        manager = CBCentralManager (delegate: self, queue: nil)
        dispositivos = ["dispositivo1", "dispositivo2", "dispositivo3", "dispositivo4"]
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
 
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int
    {
        return dispositivos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:UITableViewCell=UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cell")
        cell.textLabel?.text  = dispositivos[indexPath.row]
        
        return cell
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == CBManagerState.poweredOn{
            central.scanForPeripherals(withServices: nil, options: nil)
            print ("habilitado")
            print(central.isScanning)
            
        }else{
            print (" no está habilitado.")
        }
    }
  

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
    
      
        print (peripheral)
        dispositivos.append(peripheral.identifier.uuidString)
        if peripheral.identifier.uuidString == "3340CF08-2A4C-47F4-A360-3FA75561F7A2"{
            
            print("Did discover peripheral", peripheral.identifier)
            self.manager.stopScan()
            
            self.peripheral = peripheral
            self.peripheral.delegate = self
            
            manager.connect(peripheral, options: nil)
        }
    }
    func centralManager(
        _ central: CBCentralManager,
        didConnect peripheral: CBPeripheral) {
        peripheral.discoverServices(nil)
    }
    func peripheral(
        _ peripheral: CBPeripheral,
        didDiscoverServices error: Error?) {
        for service in peripheral.services! {
            let thisService = service as CBService
            print ("este es el servicio",thisService.uuid.uuidString)
            if service.uuid.uuidString == "0000F00D-1212-EFDE-1523-785FEF13D123" {
                peripheral.discoverCharacteristics(
                    nil,
                    for: thisService
                )
            
            }
        }
    }
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?){
    print("Looping through characteristics")
        if let charactericsArr = service.characteristics{
            for charactericsx in charactericsArr
            {
                print("esta es la caracteristica:",charactericsx)
                peripheral.setNotifyValue(true, for: charactericsx)
                
                //                *************************
                
                //                *************************
           
                let bytes : [UInt8] = [ 0x52, 0x13, 0x00, 0x56, 0xFF, 0x00, 0x00, 0x00, 0xAA ]
                let data = Data(bytes:bytes)
                
                peripheral.writeValue(data, for: charactericsx,type: CBCharacteristicWriteType.withResponse)
              
            }
        }
    }
    

  
    

    
func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if var _ :NSData = characteristic.value as NSData? {
            peripheral.readValue(for: characteristic)
            print (characteristic)
        }
    
    }


}

