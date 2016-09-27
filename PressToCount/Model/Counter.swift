//
//  Counter.swift
//  PressToCount
//
//  Created by Roman Slysh on 5/19/16.
//  Copyright © 2016 Roman Slysh. All rights reserved.
//

import UIKit

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
    
    func localizedWithComment(_ comment:String) -> String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: comment)
    }
}

enum InputTypeEnum: Int {
    case volume = 0
    case tap
    case both
}

let DefaultClickCount = 108
let CounterKey = "CounterKey"

class Counter: NSObject, NSCoding {
    var maxClickCount : Int
    var inputType : InputTypeEnum
    var currentClickCount : Int
    var currentRowsCount : Int
    
    init(uClickCount: Int?, uInputType: InputTypeEnum?, curClickCount: Int?, curRowsCount: Int?) {
        maxClickCount = uClickCount ?? DefaultClickCount
        inputType = uInputType ?? InputTypeEnum.both
        if let clickCount = curClickCount {
            currentClickCount = clickCount
        } else {
            currentClickCount = 0
        }
        currentRowsCount = curRowsCount ?? 0
    }
    
    override init() {
        maxClickCount = DefaultClickCount
        inputType = InputTypeEnum.both
        currentClickCount = 0
        currentRowsCount = 0
    }
    
    // MARK: NSCoding
    
    required convenience init(coder decoder: NSCoder) {
        self.init()
        maxClickCount = decoder.decodeInteger(forKey: "maxClickCount")
        inputType = InputTypeEnum(rawValue: decoder.decodeInteger(forKey: "inputType")) ?? .both
        currentClickCount = decoder.decodeInteger(forKey: "currentClickCount")
        currentRowsCount = decoder.decodeInteger(forKey: "currentRowsCount")
        
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(maxClickCount, forKey: "maxClickCount")
        coder.encode(inputType.rawValue, forKey: "inputType")
        coder.encode(currentClickCount, forKey: "currentClickCount")
        coder.encode(currentRowsCount, forKey: "currentRowsCount")
        
    }
    
    func save(_ curClickCount: Int? = nil, curRowsCount: Int? = nil, maximumClickCount: Int? = nil, inputTypeEnum: InputTypeEnum? = nil) {
        currentClickCount = curClickCount ?? currentClickCount
        currentRowsCount = curRowsCount ?? currentRowsCount
        maxClickCount = maximumClickCount ?? maxClickCount
        inputType = inputTypeEnum ?? inputType
        let data = NSKeyedArchiver.archivedData(withRootObject: self)
        UserDefaults.standard.set(data, forKey: CounterKey)
        UserDefaults.standard.synchronize()
    }
    
    //MARK: class methods
    
    class func getSavedCounter() -> Counter {
        if let data = UserDefaults.standard.object(forKey: CounterKey) {
            return NSKeyedUnarchiver.unarchiveObject(with: data as! Data) as! Counter
        } else {
            return Counter()
        }
    }
}
