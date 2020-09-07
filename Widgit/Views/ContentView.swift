//
//  ContentView.swift
//  Widgit
//
//  Created by Jacob Tepperman on 2020-09-06.
//

import SwiftUI

struct ContentView: View {
	var defaults = UserDefaults.init(suiteName: "group.com.jtepp.Widgit")
	var widgets = [WidgetObject.placeholder, WidgetObject.placeholder, WidgetObject.placeholder]
	var body: some View {
		
		NavigationView {
			ScrollView {
				ForEach(widgets) { size in
					WidgetObjectLink(object: size)
				}
			}
			.background(
				LinearGradient(gradient: Gradient(colors: [Color("start"), Color("end")]), startPoint: .topLeading, endPoint: .bottomTrailing)
					.edgesIgnoringSafeArea(.all)
			)
			.navigationTitle("Home")
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
//			.preferredColorScheme(.dark)
	}
}
