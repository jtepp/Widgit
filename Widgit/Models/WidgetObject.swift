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
	static let placeholder = WidgetObject(sizeName: "[Small]", width: 100, height: 100)
	static let placeholderM = WidgetObject(sizeName: "[Medium]", width: 250, height: 100)
	static let placeholderL = WidgetObject(sizeName: "[Large]", width: 250, height: 250)
}

