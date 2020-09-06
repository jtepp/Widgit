//
//  WidgetObject.swift
//  Widgit
//
//  Created by Jacob Tepperman on 2020-09-06.
//

import SwiftUI

struct WidgetObject: Identifiable {
	var id = UUID()
	var sizeName: String
	var width: CGFloat
	var height: CGFloat
}
