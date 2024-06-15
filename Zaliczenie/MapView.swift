import SwiftUI
import MapKit

struct MapView: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 51.22916, longitude: 22.48040),
        span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
    )

    var body: some View {
        VStack{
            Text("Nasze sklepy").font(.title)
            Map(coordinateRegion: $region)
            
            HStack() {
                Button("Sklep 1") {region = MKCoordinateRegion(
                    center: CLLocationCoordinate2D(latitude: 51.22916, longitude: 22.48040),
                    span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
                ) }
                .foregroundColor(.white)
                .padding()
                .background(Color.blue)
                .cornerRadius(8)
                
                
                Button("Sklep 2") { region = MKCoordinateRegion(
                    center: CLLocationCoordinate2D(latitude: 51.26294, longitude: 22.57123),
                    span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
                )}
                .foregroundColor(.white)
                .padding()
                .background(Color.blue)
                .cornerRadius(8)
            }
        }
        .navigationTitle("Nasze sklepy")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
