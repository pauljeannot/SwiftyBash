//
//  BashException.swift
//  SwiftyBash
//
//  Created by Paul Jeannot on 12/11/2017.
//  Copyright © 2017 Paul Jeannot. All rights reserved.
//

import Foundation

// MARK: - BashException structure

/// When an error occurs during the bash script execution, a BashException is thrown, with stderr and stdout values
struct BashException: Error {
    
    /// Stderr value
    let stderr:String
    /// Stdout value
    let stdout:String
}

/// To understand the difference, you can try
/// Example : `grep hosts /private/etc/*`
/// Resources : https://www.jstorimer.com/blogs/workingwithcode/7766119-when-to-use-stderr-instead-of-stdout