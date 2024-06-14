import SwiftUI
import CoreData

struct OrdersView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest var orders: FetchedResults<OrderEntity>
    var customer: CustomerEntity

    init(customer: CustomerEntity) {
        self.customer = customer
        _orders = FetchRequest<OrderEntity>(
            entity: OrderEntity.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \OrderEntity.date, ascending: false)],
            predicate: NSPredicate(format: "customer == %@", customer)
        )
    }

    var body: some View {
        List {
            ForEach(orders, id: \.self) { order in
                VStack(alignment: .leading) {
                    Text("Nr zamówienia: \(order.id!.uuidString)")
                        .font(.headline)
                    if let product = order.product {
                        HStack{
                            Text("Produkt: \(product.name ?? "Unknown")")
                                .font(.subheadline)
                            Text(String(format: "Cena: %.2f zł", product.price))
                                .font(.subheadline)
                        }
                    }
                }
                .padding(.vertical, 5)
            }.onDelete(perform: deleteOrders)
        }.navigationTitle("Moje zamówienia")
    }
    
    private func deleteOrders(offsets: IndexSet) {
        withAnimation {
            offsets.map { orders[$0] }.forEach(viewContext.delete)
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()

struct OrdersView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.shared.container.viewContext
        
        // Przykładowe dane
        let customer = CustomerEntity(context: context)
        customer.id = UUID()
        customer.email = "user@example.com"
        customer.password = "password"
        
        let product = ProductEntity(context: context)
        product.id = UUID()
        product.name = "Sample Product"
        product.price = 19.99
        product.priceEur = 4.59
        product.image = nil
        
        let order = OrderEntity(context: context)
        order.id = UUID()
        order.date = Date()
        order.customer = customer
        order.product = product
        
        return OrdersView(customer: customer)
            .environment(\.managedObjectContext, context)
    }
}
