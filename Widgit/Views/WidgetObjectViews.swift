//
//  WidgetObjectViews.swift
//  Widgit
//
//  Created by Jacob Tepperman on 2020-09-06.
//

import SwiftUI

struct WidgetObjectLink: View {
	@Binding var object: WidgetObject
	var body: some View {
		
		NavigationLink(destination: WidgetObjectEditor(object: $object)) {
			VStack {
				HStack() {
					Text(object.sizeName + " Widget")
						.foregroundColor(
							Color("blackwhite")
						)
						.font(.headline)
						.padding(.init(top: 10, leading: 20, bottom: -5, trailing: 0))
					Spacer()
				}
				Divider()
					.background(Color("blackwhite").opacity(0.6))
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
	@Binding var object: WidgetObject
	let encoder = JSONEncoder()
	var body: some View {
		ZStack {
			LinearGradient(gradient: Gradient(colors: [Color("start"), Color("end")]), startPoint: .topLeading, endPoint: .bottomTrailing)
				.edgesIgnoringSafeArea(.all)
			ScrollView {
				
				VStack {
//				HStack {
//					Text("Show first image (full widget)")
//						.bold()
//						.multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
//						.frame(minWidth:UIScreen.main.bounds.width*3/4)
//
//					Toggle("", isOn: $object.singleImage)
//						.onChange(of: object.singleImage, perform: { _ in
//							do {try defaults.setValue(encoder.encode(object), forKey: object.sizeName)} catch {print("false")}
//
//
//						})
//				}
//				.padding(20)
					
				
					Divider()
						.background(Color.white)
					VStack {
						Text("Number of posts displayed: " + String(Int(object.count)))
							.bold()
						HStack {
							Text("1")
							Slider(value: $object.count, in: 1...object.maxPosts, step: 1.0) { _ in
								do {try defaults.setValue(encoder.encode(object), forKey: object.sizeName)} catch {print("false")}
							}
							Text(String(Int(object.maxPosts)))
						}
					}
					.padding(20)
				
			
				}
				Spacer()
			}
			.foregroundColor(Color("blackwhite"))
			.navigationTitle(object.sizeName + " widget")
		}
	}
}

struct SmallWidgetViews_Previews: PreviewProvider {
	static var previews: some View {
		WidgetObjectEditor(object: .constant(WidgetObject.placeholder))
	}
}
