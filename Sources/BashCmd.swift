//
//  BashCmd.swift
//  SwiftyBash
//
//  Created by Paul Jeannot on 12/11/2017.
//  Copyright © 2017 Paul Jeannot. All rights reserved.
//

import Foundation

// MARK: - BashCmd struct

/// BashCmd represents a bash command you want to run, and allows you to execute it easily
public struct BashCmd {

    /// Bash command to run
    private var command = ""

    /**
     Initialize a BashCmd object.

     - parameters:
        - cmd: The **command** you want to execute
        - args: The **arguments** to pass to the command
        - from: The **entry point** you want the command to be *executed from*
    */
    public init(_ cmd:String, args:String..., from:String = ".") {
        self.command = (from != ".") ? "cd \(from) && " : ""
        self.command += cmd
        self.command += " " + args.joined(separator: " ")
    }

    /**
     Run the current bash command

     - parameters:
        - outputType: Describes the type of output desired (string, write to file ...)

     - returns:
        Output of the bash command *(corresponding to stdout)*
    */
    @discardableResult
    public func run(outputType:BashOutputType = .string(.raw)) throws -> String? {

        // Initialize process, stdout and stderr
        let process = Process()
        let stdout = Pipe()
        let stderr = Pipe()

        // Setup process
        process.launchPath = "/bin/bash"
        process.standardInput = nil
        process.standardOutput = stdout
        process.standardError = stderr

        // If the output type is set on `.file`, redirect stdout to `filename`.
        var finalCommand = command
        if case .file(let filename) = outputType {
            finalCommand += " > \(filename)"
        }

        // Run process
        process.arguments = ["-c", finalCommand]
        process.launch()
        process.waitUntilExit()

        // Read stdout stream and create string from it
        let stdoutData = stdout.fileHandleForReading.readDataToEndOfFile()
        let stdoutString = String(data:stdoutData, encoding:String.Encoding.utf8)

        // Read stderr steam an create string from it
        let stderrData = stderr.fileHandleForReading.readDataToEndOfFile()
        let stderrString = String(data: stderrData, encoding: String.Encoding.utf8)

        // If stderr isn't empty, throw a BashException with stderr and stdout
        if let stderrString = stderrString, stderrString != "" {
            throw BashException(stderr:stderrString, stdout:stdoutString ?? "")
        }

        // If we are here, it means that everything went fine
        // Prepare the stdout string according to the outputType given
        switch outputType {
        case .string(let type):
            switch type {
            case .raw:
                return stdoutString
            case .whiteSpacesTrimmed:
                return stdoutString?.trimmingCharactersEachNewLine(in: .whitespaces)
            }
        default:
            return nil
        }
    }
}

// MARK: - BashCmd Piping feature

/// Custom operator to pipe BashCmd
infix operator |
public extension BashCmd {

    /**
     Pipe the current stdout to the given BashCmd stdin

     - parameters:
     - pipedCmd: Command to pipe stdout into

     - returns:
     Newly BashCmd created with commands piped
     */
    public func pipe(_ pipedCmd:BashCmd) -> BashCmd {
        return BashCmd(command + " | " + pipedCmd.command)
    }

    /**
     Custom operator to pipe 2 bash commands

     - parameters
        - lhs: Pipe input stream
        - rhs: Pipe output stream
    */
    public static func | (lhs: BashCmd, rhs: BashCmd) -> BashCmd {
        return lhs.pipe(rhs)
    }
}
