import SwiftUI

enum SortOption: String, CaseIterable {
    case nameAsc
    case nameDsc
    case priceAsc
    case priceDsc
}

struct HomeView: View {
    @Binding var isLoggedIn: Bool
    var currentUser: CustomerEntity
    
    @FetchRequest(
            entity: ProductEntity.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \ProductEntity.name, ascending: true)]
    ) var products: FetchedResults<ProductEntity>
    
    @State private var sortOption: SortOption = .nameAsc
    var sortedProducts: [ProductEntity] {
        switch sortOption {
        case .nameAsc:
            return products.sorted { $0.name! < $1.name! }
        case .nameDsc:
            return products.sorted { $0.name! > $1.name! }
        case .priceAsc:
            return products.sorted { $0.price < $1.price }
        case .priceDsc:
            return products.sorted { $0.price > $1.price }
        }
    }
    
    var body: some View {
        NavigationView{
            VStack{
                Picker("Sortuj według", selection: $sortOption) {
                    Text("Nazwa rosnąco").tag(SortOption.nameAsc)
                    Text("Nazwa malejąco").tag(SortOption.nameDsc)
                    Text("Cena rosnąco").tag(SortOption.priceAsc)
                    Text("Cena malejąco").tag(SortOption.priceDsc)
                }
                .pickerStyle(NavigationLinkPickerStyle())
                .padding()
                
                List(sortedProducts, id:\.self){
                        product in
                           NavigationLink(destination:
                                           ProductView(product: product)) {
                               VStack(alignment: .leading) {
                                   Text(product.name ?? "Unknown")
                                       .font(.headline)
                                   Text(String(format: "%.2f zł", product.price))
                                       .font(.subheadline)
                               }
                               .padding(.vertical, 5)
                           }
                }
                .navigationBarItems(trailing: Button(action: {
                    isLoggedIn = false
                }) {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                })
                
                Spacer()
                
                HStack{
                    NavigationLink(destination: OrdersView(customer: currentUser)){
                        Text("Zamówienia")
                            .padding()
                            .font(.title)
                            .foregroundColor(.white)
                            .background(.orange)
                            .cornerRadius(10)
                    }
                    .shadow(color: .red, radius: 15, y: 5)
                    .padding()

                    NavigationLink(destination: MapView()){
                        Image(systemName: "map")
                            .padding()
                            .font(.title)
                            .foregroundColor(.white)
                            .background(.orange)
                            .cornerRadius(10)
                    }
                    .shadow(color: .red, radius: 15, y: 5)
                    .padding()
                }
                .navigationTitle("Lista produktów")
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    @State static var isLoggedIn = true
    static var previews: some View {
        let context = PersistenceController.shared.container.viewContext
        let customer = CustomerEntity(context: context)
        customer.email = "user1@example.com"
        customer.password = "password"
        
        return HomeView(isLoggedIn: $isLoggedIn, currentUser: customer)
            .environment(\.managedObjectContext, context)
    }
}

