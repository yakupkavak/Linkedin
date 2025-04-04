import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            Text("Hoş Geldiniz!")
                .font(.largeTitle)
                .bold()
                .padding()
            
            Text("Uygulamanın kısa tanıtım ekranı.\nBu alanı isteğinize göre doldurabilirsiniz.")
                .multilineTextAlignment(.center)
                .padding()
            
            Spacer()
            
            Button("Başla") {
                authViewModel.completeOnboarding()
            }
            .padding()
        }
    }
}
