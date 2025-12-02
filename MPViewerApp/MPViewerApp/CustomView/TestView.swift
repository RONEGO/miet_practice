//
//  TestView.swift
//  MPViewerApp
//
//  Created by Egor Geronin on 03.12.2025.
//

import SwiftUI

struct TestView: View {
    let test: Test

    var body: some View {
        VStack {
            HStack {
                Image(systemName: test.statusCode.symbolName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 24)
                    .foregroundStyle(test.statusCode.color)

                Text(test.name)

                Spacer()

                if let duration = test.duration {
                    Text("\(duration, specifier: "%.2f")s")
                        .foregroundStyle(duration > 0.3 ? Color.red : Color.black)
                }
            }
        }
        .padding(.horizontal)
        .padding(.leading)
    }
}
