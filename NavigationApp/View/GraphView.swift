//
//  GraphView.swift
//  NavigationApp
//
//  Created by Buse Karabıyık on 11.07.2024.
//

import SwiftUI
import Charts

struct GraphView: View {
    @State private var routes: [[String: Any]] = []
    @Environment(\.dismiss) private var dismiss
    private func getData() {
        DataStorageManager.shared.getRoutes { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let fetchedRoutes):
                    routes = fetchedRoutes
                case .failure(_):
                    print("Couldn't fetch route data")
                }
            }
        }
    }
   
    var body: some View {
        NavigationView {
            VStack {
                GroupBox(
                    label:
                        Text("Route Usage Frequency")
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                        .padding(.leading, UIScreen.main.bounds.size.width / 7.8)
                ) {
                    if !routes.isEmpty {
                        Chart {
                            ForEach(routes.indices, id: \.self) { index in
                                let route = routes[index]
                                BarMark(
                                    x: .value("Route", route["route"] as! String),
                                    y: .value("Frequency", route["frequency"] as! Double)
                                )
                            }
                        }
                    } else {
                        Text("No data available")
                    }
                }
                .padding()
                
                GroupBox(
                    label:
                        Text("Average Speed")
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                        .padding(.leading, UIScreen.main.bounds.size.width / 5)
                ) {
                    if !routes.isEmpty {
                        Chart {
                            ForEach(0..<routes.count, id: \.self) { index in
                                let route = routes[index]
                                BarMark(
                                    x: .value("Route", route["route"] as! String),
                                    y: .value("Average Speed", route["average_speed"] as! Double)
                                )
                            }
                        }
                    } else {
                        Text("No data available")
                    }
                }
                .padding()
              
            }
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    Button(action: {
                        dismiss()
                    }, label: {
                        Image(systemName: "chevron.left")
                            .padding(.horizontal)
                        
                    })
                }
            }
            .onAppear {
                getData()
            }
        }
    }
}



#Preview {
    GraphView()
}
