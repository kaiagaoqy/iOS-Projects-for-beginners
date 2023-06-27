//
//  Question.swift
//  Quizzler-iOS13
//
//  Created by Kaia Gao on 10/15/22.
//  Copyright © 2022 The App Brewery. All rights reserved.
//


/**
 View structure as a mini class with no paramaters, which is easier to understand than arrays
 
 Structrue consists of properties and behavior functions
 ----------------------
 Create Structure: struct Quiz { let variable: type }
 Create the initialiser (optional ): init(paramaters){  self.A = A  }
 Initialize structure: var quiz = Quiz()
 */


import Foundation
struct Question{
    let question : String
    let answer : String
    init(q:String, a:String){
        question = q
        answer = a
    }
}

