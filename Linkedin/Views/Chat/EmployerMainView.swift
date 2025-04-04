import SwiftUI

struct EmployerMainView: View {
    var body: some View {
        TabView {
            MainFeedView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Feed")
                }

            MyJobsView()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("İlanlarım")
                }

            ProfileView()
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("Profil")
                }
        }
    }
}
