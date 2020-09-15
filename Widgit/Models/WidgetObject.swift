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
	var pwidth: CGFloat = 250
	var pheight: CGFloat = 250
//	var singleImage: Bool = false;
	var maxPosts: Double
	static let placeholder = WidgetObject(sizeName: "Small", width: 80, height: 80, count: 1, pwidth: 100, pheight: 100, maxPosts: 2, placement: 1)
	static let placeholderM = WidgetObject(sizeName: "Medium", width: 250, height: 100, count: 3, pheight: 100, maxPosts: 3, placement: 1)
	static let placeholderL = WidgetObject(sizeName: "Large", width: 250, height: 250, count: 4, maxPosts: 6, placement: 1)
	var placement: Int = 1
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
