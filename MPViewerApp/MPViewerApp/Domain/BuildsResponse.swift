//
//  BuildsResponse.swift
//  MPViewerApp
//
//  Created by Egor Geronin on 02.12.2025.
//

import Foundation
import MPDTO

struct BuildsResponse {
    let builds: [BuildInfo]
    
    init(from dto: GetBuildsResponseDTO) {
        self.builds = dto.builds.map { BuildInfo(from: $0) }
    }
}

