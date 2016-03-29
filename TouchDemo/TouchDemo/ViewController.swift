//
//  ViewController.swift
//  TouchDemo
//
//  Created by macsjh on 16/3/11.
//  Copyright © 2016年 TurboExtension. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	var tdict:[UITouch:UIView] = [:]

	override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		for touch in touches{
			touch.locationInView(self.view)
			let tsize = CGSize(width: 50, height: 50)
			let tview = UIView(frame: CGRect(origin: touch.locationInView(self.view), size: tsize))
			tview.backgroundColor = UIColor.brownColor()
			self.view.addSubview(tview)
			tview.center = touch.locationInView(self.view)
			tdict[touch] = tview
		}
	}

	override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
		var up:Double = 0
		for touch in touches{
			let newloc = touch.locationInView(self.view)
			if newloc.y - tdict[touch]!.center.y > 10{
				++up
			}
			tdict[touch]?.center = newloc
		}
		if(up / Double(tdict.count) > 0.5){print("up!")}
	}
	
	override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
		for touch in touches{
			tdict[touch]?.removeFromSuperview()
			tdict[touch] = nil
		}
	}
	
	@IBAction func pan(sender: UIPanGestureRecognizer) {
		if sender.translationInView(self.view).y > 50{
			print("panup!")
			sender.setTranslation(CGPointZero, inView: self.view)
		}
	}
}

