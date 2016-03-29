//
//  ViewController.swift
//  CA3DLayer
//
//  Created by macsjh on 16/1/11.
//  Copyright © 2016年 TurboExtension. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	var imageView:UIImageView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}
	override func viewWillAppear(animated: Bool) {
		imageView = UIImageView()
		imageView.layer.anchorPoint = CGPoint(x: 0, y: 0.5)
		imageView.frame = CGRect(x: 0, y: 0, width: 320, height: 600)
		imageView.image = UIImage(named: "plantbook")
		
		self.view.addSubview(imageView)
	}
	
	override func viewDidAppear(animated: Bool) {
		imageView.userInteractionEnabled = true
		let gesture = UIPanGestureRecognizer(target: self, action: "pan:")
		imageView.addGestureRecognizer(gesture)
		print(imageView.layer.anchorPoint)
		/*UIView.animateWithDuration(1.0, delay: 1.0, options: .CurveEaseInOut, animations: { () -> Void in
			let rotate = CATransform3DMakeRotation(CGFloat(-M_PI/2), 0, 1, 0)
			self.imageView.layer.transform = self.CATransform3DPerspect(rotate, center: CGPoint(x: 0, y: 0), disZ: 521)
			}, completion: nil)
	*/}
	
	var angle = 360.0
	var radius:CGFloat = CGFloat(M_PI)
	func pan(sender: UIPanGestureRecognizer) {
		let x = sender.velocityInView(self.view).x
		if(x > 1)
		{
			//if aaaa >
			let rotate = CATransform3DMakeRotation(radius, 0, 1, 0)
			imageView.layer.transform = CATransform3DPerspect(rotate, center: CGPoint(x: 0, y: 0), disZ: 321)
			angle++
			radius = CGFloat(M_PI / 180 * angle)
		}
		else if(x < -1){
			let rotate = CATransform3DMakeRotation(radius, 0, 1, 0)
			imageView.layer.transform = CATransform3DPerspect(rotate, center: CGPoint(x: 0, y: 0), disZ: 321)
			angle--
			radius = CGFloat(M_PI / 180 * angle)
		}
		sender.setTranslation(CGPoint(x: 0,y: 0), inView: self.view)
		print(angle)
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	func CATransform3DMakePerspective(center:CGPoint, disZ:CGFloat)->CATransform3D
	{
		let transToCenter = CATransform3DMakeTranslation(-center.x, -center.y, 0);
		let transBack = CATransform3DMakeTranslation(center.x, center.y, 0);
		var scale = CATransform3DIdentity;
		scale.m34 = -1.0 / disZ;
		return CATransform3DConcat(CATransform3DConcat(transToCenter, scale), transBack);
	}
	
	func CATransform3DPerspect(t:CATransform3D, center:CGPoint, disZ:CGFloat)->CATransform3D
	{
		return CATransform3DConcat(t, CATransform3DMakePerspective(center, disZ: disZ));
	}

}

