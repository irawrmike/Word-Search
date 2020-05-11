//
//  Words.swift
//  Word Search
//
//  Created by Mike Stoltman on 2020-05-09.
//  Copyright © 2020 Mike Stoltman. All rights reserved.
//

import Foundation

struct Words {
    
    static var easy: [String] = [
        "Swift",
        "Kotlin",
        "ObjectiveC",
        "Variable",
        "Java",
        "Mobile"
    ]
    
    static var normal: [String] = {
        var list = Words.easy
        list.append(contentsOf: [
            "Program",
            "Android",
            "Apple",
            "Google",
        ])
        return list
    }()
    
    static var hard: [String] = {
        var list = Words.normal
        list.append(contentsOf: [
            "Phone",
            "App",
            "iOS",
            "Code",
            "Dev"
        ])
        return list
    }()
    
}
