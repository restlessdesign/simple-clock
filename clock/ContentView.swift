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
var timeMode = TimeMode.TWELVE
var timePeriod = TimePeriodDisplay.HIDE

let formatDigit = { (digit: Int, leadingZero: Bool) -> String in
    var precedingChar = leadingZero && digit < 10 ? "0" : ""
    return "\(precedingChar)\(digit)"
}

let formatHour = { (hour: Int, timeMode:TimeMode, leadingZero:Bool) -> String in
    var hour = hour
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
        // TODO
        // Bind this to a settings switch
        var doShowSettings = true
        
        // TODO
        // Center the settings in the middle?
        ZStack {
            if doShowSettings {
                Settings()
            }
            Clock()
        }
    }
}

struct Settings: View {
    var body: some View {
        List {
            Picker(
                selection: /*@START_MENU_TOKEN@*/.constant(1)/*@END_MENU_TOKEN@*/,
                label: Label("Font", systemImage: "textformat")) {
                /*@START_MENU_TOKEN@*/Text("1").tag(1)/*@END_MENU_TOKEN@*/
                /*@START_MENU_TOKEN@*/Text("2").tag(2)/*@END_MENU_TOKEN@*/
            }
            
            Stepper(value: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant(4)/*@END_MENU_TOKEN@*/, in: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Range@*/1...10/*@END_MENU_TOKEN@*/) {
                Label("Weight", systemImage: "bold")
            }
       
            ColorPicker(selection: /*@START_MENU_TOKEN@*/.constant(.red)/*@END_MENU_TOKEN@*/) {
                Label("Color", systemImage: "paintpalette.fill")
            }
        }
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
                let date = Date()
                let calendar = Calendar.current
                let currentHour = calendar.component(.hour, from: date)
                let currentMinute = calendar.component(.minute, from: date)
                let leadingZeroForHours = LeadingZeroForHours.HIDE
                
                let formattedHour = formatHour(currentHour, timeMode, leadingZeroForHours == LeadingZeroForHours.SHOW)
                let formattedMinute = formatDigit(currentMinute, true)
                let formattedPeriod = formatPeriod(currentHour, timeMode, timePeriod)

                currentTime = "\(formattedHour):\(formattedMinute)\(formattedPeriod)"
            }
    }
}

#Preview {
    ContentView()
}
