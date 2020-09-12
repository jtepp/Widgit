//
//  ContentView.swift
//  Widgit
//
//  Created by Jacob Tepperman on 2020-09-06.
//

import SwiftUI
import WidgetKit

var defaults = UserDefaults.init(suiteName: "group.com.jtepp.Widgit")!
struct ContentView: View {
	@State var widgets = [WidgetObject.placeholder, WidgetObject.placeholderM, WidgetObject.placeholderL]
	@State var data = [[String:String]]()
	@State var realSub = defaults.string(forKey: "sub") ?? "all"
	
	var body: some View {
		
		NavigationView {
			ScrollView {
				//				ForEach(widgets) { w in
				NavigationLink(
					destination: SettingsEditor(realSub: $realSub)){
					VStack {
						Spacer()
						HStack {
							Spacer()
							Spacer()
							Spacer()
							Text("Customize settings")
								.font(.title)
								.bold()
							Spacer()
							Image(systemName: "chevron.right.circle")
							Spacer()
						}
						Spacer()
					}
					.foregroundColor(Color("blackwhite"))
					.background(
						RoundedRectangle(cornerRadius: 10)
							.fill(
								Color.init(.systemGray3).opacity(0.5)
							)
					)
					.padding(20)
				}
				WidgetObjectLink(object: $widgets[0])
				WidgetObjectLink(object: $widgets[1])
				WidgetObjectLink(object: $widgets[2])
				//				}
			}
			.background(
				LinearGradient(gradient: Gradient(colors: [Color("start"), Color("end")]), startPoint: .topLeading, endPoint: .bottomTrailing)
					.edgesIgnoringSafeArea(.all)
			)
			.navigationTitle("Home")
		}
		.accentColor(Color("blackwhite"))
		.onAppear(){
//			let c = JSONEncoder()
			
//			for w in widgets {
//				do {
//					try defaults.setValue(c.encode(w), forKey: w.sizeName)
//				} catch {}
//			}
			
//			loadData(to: &data, sub: "clashroyale")
			let decoder = JSONDecoder()
			if let savedSmall = defaults.object(forKey: "Small") as? Data {
				if let loadedSmall = try? decoder.decode(WidgetObject.self, from: savedSmall) {
					widgets[0] = loadedSmall
				}
			}
			
			if let savedMedium = defaults.object(forKey: "Medium") as? Data {
				if let loadedMedium = try? decoder.decode(WidgetObject.self, from: savedMedium) {
					widgets[1] = loadedMedium
				}
			}
			
			if let savedLarge = defaults.object(forKey: "Large") as? Data {
				if let loadedLarge = try? decoder.decode(WidgetObject.self, from: savedLarge) {
					widgets[2] = loadedLarge
				}
			}
//			print(data)
//			print(widgets)
			
			
		}
		.onOpenURL(perform: { url in
			UIApplication.shared.open(url)
		})
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
//		SubredditSettingsEditor(realSub: .constant("pics"))
			.preferredColorScheme(.dark)
	}
}


func convertStringToDictionary(text: String) -> [[String:String]] {
	if let data = text.data(using: .utf8) {
		do {
			let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [[String:String]]
			return json
		} catch {
			print("Something went wrong")
		}
	}
	return [[String:String]]()
}

public func loadData(to: inout [[String:String]], limit: Int = 6) {
	let offset = defaults.integer(forKey: "offset")
	let sub = defaults.string(forKey: "sub") ?? "all"
	let sort = defaults.string(forKey: "sort") ?? "hot"
	do {
		var s =  "https://allpurpose.netlify.app/.netlify/functions/reddit?"
		s = s + "sub=" + sub
		s = s + "&sort=" + sort
		s = s + "&limit=" + String(limit)
		s = s + "&offset=" + String(offset)
		print(s)
		let url = URL(string: s)
		let a = try String(contentsOf: url!)
		to = convertStringToDictionary(text: String(a))
		
	} catch {}
}

public func returnLoadData(for configuration: ChannelE, limit: Int = 6) -> [[String:String]] {
	let offset = defaults.integer(forKey: "offset")
	let sub = defaults.string(forKey: "sub") ?? "all"
	let sort = defaults.string(forKey: "sort") ?? "hot"
	var to = [[String:String]]()
	do {
		var s =  "https://allpurpose.netlify.app/.netlify/functions/reddit?"
		s = s + "sub=" + sub
		s = s + "&sort=" + sort
		s = s + "&limit=" + String(limit)
		s = s + "&offset=" + String(offset)
		print(s)
		let url = URL(string: s)
		let a = try String(contentsOf: url!)
		to = convertStringToDictionary(text: String(a))
		
	} catch {}
	return to
}




func verifySub(sub: String) -> Bool {
	var b = false
	do {
		
		var s =  "https://allpurpose.netlify.app/.netlify/functions/reddit?verify=true&"
		s = s + "sub=" + sub
		s = s + "&sort=hot"
		let url = URL(string: s)
		let a = try String(contentsOf: url!)
		b = Bool(a) ?? false
		
	} catch {}
	if b {
		WidgetCenter.shared.reloadAllTimelines()
	}
	return b
}


struct SettingsEditor: View {
	@Binding var realSub: String
	@State var subber:String = ""
	@State var verification: Bool = false
	@State var showBad = false
	@State var newOffset = defaults.integer(forKey: "offset")
	@State var newOffsetString = String(defaults.integer(forKey: "offset"))
	@State var sortValue = defaults.string(forKey: "sort") ?? "hot"
	@State var update = defaults.double(forKey: "update")
	var body: some View {
		ZStack {
			LinearGradient(gradient: Gradient(colors: [Color("start"), Color("end")]), startPoint: .topLeading, endPoint: .bottomTrailing)
				.edgesIgnoringSafeArea(.all)
		ScrollView {
			VStack{
				Text("Set refresh time: " + String(Int(update) == 0 ? 5 : Int(update)) + " minutes")
					.font(.title3)
					.bold()
					.padding(.top,20)
				HStack{
					Text("5")
					Slider(value: $update, in: 5...120, step: 1.0) { _ in
						defaults.setValue(Double(update), forKey: "update")
						WidgetCenter.shared.reloadAllTimelines()
					}
					Text("120")
				}.padding(20)
//				Text("For best results, restart your device to enact changes")
//					.font(.callout)
//					.padding(20)
			}
				TextField("Enter subreddit", text: $subber)
					.font(.title)
					.padding(20)
			Button(action: {
				subber = subber.replacingOccurrences(of: " ", with: "")
				verification = verifySub(sub: subber)
				if verification {
					realSub = subber
					showBad = false
					defaults.setValue(realSub, forKey: "sub")
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
					.font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
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
				defaults.setValue(sortValue, forKey: "sort")
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
				defaults.setValue(newOffset, forKey: "offset")
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
		}
		.navigationTitle("Customize settings")
		
			}
		.onAppear(){
			update = defaults.double(forKey: "update")
			newOffset = defaults.integer(forKey: "offset")
			newOffsetString = String(defaults.integer(forKey: "offset"))
			sortValue = defaults.string(forKey: "sort") ?? "hot"
			
		}
	}
	
}


public enum ChannelE: Int {
	case one = 1
	case two
	case three
	case four
	case five
	case six
	
	func number() -> Int {
		switch self {
			case .one:
				return 1
			case .two:
				return 2
			case .three:
				return 3
			case .four:
				return 4
			case .five:
				return 5
			case .six:
				return 6
		}
	}
}
