//
//  ViewController.swift
//  ChineseConverter
//
//  Created by macsjh on 15/10/4.
//  Copyright © 2015年 TurboExtension. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

	override func viewDidLoad() {
		if #available(OSX 10.10, *) {
		    super.viewDidLoad()
		} else {
		    // Fallback on earlier versions
		}

		// Do any additional setup after loading the view.
	}

	override var representedObject: AnyObject? {
		didSet {
		// Update the view, if already loaded.
		}
	}

	@IBOutlet weak var text: NSTextField!
	
	@IBAction func convert(sender: NSButton) {
		let aaa:CFMutableStringRef = CFStringCreateMutableCopy(nil, 0, text.stringValue)
//		CFStringTransform(aaa, nil, kCFStringTransformMandarinLatin, false)
		CFStringTransform(aaa, nil, kCFStringTransformStripDiacritics, false);
		text.stringValue = aaa as String
		print(text.stringValue)
		
		/** MARK: 转换至Unicode汉字
		var str = ""
		for (var i = 0x20000; i <= 0x2A6D2; ++i)
		{
			str.append(UnicodeScalar(i))
		}
		print(str)
		*/
	}
}

