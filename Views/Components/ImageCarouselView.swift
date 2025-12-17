import SwiftUI
internal import Combine

struct ImageCarouselView: View {

    let images: [String]
    @State private var currentIndex = 0

    private let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()

    var body: some View {
        TabView(selection: $currentIndex) {
            ForEach(images.indices, id: \.self) { index in
                Image(images[index])
                    .resizable()
                    .scaledToFill()
                    .frame(height: 200)
                    .clipped()
                    .cornerRadius(16)
                    .padding(.horizontal)
                    .tag(index)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
        .frame(height: 220)
        .onReceive(timer) { _ in
            withAnimation(.easeInOut) {
                currentIndex = (currentIndex + 1) % images.count
            }
        }
    }
}
