//
//  BuildCaseView.swift
//  MPViewerApp
//
//  Created by Egor Geronin on 03.12.2025.
//

import SwiftUI

struct TestCaseView: View {
    let testCase: TestCase

    @State private var isExpanded: Bool = false

    var body: some View {
        VStack {
            HStack {
                Image(systemName: testCase.statusCode.symbolName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 24)
                    .foregroundStyle(testCase.statusCode.color)
                
                Text(testCase.name)
                
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
                ForEach(testCase.tests, id: \.name) { test in
                    TestView(test: test)
                }
            }
        }
        .padding(.horizontal)
        .padding(.leading)
    }
}

extension TestStatus {
    var symbolName: String {
        switch self {
        case .success: return "checkmark.circle.fill"
        case .failure: return "xmark.circle.fill"
        case .skipped: return "minus.circle"
        case .unknown: return "questionmark.circle"
        }
    }

    var color: Color {
        switch self {
        case .success: return .green
        case .failure: return .red
        case .skipped: return .gray
        case .unknown: return .gray.opacity(0.6)
        }
    }
}
