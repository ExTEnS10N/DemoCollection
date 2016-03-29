//
//  CatalogViewController.swift
//  pager
//
//  Created by macsjh on 15/12/3.
//  Copyright © 2015年 TurboExtension. All rights reserved.
//

import UIKit

class CatalogViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate{

	@IBOutlet weak var CatalogView: UITableView!
	
	var tapDelegate = [UIGestureRecognizerDelegate]()
    override func viewDidLoad() {
        super.viewDidLoad()
		CatalogView.backgroundColor = UIColor.clearColor()
		for gesture in _rootViewController!.view.gestureRecognizers!
		{
			if(gesture.isKindOfClass(UITapGestureRecognizer))
			{
				tapDelegate.append(gesture.delegate!)
				gesture.delegate = self
			}
		}
    }
	
	override func viewWillAppear(animated: Bool) {
		if(_rootViewController != nil)
		{
			_rootViewController!.commingViewController = self
			_rootViewController!.setNeedsStatusBarAppearanceUpdate()
		}
	}
	
	override func viewDidDisappear(animated: Bool) {
		super.viewDidDisappear(animated)
		var i = 0
		for gesture in _rootViewController!.view.gestureRecognizers!
		{
			if(gesture.isKindOfClass(UITapGestureRecognizer))
			{
				gesture.delegate = tapDelegate[i++]
			}
		}
	}
	
	// MARK: - TableView DataSource
	
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return pageData.count - 2
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
	{
		let cell = tableView.dequeueReusableCellWithIdentifier("CatalogCell") as! CatalogCell
		cell.Title.text = pageData[indexPath.row + 2]
		cell.PageNum.text = String(indexPath.row + 1)
		cell.backgroundColor = UIColor.clearColor()
		return cell
	}
	
	func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		return true
	}
	
	func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
		let element = pageData.removeAtIndex(sourceIndexPath.row + 2)
		pageData.insert(element, atIndex: destinationIndexPath.row + 2)
	}
	
	func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
		if(editingStyle == .Delete)
		{
			pageData.removeAtIndex(indexPath.row + 2)
			tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
		}
	}
	
	// MARK: - TableView Delegate
	
	func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
		if(tableView.editing)
		{
			return .Delete
		}
		return .None
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.cellForRowAtIndexPath(indexPath)?.setSelected(false, animated: true)
		_rootViewController?.setViewControllers([_rootViewController!.modelController.viewControllerAtIndex(indexPath.row + 2, storyboard: self.storyboard!)!], direction: .Forward, animated: true, completion: nil)
	}
	
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
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
	
	// MARK: - button events
	var panDelegate = [UIGestureRecognizerDelegate]()
	@IBAction func editModeSwitcher(sender: UIButton)
	{
		CatalogView.setEditing(!CatalogView.editing, animated: true)
		if(sender.titleLabel?.text == "编辑")
		{
			sender.setTitle("完成", forState: .Normal)
			for gesture in _rootViewController!.view.gestureRecognizers!
			{
				if(gesture.isKindOfClass(UIPanGestureRecognizer))
				{
					panDelegate.append(gesture.delegate!)
					gesture.delegate = self
				}
			}
		}
		else
		{
			sender.setTitle("编辑", forState: .Normal)
			var i = 0
			for gesture in _rootViewController!.view.gestureRecognizers!
			{
				if(gesture.isKindOfClass(UIPanGestureRecognizer))
				{
					gesture.delegate = panDelegate[i++]
				}
			}
		}
	}
	
	// MARK: - gesture delegate
	
	func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
		if(gestureRecognizer.isKindOfClass(UIPanGestureRecognizer))
		{
			print(gestureRecognizer.locationInView(self.view))
		}
		return false
	}
}
