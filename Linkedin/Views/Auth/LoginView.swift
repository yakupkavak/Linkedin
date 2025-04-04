import SwiftUI

struct LoginView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var authViewModel: AuthViewModel

    @State private var showAlert = false
    @State private var alertMsg = ""

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Giriş Yap").font(.largeTitle).bold()

                TextField("Email", text: $authViewModel.email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                SecureField("Şifre", text: $authViewModel.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                Button("Giriş Yap") {
                    let success = authViewModel.login(context: viewContext)
                    if !success {
                        alertMsg = "Email veya şifre hatalı."
                        showAlert = true
                    }
                }
                .padding()

                NavigationLink(destination: SignUpView()) {
                    Text("Hesabın yok mu? Kayıt ol")
                }

                Spacer()
            }
            .navigationBarHidden(true)
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Hata"), message: Text(alertMsg), dismissButton: .default(Text("Tamam")))
            }
        }
    }
}
