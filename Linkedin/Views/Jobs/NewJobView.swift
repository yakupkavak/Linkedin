import SwiftUI

struct NewJobView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var authViewModel: AuthViewModel
    @ObservedObject var jobVM: JobViewModel
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("İş Bilgileri")) {
                    TextField("Başlık", text: $jobVM.jobTitle)
                    TextField("Açıklama", text: $jobVM.jobDescription)
                }
                Section {
                    Button("Yayınla") {
                        if let user = authViewModel.currentUser {
                            jobVM.createJob(employer: user, context: viewContext)
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
            }
            .navigationTitle("Yeni İş İlanı")
            .navigationBarItems(leading: Button("İptal") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}
