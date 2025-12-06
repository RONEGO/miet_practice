//
//  ContentView.swift
//  MPViewerApp
//
//  Created by Egor Geronin on 02.12.2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()

    var body: some View {
        buildsContent
            .onAppear {
                Task { await viewModel.handle(input: .viewDidAppear) }
            }
            .toolbar {
                Button {
                    Task { await viewModel.handle(input: .didTapReload) }
                } label: {
                    Image(systemName: "arrow.clockwise.circle")
                }
            }
            .navigationTitle("Сборки")
    }

    var buildsContent: some View {
        ScrollView {
            ForEach(viewModel.state.builds, id: \.id) { build in
                VStack {
                    BuildView(model: build)
                    Rectangle()
                        .frame(maxWidth: .infinity, maxHeight: 1.0)
                        .foregroundStyle(Color.black)
                }
            }

            Color.clear
                .frame(height: 1)
                .onAppear {
                    print("Достигнуто дно!")
                }
        }
    }
}
