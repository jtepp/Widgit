//
//  SettingsEditor.swift
//  Widgit
//
//  Created by Jacob Tepperman on 2020-09-12.
//

import SwiftUI
import WidgetKit

struct SettingsEditor: View {
	@State var update = defaults.double(forKey: "update")
	var body: some View {
		ZStack {
			LinearGradient(gradient: Gradient(colors: [Color("start"), Color("end")]), startPoint: .topLeading, endPoint: .bottomTrailing)
				.edgesIgnoringSafeArea(.all)
			ScrollView {
				VStack{
					Text("Set refresh time: " + String(Int(update) == 0 ? 5 : Int(update)) + " minutes")
						.font(.title3)
						.bold()
						.padding(.top,20)
					HStack{
						Text("5")
						Slider(value: $update, in: 5...120, step: 1.0) { _ in
							defaults.setValue(Double(update), forKey: "update")
							WidgetCenter.shared.reloadAllTimelines()
						}
						Text("120")
					}.padding(20)
					
					ForEach(0..<6){ n in
						NavigationLink(destination: ChannelEditor(n: n+1)){
							HStack{
								Text("Channel " + String(n+1) + "")
								Spacer()
								Image(systemName: "chevron.right")
							}
								.padding(8)
								.foregroundColor(Color("blackwhite"))
								.background(
									RoundedRectangle(cornerRadius:10).fill(Color("start")))
						}
						.padding(.horizontal,20)
					}
				}
				
			.navigationTitle("Customize settings")
			
			}}
		.onAppear(){
			update = defaults.double(forKey: "update")
			
			
		}
	}
	
}

struct SettingsEditor_Previews: PreviewProvider {
	static var previews: some View {
		SettingsEditor()
	}
}
