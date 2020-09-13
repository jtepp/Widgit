//
//  ChannelEditor.swift
//  Widgit
//
//  Created by Jacob Tepperman on 2020-09-12.
//

import SwiftUI
import WidgetKit

struct ChannelEditor: View {
	let n: Int
	@State var realSub = ""
	@State var subber:String = ""
	@State var verification: Bool = false
	@State var showBad = false
	@State var newOffset = 0
	@State var newOffsetString = "0"
	@State var sortValue = defaults.string(forKey: "sort") ?? "hot"
	var body: some View {
		ZStack {
			LinearGradient(gradient: Gradient(colors: [Color("start"), Color("end")]), startPoint: .topLeading, endPoint: .bottomTrailing)
				.edgesIgnoringSafeArea(.all)
			ScrollView {
			TextField("Enter subreddit", text: $subber)
				.font(.title)
				.padding(20)
			Button(action: {
				subber = subber.replacingOccurrences(of: " ", with: "")
				verification = verifySub(sub: subber)
				if verification {
					realSub = subber
					showBad = false
					defaults.setValue(realSub, forKey: "sub" + String(n))
				} else {
					showBad = true
				}
			}, label: {
				Text("Check subreddit")
			})
			.foregroundColor(.white)
			.padding(8)
			.background(
				RoundedRectangle(cornerRadius: 5)
					.fill(Color("end"))
			)
			Text("Current subreddit: r/" + realSub.lowercased())
				.padding(20)
			if showBad {
				Text("Invalid subreddit")
					.padding(20)
			}
			
			VStack {
				Divider()
					.background(Color.white)
				Text("Sort posts by:")
					.font(.title2)
					.bold()
					.padding(20)
			}
			Picker(selection: $sortValue, label: Text("Sort"), content: {
				Text("Hot").tag("hot")
				Text("New").tag("new")
				Text("Rising").tag("rising")
				Text("Controversial").tag("controversial")
				Text("Top [All time]").tag("top!t=all")
				Text("Top [This year]").tag("top!t=year")
				Text("Top [This month]").tag("top!t=month")
				Text("Top [This week]").tag("top!t=week")
				Text("Top [Today]").tag("top!t=day")
			})
			.onChange(of: sortValue, perform: { value in
				defaults.setValue(sortValue, forKey: "sort" + String(n))
				WidgetCenter.shared.reloadAllTimelines()
			})
			VStack {
				Divider()
					.background(Color.white)
				HStack {
					
					Text("Current offset: ")
						.padding(20)
					TextField("Enter offset", text: $newOffsetString, onEditingChanged: { _ in
						let filtered = newOffsetString.filter{ "0123456789".contains($0)}
						if filtered != newOffsetString {
							newOffsetString = filtered
							
							newOffset = Int(newOffsetString)!
							WidgetCenter.shared.reloadAllTimelines()
							
						}
					})
					.font(.title3)
					.padding(20)
					.keyboardType(.numberPad)
					Spacer()
				}
			}
			Button(action: {
				newOffset = Int(newOffsetString)!
				defaults.setValue(newOffset, forKey: "offset" + String(n))
				WidgetCenter.shared.reloadAllTimelines()
			}, label: {
				Text("Set offset")
			})
			.foregroundColor(.white)
			.padding(8)
			.background(
				RoundedRectangle(cornerRadius: 5)
					.fill(Color("end"))
			)
			Text("Use an offset if your subreddit has a constant number of pinned or moderator posts that arent filtered out by the Widgit API")
				.multilineTextAlignment(.center)
				.lineLimit(4)
				.padding(20)
				.font(.callout)
				
				//			Spacer()
				.navigationTitle("Channel Editor")
		}
		}
		.onAppear{
			newOffset = defaults.integer(forKey: "offset" + String(n))
			newOffsetString = String(defaults.integer(forKey: "offset" + String(n)))
			sortValue = defaults.string(forKey: "sort" + String(n)) ?? "hot"
			realSub = defaults.string(forKey: "sub" + String(n)) ?? "all"
		}
	}
}

struct ChannelEditor_Previews: PreviewProvider {
	static var previews: some View {
		NavigationView {
			ChannelEditor(n: 1)
		}
	}
}
