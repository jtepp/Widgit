//
//  WidgitWidget.swift
//  WidgitWidget
//
//  Created by Jacob Tepperman on 2020-09-07.
//

import WidgetKit
import SwiftUI

struct WidgetObjectEntry: TimelineEntry {
	let date = Date()
	let object: [WidgetObject]
	var data: [[String:String]]
}

struct Provider: TimelineProvider {
	typealias Entry = WidgetObjectEntry
	@State var widgets = [WidgetObject.placeholder,WidgetObject.placeholderM,WidgetObject.placeholderL]
	
	let decoder = JSONDecoder()
	
	
	
	
	
	func snapshot(with context: Context, completion: @escaping (Entry) -> ()) {
		let entry = WidgetObjectEntry(object: [WidgetObject.placeholder, WidgetObject.placeholderM, WidgetObject.placeholderL], data:[[String:String]]())
		completion(entry)
	}
	func timeline(with context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
		
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
		
		
		var data = [[String:String]]()
		loadData(to: &data)
		let entry = WidgetObjectEntry(object:widgets, data:data)
		let update = defaults.double(forKey: "update")
		let nextUpdateDate = Calendar.current.date(byAdding: .minute, value: (Int(update) == 0 ? 5 : Int(update)), to: Date())!
		let timeline = Timeline(entries: [entry], policy: .after(nextUpdateDate))
		completion(timeline)
	}
}

struct ImageProvider: TimelineProvider {
	typealias Entry = WidgetObjectEntry
	@State var widgets = [WidgetObject.placeholder,WidgetObject.placeholderM,WidgetObject.placeholderL]
	
	let decoder = JSONDecoder()
	
	func snapshot(with context: Context, completion: @escaping (Entry) -> ()) {
		let entry = WidgetObjectEntry(object: [WidgetObject.placeholder, WidgetObject.placeholderM, WidgetObject.placeholderL], data:[[String:String]]())
		completion(entry)
	}
	func timeline(with context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
		
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
		
		
		var data = [[String:String]]()
		loadData(to: &data)
		let entry = WidgetObjectEntry(object:widgets, data:[data[0]])
		let update = defaults.double(forKey: "update")
		let nextUpdateDate = Calendar.current.date(byAdding: .minute, value: (Int(update) == 0 ? 5 : Int(update)), to: Date())!
		let timeline = Timeline(entries: [entry], policy: .after(nextUpdateDate))
		completion(timeline)
	}
}


struct WidgetEntryView: View {
	let entry: Provider.Entry
	
	@Environment(\.widgetFamily) var family
	var body: some View {
		switch family {
			case .systemSmall:
				WidgetView(object: entry.object[0], data:entry.data)
			case .systemMedium:
				WidgetView(object: entry.object[1], data:entry.data)
			case .systemLarge:
				WidgetView(object: entry.object[2], data:entry.data)
			@unknown default:
				WidgetView(object: entry.object[0], data:entry.data)
				
		}
		
	}
}

struct PlaceholderView: View {
	let data = [[String:String]](arrayLiteral: ["title":"title","ups":"10"],["title":"title2","ups":"20"])
	
	@Environment(\.widgetFamily) var family
	var body: some View {
		switch family {
			case .systemSmall:
				WidgetView(object: WidgetObject.placeholder, data: data)
			case .systemMedium:
				WidgetView(object: WidgetObject.placeholder, data: data)
			case .systemLarge:
				WidgetView(object: WidgetObject.placeholder, data: data)
			@unknown default:
				WidgetView(object: WidgetObject.placeholder, data: data)

		}
	}
}




@main
struct WidgitWidget: WidgetBundle {
	@WidgetBundleBuilder
	var body: some Widget {
		ListWidget()
		ImageWidget()
	}
}



struct ListWidget: Widget {
	private let kind = "ListWidget"
	var body: some WidgetConfiguration {
		StaticConfiguration(kind: kind, provider: Provider(), placeholder: PlaceholderView()) {
			entry in
			WidgetEntryView(entry: entry)
		}
		.configurationDisplayName("Reddit Posts")
		
		.description("Displays Reddit posts based on customized settings within the app")

	}
}

struct ImageWidget: Widget {
	private let kind = "ImageWidget"
	var body: some WidgetConfiguration {
		StaticConfiguration(kind: kind, provider: ImageProvider(), placeholder: PlaceholderView()) {
			entry in
			WidgetEntryView(entry: entry)
		}
		.configurationDisplayName("Reddit Images")
		
		.description("Displays the top Reddit post with an image, based on customized settings within the app")
		
	}
}
