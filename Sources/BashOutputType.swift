//
//  BashOutputType.swift
//  SwiftyBash
//
//  Created by Paul Jeannot on 12/11/2017.
//  Copyright © 2017 Paul Jeannot. All rights reserved.
//

import Foundation

// MARK: - Enum BashOutputType

/// Describes the output of a BashCmd or BashPipe
public enum BashOutputType {

    /// Describes the format of string to return
    public enum StringFormat {

        /// Returns the output as it is
        case raw
        /// Returns the output without white spaces
        case whiteSpacesTrimmed
    }

    /// Returns a string in StringFormat
    /// Argument:
    ///     - format:StringFormat
    case string(StringFormat)

    /// Write the output in a file
    /// Argument:
    ///     - Filename:String
    case file(String)
}

public extension String {

    /// Returns a new string made by removing from both ends on each new line of the String characters
    /// contained in a given character set.
    public func trimmingCharactersEachNewLine(in set: CharacterSet) -> String {
        let lines = split(separator: "\n")
        // Need to transform each String.SubSequence aka Substring to String to avoid errors on Linux 16.04 with Swift 4.0
        let linesTrimmed = lines.map({ String($0) }).map({ $0.trimmingCharacters(in: set) })
        return linesTrimmed.joined(separator: "\n")
    }
}
