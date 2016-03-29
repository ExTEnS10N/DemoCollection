//
//  ModelController.swift
//  pager
//
//  Created by macsjh on 15/12/1.
//  Copyright © 2015年 TurboExtension. All rights reserved.
//

import UIKit

/*
 A controller object that manages a simple model -- a collection of month names.
 
 The controller serves as the data source for the page view controller; it therefore implements pageViewController:viewControllerBeforeViewController: and pageViewController:viewControllerAfterViewController:.
 It also implements a custom method, viewControllerAtIndex: which is useful in the implementation of the data source methods, and in the initial configuration of the application.
 
 There is no need to actually create view controllers for each page in advance -- indeed doing so incurs unnecessary overhead. Given the data model, these methods create, configure, and return a new view controller on demand.
 */

var pageData: [String] = ["植书网", "目录", "首页", "分类", "发现", "我的", "空"]
class ModelController: NSObject, UIPageViewControllerDataSource {
	

	override init() {
	    super.init()
		// Create the data model.
//		let dateFormatter = NSDateFormatter()
//		pageData = dateFormatter.monthSymbols
	}

	func viewControllerAtIndex(index: Int, storyboard: UIStoryboard) -> UIViewController? {
		// Return the data view controller for the given index.
		if (pageData.count == 0) || (index >= pageData.count) {
		    return nil
		}

		// Create a new view controller and pass suitable data.
		if(index == 1)
		{
			return storyboard.instantiateViewControllerWithIdentifier("CatalogController")
		}
		else
		{
			let dataViewController = storyboard.instantiateViewControllerWithIdentifier("DataViewController") as! DataViewController
			dataViewController.dataObject = pageData[index]
			dataViewController.pageNum = index
			return dataViewController
		}
		
	}

	func indexOfViewController(viewController: UIViewController) -> Int {
		// Return the index of the given data view controller.
		// For simplicity, this implementation uses a static array of model objects and the view controller stores the model object; you can therefore use the model object to identify the index.
		if let _ = viewController as? CatalogViewController
		{
			return 1
		}
		else if let dataViewController = viewController as? DataViewController
		{
			return pageData.indexOf(dataViewController.dataObject) ?? NSNotFound
		}
		return NSNotFound
	}

	// MARK: - Page View Controller Data Source

	func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
	    var index = self.indexOfViewController(viewController)
	    if (index == 0) || (index == NSNotFound) {
	        return nil
	    }
		
	    index--
	    return self.viewControllerAtIndex(index, storyboard: viewController.storyboard!)
	}

	func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
	    var index = self.indexOfViewController(viewController)
	    if index == NSNotFound {
	        return nil
	    }
	    index++
	    if index == pageData.count {
	        return nil
	    }
	    return self.viewControllerAtIndex(index, storyboard: viewController.storyboard!)
	}

}

