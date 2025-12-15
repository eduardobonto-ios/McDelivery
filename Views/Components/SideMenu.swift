import SwiftUI
import FirebaseAuth


struct SideMenu: View {

    @Binding var showMenu: Bool
    let onLogout: () -> Void

    var body: some View {
        ZStack {

            // MATCH LOGIN VIEW BACKGROUND (3D STYLE)
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color.blue.opacity(0.8),
                            Color.purple.opacity(0.8)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.18),
                            Color.clear,
                            Color.black.opacity(0.25)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .shadow(color: .black.opacity(0.35), radius: 12, x: 6, y: 0)

            VStack(alignment: .leading, spacing: 24) {

                // PROFILE HEADER
                VStack(alignment: .leading, spacing: 12) {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .frame(width: 64, height: 64)
                        .foregroundColor(.white)

                    Text("Welcome Back")
                        .font(.headline)
                        .foregroundColor(.white)

                    Text(Auth.auth().currentUser?.email ?? "Guest User")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                }
                .padding(.top, 40)

                Divider()
                    .background(Color.white.opacity(0.3))

                // MENU ITEMS
                SideMenuItem(icon: "house.fill", title: "Home")
                SideMenuItem(icon: "cart.fill", title: "Orders")
                SideMenuItem(icon: "heart.fill", title: "Favorites")
                SideMenuItem(icon: "creditcard.fill", title: "Payment")
                SideMenuItem(icon: "gearshape.fill", title: "Settings")

                Spacer()

                Divider()
                    .background(Color.white.opacity(0.3))

                // LOGOUT
                Button {
                    onLogout()
                } label: {
                    HStack(spacing: 12) {
                        Image(systemName: "arrow.backward.circle.fill")
                        Text("Logout")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                }
                .padding(.bottom, 30)
            }
            .padding(.horizontal, 20)
        }
        .ignoresSafeArea()
    }
}
