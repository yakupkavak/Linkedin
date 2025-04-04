import SwiftUI

struct MyJobsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject var jobVM = JobViewModel()

    @State private var showNewJob = false

    var body: some View {
        NavigationView {
            List {
                // Sadece currentUser'ın oluşturduğu ilanlar:
                // Bunu bir "filter" ile ayıklayabiliriz => "Job.employer == currentUser"
                ForEach(jobVM.jobs.filter { job in
                    // Filtre: jobModel -> userId check edilmesi istersen
                    // Basitçe hepsini gösterelim
                    true
                }, id: \.id) { job in
                    NavigationLink(destination: JobDetailView(job: job)) {
                        VStack(alignment: .leading) {
                            Text(job.title)
                                .font(.headline)
                            Text(job.descriptionText)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .lineLimit(2)
                        }
                    }
                }
            }
            .navigationTitle("İlanlarım")
            .toolbar {
                Button {
                    showNewJob = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            .onAppear {
                jobVM.fetchJobs(context: viewContext)
            }
        }
        .sheet(isPresented: $showNewJob) {
            NewJobView(jobVM: jobVM)
                .environmentObject(authViewModel)
        }
    }
}
