//
//  AddGrowthRecordView.swift
//  ilk bebegim
//
//  Created by Zeynep Toy on 20.04.2025.
//

import SwiftUI

struct AddGrowthRecordView: View {
    let babyProfile: BabyProfile
    @ObservedObject var viewModel: GrowthViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var selectedDate = Date()
    @State private var weightText = ""
    @State private var heightText = ""
    @State private var headCircumferenceText = ""
    @State private var notes = ""
    @State private var showingDatePicker = false
    
    var canSave: Bool {
        !weightText.isEmpty || !heightText.isEmpty || !headCircumferenceText.isEmpty
    }
    
    var currentAge: Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: babyProfile.birthDate, to: selectedDate)
        return max(0, components.day ?? 0)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: [
                        Color(red: 0.98, green: 0.94, blue: 0.96),
                        Color(red: 0.95, green: 0.97, blue: 0.99)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Header
                        VStack(spacing: 16) {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 60))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [
                                            Color(red: 0.89, green: 0.47, blue: 0.76),
                                            Color(red: 0.67, green: 0.32, blue: 0.89)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                            
                            VStack(spacing: 8) {
                                Text("Yeni Ölçüm Ekle")
                                    .font(.system(size: 24, weight: .bold, design: .rounded))
                                    .foregroundStyle(
                                        LinearGradient(
                                            colors: [
                                                Color(red: 0.89, green: 0.47, blue: 0.76),
                                                Color(red: 0.67, green: 0.32, blue: 0.89)
                                            ],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                
                                Text("\(babyProfile.name) için ölçüm kaydı")
                                    .font(.system(size: 16, weight: .medium, design: .rounded))
                                    .foregroundColor(Color(.darkGray))
                            }
                        }
                        
                        // Form
                        VStack(spacing: 20) {
                            // Date selection
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Ölçüm Tarihi")
                                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                                    .foregroundColor(.black)
                                
                                Button(action: {
                                    showingDatePicker = true
                                }) {
                                    HStack {
                                        Image(systemName: "calendar")
                                            .foregroundColor(Color(red: 0.89, green: 0.47, blue: 0.76))
                                        
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(formatDate(selectedDate))
                                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                                .foregroundColor(.black)
                                            
                                            Text("Yaş: \(formatAge(currentAge))")
                                                .font(.system(size: 12, weight: .medium, design: .rounded))
                                                .foregroundColor(Color(.darkGray))
                                        }
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.right")
                                            .font(.system(size: 12))
                                            .foregroundColor(.gray)
                                    }
                                    .padding(16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.white)
                                            .shadow(color: .black.opacity(0.05), radius: 4, y: 2)
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            
                            // Measurements
                            VStack(spacing: 16) {
                                // Weight
                                MeasurementInputView(
                                    title: "Kilo",
                                    placeholder: "Örn: 4.2",
                                    unit: "kg",
                                    text: $weightText,
                                    icon: "scalemass.fill",
                                    color: "#FF6B6B"
                                )
                                
                                // Height
                                MeasurementInputView(
                                    title: "Boy",
                                    placeholder: "Örn: 58",
                                    unit: "cm",
                                    text: $heightText,
                                    icon: "ruler.fill",
                                    color: "#4A90E2"
                                )
                                
                                // Head circumference
                                MeasurementInputView(
                                    title: "Baş Çevresi",
                                    placeholder: "Örn: 37.5",
                                    unit: "cm",
                                    text: $headCircumferenceText,
                                    icon: "circle.dotted",
                                    color: "#87CEEB"
                                )
                            }
                            
                            // Notes
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Notlar (İsteğe Bağlı)")
                                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                                    .foregroundColor(.black)
                                
                                TextEditor(text: $notes)
                                    .font(.system(size: 16, weight: .medium, design: .rounded))
                                    .frame(minHeight: 80)
                                    .padding(12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.white)
                                            .shadow(color: .black.opacity(0.05), radius: 4, y: 2)
                                    )
                            }
                            
                            // Info card
                            if canSave {
                                VStack(spacing: 8) {
                                    HStack {
                                        Image(systemName: "info.circle.fill")
                                            .foregroundColor(.blue)
                                        Text("Ölçüm Özeti")
                                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                                            .foregroundColor(.black)
                                        Spacer()
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        if !weightText.isEmpty {
                                            Text("• Kilo: \(weightText) kg")
                                                .font(.system(size: 14, weight: .medium, design: .rounded))
                                                .foregroundColor(Color(.darkGray))
                                        }
                                        if !heightText.isEmpty {
                                            Text("• Boy: \(heightText) cm")
                                                .font(.system(size: 14, weight: .medium, design: .rounded))
                                                .foregroundColor(Color(.darkGray))
                                        }
                                        if !headCircumferenceText.isEmpty {
                                            Text("• Baş Çevresi: \(headCircumferenceText) cm")
                                                .font(.system(size: 14, weight: .medium, design: .rounded))
                                                .foregroundColor(Color(.darkGray))
                                        }
                                    }
                                }
                                .padding(16)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.blue.opacity(0.1))
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        // Save button
                        Button(action: saveRecord) {
                            Text("Kaydet")
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(
                                            canSave ?
                                            LinearGradient(
                                                colors: [
                                                    Color(red: 0.89, green: 0.47, blue: 0.76),
                                                    Color(red: 0.67, green: 0.32, blue: 0.89)
                                                ],
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            ) :
                                            LinearGradient(
                                                colors: [Color.gray, Color.gray],
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            )
                                        )
                                        .shadow(
                                            color: canSave ? Color(red: 0.89, green: 0.47, blue: 0.76).opacity(0.3) : Color.clear,
                                            radius: canSave ? 8 : 0,
                                            y: canSave ? 4 : 0
                                        )
                                )
                        }
                        .buttonStyle(PlainButtonStyle())
                        .disabled(!canSave)
                        .padding(.horizontal, 20)
                        
                        Spacer(minLength: 50)
                    }
                    .padding(.vertical, 20)
                }
            }
        }
        .navigationTitle("Ölçüm Ekle")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("İptal") {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
        .sheet(isPresented: $showingDatePicker) {
            DatePickerSheet(selectedDate: $selectedDate)
        }
    }
    
    private func saveRecord() {
        let weight = Double(weightText.replacingOccurrences(of: ",", with: "."))
        let height = Double(heightText.replacingOccurrences(of: ",", with: "."))
        let headCirc = Double(headCircumferenceText.replacingOccurrences(of: ",", with: "."))
        
        let record = GrowthRecord(
            babyId: babyProfile.id,
            date: selectedDate,
            ageInDays: currentAge,
            weight: weight,
            height: height,
            headCircumference: headCirc,
            notes: notes.isEmpty ? nil : notes,
            photoData: nil
        )
        
        viewModel.addGrowthRecord(record)
        presentationMode.wrappedValue.dismiss()
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.locale = Locale(identifier: "tr_TR")
        return formatter.string(from: date)
    }
    
    private func formatAge(_ days: Int) -> String {
        if days < 30 {
            return "\(days) gün"
        } else {
            let months = days / 30
            let remainingDays = days % 30
            if remainingDays == 0 {
                return "\(months) ay"
            } else {
                return "\(months) ay \(remainingDays) gün"
            }
        }
    }
}
