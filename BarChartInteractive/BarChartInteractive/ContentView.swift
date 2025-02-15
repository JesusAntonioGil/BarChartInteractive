//
//  ContentView.swift
//  BarChartInteractive
//
//  Created by Jesus Antonio Gil on 15/2/25.
//

import SwiftUI
import Charts


struct ContentView: View {
    @State private var rawSelectedDate: Date?
    
    var selectedViewMonth: ViewMonth? {
        guard let rawSelectedDate else { return nil }
        return ViewMonth.mockData.first {
            Calendar.current.isDate(rawSelectedDate, equalTo: $0.date, toGranularity: .month)
        }
    }
    
    
    var body: some View {
        ZStack{
            VStack(alignment: .leading, spacing: 4) {
                Text("YouTube Views")
                    .bold()
                    .padding(.top)

                Text("Total: \(ViewMonth.mockData.reduce(0, { $0 + $1.viewCount }))")
                    .fontWeight(.semibold)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 12)

                Chart {
                    if let selectedViewMonth {
                        RuleMark(x: .value("Selected Month", selectedViewMonth.date, unit: .month))
                            .foregroundStyle(.secondary.opacity(0.3))
                            .annotation(position: .top, overflowResolution: .init(x: .fit(to: .chart), y: .disabled)) {
                                VStack {
                                    Text(selectedViewMonth.date, format: .dateTime.month(.wide))
                                        .bold()
                                    
                                    Text("\(selectedViewMonth.viewCount)")
                                        .font(.title3.bold())
                                }
                                .foregroundStyle(.white)
                                .padding(12)
                                .frame(width: 120)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(.teal.gradient)
                                )
                            }
                    }
                    
                    ForEach(ViewMonth.mockData) { viewMonth in
                        BarMark(
                            x: .value("Month", viewMonth.date, unit: .month),
                            y: .value("Views", viewMonth.viewCount)
                        )
                        .foregroundStyle(Color.teal.gradient)
                        .opacity(rawSelectedDate == nil || viewMonth.date == selectedViewMonth?.date ? 1.0 : 0.3)
                    }
                }
                .frame(height: 180)
                .chartXSelection(value: $rawSelectedDate.animation(.easeInOut))
                .chartXAxis {
                    AxisMarks {
                        AxisValueLabel()
                        //AxisGridLine()
                    }
                }
                .chartYAxis {
                    AxisMarks {
                        AxisValueLabel()
                        AxisGridLine()
                    }
                }
                .padding(.bottom)

                Spacer()
            }
        }
        .padding(30)
    }
}


#Preview {
    ContentView()
}
