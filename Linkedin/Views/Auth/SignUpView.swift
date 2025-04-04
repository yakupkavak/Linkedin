import SwiftUI

struct SignUpView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var authViewModel: AuthViewModel

    @State private var showAlert = false
    @State private var alertMsg = ""

    var body: some View {
        VStack(spacing: 20) {
            Text("Kayıt Ol").font(.largeTitle).bold()

            TextField("Email", text: $authViewModel.email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            SecureField("Şifre", text: $authViewModel.password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            TextField("Ad Soyad", text: $authViewModel.fullName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            Picker("Kullanıcı Tipi", selection: $authViewModel.userType) {
                Text("Çalışan").tag("employee")
                Text("İşveren").tag("employer")
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)

            Button("Kayıt Ol") {
                let success = authViewModel.signUp(context: viewContext)
                if !success {
                    alertMsg = "Kayıt başarısız. Bilgileri kontrol edin."
                    showAlert = true
                }
            }
            .padding()

            Spacer()
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Hata"), message: Text(alertMsg), dismissButton: .default(Text("Tamam")))
        }
    }
}
