import SwiftUI

struct EmployeeMainView: View {
    var body: some View {
        TabView {
            MainFeedView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Feed")
                }

            JobListView()
                .tabItem {
                    Image(systemName: "briefcase.fill")
                    Text("İşler")
                }

            ProfileView()
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("Profil")
                }
        }
    }
}
