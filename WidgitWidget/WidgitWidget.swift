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

struct Provider: IntentTimelineProvider {
	
//	typealias Intent = SelectSubredditChannelIntent
	
	
	
	
	
	
	typealias Entry = WidgetObjectEntry
	@State var widgets = [WidgetObject.placeholder,WidgetObject.placeholderM,WidgetObject.placeholderL]
	@State var data = [[String:String]]()
	let decoder = JSONDecoder()
	
	
	func channel(for config:SelectSubredditChannelIntent) -> ChannelE {
		switch config.Channel {
			case .one:
				return .one
			case .two:
				return .two
			case .three:
				return .three
			case .four:
				return .four
			case .five:
				return .five
			case .six:
				return .six
			default:
				return .one
		}
	}
	
	
	func getSnapshot(for configuration: SelectSubredditChannelIntent, in context: Context, completion: @escaping (Entry) -> ()) {
		
		
		var small = WidgetObject(sizeName: "", width: 0, height: 0, count: 0, maxPosts: 0);
		if let savedSmall = defaults.object(forKey: "Small") as? Data {
			if let loadedSmall = try? decoder.decode(WidgetObject.self, from: savedSmall) {
				small = loadedSmall
				widgets[0] = loadedSmall
				
				print(loadedSmall)} else {print("Small")}
		}
		
		
		var medium = WidgetObject(sizeName: "", width: 0, height: 0, count: 0, maxPosts: 0);
		if let savedMedium = defaults.object(forKey: "Medium") as? Data {
			if let loadedMedium = try? decoder.decode(WidgetObject.self, from: savedMedium) {
				medium = loadedMedium
				widgets[1] = loadedMedium
				print(loadedMedium)} else {print("Medium")}
		}
		var large = WidgetObject(sizeName: "", width: 0, height: 0, count: 0, maxPosts: 0);
		if let savedLarge = defaults.object(forKey: "Large") as? Data {
			if let loadedLarge = try? decoder.decode(WidgetObject.self, from: savedLarge) {
				large = loadedLarge
				
				widgets[2] = loadedLarge
				print(loadedLarge)
				
			} else {print("Large")}
		}
		
		let entry = WidgetObjectEntry(object: [small, medium, large], data:returnLoadData(for: channel(for: configuration)))
		completion(entry)
	}
	
	func getTimeline(for configuration: SelectSubredditChannelIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
		var small = WidgetObject(sizeName: "", width: 0, height: 0, count: 0, maxPosts: 0);
		if let savedSmall = defaults.object(forKey: "Small") as? Data {
			if let loadedSmall = try? decoder.decode(WidgetObject.self, from: savedSmall) {
				small = loadedSmall
				widgets[0] = loadedSmall
				
				print(loadedSmall)} else {print("Small")}
		}
		
		
		var medium = WidgetObject(sizeName: "", width: 0, height: 0, count: 0, maxPosts: 0);
		if let savedMedium = defaults.object(forKey: "Medium") as? Data {
			if let loadedMedium = try? decoder.decode(WidgetObject.self, from: savedMedium) {
				medium = loadedMedium
				widgets[1] = loadedMedium
				print(loadedMedium)} else {print("Medium")}
		}
		var large = WidgetObject(sizeName: "", width: 0, height: 0, count: 0, maxPosts: 0);
		if let savedLarge = defaults.object(forKey: "Large") as? Data {
			if let loadedLarge = try? decoder.decode(WidgetObject.self, from: savedLarge) {
				large = loadedLarge
				
				widgets[2] = loadedLarge
				print(loadedLarge)
				
			} else {print("Large")}
		}
		
		
		
		//		loadData(to: &data)
		let entry = WidgetObjectEntry(object:[small, medium, large], data:returnLoadData(for: channel(for: configuration)))
		
		let update = defaults.double(forKey: "update")
		let nextUpdateDate = Calendar.current.date(byAdding: .minute, value: (Int(update) == 0 ? 5 : Int(update)), to: Date())!
		let timeline = Timeline(entries: [entry], policy: .after(nextUpdateDate))
		completion(timeline)
	}
	
	func placeholder(in context: Context) -> WidgetObjectEntry {
		if let savedSmall = defaults.object(forKey: "Small") as? Data {
			if let loadedSmall = try? decoder.decode(WidgetObject.self, from: savedSmall) {
				widgets[0] = loadedSmall; print(loadedSmall)} else {print("Small")}
		}

		if let savedMedium = defaults.object(forKey: "Medium") as? Data {
			if let loadedMedium = try? decoder.decode(WidgetObject.self, from: savedMedium) {
				widgets[1] = loadedMedium; print(loadedMedium)} else {print("Medium")}
		}

		if let savedLarge = defaults.object(forKey: "Large") as? Data {
			if let loadedLarge = try? decoder.decode(WidgetObject.self, from: savedLarge) {
				widgets[2] = loadedLarge; print(loadedLarge)} else {print("Large")}
		}
		return WidgetObjectEntry(object: widgets, data: returnLoadData(for: ChannelE.one))
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
	let data = [[String:String]](arrayLiteral: ["title":"title","ups":"10", "sub":"test","author":"me"],["title":"title","ups":"10", "sub":"test","author":"me"])
	
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
		IntentConfiguration(kind: kind, intent: SelectSubredditChannelIntent.self, provider: Provider()) {
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
		IntentConfiguration(kind: kind, intent: SelectSubredditChannelIntent.self, provider: Provider()) {
			entry in
			WidgetEntryView(entry: WidgetObjectEntry(object: entry.object, data: [entry.data.isEmpty ?  ["sub":"r/pics","title":"Amazing costumes","ups":"35720", "author":"D0NW0N", "image": "true", "url":"https://i.redd.it/hev4kwkzuzl51.jpg"] : entry.data[0]]))
		}
		.configurationDisplayName("Reddit Images")

		.description("Displays the top Reddit post with an image, based on customized settings within the app")

	}
}
