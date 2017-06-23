//
//  ViewController.swift
//  Prueba
//
//  Created by Ayoze on 16/6/17.
//  Copyright © 2017 Ayoze. All rights reserved.
//

import UIKit
import CoreBluetooth
import SystemConfiguration


class ViewController: UIViewController, CBCentralManagerDelegate,CBPeripheralDelegate, UITableViewDataSource, UITableViewDelegate{
    var dispositivos: [String] = []
   var manager: CBCentralManager!
    var peripheral:CBPeripheral!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonFront: UIButton!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
     var balizas: [Baliza] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        manager = CBCentralManager (delegate: self, queue: nil)
       
        buttonFront.addTarget(self, action: #selector(ViewController.but(sender:)), for: .touchUpInside)
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func viewWillAppear(_ animated: Bool) {
        getData()
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return balizas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        let baliza = balizas[indexPath.row]
        
        if let myName = baliza.uuid {
            cell.textLabel?.text = myName
        }
        
        return cell
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath:       IndexPath) {
        
        print("You selected cell number: \(indexPath.row)!");
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let miVistaDos = storyBoard.instantiateViewController(withIdentifier: "ViewControllerWebService") as! ViewControllerWebService
        
        self.present(miVistaDos, animated:true, completion:nil)
        
        
    }
    func getData() {
        do {
            balizas = try context.fetch(Baliza.fetchRequest())
        }
        catch {
            print("Fetching Failed")
        }
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
        peripheral.maximumWriteValueLength(for: CBCharacteristicWriteType(rawValue: 420)!)
        if peripheral.identifier.uuidString == "3340CF08-2A4C-47F4-A360-3FA75561F7A2"{
            
            //  DDEBE7A9-F336-4D8A-A406-E7F6666AE1BE
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
                let comando : [UInt8] = [ 52]
                let basurilla : [UInt8] = [ 52, 13, 00, 56, 00, 00, 00, 00, 00 ]
                let prueba : [UInt8] = [ 33, 34, 35, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34  ]
                //print ("uuuu", fraccionDatagrama(datagrama: prueba))
                print ("llllll",prueba[1...3])
                let pruebilla = Array(prueba[1...3])
                print ("lllll",pruebilla)
               // fraccionDatagrama(datagrama: prueba)
                let buf = [UInt8](Date().currentUTCTimeZoneDate.utf8)
                
                
               
                let bytes = comando + buf + prueba
                
                let data2 = Data(bytes:bytes)
               // let data3 = Data(bytes:prueba)
                
                print (bytes)
                print (buf)
                
                
                peripheral.writeValue(data2, for: charactericsx,type: CBCharacteristicWriteType.withResponse)
              
            }
        }
    }
    

  
    

    
func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if var _ :NSData = characteristic.value as NSData? {
            peripheral.readValue(for: characteristic)
            print (characteristic)
            manager.cancelPeripheralConnection(peripheral)
            
            print("este es el uptime ",self.systemUptime())
            
            print("UTC",Date().currentUTCTimeZoneDate)
           
    
            let buf = [UInt8](Date().currentUTCTimeZoneDate.utf8)
                for value in buf {
                    print (value)
                }
           
        
           // let n = 123
            //var st = String(format:"%2X", n)
            //st += " is the hexadecimal representation of \(n)"
            // "7B is the hexadecimal representation of 123"
            
            
            print(buf)
        }
    
    }
    
    func but(sender:AnyObject?){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let miVistaDos = storyBoard.instantiateViewController(withIdentifier: "ViewControllerWebService") as! ViewControllerWebService
        
        self.present(miVistaDos, animated:true, completion:nil)    }
    
    
    
    func systemUptime() -> TimeInterval {
        var currentTime = time_t()
        var bootTime    = timeval()
        var mib         = [CTL_KERN, KERN_BOOTTIME]
        
        var size = MemoryLayout<timeval>.stride
        let result = sysctl(&mib, u_int(mib.count), &bootTime, &size, nil, 0)
        if result != 0 {
            #if DEBUG
                print("ERROR - \(#file):\(#function) - errno = "
                    + "\(result)")
            #endif
            
            return 0
        }
        
        time(&currentTime)
        let uptime = currentTime - bootTime.tv_sec
        
        return TimeInterval(uptime)
    }
    func fraccionDatagrama(datagrama: [UInt8]) -> [[UInt8]] {
        
        let resto = datagrama.count % 17
        let fracciones = datagrama.count/17
        let arrayDeFracciones = [[UInt8]]()
        var i = 0
        var offSet = 0
        let tamaño = 17
        let operacion = 99
        var fraccion: [UInt8]!
        if (fracciones < 0){

            while (i < fracciones){
                if (i == fracciones - 1){
                    fraccion.append(UInt8(operacion))
                    fraccion.append(UInt8(offSet))
                    fraccion.append(UInt8(resto))
                    let fraccionDatos = [UInt8](datagrama[offSet...offSet + 17])
                    fraccion = fraccion + fraccionDatos
                    return arrayDeFracciones
                }else{
                fraccion.append(UInt8(operacion))
                fraccion.append(UInt8(offSet))
                fraccion.append(UInt8(tamaño))
                let fraccionDatos = [UInt8](datagrama[offSet...offSet + 17])
                fraccion = fraccion + fraccionDatos
                offSet += 17
                i += 1
                }
            }
        }else {
            fraccion.append(UInt8(operacion))
            fraccion.append(UInt8(offSet))
            fraccion.append(UInt8(resto))
            let fraccionDatos = [UInt8](datagrama[offSet...offSet + 17])
            fraccion = fraccion + fraccionDatos
        }
        return arrayDeFracciones
    }
    
  
}

extension Date {
    
    var currentUTCTimeZoneDate: String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "UTC")
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return formatter.string(from: self)
    }
}
