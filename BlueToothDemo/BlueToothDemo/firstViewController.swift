//
//  firstViewController.swift
//  BlueToothDemo
//
//  Created by macsjh on 16/3/10.
//  Copyright © 2016年 TurboExtension. All rights reserved.
//

import UIKit

class firstViewController: UIViewController {

	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		if(UIDevice.currentDevice().localizedModel.indexOf("iPad") < 0){
			performSegueWithIdentifier("notIpadSegue", sender: nil)
		}
		else{
			performSegueWithIdentifier("ipadSegue", sender: nil)
		}
	}

}
