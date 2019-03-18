//
//  AndroidPlatform.swift
//  localizable
//
//  Created by Craig Spitzkoff on 9/26/17.
//  Copyright © 2017 Raizlabs. All rights reserved.
//

import Cocoa


/// Protocol to implement for localization platforms. This protocol allows
/// classes to return all information required to produce a localized string
/// table for a specific platform
protocol LocalizationPlatform {
    
    /// Unique key used to represent the platform.
    var platformKey : String {get}
    
    /// prefix used to start a localized string table
    var startString : String {get}
    
    /// suffix used to end a localized string table
    var endString : String {get}
    
    /// format used when outputting a string and its key
    var keyValueFormat : String {get}
    
    /// format used when outputting a comment
    var commentFormat : String {get}
    
    // command line parameters
    /// short flag used on the command line to specify this platform
    var shortFlag : String {get}

    /// short flag used on the command line to specify this platform
    var longFlag : String {get}

    func string(for localizationValue: LocalizationValue?) -> String?
    
}

struct LocalizationValue {

    init?(value: String?) {
        guard let value = value else {
            return nil
        }
        self.value = value

        if let results = LocalizationValue.regExpResults(value: value)?.matches(in: value, range: NSRange(location: 0, length: value.count)), results.count > 0 {
            self.containsArguments = true
        } else {
            self.containsArguments = false
        }
    }

    let containsArguments: Bool
    let value: String

    func replacedArgumentsValue(with replacement: String) -> String {
        if let result = LocalizationValue.regExpResults(value: value)?.stringByReplacingMatches(in: value, range: NSRange(location: 0, length: value.count), withTemplate: replacement) {
            return result
        } else {
            return value
        }
    }

    private static func regExpResults(value: String) -> NSRegularExpression? {
        return try? NSRegularExpression(pattern: "[%][0-9]*[$][s]")
    }

}
