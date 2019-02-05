//
//  MD5Extension.swift
//  AnagramCracker
//
//  Created by Morten on 05/02/2019.
//  Copyright © 2019 Morten Albertsen. All rights reserved.
//

import Foundation
import AppKit

extension String {
    
    func runAsCommand() -> String {
        let pipe = Pipe()
        let task = Process()
        task.launchPath = "/bin/sh"
        task.arguments = ["-c", String(format:"%@", self)]
        task.standardOutput = pipe
        let file = pipe.fileHandleForReading
        task.launch()
        if let result = NSString(data: file.readDataToEndOfFile(), encoding: String.Encoding.utf8.rawValue) {
            return result as String
        }
        else {
            return "--- Error running command - Unable to initialize string from file data ---"
        }
    }
}
