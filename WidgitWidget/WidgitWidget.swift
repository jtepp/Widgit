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
	let object: WidgetObject
}

struct Provider: TimelineProvider {
	typealias Entry = WidgetObjectEntry
	var widgets = [WidgetObject.placeholder,WidgetObject.placeholderM,WidgetObject.placeholderL]
	
	func snapshot(with context: Context, completion: @escaping (Entry) -> ()) {
		let entry = WidgetObjectEntry(object: WidgetObject.placeholder)
		completion(entry)
	}
	func timeline(with context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
		let entry = WidgetObjectEntry(object: WidgetObject.placeholderL)
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
			SmallWidgetView()
			case .systemMedium:
				MediumWidgetView()
			case .systemLarge:
				LargeWidgetView()
			@unknown default:
				SmallWidgetView()
				
		}
	}
}

struct PlaceholderView: View {
	let entry = WidgetObject.placeholder
	
	@Environment(\.widgetFamily) var family
	var body: some View {
		switch family {
			case .systemSmall:
				SmallWidgetView()
			case .systemMedium:
				MediumWidgetView()
			case .systemLarge:
				LargeWidgetView()
			@unknown default:
				SmallWidgetView()

		}
	}
}


@main struct WidgetWidget: Widget {
	private let kind = "WidgitWidget"
	var body: some WidgetConfiguration {
		StaticConfiguration(kind: kind, provider: Provider(), placeholder: PlaceholderView()) {
			entry in
			WidgetEntryView(entry: entry)
		}
	}
}
