//
//  RootViewController.swift
//  pager
//
//  Created by macsjh on 15/12/1.
//  Copyright © 2015年 TurboExtension. All rights reserved.
//

import UIKit

var _rootViewController:RootViewController?

class RootViewController: UIPageViewController, UIPageViewControllerDelegate {

//	var pageViewController: UIPageViewController?

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		// Configure the page view controller and add it as a child view controller.
//		self.pageViewController = UIPageViewController(transitionStyle: .PageCurl, navigationOrientation: .Horizontal, options: nil)
//		self.pageViewController!.delegate = self
		
		_rootViewController = self

		let startingViewController = self.modelController.viewControllerAtIndex(0, storyboard: self.storyboard!)!
		let viewControllers = [startingViewController]
		self.setViewControllers(viewControllers, direction: .Forward, animated: false, completion: {done in })

		self.dataSource = self.modelController

		// Set the page view controller's bounds using an inset rect so that self's view is visible around the edges of the pages.
//		var pageViewRect = self.view.bounds
//		if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
//		    pageViewRect = CGRectInset(pageViewRect, 40.0, 40.0)
//		}
//		self.view.frame = pageViewRect

//		self.pageViewController!.didMoveToParentViewController(self)

		// Add the page view controller's gesture recognizers to the book view controller's view so that the gestures are started more easily.
//		self.view.gestureRecognizers = self.pageViewController!.gestureRecognizers
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	var modelController: ModelController {
		// Return the model controller object, creating it if necessary.
		// In more complex implementations, the model controller may be passed to the view controller.
		if _modelController == nil {
		    _modelController = ModelController()
		}
		return _modelController!
	}

	private var _modelController: ModelController? = nil

	// MARK: - UIPageViewController delegate methods

	func pageViewController(pageViewController: UIPageViewController, spineLocationForInterfaceOrientation orientation: UIInterfaceOrientation) -> UIPageViewControllerSpineLocation {
		if (orientation == .Portrait) || (orientation == .PortraitUpsideDown) || (UIDevice.currentDevice().userInterfaceIdiom == .Phone) {
		    // In portrait orientation or on iPhone: Set the spine position to "min" and the page view controller's view controllers array to contain just one view controller. Setting the spine position to 'UIPageViewControllerSpineLocationMid' in landscape orientation sets the doubleSided property to true, so set it to false here.
		    let currentViewController = self.viewControllers![0]
		    let viewControllers = [currentViewController]
		    self.setViewControllers(viewControllers, direction: .Forward, animated: true, completion: {done in })

		    self.doubleSided = false
		    return .Min
		}

		// In landscape orientation: Set set the spine location to "mid" and the page view controller's view controllers array to contain two view controllers. If the current page is even, set it to contain the current and next view controllers; if it is odd, set the array to contain the previous and current view controllers.
		let currentViewController = self.viewControllers![0] as! DataViewController
		var viewControllers: [UIViewController]

		let indexOfCurrentViewController = self.modelController.indexOfViewController(currentViewController)
		if (indexOfCurrentViewController == 0) || (indexOfCurrentViewController % 2 == 0) {
		    let nextViewController = self.modelController.pageViewController(self, viewControllerAfterViewController: currentViewController)
		    viewControllers = [currentViewController, nextViewController!]
		} else {
		    let previousViewController = self.modelController.pageViewController(self, viewControllerBeforeViewController: currentViewController)
		    viewControllers = [previousViewController!, currentViewController]
		}
		self.setViewControllers(viewControllers, direction: .Forward, animated: true, completion: {done in })

		return .Mid
	}
	
	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return .Default
	}
	
	internal var commingViewController:UIViewController?
	
	override func childViewControllerForStatusBarStyle() -> UIViewController? {
		return commingViewController
	}

}

