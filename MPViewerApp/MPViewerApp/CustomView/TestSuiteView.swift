//
//  TestSuiteView.swift
//  MPViewerApp
//
//  Created by Egor Geronin on 03.12.2025.
//

import SwiftUI

struct TestSuiteView: View {
    let testSuite: TestSuite

    @State private var isExpanded: Bool = false
    @State private var showLogs = false

    var body: some View {
        VStack {
            HStack {
                Image(systemName: testSuite.type.symbolName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 24)
                    .foregroundStyle(Color.black)

                Text(testSuite.name)

                if let testSuiteResultId = testSuite.testSuiteResultId {
                    Button("See logs") {
                        showLogs = true
                    }
                    .sheet(isPresented: $showLogs) {
                        LogView(testSuiteResultId: testSuiteResultId)
                    }
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
                ForEach(testSuite.cases, id: \.name) { testCase in
                    TestCaseView(testCase: testCase)
                }
            }
        }
        .padding(.horizontal)
        .padding(.leading)
    }
}

extension TestFramework {
    var symbolName: String {
        switch self {
        case .xctestUI:
            return "hand.tap"                // UI interaction
        case .xctestUnit:
            return "curlybraces"             // код / юнит тесты
        case .unknown:
            return "questionmark.circle"     // неизвестно
        }
    }
}
