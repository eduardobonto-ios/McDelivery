import SwiftUI
import AuthenticationServices

struct LoginView: View {

    @StateObject private var authVM = AuthViewModel()

    @State private var email = ""
    @State private var password = ""
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var fadeIn = false
    @State private var slideUp = false

    var onLoginSuccess: (() -> Void)?

    var body: some View {
        ZStack {
            AppGradient.primary
                .ignoresSafeArea()

            VStack(spacing: 28) {

                Spacer().frame(height: 40)

                // IMAGE CAROUSEL HEADER
                ImageCarouselView(
                    images: [
                        "banner1",
                        "banner2",
                        "banner3"
                    ]
                )
                .opacity(fadeIn ? 1 : 0)
                .offset(y: slideUp ? 0 : 20)
                .animation(.easeOut(duration: 0.8), value: fadeIn)


                VStack(spacing: 18) {

                    inputField(icon: "envelope.fill",
                               placeholder: "Email",
                               text: $email)

                    inputField(icon: "lock.fill",
                               placeholder: "Password",
                               text: $password,
                               isSecure: true)

                    if showError {
                        Text(errorMessage)
                            .font(.callout)
                            .foregroundColor(.white)
                            .padding(10)
                            .frame(maxWidth: .infinity)
                            .background(Color.red.opacity(0.8))
                            .cornerRadius(10)
                    }

                    Button {
                        Task {
                            let success = await authVM.signIn(
                                email: email,
                                password: password
                            )

                            if success {
                                onLoginSuccess?()
                            } else {
                                showFirebaseError()
                            }
                        }
                    } label: {
                        if authVM.isLoading {
                            ProgressView()
                        } else {
                            Text("Log In").bold()
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white)
                    .foregroundColor(.black)
                    .cornerRadius(12)
                }
                .padding(.horizontal, 30)

                HStack {
                    line
                    Text("OR").foregroundColor(.white)
                    line
                }

                VStack(spacing: 14) {

                    Button {
                        Task {
                            let success = await authVM.signUp(
                                email: email,
                                password: password
                            )

                            if success {
                                onLoginSuccess?()
                            } else {
                                showFirebaseError()
                            }
                        }
                    } label: {
                        HStack(spacing: 10) {
                            Image(systemName: "envelope.fill")
                                .foregroundColor(.red)

                            Text("Sign up with Email")
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.25))
                    .cornerRadius(12)



                    SignInWithAppleButton(.signIn) { _ in
                    } onCompletion: { _ in }
                    .frame(height: 45)

                    Button {
                        Task {
                            let success = await authVM.signInAnonymously()
                            if success {
                                onLoginSuccess?()
                            } else {
                                showFirebaseError()
                            }
                        }
                    } label: {
                        Text("Order as guest")
                            .foregroundColor(.red)
                    }
                }
                .padding(.horizontal, 30)

                Spacer()
            }
        }
        .onAppear {
            fadeIn = true
            slideUp = true
        }
    }

    private func showFirebaseError() {
        errorMessage = authVM.errorMessage ?? "Authentication failed"
        withAnimation { showError = true }
    }

    func inputField(icon: String,
                    placeholder: String,
                    text: Binding<String>,
                    isSecure: Bool = false) -> some View {
        HStack {
            Image(systemName: icon).foregroundColor(.white)
            if isSecure {
                SecureField(placeholder, text: text)
            } else {
                TextField(placeholder, text: text)
            }
        }
        .padding()
        .background(Color.white.opacity(0.15))
        .cornerRadius(12)
    }

    var line: some View {
        Rectangle()
            .frame(height: 1)
            .foregroundColor(.white.opacity(0.4))
    }
}
