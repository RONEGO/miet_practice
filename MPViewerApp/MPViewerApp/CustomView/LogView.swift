//
//  LogView.swift
//  MPViewerApp
//
//  Created by Egor Geronin on 03.12.2025.
//

import SwiftUI

struct LogView: View {
    let testSuiteResultId: UUID
    @State private var logText: String = ""
    @State private var isLoading = false
    @State private var error: Error?
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            Group {
                if isLoading {
                    ProgressView("Loading logs...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let error = error {
                    VStack {
                        Text("Error loading logs")
                            .font(.headline)
                        Text(error.localizedDescription)
                            .font(.caption)
                            .foregroundColor(.red)
                            .padding()
                        Button("Retry") {
                            loadLogs()
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView {
                        Text(logText)
                            .font(.system(.body, design: .monospaced))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                    }
                }
            }
            .navigationTitle("Test Suite Logs")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                loadLogs()
            }
        }
    }
    
    private func loadLogs() {
        isLoading = true
        error = nil
        
        Task {
            do {
                let logs = try await APIService.shared.fetchTestSuiteLog(testSuiteResultId: testSuiteResultId)
                await MainActor.run {
                    self.logText = logs
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.error = error
                    self.isLoading = false
                }
            }
        }
    }
}

