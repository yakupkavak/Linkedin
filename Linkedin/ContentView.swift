import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        Group {
            if authViewModel.isFirstLaunch {
                OnboardingView()
            } else if authViewModel.currentUser == nil {
                // Giriş yapmamış, login ekranına
                LoginView()
            } else {
                // Giriş yapmış => userType'a göre göster
                if authViewModel.currentUser?.userType == "employer" {
                    EmployerMainView()
                } else {
                    EmployeeMainView()
                }
            }
        }
        .onAppear {
            authViewModel.checkFirstLaunch()
        }
    }
}
