//
//  ContentView.swift
//  clock
//
//  Created by Kevin Sweeney on 3/15/24.
//

import SwiftUI

enum TimeMode {
    case TWELVE, TWENTY_FOUR
}

enum TimePeriodDisplay {
    case HIDE, SHOW
}

enum LeadingZeroForHours {
    case HIDE, SHOW
}

// TODO 
// Read from options
var timeMode:TimeMode = .TWELVE
var timePeriod:TimePeriodDisplay = .HIDE

let formatDigit = { (digit: Int, leadingZero: Bool) -> String in
    var precedingChar:String = leadingZero && digit < 10 ? "0" : ""
    return "\(precedingChar)\(digit)"
}

let formatHour = { (hour: Int, timeMode:TimeMode, leadingZero:Bool) -> String in
    var hour: Int = hour
    if timeMode == TimeMode.TWELVE && hour > 12 {
        hour -= 12
    }

    return formatDigit(hour, leadingZero)
}

let formatPeriod = { (hour: Int, timeMode:TimeMode, timePeriod:TimePeriodDisplay) -> String in
    if timeMode == TimeMode.TWENTY_FOUR || timePeriod == TimePeriodDisplay.HIDE {
        return ""
    }
    
    return hour < 12 ? "am" : "pm"
}

struct ContentView: View {
    var body: some View {
        Clock()
    }
}

struct Clock: View {
    @State var currentTime:String = ""
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        Text(currentTime)
            .font(.system(size: 144))
            .fontWeight(.ultraLight)
            .onReceive(timer) { time in
                let date:Date = Date()
                let calendar:Calendar = Calendar.current
                let currentHour:Int = calendar.component(.hour, from: date)
                let currentMinute:Int = calendar.component(.minute, from: date)
                let leadingZeroForHours:LeadingZeroForHours = .HIDE
                
                let formattedHour:String = formatHour(currentHour, timeMode, leadingZeroForHours == LeadingZeroForHours.SHOW)
                let formattedMinute:String = formatDigit(currentMinute, true)
                let formattedPeriod:String = formatPeriod(currentHour, timeMode, timePeriod)

                currentTime = "\(formattedHour):\(formattedMinute)\(formattedPeriod)"
            }
    }
}

#Preview {
    ContentView()
}
