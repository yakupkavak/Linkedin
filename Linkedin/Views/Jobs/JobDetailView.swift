import SwiftUI

struct JobDetailView: View {
    let job: JobModel
    @StateObject var jobVM = JobViewModel()

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(job.title)
                .font(.largeTitle)
                .bold()

            Text(job.descriptionText)

            Spacer()

            Button("Başvur") {
                jobVM.applyToJob(job)
            }
            .padding()
        }
        .padding()
        .navigationTitle("İş Detayı")
    }
}
