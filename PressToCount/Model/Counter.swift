//
//  Counter.swift
//  Sadhana
//
//  Created by Roman Slysh on 5/19/16.
//  Copyright © 2016 Roman Slysh. All rights reserved.
//

import UIKit

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
        maxClickCount = decoder.decodeIntegerForKey("maxClickCount")
        inputType = InputTypeEnum(rawValue: decoder.decodeIntegerForKey("inputType")) ?? .both
        currentClickCount = decoder.decodeIntegerForKey("currentClickCount")
        currentRowsCount = decoder.decodeIntegerForKey("currentRowsCount")
        
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeInteger(maxClickCount, forKey: "maxClickCount")
        coder.encodeInteger(inputType.rawValue, forKey: "inputType")
        coder.encodeInteger(currentClickCount, forKey: "currentClickCount")
        coder.encodeInteger(currentRowsCount, forKey: "currentRowsCount")
        
    }
    
    func save(curClickCount: Int? = nil, curRowsCount: Int? = nil, maximumClickCount: Int? = nil, inputTypeEnum: InputTypeEnum? = nil) {
        currentClickCount = curClickCount ?? currentClickCount
        currentRowsCount = curRowsCount ?? currentRowsCount
        maxClickCount = maximumClickCount ?? maxClickCount
        inputType = inputTypeEnum ?? inputType
        let data = NSKeyedArchiver.archivedDataWithRootObject(self)
        NSUserDefaults.standardUserDefaults().setObject(data, forKey: CounterKey)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    //MARK: class methods
    
    class func getSavedCounter() -> Counter {
        if let data = NSUserDefaults.standardUserDefaults().objectForKey(CounterKey) {
            return NSKeyedUnarchiver.unarchiveObjectWithData(data as! NSData) as! Counter
        } else {
            return Counter()
        }
    }
}