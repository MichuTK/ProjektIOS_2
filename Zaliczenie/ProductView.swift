import SwiftUI
import CoreData

struct ProductView: View {
    var product: ProductEntity
    @State var scaleImg: CGFloat = 1.0
    @State private var eur = false

    var body: some View {
            VStack(alignment: .leading) {
                if let imageData = product.image, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .scaleEffect(scaleImg)
                        .gesture(
                            TapGesture(count: 2)
                                .onEnded(){_ in scaleImg += 0.20
                                    if  (scaleImg>3) {scaleImg = 1}
                                }
                        )
                        .gesture(
                            TapGesture(count: 1)
                                .onEnded(){_ in scaleImg -= 0.20
                                    if  (scaleImg<0.2) {scaleImg = 1}
                                }
                        )
                        .gesture(
                            LongPressGesture(minimumDuration: 0.3)
                                .onEnded(){_ in scaleImg = 1}
                        )
                }
                Text(product.name ?? "Unknown")
                    .font(.largeTitle)
                    .padding(.bottom, 10)
                Text(String(format: "%.2f %@",
                            eur ? product.priceEur : product.price,
                            eur ? "EUR" : "zł")
                )
                    .font(.title)
                    .padding(.bottom, 20)
                Toggle("Waluta EUR", isOn: $eur)
                
            }
            .padding()
            .navigationTitle("Szczegóły")
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct ProductView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.shared.container.viewContext
        let product = ProductEntity(context: context)
        product.name = "Sample Product"
        product.price = 45.99
        product.priceEur = 9.99
        product.image = UIImage(named: "rondo-raat-cf")?.jpegData(compressionQuality: 1.0)
        return ProductView(product: product)
    }
}
