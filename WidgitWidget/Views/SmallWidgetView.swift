//
//  SmallWidgetView.swift
//  Widgit
//
//  Created by Jacob Tepperman on 2020-09-07.
//

import SwiftUI
import WidgetKit

struct SmallWidgetView: View {
	let object: WidgetObject
	let data: [[String:String]]
	var body: some View {
		
		ZStack {
			if object.count == 1 && data[0]["image"]! == "true" {
				imgFromUrl(url: data[0]["url"]!)
					.resizable()
					.aspectRatio(contentMode: .fill)
			}
			else {LinearGradient(gradient: Gradient(colors: [Color("start"), Color("end")]), startPoint: .topLeading, endPoint: .bottomTrailing)}
			VStack {
				Spacer()
				if object.count == 1 {
					SmallRow(object: object, data: data[0])
				} else {
					HStack{
						VStack {
							
							votesView(data: data[0])
								.padding(.vertical,20)
							votesView(data: data[1])
								.padding(.bottom,20)
						}
						VStack(alignment:.leading) {
							infoView(data: data[0])
								.padding(.vertical,20)
							infoView(data: data[1])
								.padding(.bottom,20)
						}
					}
				}
				Spacer()
			}
			
		}
		
		
	}
}


struct SmallRow: View {
	var object: WidgetObject
	var data: [String:String]
	var body: some View {
		HStack {
			VStack(alignment:.center) {
				votesView(data: data)
			}
			
			infoView(data: data)

		}
		.foregroundColor(.white)
		.background(
		RoundedRectangle(cornerRadius: 5)
			.fill(Color.black.opacity(object.count == 1 && data["image"]! == "true" ? 0.6 : 0))
		)
	}
}

struct votesView: View {
	var data: [String:String]
	var body: some View {
			VStack {
				Image(systemName: "arrow.up.square.fill")
					.foregroundColor(.red)
				Text(shortNumber(num:data["ups"]!))
					.font(.subheadline)
					.bold()
				Image(systemName: "arrow.down.square.fill")
					.foregroundColor(.red)
			}
			.foregroundColor(.white)
			.padding(.horizontal, 4)
	}
}

struct infoView: View {
	var data: [String:String]
	var body: some View {
		VStack(alignment:.leading) {
			Text("r/" + data["sub"]!)
				.font(.subheadline)
				.bold()
				.foregroundColor(Color("silver"))
			Text(data["title"]!)
				.font(.headline)
				.lineLimit(2)
				.minimumScaleFactor(0.8)
			Text("u/" + data["author"]!)
				.foregroundColor(Color("silver"))
				.font(.footnote)
				.bold()
		}.foregroundColor(.white)
	}
}

struct SmallWidgetView_Previews: PreviewProvider {
	static var previews: some View {
		Group {
			SmallWidgetView(object: WidgetObject.placeholder, data: [[String:String]](arrayLiteral: ["sub":"r/pics","title":"Amazing costumes","ups":"35720", "author":"D0NW0N", "image": "true", "url":"https://i.redd.it/hev4kwkzuzl51.jpg"],["sub":"r/ClashRoyale","title":"Something","ups":"3520", "author":"D0NW0N", "image": "false", "url":""]))
				.previewContext(WidgetPreviewContext(family: .systemSmall))
			SmallWidgetView(object: WidgetObject(sizeName: "Small", width: 100, height: 100, count: 2), data: [[String:String]](arrayLiteral: ["sub":"r/pics","title":"Amazing costumes","ups":"35720", "author":"D0NW0N", "image": "true", "url":"https://i.redd.it/hev4kwkzuzl51.jpg"],["sub":"r/ClashRoyale","title":"Something","ups":"3520", "author":"D0NW0N", "image": "false", "url":""]))
				.previewContext(WidgetPreviewContext(family: .systemSmall))
		}
	}
}

func imgFromUrl(url:String) -> Image {
	var d = Data()
	do {
		d = try Data(contentsOf: URL(string: url)!)
	}
	catch{}
	let i = UIImage(data: d)
	return Image(uiImage: i!)
}
