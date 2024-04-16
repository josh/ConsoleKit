//
//  LogRowIconView.swift
//  ConsoleKit
//
//  Created by Joshua Peek on 4/9/24.
//

import OSLog
import SwiftUI

struct LogRowIconView: View {
    let level: OSLogEntryLog.Level

    @ScaledMetric private var fontSize: CGFloat = 7
    @ScaledMetric private var width: CGFloat = 12
    @ScaledMetric private var cornerRadius: CGFloat = 2.0

    var body: some View {
        Image(systemName: iconName)
            .font(.system(size: fontSize))
            .frame(width: width, height: width, alignment: .center)
            .foregroundColor(.white)
            .background(iconColor)
            .clipShape(.rect(cornerRadius: cornerRadius))
    }

    private var iconName: String {
        switch level {
        case .debug: "stethoscope"
        case .info: "info"
        case .notice: "bell.fill"
        case .error: "exclamationmark.2"
        case .fault: "exclamationmark.3"
        default: "questionmark"
        }
    }

    private var iconColor: Color {
        switch level {
        case .debug: .gray
        case .info: .blue
        case .notice: .gray
        case .error: .yellow
        case .fault: .red
        default: .clear
        }
    }

    private var background: Color {
        switch level {
        case .error: .yellow.opacity(0.25)
        case .fault: .red.opacity(0.25)
        default: .clear
        }
    }
}

#Preview {
    List {
        HStack(alignment: .center) {
            LogRowIconView(level: .debug)
            LogRowIconView(level: .info)
            LogRowIconView(level: .notice)
            LogRowIconView(level: .error)
            LogRowIconView(level: .fault)
        }

        HStack(alignment: .center) {
            LogRowIconView(level: .debug)
            Text("Debug")
        }

        HStack(alignment: .center) {
            LogRowIconView(level: .info)
            Text("Info")
        }

        HStack(alignment: .center) {
            LogRowIconView(level: .notice)
            Text("Notice")
        }

        HStack(alignment: .center) {
            LogRowIconView(level: .error)
            Text("Error")
        }

        HStack(alignment: .center) {
            LogRowIconView(level: .fault)
            Text("Fault")
        }
    }
    .padding()
}
