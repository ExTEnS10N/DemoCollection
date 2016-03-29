//
//  PeripheralViewController.swift
//  BlueToothDemo
//
//  Created by macsjh on 16/3/10.
//  Copyright © 2016年 TurboExtension. All rights reserved.
//

import UIKit
import CoreBluetooth

class PeripheralViewController: UIViewController, CBPeripheralManagerDelegate{
	
	private var manager:CBPeripheralManager!
	private let service = CBMutableService(type: CBUUID(string: "6B341A63-4023-4C6B-ADDE-F95538A2958A"), primary: true)
	private let readCharacter = CBMutableCharacteristic(type: CBUUID(string: "91A61DA4-59B6-4BDB-B9CD-15037F9CFB77"), properties: .Notify, value: nil, permissions: CBAttributePermissions.Readable)
	private let writeCharacter = CBMutableCharacteristic(type: CBUUID(string: "5614EB6F-3F00-4D6D-9D34-A9C4C0CD39B8"), properties: .Write, value: nil, permissions: CBAttributePermissions.Writeable)
	private var subscribedCentral:CBCentral?
	private var unUpdateData:NSData?
	
	/// not called in main queue
	var receivingData:((NSData?) -> Void)?
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		manager = CBPeripheralManager(delegate: self, queue: dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
    }

	func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager) {
		switch peripheral.state {
		case CBPeripheralState.PoweredOn:
			if(service.characteristics == nil){
				service.characteristics = [readCharacter, writeCharacter]
				self.manager.addService(service)
			}
			print("蓝牙已打开")
		case CBPeripheralState.Unauthorized:
			TEMessageBox.OKBox("", message: "这个应用程序是无权使用蓝牙低功耗", parentViewController: self)
		case CBPeripheralState.PoweredOff:
			TEMessageBox.OKBox("", message: "蓝牙已关闭", parentViewController: self)
		default:
			TEMessageBox.OKBox("", message: "中央管理器没有改变状态", parentViewController: self)
		}
	}
	
	func peripheralManager(peripheral: CBPeripheralManager, didAddService service: CBService, error: NSError?) {
		guard error == nil else {debugPrint(error); return}
		manager.startAdvertising([CBAdvertisementDataServiceUUIDsKey: [service.UUID]])
		print("服务添加完成")
	}

	func peripheralManagerDidStartAdvertising(peripheral: CBPeripheralManager, error: NSError?) {
		guard error == nil else {debugPrint(error); return}
		print("开始广播")
	}
	
	func peripheralManager(peripheral: CBPeripheralManager, central: CBCentral, didSubscribeToCharacteristic characteristic: CBCharacteristic) {
		if(subscribedCentral != nil){print("it seems that thief subscribe occured!")}
		subscribedCentral = central
		if (readCharacter.value != nil){
			updateCharateristicData(readCharacter.value!, length: readCharacter.value!.length)
		}
		print("收到新订阅")
	}
	
	func peripheralManager(peripheral: CBPeripheralManager, central: CBCentral, didUnsubscribeFromCharacteristic characteristic: CBCharacteristic) {
		subscribedCentral = nil
		print("订阅被注销")
	}
	
	func peripheralManagerIsReadyToUpdateSubscribers(peripheral: CBPeripheralManager) {
		print("可以发送新数据")
		if unUpdateData != nil {
			print("正在重发数据")
			updateCharateristicData(unUpdateData!, length: unUpdateData!.length)
			unUpdateData = nil
		}
	}
	
	func updateCharateristicData(var value:AnyObject, length: Int){
		let dataToUpdate = NSData(bytesNoCopy: &value, length: length)
		if manager.updateValue(dataToUpdate, forCharacteristic: readCharacter, onSubscribedCentrals: [subscribedCentral!])
		{
			unUpdateData = dataToUpdate
			print("数据发送失败")
		}else {print("数据发送成功")}
	}
	
	func peripheralManager(peripheral: CBPeripheralManager, didReceiveReadRequest request: CBATTRequest) {
		if request.characteristic.UUID == readCharacter.UUID{
			// 确保读请求所请求的偏移量没有超出我们的特性的值的长度范围
			// offset属性指定的请求所要读取值的偏移位置
			print("收到读请求")
			if (readCharacter.value == nil || request.offset > readCharacter.value?.length)
			{
				manager.respondToRequest(request, withResult:CBATTError.InvalidOffset)
				return
			}
			else{
				print("回复读请求")
				request.value = readCharacter.value!.subdataWithRange(NSRange(location: request.offset, length: readCharacter.value!.length - request.offset))
			}
			manager.respondToRequest(request, withResult: CBATTError.Success)
		}
	}
	
	func peripheralManager(peripheral: CBPeripheralManager, didReceiveWriteRequests requests: [CBATTRequest]) {
		print("收到写请求")
		receivingData?(requests[0].value)
		manager.respondToRequest(requests[0], withResult: CBATTError.Success)
	}
}
