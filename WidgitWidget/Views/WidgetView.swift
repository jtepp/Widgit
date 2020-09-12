//
//  SmallWidgetView.swift
//  Widgit
//
//  Created by Jacob Tepperman on 2020-09-07.
//

import SwiftUI
import WidgetKit

var scale: CGFloat = UIScreen.main.bounds.width/414

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
			
		}
//		.onAppear{
//			let n = object.sizeName
//			let decoder = JSONDecoder()
//			if let savedw = defaults.object(forKey: n) as? Data {
//				if let loadedw = try? decoder.decode(WidgetObject.self, from: savedw) {
//					object = loadedw; print(object)} else {print(n)}
//			}
//		}
		}
		
		
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
					.padding(.trailing, 4)
				
			}
			.foregroundColor(.white)
			.background(
				RoundedRectangle(cornerRadius: 5)
					.fill(Color.black.opacity(0.6))
			)

//			.padding(.horizontal,family != .systemMedium ? 25 : 5)
			.padding(.horizontal, 10)
			.frame(maxWidth: object.pwidth-(314-UIScreen.main.bounds.width), maxHeight: object.height)
		}
		.widgetURL(URL(string: data["link"]!)!)
	}
}

struct listView: View {
	var object: WidgetObject
	var data: [[String:String]]
	var pad: CGFloat {return CGFloat(5 * (object.maxPosts-object.count) + 2)}
	var body: some View {
		HStack(alignment:.center){
			VStack {
				ForEach(1..<Int(object.count + 1)) { i in
					if data.count > i {
						Link(destination: URL(string: data[i]["link"]!)!) {
							votesView(data: data[i])
								.minimumScaleFactor(0.6)
								.padding(.vertical,pad)
								.padding(.top, i == 1 ? pad : 0)
						}
//							.onAppear{
//						print(String(i) + "list" + object.sizeName)}
					}
					
					
				}
			}
			VStack(alignment:.leading) {
				ForEach(1..<Int(object.count + 1)) { i in
					if data.count > i {
						Link(destination: URL(string: data[i]["link"]!)!) {
					infoView(data: data[i])
						.padding(.top, i == 1 ? pad : 0)
						.padding(.vertical,pad)
						}
					}
				}
				
			}
		}
		.frame(maxWidth: object.pwidth-(314-UIScreen.main.bounds.width), maxHeight: object.height)
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
				.font(.footnote)
				.bold()
				.foregroundColor(Color("silver"))
				.minimumScaleFactor(0.4)
				.lineLimit(1)
			Text(data["title"]!)
				.minimumScaleFactor(0.6)
				.font(.headline)
				.lineLimit(2)
			Text("u/" + data["author"]!)
				.foregroundColor(Color("silver"))
				.font(.footnote)
				.bold()
				.minimumScaleFactor(0.6)
				.lineLimit(1)
		}.foregroundColor(.white)
	}
}

struct SmallWidgetView_Previews: PreviewProvider {
	static var previews: some View {
		Group {
			WidgetView(object: WidgetObject(sizeName: "Small", width: 100, height: 100, count: 1, maxPosts:2), data: [[String:String]](arrayLiteral: ["sub":"r/pics","title":"Amazing costumes","ups":"35720", "author":"D0NW0N", "image": "true", "url":"https://i.redd.it/hev4kwkzuzl51.jpg"]))
				.previewContext(WidgetPreviewContext(family: .systemSmall))
			WidgetView(object: WidgetObject(sizeName: "Medium", width: 250, height: 100, count: 2, maxPosts:2), data: [[String:String]](arrayLiteral: ["sub":"r/pics","title":"Amazing costumes","ups":"35720", "author":"D0NW0N", "image": "true", "url":"https://i.redd.it/hev4kwkzuzl51.jpg"],["sub":"r/ClashRoyale","title":"Something","ups":"3520", "author":"D0NW0N", "image": "false", "url":""],["sub":"r/pics","title":"Amazing costumes","ups":"35720", "author":"D0NW0N", "image": "true", "url":"https://i.redd.it/hev4kwkzuzl51.jpg"],["sub":"r/ClashRoyale","title":"Something","ups":"3520", "author":"D0NW0N", "image": "false", "url":""]))
				.previewContext(WidgetPreviewContext(family: .systemLarge))
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
