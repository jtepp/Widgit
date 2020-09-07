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
	var body: some View {
		
		NavigationView {
			ScrollView {
				//				ForEach(widgets) { w in
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
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
			.preferredColorScheme(.dark)
	}
}


func convertStringToDictionary(text: String) -> [String:AnyObject]? {
	if let data = text.data(using: .utf8) {
		do {
			let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject]
			return json
		} catch {
			print("Something went wrong")
		}
	}
	return nil
}

func ioLoadData(sub:String, to: inout Dictionary<String, String>) {
	do {
		let x = try String(contentsOf: URL(string: "https://reddit.com/r/" + sub + ".json")!)
		let y = convertStringToDictionary(text: x)!
		to = y["data"] as! Dictionary<String, String>
	} catch {}
}

func loadData(sub:String) -> Dictionary<String, String> {
	do {
		let x = try String(contentsOf: URL(string: "https://reddit.com/r/" + sub + ".json")!)
		let y = convertStringToDictionary(text: x)!
		return y["data"] as! Dictionary<String, String>
	} catch {}
	return Dictionary<String, String>()
}
