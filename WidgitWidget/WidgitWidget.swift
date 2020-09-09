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
	var widgets = [WidgetObject.placeholder,WidgetObject.placeholderM,WidgetObject.placeholderL]
	
	func snapshot(with context: Context, completion: @escaping (Entry) -> ()) {
		let entry = WidgetObjectEntry(object: [WidgetObject.placeholder, WidgetObject.placeholderM, WidgetObject.placeholderL], data:[[String:String]]())
		completion(entry)
	}
	func timeline(with context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
		var sub = defaults.string(forKey: "sub") ?? "all"
		var data = [[String:String]]()
		loadData(to: &data, sub: "pics")
		let entry = WidgetObjectEntry(object:widgets, data:data)
		let nextUpdateDate = Calendar.current.date(byAdding: .minute, value: 15, to: Date())!
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
				SmallWidgetView(object: entry.object[0], data:entry.data)
			case .systemMedium:
				MediumWidgetView()
			case .systemLarge:
				LargeWidgetView()
			@unknown default:
				SmallWidgetView(object: entry.object[0], data:entry.data)
				
		}
	}
}

struct PlaceholderView: View {
	let data = [[String:String]](arrayLiteral: ["title":"title","ups":"10"],["title":"title2","ups":"20"])
	
	@Environment(\.widgetFamily) var family
	var body: some View {
		switch family {
			case .systemSmall:
				SmallWidgetView(object: WidgetObject.placeholder, data: data)
			case .systemMedium:
				MediumWidgetView()
			case .systemLarge:
				LargeWidgetView()
			@unknown default:
				SmallWidgetView(object: WidgetObject.placeholder, data: data)

		}
	}
}


@main struct WidgitWidget: Widget {
	private let kind = "WidgitWidget"
	var body: some WidgetConfiguration {
		StaticConfiguration(kind: kind, provider: Provider(), placeholder: PlaceholderView()) {
			entry in
			WidgetEntryView(entry: entry)
		}
	}
}

