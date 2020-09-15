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
	let devMode = false
	var body: some View {
		
		NavigationView {
			ScrollView {
				//				ForEach(widgets) { w in
				NavigationLink(
					destination: SettingsEditor()){
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
			if devMode {let c = JSONEncoder()
			
			for w in widgets {
				do {
					try defaults.setValue(c.encode(w), forKey: w.sizeName)
				} catch {}
			}}
			
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
			var s = url.absoluteString
			if defaults.bool(forKey: "apollo"){
				s = "apollo" + s
			} else {
				s = "https" + s
			}
			UIApplication.shared.open(URL(string: s)!)
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
	let offset = defaults.integer(forKey: "offset" + String(configuration.number()))
	let sub = defaults.string(forKey: "sub" + String(configuration.number())) ?? "all"
	let sort = defaults.string(forKey: "sort" + String(configuration.number())) ?? "hot"
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
