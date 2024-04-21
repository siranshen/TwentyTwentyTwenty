//
//  ContentView.swift
//  TwentyTwentyTwenty
//
//  Created by Siran on 4/21/24.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var timerManager = TimerManager()
    @State private var workTimeInput: String = ""
    @State private var restTimeInput: String = ""
    
    var body: some View {
        VStack {
            Text(timerManager.timerMode == .work ? "Focus Time" : "Rest Time")
                .font(.largeTitle)
            
            Text(formatTime(time: timerManager.timeRemaining))
                .font(.system(size: 48))
                .padding()
            
            HStack {
                Button(action: {
                    if self.timerManager.timerIsRunning {
                        self.timerManager.pause()
                    } else {
                        self.timerManager.start()
                    }
                }) {
                    #if os(iOS)
                    Image(systemName: timerManager.timerIsRunning ? "pause.circle" : "play.circle")
                        .font(.system(size: 36))
                    #else
                    Image(systemName: timerManager.timerIsRunning ? "pause" : "play")
                        .font(.system(size: 24))
                        .frame(width: 28, height: 28)
                        .padding(4)
                    #endif
                }
                .padding(.trailing)
                
                Button(action: {
                    self.timerManager.reset()
                }) {
                    #if os(iOS)
                    Image(systemName: "stop.circle")
                        .font(.system(size: 36))
                    #else
                    Image(systemName: "stop")
                        .font(.system(size: 24))
                        .frame(width: 28, height: 28)
                        .padding(4)
                    #endif
                }
            }
            .padding(.bottom, 40)
            
            HStack {
                Text("Work Interval")
                    .frame(width: 100, alignment: .trailing)
                TextField("in minutes", text: $workTimeInput)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                Button(action: {
                    if let minutes = Int(workTimeInput) {
                        timerManager.setWorkInterval(minutes: minutes)
                    }
                    workTimeInput = ""
                }) {
                    #if os(iOS)
                    Image(systemName: "arrow.right.square")
                        .font(.system(size: 24))
                    #else
                    Image(systemName: "arrowshape.forward")
                        .padding(.vertical, 2)
                    #endif
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 10)

            HStack {
                Text("Rest Interval")
                    .frame(width: 100, alignment: .trailing)
                TextField("in seconds", text: $restTimeInput)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                Button(action: {
                    if let seconds = Int(restTimeInput) {
                        timerManager.setRestInterval(seconds: seconds)
                    }
                    restTimeInput = ""
                }) {
                    #if os(iOS)
                    Image(systemName: "arrow.right.square")
                        .font(.system(size: 24))
                    #else
                    Image(systemName: "arrowshape.forward")
                        .padding(.vertical, 2)
                    #endif
                }
            }
            .padding(.horizontal)
        }
        .padding()
        .frame(width: 400, height: 400)
    }
    
    func formatTime(time: Int) -> String {
        let minutes = time / 60
        let seconds = time % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

#Preview {
    ContentView()
}
