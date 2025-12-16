//
//  UserDefaultsWrapper.swift
//  lessons
//
//  Created by Watson22_YJ on 12/16/25.
//

import Foundation

// MARK: - UserDefault Property Wrapper

@propertyWrapper
public struct UserDefaultsWrapper<T> {
    let key: String
    let defaultValue: T
    let storage: UserDefaults

    public init(
        key: String,
        defaultValue: T,
        storage: UserDefaults = .standard
    ) {
        self.key = key
        self.defaultValue = defaultValue
        self.storage = storage
    }

    public var wrappedValue: T {
        get {
            storage.object(forKey: key) as? T ?? defaultValue
        }
        set {
            storage.set(newValue, forKey: key)
        }
    }
}

