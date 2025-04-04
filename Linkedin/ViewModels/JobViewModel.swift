import SwiftUI
import CoreData

class JobViewModel: ObservableObject {
    @Published var jobs: [JobModel] = []
    @Published var searchText: String = ""
    
    // Yeni job form:
    @Published var jobTitle: String = ""
    @Published var jobDescription: String = ""
    
    func fetchJobs(context: NSManagedObjectContext) {
        let request = NSFetchRequest<NSManagedObject>(entityName: "Job")
        request.sortDescriptors = [NSSortDescriptor(key: "postedDate", ascending: false)]
        
        if !searchText.isEmpty {
            let pred = NSPredicate(format: "title CONTAINS[cd] %@ OR descriptionText CONTAINS[cd] %@", searchText, searchText)
            request.predicate = pred
        }
        
        do {
            let objects = try context.fetch(request)
            self.jobs = objects.map { obj in
                let jid = obj.value(forKey: "id") as? UUID ?? UUID()
                let title = obj.value(forKey: "title") as? String ?? ""
                let desc = obj.value(forKey: "descriptionText") as? String ?? ""
                let date = obj.value(forKey: "postedDate") as? Date ?? Date()
                return JobModel(id: jid, title: title, descriptionText: desc, postedDate: date)
            }
        } catch {
            print("fetchJobs hata: \(error)")
            jobs = []
        }
    }
    
    func createJob(employer: UserModel, context: NSManagedObjectContext) {
        guard let entity = NSEntityDescription.entity(forEntityName: "Job", in: context) else { return }
        let newJob = NSManagedObject(entity: entity, insertInto: context)
        
        let newId = UUID()
        newJob.setValue(newId, forKey: "id")
        newJob.setValue(jobTitle, forKey: "title")
        newJob.setValue(jobDescription, forKey: "descriptionText")
        newJob.setValue(Date(), forKey: "postedDate")
        
        // Relationship => job.employer = user?
        if let employerObj = findUserObject(by: employer.id, context: context) {
            newJob.setValue(employerObj, forKey: "employer")
        }
        
        do {
            try context.save()
            jobTitle = ""
            jobDescription = ""
            fetchJobs(context: context)
        } catch {
            print("createJob hata: \(error)")
        }
    }
    
    func applyToJob(_ job: JobModel) {
        // Sadece log
        print("İşe başvuruldu: \(job.title)")
    }
    
    private func findUserObject(by userId: UUID, context: NSManagedObjectContext) -> NSManagedObject? {
        let req = NSFetchRequest<NSManagedObject>(entityName: "User")
        req.predicate = NSPredicate(format: "id == %@", userId as CVarArg)
        return (try? context.fetch(req))?.first
    }
}
