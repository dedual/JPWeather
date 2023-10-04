//
//  UserPreferences.swift
//  JPWeather
//
//  Created by Nicolas Dedual on 10/2/23.
//

import Foundation

public enum UserPreferences {
    
    enum Keys {
        static let preferredUnits = "PreferredUnits"
        static let lastLocationRetrieved = "LastLocationRetrieved"
        static let preferredLanguage = "PreferredLanguage"
    }
    
    // MARK: - Variables -
    private static let userDefaults = UserDefaults.standard // not really needed
    
    private static let languagePListDict:[String:String] = {
        guard let dictPath = Bundle.main.path(forResource: "SupportedLocales", ofType: "plist") else
        {
            fatalError("Supported locale plist file not found")
        }
        
        guard let nsDict = NSDictionary(contentsOfFile:dictPath) else
        {
            fatalError("Unable to load supported locale plist file")
        }
        
        guard let dict = nsDict as? [String:String] else
        {
            fatalError("Supported locale plist file is unusable")
        }
        return dict
    }()
    // Note: with more time, we should test RTL UI support
    
    // MARK: - Internal functions
    static private func ensureValidLocale(value:String) -> String
    {
        // check that the locale provided is supported by OpenWeather
        
        if !UserPreferences.languagePListDict.keys.contains(value)
        {
            return "en" // default to English.
        }
        // I mean, it's very naive. There's several subdivisions of languages that
        // iOS supports that would default to english with this logic.
        // but, it's a start.
        
        return value // safe to use the value provided then
    }
    
    static private func ensureValidMeasurementUnit(unit:String) -> String
    {
        if unit == "standard" || unit == "metric" || unit == "imperial"
        {
            return unit
        }
        
        // check the locale, make assumptions.
        // US-Based locales get Imperial
        // Everyone else gets metric, unless they ask for Kelvin (which is handled in first if test).
        
        if let deviceLanguage = Locale.current.language.languageCode?.identifier
        {
            if deviceLanguage == "en_US_POSIX" ||
                deviceLanguage == "en_US" ||
                deviceLanguage == "haw_US" ||
                deviceLanguage == "es_US" ||
                deviceLanguage == "en"
            {
                return "imperial"
            }
        }
        
        return "metric"
        
    }
    
    // MARK: - Public Getters and Setters
    static func setPreferredMeasurementUnit(value:String)
    {
        // clean value
        
        let cleanMeasurementValue = ensureValidMeasurementUnit(unit: value)
        
        userDefaults.setValue(cleanMeasurementValue, forKey: Keys.preferredUnits)
    }
    
    static var getPreferredMeasurementUnit: String
    {
        if let unit = userDefaults.value(forKey: Keys.preferredUnits) as? String
        {
            return ensureValidMeasurementUnit(unit: unit) // trust, but verify
        }
        
        return ensureValidMeasurementUnit(unit: "")
    }
    
    static var getPreferredLanguage:String
    {
        if let locale = userDefaults.value(forKey: Keys.preferredLanguage) as? String
        {
            return ensureValidLocale(value: locale) // again, trust but verify
        }
        
        if let deviceLanguage = Locale.current.language.languageCode?.identifier
        {
            return ensureValidLocale(value: deviceLanguage)
        }
        
        return "en" // when in doubt, default to English
    }
    
    static func setPreferredLanguage(value:String)
    {
        let cleanLanguageValue = ensureValidLocale(value: value)
        userDefaults.setValue(cleanLanguageValue, forKey: Keys.preferredLanguage)
    }
}
