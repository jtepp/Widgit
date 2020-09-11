//
//  WidgetObject.swift
//  Widgit
//
//  Created by Jacob Tepperman on 2020-09-06.
//

import SwiftUI




struct WidgetObject: Identifiable, Codable {
	var id = UUID()
	var sizeName: String
	var width: CGFloat
	var height: CGFloat
	var count: Double
//	var singleImage: Bool = false;
	var maxPosts: Double
	static let placeholder = WidgetObject(sizeName: "Small", width: 100, height: 100, count: 1, maxPosts: 2)
	static let placeholderM = WidgetObject(sizeName: "Medium", width: 250, height: 100, count: 2, maxPosts: 3)
	static let placeholderL = WidgetObject(sizeName: "Large", width: 250, height: 250, count: 4, maxPosts: 6)
}

func shortNumber(num:String) -> String{
	let x = Double(num)!
	var y = num
	if x >= 1000 {
		let a = floor(x/1000)
		let z = x/1000 - a
		let f = String(Int(floor(z*10)))
		y = String(Int(a))
		y = y  + "."
		y = y + f
		y = y + "k"
	}
	return y
}
