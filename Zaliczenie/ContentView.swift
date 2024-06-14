import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String? = nil
    @State private var isLoggedIn: Bool = false
    @State private var currentUser: CustomerEntity? = nil

    var body: some View {
        if isLoggedIn {
            if let user = currentUser {
                HomeView(isLoggedIn: $isLoggedIn, currentUser: user)
                    .environment(\.managedObjectContext, viewContext)
            }
        } else {
            VStack {
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200)
                    .padding(.bottom, 10)
                
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }

                TextField("Email", text: $email)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(8)
                    .padding(.bottom, 20)

                SecureField("Hasło", text: $password)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(8)
                    .padding(.bottom, 20)

                Button(action: {
                    let authManager = AuthManager(viewContext: viewContext)
                    let (user, error) = authManager.login(email: email, password: password)
                    if let user = user {
                        errorMessage = error
                        currentUser = user
                        isLoggedIn = true
                   } else {
                       errorMessage = error
                   }
                }) {
                    Text("Zaloguj się")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .cornerRadius(8)
                }
                .padding(.horizontal, 20)
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}

