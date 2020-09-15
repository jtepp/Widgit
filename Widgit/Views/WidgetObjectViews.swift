//
//  WidgetObjectViews.swift
//  Widgit
//
//  Created by Jacob Tepperman on 2020-09-06.
//

import SwiftUI
import WidgetKit

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
					.frame(width: object.pwidth, height: object.pheight, alignment: .center)
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
	@State var placement = 0
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
					
//
//					Divider()
//						.background(Color.white)
					VStack {
						Text("List widget:")
							.font(.headline)
						Text("Number of posts displayed: " + String(Int(object.count)))
							.bold()
						HStack {
							Text("1")
							Slider(value: $object.count, in: 1...object.maxPosts, step: 1.0) { _ in
								do {try defaults.setValue(encoder.encode(object), forKey: object.sizeName)} catch {print("false")}
								WidgetCenter.shared.reloadAllTimelines()
							}
							Text(String(Int(object.maxPosts)))
						}
					}
					.padding(20)
					Text("Image widget:")
						.font(.headline)
					Text("Info placement:")
						.font(.title2)
						.bold()
						.padding(.init(top: 0, leading: 20, bottom: 20, trailing: 20))
					Picker("info", selection: $placement, content: {
						Text("Top").tag(0)
						Text("Center").tag(1)
						Text("Bottom").tag(2)
					})
					
					.pickerStyle(InlinePickerStyle())
			
				}.onChange(of: placement, perform: { _ in
					object.placement = placement
					do {try defaults.setValue(encoder.encode(object), forKey: object.sizeName)} catch {}
					WidgetCenter.shared.reloadAllTimelines()
				})
				Spacer()
			}
			.onAppear{
				placement = object.placement
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
