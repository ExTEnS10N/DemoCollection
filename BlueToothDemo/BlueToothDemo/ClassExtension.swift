//
//  ClassExtension.swift
//  BlueToothDemo
//
//  Created by macsjh on 16/3/10.
//  Copyright © 2016年 TurboExtension. All rights reserved.
//

import Foundation
extension String{
	func indexOf(string: String) -> Int
	{
		let range = NSString(string: self).rangeOfString(string)
		if(range.length < 1)
		{
			return -1
		}
		return range.location
	}
	
	var intValue:Int?
		{
		get{
			return NSNumberFormatter().numberFromString(self)?.integerValue
		}
	}
}