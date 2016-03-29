//
//  DataViewController.swift
//  pager
//
//  Created by macsjh on 15/12/1.
//  Copyright © 2015年 TurboExtension. All rights reserved.
//

import UIKit

class DataViewController: UIViewController {

	@IBOutlet weak var dataLabel: UILabel!
	var dataObject: String = ""
	var pageNum:Int = -1


	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		switch pageNum
		{
		case 0:
			view.backgroundColor = UIColor(red: 0, green: 153/255, blue: 102/255, alpha: 1)
			dataLabel.textColor = UIColor.whiteColor()
			break
		default:
			break
		}
		
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		self.dataLabel!.text = dataObject
		if(_rootViewController != nil)
		{
			_rootViewController!.commingViewController = self
			_rootViewController!.setNeedsStatusBarAppearanceUpdate()
		}
	}
	
	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		if(view.backgroundColor != nil)
		{
			var white = CGFloat()
			var alpha = CGFloat()
			view.backgroundColor?.getWhite(&white, alpha: &alpha)
			if(white >= 0.5)
			{
				return .Default
			}
			else
			{
				return .LightContent
			}
		}
		return .Default
	}

}

