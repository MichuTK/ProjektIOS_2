import Foundation
import CoreData

class AuthManager {
    private let viewContext: NSManagedObjectContext

    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
    }

    func login(email: String, password: String) -> (CustomerEntity?, String?) {
        guard !email.isEmpty, !password.isEmpty else {
            return (nil, "Email i hasło nie mogą być puste.")
        }
        
        guard isValidEmail(email) else {
            return (nil, "Nieprawidłowy format adresu e-mail.")
        }

        let fetchRequest: NSFetchRequest<CustomerEntity> = CustomerEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email == %@ AND password == %@", email, password)

        do {
            let users = try viewContext.fetch(fetchRequest)
            if let user = users.first {
                return (user, nil)
            } else {
                return (nil, "Nieprawidłowy email lub hasło.")
            }
        } catch {
            return (nil, "Wystąpił błąd podczas próby logowania.")
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
