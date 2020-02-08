//
//  AppleAuthService.swift
//  Meditation
//
//  Created by Ruslan Timchenko on 20.12.2019.
//  Copyright © 2019 Meditation. All rights reserved.
//

import Foundation
import AuthenticationServices

@available(iOS 13.0, *)
protocol IAppleAuthService: NSObjectProtocol {
    func startSignInWithAppleFlow()
}

@available(iOS 13.0, *)
protocol IAppleAuthOutput: class {
    func appleAuthSuccessfull(with idToken: String, rawNonce: String)
    func appleAuthFailed(with error: Error)
}

@available(iOS 13.0, *)
final class AppleAuthService: NSObject, IAppleAuthService {
    
    // Delegate
    private let output: IAppleAuthOutput?
    
    // Private Interface
    fileprivate var currentNonce: String?
    
    // MARK: - Initialization
    
    init(output: IAppleAuthOutput) {
        self.output = output
    }
    
    deinit {
        print("AppleAuthService deinit")
    }
    
    // MARK: - AppleAuthService
    
    func startSignInWithAppleFlow() {
        let nonce = randomNonceString()
        currentNonce = nonce
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = []
        request.nonce = sha256(nonce)
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
}

// MARK: - ASAuthorizationControllerDelegate

@available(iOS 13.0, *)
extension AppleAuthService: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
              fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
              print("Unable to fetch identity token")
              return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
              print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
              return
            }
            output?.appleAuthSuccessfull(with: idTokenString, rawNonce: nonce)
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        output?.appleAuthFailed(with: error)
    }
}

@available(iOS 13.0, *)
extension AppleAuthService {
    // Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
    private func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      let charset: Array<Character> =
          Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
      var result = ""
      var remainingLength = length

      while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
          var random: UInt8 = 0
          let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
          if errorCode != errSecSuccess {
            fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
          }
          return random
        }

        randoms.forEach { random in
          if length == 0 {
            return
          }

          if random < charset.count {
            result.append(charset[Int(random)])
            remainingLength -= 1
          }
        }
      }

      return result
    }
    
    private func sha256(_ input: String) -> String {
        
        func digest(input : NSData) -> NSData {
            let digestLength = Int(CC_SHA256_DIGEST_LENGTH)
            var hashValue = [UInt8](repeating: 0, count: digestLength)
            CC_SHA256(input.bytes, UInt32(input.length), &hashValue)
            return NSData(bytes: hashValue, length: digestLength)
        }
        
        func getHexString(fromData data: NSData) -> String {
            var bytes = [UInt8](repeating: 0, count: data.length)
            data.getBytes(&bytes, length: data.length)
            
            var hexString = ""
            for byte in bytes {
                hexString += String(format:"%02x", UInt8(byte))
            }
            return hexString
        }
        
        guard let data = input.data(using: .utf8) else {
            print("Data not available")
            return ""
        }
        return getHexString(fromData: digest(input: data as NSData))
    }
}
