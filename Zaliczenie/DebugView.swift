import SwiftUI

struct DebugView: View {
    var body: some View {
        Button(action: {
            PersistenceController.shared.deleteAllData()
        }) {
            Text("Wyczyść dane")
        }
    }
}

struct DebugView_Previews: PreviewProvider {
    static var previews: some View {
        DebugView()
    }
}
