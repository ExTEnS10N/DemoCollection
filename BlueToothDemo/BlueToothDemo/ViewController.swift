//
//  ViewController.swift
//  BlueToothDemo
//
//  Created by macsjh on 16/3/8.
//  Copyright © 2016年 TurboExtension. All rights reserved.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate {
	
	@IBOutlet weak var tableView: UITableView!
	//添加属性
	var manager: CBCentralManager!
	var peripheral: CBPeripheral!
	var peripheralList:NSMutableArray = NSMutableArray()
	var writeCharacteristic: CBCharacteristic!
	//保存收到的蓝牙设备
	var deviceList:NSMutableArray = NSMutableArray()
	//服务和特征的UUID
	let kServiceUUID = [CBUUID(string:"6B341A63-4023-4C6B-ADDE-F95538A2958A")]
	let kCharacteristicUUID = [CBUUID(string:"91A61DA4-59B6-4BDB-B9CD-15037F9CFB77")]
	
	override func viewDidLoad() {
		super.viewDidLoad()
		//1.创建一个中央对象
		self.manager = CBCentralManager(delegate: self, queue: dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
	}
	
	//2.检查运行这个App的设备是不是支持BLE。代理方法
	func centralManagerDidUpdateState(central: CBCentralManager){
		switch central.state {
		case CBCentralManagerState.PoweredOn:
			//扫描周边蓝牙外设.
			//写nil表示扫描所有蓝牙外设，如果传上面的kServiceUUID,那么只能扫描出FFEO这个服务的外设。
			//CBCentralManagerScanOptionAllowDuplicatesKey为true表示允许扫到重名，false表示不扫描重名的。
			self.manager.scanForPeripheralsWithServices(nil, options:[CBCentralManagerScanOptionAllowDuplicatesKey: true])
			print("蓝牙已打开")
		case CBCentralManagerState.Unauthorized:
			TEMessageBox.OKBox("", message: "这个应用程序是无权使用蓝牙低功耗", parentViewController: self)
		case CBCentralManagerState.PoweredOff:
			TEMessageBox.OKBox("", message: "蓝牙已关闭", parentViewController: self)
		default:
			TEMessageBox.OKBox("", message: "中央管理器没有改变状态", parentViewController: self)
		}
	}
	
	//3.查到外设后，连接设备
	//广播、扫描的响应数据保存在advertisementData 中，可以通过CBAdvertisementData 来访问它。
	func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber) {
		if(!self.deviceList.containsObject(peripheral)){
			self.deviceList.addObject(peripheral)
		}
		NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
			self.tableView.reloadData()
		}
	}
	
	//4.连接外设成功，开始发现服务
	func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral){
		//停止扫描外设
		self.manager.stopScan()
		self.peripheral = peripheral
		self.peripheral.delegate = self
		self.peripheral.discoverServices(nil)
	}
	
	//连接外设失败
	func centralManager(central: CBCentralManager, didFailToConnectPeripheral peripheral: CBPeripheral, error: NSError?){
		TEMessageBox.OKBox("", message: "连接外设失败===\(error)", parentViewController: self)
	}
	
	func centralManager(central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: NSError?) {
		TEMessageBox.OKBox("", message: "已断开和外设的连接", parentViewController: self)
	}
	
	//5.请求周边去寻找它的服务所列出的特征
	func peripheral(peripheral: CBPeripheral, didDiscoverServices error: NSError?){
		guard error == nil else{
			TEMessageBox.OKBox("", message: "错误的服务特征:\(error?.localizedDescription)", parentViewController: self)
			return
		}
		var i: Int = 0
		for service in peripheral.services! {
			print("服务的UUID:\(service.UUID)")
			i++
			//发现给定格式的服务的特性
			//            if (service.UUID == CBUUID(string:"FFE0")) {
			//                peripheral.discoverCharacteristics(kCharacteristicUUID, forService: service as CBService)
			//            }
			peripheral.discoverCharacteristics(nil, forService: service)
		}
	}
	
	//6.已搜索到Characteristics
	func peripheral(peripheral: CBPeripheral, didDiscoverCharacteristicsForService service: CBService, error: NSError?){
		guard (error == nil) else{
			print("发现错误的特征：\(error?.localizedDescription)")
			return
		}
		
		for  characteristic in service.characteristics!  {
			//罗列出所有特性，看哪些是notify方式的，哪些是read方式的，哪些是可写入的。
			print("服务UUID:\(service.UUID)         特征UUID:\(characteristic.UUID)")
			//特征的值被更新，用setNotifyValue:forCharacteristic
			switch characteristic.UUID.description {
			case "91A61DA4-59B6-4BDB-B9CD-15037F9CFB77":
				//如果以通知的形式读取数据，则直接发到didUpdateValueForCharacteristic方法处理数据。
				self.peripheral.setNotifyValue(true, forCharacteristic: characteristic )
				
			case "2A37":
				//通知关闭，read方式接受数据。则先发送到didUpdateNotificationStateForCharacteristic方法，再通过readValueForCharacteristic发到didUpdateValueForCharacteristic方法处理数据。
				self.peripheral.readValueForCharacteristic(characteristic)

			case "5614EB6F-3F00-4D6D-9D34-A9C4C0CD39B8":
				self.writeCharacteristic = characteristic
				let heartRate: NSString = "I am virtual host!"
				let dataValue: NSData = heartRate.dataUsingEncoding(NSUTF8StringEncoding)!
				//写入数据
				self.writeValue(dataValue)
			default:
				break
			}
		}
	}
	
	//8.获取外设发来的数据，不论是read和notify,获取数据都是从这个方法中读取。
	func peripheral(peripheral: CBPeripheral, didUpdateValueForCharacteristic characteristic: CBCharacteristic, error: NSError?){
		if(error != nil){
			print("发送数据错误的特性是：\(characteristic.UUID)     错误信息：\(error?.localizedDescription)       错误数据：\(characteristic.value)")
			return
		}
		switch characteristic.UUID.description {
		case "91A61DA4-59B6-4BDB-B9CD-15037F9CFB77":
			print("=\(characteristic.UUID)特征发来的数据是:\(characteristic.value)=")
		default:
			break
		}
	}
	
	//写入数据
	func writeValue(data: NSData!){
		peripheral.writeValue(data, forCharacteristic: self.writeCharacteristic, type: CBCharacteristicWriteType.WithResponse)
		print("手机向蓝牙发送的数据为:\(data)")
	}
	
	//用于检测中心向外设写数据是否成功
	func peripheral(peripheral: CBPeripheral, didWriteValueForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
		if(error != nil){
			print("发送数据失败!error信息:\(error)")
		}else{
			print("发送数据成功\(characteristic)")
		}
	}
	
	// MARK: - table view
	
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.deviceList.count
	}
	
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		//PCell,确定单元格的样式
		let cell = tableView.dequeueReusableCellWithIdentifier("aCell", forIndexPath: indexPath)
		let device:CBPeripheral = self.deviceList.objectAtIndex(indexPath.row) as! CBPeripheral
		//主标题
		cell.textLabel?.text = device.name
		//副标题
		cell.detailTextLabel?.text = device.identifier.UUIDString
		return cell
	}
	
	//通过选择来连接和断开外设
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		if(self.peripheralList.containsObject(self.deviceList.objectAtIndex(indexPath.row))){
			self.manager.cancelPeripheralConnection(self.deviceList.objectAtIndex(indexPath.row) as! CBPeripheral)
			self.peripheralList.removeObject(self.deviceList.objectAtIndex(indexPath.row))
			print("蓝牙已断开！")
		}else{
			self.manager.connectPeripheral(self.deviceList.objectAtIndex(indexPath.row) as! CBPeripheral, options: nil)
			self.peripheralList.addObject(self.deviceList.objectAtIndex(indexPath.row))
			print("蓝牙已连接！ \(self.peripheralList.count)")
		}
	}
}

