import SwiftUI

struct JobListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject var jobVM = JobViewModel()

    var body: some View {
        NavigationView {
            VStack {
                JobSearchBarView(searchText: $jobVM.searchText) {
                    jobVM.fetchJobs(context: viewContext)
                }

                List {
                    ForEach(jobVM.jobs, id: \.id) { job in
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
                .onAppear {
                    jobVM.fetchJobs(context: viewContext)
                }
            }
            .navigationTitle("İş İlanları")
        }
    }
}
