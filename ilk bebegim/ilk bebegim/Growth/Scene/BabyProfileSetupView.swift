//
//  BabyProfileSetupView.swift
//  ilk bebegim
//
//  Created by Zeynep Toy on 20.04.2025.
//

import SwiftUI

struct BabyProfileSetupView: View {
    @ObservedObject var viewModel: GrowthViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var babyName: String = ""
    @State private var selectedGender: BabyGender = .female
    @State private var birthDate: Date = Date()
    @State private var showingDatePicker = false
    
    var isEditMode: Bool {
        viewModel.babyProfile != nil
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
                            Image(systemName: "figure.child.circle.fill")
                                .font(.system(size: 80))
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
                                .shadow(color: Color(red: 0.89, green: 0.47, blue: 0.76).opacity(0.3), radius: 8, y: 4)
                            
                            VStack(spacing: 8) {
                                Text(isEditMode ? "Profil Düzenle" : "Bebeğin Profilini Oluştur")
                                    .font(.system(size: 28, weight: .bold, design: .rounded))
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
                                    .multilineTextAlignment(.center)
                                
                                if !isEditMode {
                                    Text("Büyüme takibi için gerekli bilgileri girin")
                                        .font(.system(size: 16, weight: .medium, design: .rounded))
                                        .foregroundColor(Color(.darkGray))
                                        .multilineTextAlignment(.center)
                                }
                            }
                        }
                        
                        // Form
                        VStack(spacing: 20) {
                            // Baby name
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Bebeğin Adı")
                                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                                    .foregroundColor(.black)
                                
                                TextField("Örn: Ayşe", text: $babyName)
                                    .font(.system(size: 16, weight: .medium, design: .rounded))
                                    .foregroundColor(.black)
                                    .padding(16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.white)
                                            .shadow(color: .black.opacity(0.05), radius: 4, y: 2)
                                    )
                            }
                            
                            // Gender selection
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Cinsiyet")
                                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                                    .foregroundColor(.black)
                                
                                HStack(spacing: 12) {
                                    ForEach(BabyGender.allCases, id: \.self) { gender in
                                        GenderSelectionCard(
                                            gender: gender,
                                            isSelected: selectedGender == gender,
                                            action: {
                                                selectedGender = gender
                                            }
                                        )
                                    }
                                }
                            }
                            
                            // Birth date
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Doğum Tarihi")
                                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                                    .foregroundColor(.black)
                                
                                Button(action: {
                                    showingDatePicker = true
                                }) {
                                    HStack {
                                        Image(systemName: "calendar")
                                            .foregroundColor(Color(red: 0.89, green: 0.47, blue: 0.76))
                                        
                                        Text(formatDate(birthDate))
                                            .font(.system(size: 16, weight: .medium, design: .rounded))
                                            .foregroundColor(.black)
                                        
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
                            
                            // Age preview
                            if !babyName.isEmpty {
                                VStack(spacing: 8) {
                                    Text("Yaş Hesaplaması")
                                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                                        .foregroundColor(.black)
                                    
                                    Text("\(babyName) şu an \(calculateAge()) günlük")
                                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                                        .foregroundColor(Color(red: 0.89, green: 0.47, blue: 0.76))
                                }
                                .padding(16)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color(red: 0.89, green: 0.47, blue: 0.76).opacity(0.1))
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        // Save button
                        Button(action: saveProfile) {
                            Text(isEditMode ? "Güncelle" : "Profil Oluştur")
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(
                                            LinearGradient(
                                                colors: [
                                                    Color(red: 0.89, green: 0.47, blue: 0.76),
                                                    Color(red: 0.67, green: 0.32, blue: 0.89)
                                                ],
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            )
                                        )
                                        .shadow(color: Color(red: 0.89, green: 0.47, blue: 0.76).opacity(0.3), radius: 8, y: 4)
                                )
                        }
                        .buttonStyle(PlainButtonStyle())
                        .disabled(babyName.isEmpty || babyName.count < 2)
                        .opacity(babyName.isEmpty || babyName.count < 2 ? 0.6 : 1.0)
                        .padding(.horizontal, 20)
                        
                        Spacer(minLength: 50)
                    }
                    .padding(.vertical, 20)
                }
            }
        }
        .navigationTitle(isEditMode ? "Profil Düzenle" : "Profil Oluştur")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if isEditMode {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("İptal") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
        .sheet(isPresented: $showingDatePicker) {
            DatePickerSheet(selectedDate: $birthDate)
        }
        .onAppear {
            loadExistingProfile()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                AdManager.shared.trackQuestionDetailView()
            }
        }
    }
    
    private func loadExistingProfile() {
        if let profile = viewModel.babyProfile {
            babyName = profile.name
            selectedGender = profile.gender
            birthDate = profile.birthDate
        }
    }
    
    private func saveProfile() {
        let profile = BabyProfile(
            name: babyName.trimmingCharacters(in: .whitespaces), birthDate: birthDate,
            gender: selectedGender
        )
        
        viewModel.saveBabyProfile(profile)
        
        if isEditMode {
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.locale = Locale(identifier: "tr_TR")
        return formatter.string(from: date)
    }
    
    private func calculateAge() -> String {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: birthDate, to: Date())
        let days = components.day ?? 0
        
        if days <= 0 {
            return "0"
        } else if days < 30 {
            return "\(days)"
        } else {
            let months = days / 30
            let remainingDays = days % 30
            if remainingDays == 0 {
                return "\(months) ay (\(days) gün)"
            } else {
                return "\(months) ay \(remainingDays) gün (\(days) gün)"
            }
        }
    }
}
