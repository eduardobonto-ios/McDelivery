import SwiftUI
import FirebaseAuth

// MARK: - CONTENT VIEW
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
                    authVM.user = Auth.auth().currentUser
                }

            } else {

                // MAIN APP
                ZStack {

                    NavigationStack {
                        VStack(spacing: 0) {

                            // TOP BAR
                            VStack(spacing: 4) {

                                HStack {
                                    Button {
                                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                            showMenu.toggle()
                                        }
                                    } label: {
                                        Image(systemName: "line.3.horizontal")
                                            .font(.title2)
                                            .foregroundColor(.black)
                                            .padding()
                                    }

                                    Spacer()
                                }

                                // Dynamic Caption based on selected tab
                                Text(tabTitle(for: selectedTab))
                                    .font(.title2)
                                    .bold()
                                    .foregroundColor(.black)
                                    .padding(.horizontal)
                                    .padding(.bottom, 8)
                            }
                            .frame(maxWidth: .infinity)
                            .background(
                                LinearGradient(
                                    colors: [Color.yellow.opacity(5), Color.orange.opacity(0.7)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )


                            // TAB CONTENT
                            TabContentView(
                                selectedTab: selectedTab,
                                user: authVM.user
                            )
                            .frame(maxWidth: .infinity, maxHeight: .infinity)

                            // BOTTOM TAB BAR
                            TikTokTabBar(selectedTab: $selectedTab)
                        }
                    }
                    .disabled(showMenu)
                    .blur(radius: showMenu ? 6 : 0)

                    // SIDE MENU
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
                                    withAnimation {
                                        showMenu = false
                                    }
                                }
                        )
                    }
                }
            }
        }
        .onAppear {
            authVM.user = Auth.auth().currentUser
        }
    }

    private func tabTitle(for tab: Tab) -> String {
        switch tab {
        case .home: return "Home"
        case .discover: return "Menu"
        case .create: return "Orders"
        case .inbox: return "Coupons"
        case .profile: return "More"
        }
    }

    
    // MARK: - LOGOUT
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
    let user: User?

    var body: some View {
        switch selectedTab {

        case .home:
            ScrollView {
                VStack(spacing: 16) {

                    // IMAGE CAROUSEL
                    ImageCarouselView(
                        images: ["feature1", "feature2", "feature3"]
                    )

                    // WELCOME + MEAL SCROLL
                    VStack(alignment: .leading, spacing: 14) {

                        Text("Welcome Back, \(displayUsername(from: user))")
                            .font(.title2)
                            .bold()

                        MealHorizontalScrollView(
                            meals: [
                                MealItem(image: "meal1", name: "Big Mac Meal", price: "₱189"),
                                MealItem(image: "meal2", name: "McChicken Meal", price: "₱169"),
                                MealItem(image: "meal3", name: "Fries + Drink", price: "₱99"),
                                MealItem(image: "meal4", name: "McNuggets Meal", price: "₱199"),
                                MealItem(image: "meal1", name: "McFlurry", price: "₱89")
                            ]
                        )
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                }
                .padding(.top)
            }

        case .discover:
            CenterPlaceholder(
                icon: "takeoutbag.and.cup.and.straw.fill",
                title: "Menu"
            )

        case .create:
            CenterPlaceholder(
                icon: "doc.text.fill",
                title: "Orders"
            )

        case .inbox:
            CenterPlaceholder(
                icon: "ticket.fill",
                title: "Coupons"
            )

        case .profile:
            CenterPlaceholder(
                icon: "ellipsis.circle",
                title: "More"
            )
        }
    }
}

// MARK: - BOTTOM TAB BAR
struct TikTokTabBar: View {

    @Binding var selectedTab: ContentView.Tab

    var body: some View {
        HStack {

            CustomTabButton(tab: .home, selectedTab: $selectedTab, label: "Home") {
                Image("mcdonalds_logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 22, height: 22)
            }

            CustomTabButton(tab: .discover, selectedTab: $selectedTab, label: "Menu") {
                Image(systemName: "takeoutbag.and.cup.and.straw.fill")
            }

            CustomTabButton(tab: .create, selectedTab: $selectedTab, label: "Orders") {
                Image(systemName: "doc.text.fill")
            }

            CustomTabButton(tab: .inbox, selectedTab: $selectedTab, label: "Coupons") {
                Image(systemName: "ticket.fill")
            }

            CustomTabButton(tab: .profile, selectedTab: $selectedTab, label: "More") {
                Image(systemName: "ellipsis.circle")
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(.ultraThinMaterial)
    }
}

// MARK: - TAB BUTTON
struct CustomTabButton<Icon: View>: View {

    let tab: ContentView.Tab
    @Binding var selectedTab: ContentView.Tab
    let label: String
    let icon: Icon

    init(
        tab: ContentView.Tab,
        selectedTab: Binding<ContentView.Tab>,
        label: String,
        @ViewBuilder icon: () -> Icon
    ) {
        self.tab = tab
        self._selectedTab = selectedTab
        self.label = label
        self.icon = icon()
    }

    var body: some View {
        Button {
            selectedTab = tab
        } label: {
            VStack(spacing: 4) {
                icon
                    .font(.system(size: 20))
                    .foregroundColor(selectedTab == tab ? .red : .gray)

                Text(label)
                    .font(.caption2)
                    .foregroundColor(selectedTab == tab ? .red : .gray)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

// MARK: - PLACEHOLDER
struct CenterPlaceholder: View {

    let icon: String
    let title: String

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.largeTitle)
            Text(title)
        }
    }
}



// MARK: - USERNAME HELPER
private func displayUsername(from user: User?) -> String {
    if let name = user?.displayName, !name.isEmpty {
        return name
    }
    if let email = user?.email {
        return email.components(separatedBy: "@").first ?? "User"
    }
    return "Guest"
}

// MARK: - MEAL MODELS
struct MealItem: Identifiable {
    let id = UUID()
    let image: String
    let name: String
    let price: String
}

// MARK: - UPDATED MEAL HORIZONTAL SCROLL
struct MealHorizontalScrollView: View {

    let meals: [MealItem]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {

                ForEach(meals) { meal in
                    VStack(spacing: 8) {

                        ZStack(alignment: .top) {
                            // LIGHT GRAY VERTICAL BACKGROUND
                            RoundedRectangle(cornerRadius: 18)
                                .fill(Color.gray.opacity(0.12))
                                .frame(width: 150, height: 160 + 40) // add space for text

                            VStack(spacing: 8) {
                                // MEAL IMAGE
                                Image(meal.image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 130, height: 110)
                                    .padding(.top, 12)

                                // MEAL NAME
                                Text(meal.name)
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .lineLimit(1)

                                // PRICE
                                Text(meal.price)
                                    .font(.caption)
                                    .bold()
                                    .foregroundColor(.red)
                            }
                            .padding(.bottom, 12)
                        }
                        .frame(width: 150)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

