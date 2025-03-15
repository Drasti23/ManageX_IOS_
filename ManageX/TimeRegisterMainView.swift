//
//  TimeRegisterMainView.swift
//  ManageX
//
//  Created by Drasti Parikh on 2025-02-28.
//

import SwiftUI

struct TimeRegisterMainView: View {
    @ObservedObject private var firestoreManager = FirestoreManager()
    var employee: Employee // ✅ Get employee details
    @State private var clockInTime: Date? = nil
    @State private var clockOutTime: Date? = nil
    @State private var duration: String = "--:--:--"

    var body: some View {
        VStack {
            Text("Time Register")
                .font(.largeTitle)
                .padding(.bottom, 5)

            Text("Welcome, \(employee.name)!")
                .font(.headline)
                .foregroundColor(.gray)
                .padding(.bottom, 20)

            if let clockIn = clockInTime {
                Text("Clocked In At: \(formatDate(clockIn))")
                    .font(.headline)
                    .padding(.bottom, 5)
            }

            if let clockOut = clockOutTime {
                Text("Clocked Out At: \(formatDate(clockOut))")
                    .font(.headline)
                    .padding(.bottom, 5)
            }

            Text("Duration: \(duration)")
                .font(.title3)
                .foregroundColor(.green)
                .padding(.bottom, 20)

            HStack(spacing: 20) {
                Button(action: {
                    clockIn()
                }) {
                    Text("Clock In")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(clockInTime == nil || (clockInTime != nil && clockOutTime != nil) ? Color.green : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(clockInTime != nil && clockOutTime == nil) // 🔹 Allow Clock-In only if last session is completed

                Button(action: {
                    clockOut()
                }) {
                    Text("Clock Out")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(clockInTime != nil && clockOutTime == nil ? Color.red : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(clockInTime == nil || clockOutTime != nil) // 🔹 Only enable Clock-Out if Clock-In is present
            }
            .padding(.horizontal)
        }
        .padding()
        .onAppear {
            firestoreManager.fetchLastClockStatus(employeeId: employee.id) { clockIn, clockOut in
                DispatchQueue.main.async {
                    self.clockInTime = clockIn
                    self.clockOutTime = clockOut

                    if clockIn != nil && clockOut == nil {
                        print("✅ Employee is currently clocked in at \(formatDate(clockIn!))")
                    } else if clockOut != nil {
                        print("✅ Employee completed previous session and clocked out at \(formatDate(clockOut!))")
                    } else {
                        print("❌ No previous clock-in found. Employee needs to clock in.")
                    }
                }
            }
        }
    }

    // ✅ Clock In - Save to Firestore
    func clockIn() {
        clockInTime = Date()
        clockOutTime = nil // Reset clock-out
        duration = "--:--:--"
        firestoreManager.logClockIn(employeeId: employee.id, time: clockInTime!)
    }

    // ✅ Clock Out - Save to Firestore
    func clockOut() {
        guard let clockIn = clockInTime else { return }
        clockOutTime = Date()
        calculateDuration(from: clockIn, to: clockOutTime!)
        firestoreManager.logClockOut(employeeId: employee.id, time: clockOutTime!)
    }

    // Calculate Duration
    func calculateDuration(from start: Date, to end: Date) {
        let timeInterval = end.timeIntervalSince(start)
        let hours = Int(timeInterval) / 3600
        let minutes = (Int(timeInterval) % 3600) / 60
        let seconds = Int(timeInterval) % 60

        duration = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }

    // Format Date
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm:ss a"
        return formatter.string(from: date)
    }
}
