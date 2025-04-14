//
//  File.swift
//  
//
//  Created by Dmitriy Soloshenko on 23.03.2023.
//

import Foundation
import Vapor

extension RoutesBuilder {
    var root: RoutesBuilder {
        return self
            .grouped(Constants.restRootGroup)
            .grouped(Constants.restVersion)
    }
}
