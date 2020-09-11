//
//  SmallWidgetView.swift
//  Widgit
//
//  Created by Jacob Tepperman on 2020-09-07.
//

import SwiftUI
import WidgetKit

struct WidgetView: View {
	let object: WidgetObject
	let data: [[String:String]]
	var body: some View {
		
		if data.count == 1 {
			SingleImageView(object: object, data: data[0])
		} else {ZStack
		{LinearGradient(gradient: Gradient(colors: [Color("start"), Color("end")]), startPoint: .topLeading, endPoint: .bottomTrailing)
			VStack {
				Spacer()
				
					listView(object: object, data: data)
				
				Spacer()
			}
			
		}}
		
		
	}
}


struct SingleImageView: View {
	var object: WidgetObject
	var data: [String:String]
	@Environment(\.widgetFamily) var family
	var body: some View {
		ZStack{
			imgFromUrl(url: data["url"]!)
				.resizable()
				.aspectRatio(contentMode: .fill)
			HStack {
				VStack(alignment:.center) {
					votesView(data: data)
				}
				
				infoView(data: data)
				
			}
			.foregroundColor(.white)
			.background(
				RoundedRectangle(cornerRadius: 5)
					.fill(Color.black.opacity(0.6))
			)
			.padding(.horizontal,family != .systemMedium ? 25 : 5)
		}}
}

struct listView: View {
	var object: WidgetObject
	var data: [[String:String]]
	var body: some View {
		HStack{
			VStack {
				ForEach(1..<Int(object.count + 1)) { i in
					if data.count > i {
						votesView(data: data[i])
							.padding(.vertical,20)
					}
					
				}
			}
			VStack(alignment:.leading) {
				ForEach(1..<Int(object.count + 1)) { i in
					if data.count > i {
					infoView(data: data[i])
						.padding(.vertical,20)
					}
				}
				
			}
		}
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
			WidgetView(object: WidgetObject(sizeName: "Small", width: 100, height: 100, count: 1, maxPosts:2), data: [[String:String]](arrayLiteral: ["sub":"r/pics","title":"Amazing costumes","ups":"35720", "author":"D0NW0N", "image": "true", "url":"https://i.redd.it/hev4kwkzuzl51.jpg"],["sub":"r/ClashRoyale","title":"Something","ups":"3520", "author":"D0NW0N", "image": "false", "url":""]))
				.previewContext(WidgetPreviewContext(family: .systemSmall))
			WidgetView(object: WidgetObject(sizeName: "Small", width: 100, height: 100, count: 1, maxPosts:2), data: [[String:String]](arrayLiteral: ["sub":"r/pics","title":"Amazing costumes","ups":"35720", "author":"D0NW0N", "image": "true", "url":"https://i.redd.it/hev4kwkzuzl51.jpg"],["sub":"r/ClashRoyale","title":"Something","ups":"3520", "author":"D0NW0N", "image": "false", "url":""]))
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
