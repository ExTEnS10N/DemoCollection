//
//  ViewController.swift
//  MapKitDemo
//
//  Created by macsjh on 16/3/11.
//  Copyright © 2016年 TurboExtension. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController,MKMapViewDelegate{

	@IBOutlet weak var imap: MKMapView!
	var anno = MKPointAnnotation()
	var firstrun = true
	
	override func viewDidLoad() {
		anno.title = "这是哪？"
	}
	
	func centerMapOnLocation(location: CLLocation) {
		let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 100, 100)
		imap.setRegion(coordinateRegion, animated: true)
		
//		//创建一个大头针对象
//		let annotation = MKPointAnnotation()
//		//设置大头针的显示位置
//		annotation.coordinate = location.coordinate
//		//设置点击大头针之后显示的标题
//		annotation.title = "当前位置"
//		//设置点击大头针之后显示的描述
//		annotation.subtitle = "精确度: 方圆百米"
//		//添加大头针
//		imap.addAnnotation(annotation)
	}
	
	func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
		if firstrun{
			centerMapOnLocation(userLocation.location!)
			firstrun = false
		}
	}
	
	@IBAction func tapMap(sender: UITapGestureRecognizer) {
		imap.removeAnnotation(anno)
		let coordinate = imap.convertPoint(sender.locationInView(imap), toCoordinateFromView: imap)
		anno.coordinate = coordinate
		imap.addAnnotation(anno)
		
		let drequest = MKDirectionsRequest()
		drequest.source = MKMapItem(placemark: MKPlacemark(coordinate: imap.userLocation.coordinate, addressDictionary: nil))
		
		drequest.destination = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary: nil))
		
		let direction = MKDirections(request: drequest)
		
		let midlatitude = (imap.userLocation.coordinate.latitude + coordinate.latitude) / 2
		let midlongtitude = (imap.userLocation.coordinate.longitude + coordinate.longitude) / 2
		
		direction.calculateDirectionsWithCompletionHandler { (res:MKDirectionsResponse?, error:NSError?) -> Void in
			if let polyline = res?.routes.first?.polyline {
				
				self.imap.addOverlay(polyline, level: MKOverlayLevel.AboveLabels)
				self.imap.setRegion(MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2D(latitude: midlatitude, longitude: midlongtitude), res!.routes.first!.distance, res!.routes.first!.distance), animated: false)
			}
		}
	}
	
	//渲染路径
	func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
		print("render!")
		let render = MKPolylineRenderer(overlay: overlay)
		render.lineWidth = 2.0
		render.strokeColor = UIColor.blueColor()
		return render
	}
}

