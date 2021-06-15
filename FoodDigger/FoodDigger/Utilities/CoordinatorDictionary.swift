//
//  CoordinatorDictionary.swift
//  FoodDigger
//
//  Created by JihyeKim on 2021/06/15.
//

import Foundation

struct CoordinatorDictionary<Type> {

    private var coordinators = [ObjectIdentifier: Type]()

    subscript(key: Type.Type) -> Type? {
        get {
            return coordinators[ObjectIdentifier(key)]
        }
        set(newValue) {
            return coordinators[ObjectIdentifier(key)] = newValue
        }
    }
}
