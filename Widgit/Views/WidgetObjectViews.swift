//
//  WidgetObjectViews.swift
//  Widgit
//
//  Created by Jacob Tepperman on 2020-09-06.
//

import SwiftUI

struct WidgetObjectLink: View {
	var object: WidgetObject
	var body: some View {
		NavigationLink(destination: WidgetObjectEditor(object: object)) {
			VStack {
				HStack() {
					Text(object.sizeName + " Widget")
						.foregroundColor(.black)
						.font(.headline)
						.padding(.init(top: 10, leading: 20, bottom: -5, trailing: 0))
					Spacer()
				}
				Divider()
					.padding(.horizontal)
				RoundedRectangle(cornerRadius: 20)
					.frame(width: object.width, height: object.height, alignment: .center)
					.shadow(radius: 10, x: 8, y: 8)
					.rotation3DEffect(
						.degrees(4),
						axis: (x: 1.0, y: -1.0, z: 0.5)
					)
					.padding(.vertical)
					.foregroundColor(
						Color("whiteblack").opacity(0.6)
					)
			}
			.background(
				RoundedRectangle(cornerRadius: 10)
					.fill(
						Color.init(.systemGray3).opacity(0.5)
					)
			)
			.padding(20)
			
		}
	}
}

struct WidgetObjectEditor: View {
	var object: WidgetObject
	var body: some View {
		Text("Hello")
	}
}

struct SmallWidgetViews_Previews: PreviewProvider {
	static var previews: some View {
		WidgetObjectLink(object: WidgetObject.placeholder)
	}
}
