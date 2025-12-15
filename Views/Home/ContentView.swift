import SwiftUI
import FirebaseAuth

struct ContentView: View {

    @StateObject private var authVM = AuthViewModel()

    @State private var showMenu = false
    @State private var selectedTab: Tab = .home

    enum Tab {
        case home, discover, create, inbox, profile
    }

    var body: some View {

        Group {
            if authVM.user == nil {
                // LOGIN FLOW
                LoginView {
                    // Firebase already updated user internally
                    authVM.user = Auth.auth().currentUser
                }
            } else {
                // MAIN APP
                ZStack {

                    // MAIN CONTENT
                    NavigationStack {
                        VStack(spacing: 0) {

                            // TOP BAR
                            HStack {
                                Button {
                                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                        showMenu.toggle()
                                    }
                                } label: {
                                    Image(systemName: "line.3.horizontal")
                                        .font(.title2)
                                        .padding()
                                }

                                Spacer()
                            }

                            // TAB CONTENT
                            TabContentView(selectedTab: selectedTab)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)

                            // BOTTOM TAB BAR
                            TikTokTabBar(selectedTab: $selectedTab)
                        }
                    }
                    .disabled(showMenu)
                    .blur(radius: showMenu ? 6 : 0)

                    // SIDE MENU OVERLAY
                    if showMenu {
                        HStack(spacing: 0) {
                            SideMenu(
                                showMenu: $showMenu,
                                onLogout: handleLogout
                            )
                            .frame(width: 280)
                            .transition(.move(edge: .leading))

                            Spacer()
                        }
                        .background(
                            Color.black.opacity(0.35)
                                .ignoresSafeArea()
                                .onTapGesture {
                                    withAnimation(.spring()) {
                                        showMenu = false
                                    }
                                }
                        )
                    }
                }
            }
        }
        .onAppear {
            // Sync Firebase session on launch
            authVM.user = Auth.auth().currentUser
        }
    }

    // MARK: - Logout Logic
    private func handleLogout() {
        withAnimation {
            showMenu = false
        }
        authVM.signOut()
    }
}

// MARK: - TAB CONTENT
struct TabContentView: View {
    let selectedTab: ContentView.Tab

    var body: some View {
        switch selectedTab {
        case .home:
            VStack(spacing: 12) {
                Image(systemName: "house.fill")
                    .font(.largeTitle)
                Text("Home Tab")
            }

        case .discover:
            VStack(spacing: 12) {
                Image(systemName: "magnifyingglass")
                    .font(.largeTitle)
                Text("Discover Tab")
            }

        case .create:
            VStack(spacing: 12) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 50))
                Text("Create Tab")
            }

        case .inbox:
            VStack(spacing: 12) {
                Image(systemName: "envelope.fill")
                    .font(.largeTitle)
                Text("Inbox Tab")
            }

        case .profile:
            VStack(spacing: 12) {
                Image(systemName: "person.crop.circle.fill")
                    .font(.largeTitle)
                Text("Profile Tab")
            }
        }
    }
}

// MARK: - TIKTOK STYLE TAB BAR
struct TikTokTabBar: View {
    @Binding var selectedTab: ContentView.Tab

    var body: some View {
        HStack {

            TabBarButton(icon: "house.fill", tab: .home, selectedTab: $selectedTab)
            TabBarButton(icon: "magnifyingglass", tab: .discover, selectedTab: $selectedTab)

            // CREATE BUTTON
            Button {
                selectedTab = .create
            } label: {
                ZStack {
                    Circle()
                        .foregroundColor(.blue)
                        .frame(width: 50, height: 50)

                    Image(systemName: "plus")
                        .foregroundColor(.white)
                        .font(.title)
                }
            }
            .offset(y: -10)

            TabBarButton(icon: "envelope.fill", tab: .inbox, selectedTab: $selectedTab)
            TabBarButton(icon: "person.crop.circle.fill", tab: .profile, selectedTab: $selectedTab)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(.ultraThinMaterial)
    }
}

// MARK: - TAB BAR BUTTON
struct TabBarButton: View {
    let icon: String
    let tab: ContentView.Tab
    @Binding var selectedTab: ContentView.Tab

    var body: some View {
        Button {
            selectedTab = tab
        } label: {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(selectedTab == tab ? .primary : .gray)
                .frame(maxWidth: .infinity)
        }
    }
}
