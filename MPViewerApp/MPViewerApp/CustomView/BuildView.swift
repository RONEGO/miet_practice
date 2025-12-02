//
//  BuildView.swift
//  MPViewerApp
//
//  Created by Egor Geronin on 02.12.2025.
//

import SwiftUI

struct BuildView: View {
    let model: BuildInfo

    @State private var isExpanded: Bool = false

    var body: some View {
        VStack {
            HStack(spacing: 8) {
                Image(systemName: model.status.symbolName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 24)
                    .foregroundStyle(model.status.color)

                VStack(alignment: .leading) {
                    Text("Сборка:")
                    Text("\(model.id)")
                        .font(.title3)
                }

                Spacer()

                Button {
                    withAnimation {
                        isExpanded.toggle()
                    }
                } label: {
                    Image(
                        systemName: isExpanded ? "arrowtriangle.down.fill" : "arrowtriangle.right.fill"
                    )
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 16, height: 16)
                    .foregroundStyle(Color.black)
                }
            }

            if isExpanded {
                ForEach(model.testSuites, id: \.name) { testSuite in
                    TestSuiteView(testSuite: testSuite)

                    Rectangle()
                        .frame(maxWidth: .infinity, maxHeight: 0.75)
                        .foregroundStyle(Color.gray)
                }
            }
        }
        .padding()
    }
}

extension BuildInfoStatus {
    var symbolName: String {
        switch self {
        case .running:  return "arrow.clockwise"
        case .success:  return "checkmark.circle.fill"
        case .failure:  return "xmark.circle.fill"
        case .unknown:  return "questionmark.circle"
        }
    }

    var color: Color {
        switch self {
        case .running: return .blue
        case .success: return .green
        case .failure: return .red
        case .unknown: return .gray
        }
    }
}
