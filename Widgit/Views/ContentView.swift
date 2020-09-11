//
//  ContentView.swift
//  Widgit
//
//  Created by Jacob Tepperman on 2020-09-06.
//

import SwiftUI
var defaults = UserDefaults.init(suiteName: "group.com.jtepp.Widgit")!
struct ContentView: View {
	@State var widgets = [WidgetObject.placeholder, WidgetObject.placeholderM, WidgetObject.placeholderL]
	@State var data = [[String:String]]()
	var body: some View {
		
		NavigationView {
			ScrollView {
				//				ForEach(widgets) { w in
				NavigationLink(
					destination: SubredditSettingsEditor()){
					Text("Subreddit Settings")
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
		.onAppear(){
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
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
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

public func loadData(to: inout [[String:String]], limit: Int = 2, firstImg: Bool = false, offset: Int = 0) {
	let sub = defaults.string(forKey: "sub") ?? "all"
	let sort = defaults.string(forKey: "sort") ?? "hot"
	do {
		var s =  "https://allpurpose.netlify.app/.netlify/functions/reddit?"
		s = s + "sub=" + sub
		s = s + "&sort=" + sort
		s = s + "&limit=" + String(limit + 1)
		s = s + "&offset=" + String(offset)
		s = s + "&firstImg=" + String(firstImg)
		let url = URL(string: s)
		let a = try String(contentsOf: url!)
		to = convertStringToDictionary(text: String(a))
		
	} catch {}
}

func verifySub(sub: String) -> Bool {
	var b = false
	do {
		
		var s =  "https://allpurpose.netlify.app/.netlify/functions/reddit?verify=true&"
		s = s + "sub=" + sub
		let url = URL(string: s)
		let a = try String(contentsOf: url!)
		b = Bool(a) ?? false
		
	} catch {}
	return b
}


struct SubredditSettingsEditor: View {
	var body: some View {
		Text("here")
	}
}
