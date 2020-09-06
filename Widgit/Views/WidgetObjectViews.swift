//
//  WidgetObjectViews.swift
//  Widgit
//
//  Created by Jacob Tepperman on 2020-09-06.
//

import SwiftUI

struct WidgetObjectLink: View {
	var editor: WidgetObjectEditor

	var body: some View {
		NavigationLink(destination: editor) {
			VStack {
				HStack() {
					Text("Small Widget")
						.foregroundColor(.black)
						.font(.headline)
						.padding(.init(top: 10, leading: 20, bottom: -5, trailing: 0))
					Spacer()
				}
				Divider()
				RoundedRectangle(cornerRadius: 20)
					.frame(width: 100, height: 100, alignment: .center)
					.shadow(radius: 10, x: 8, y: 8)
					.rotation3DEffect(
						.degrees(4),
						axis: (x: 1.0, y: -1.0, z: 0.5)
					)
					.padding(.bottom)
					.foregroundColor(
						Color.black.opacity(0.6)
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
	var body: some View {
			Text("Hello")
	}
}

struct SmallWidgetViews_Previews: PreviewProvider {
	static var previews: some View {
		NavigationView{
			WidgetObjectLink(editor: WidgetObjectEditor())
		}
	}
}
