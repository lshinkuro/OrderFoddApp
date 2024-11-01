//
//  EncryptManager.swift
//  OrderFoodApp
//
//  Created by Phincon on 28/10/24.
//

import Foundation
import CryptoKit

struct MedicalProfile: Codable {
    let name: String
    let age: Int
    let medicalHistory: String
    // Add other relevant fields as necessary
}

class EncryptionManager {
    
//    static let shared = EncryptionManager()
    // Generate a symmetric encryption key (can be stored securely in Keychain for reuse)
    private let key = SymmetricKey(size: .bits256)
    
    func encryptMedicalProfile(profile: MedicalProfile) throws -> (ciphertext: Data, nonce: Data) {
        let encoder = JSONEncoder()
        let profileData = try encoder.encode(profile)
        
        // Generate a random nonce for AES-GCM encryption
        let nonce = AES.GCM.Nonce()
    
        // Encrypt the profile data using AES-GCM
        let sealedBox = try AES.GCM.seal(profileData, using: key, nonce: nonce)
        let nonceData = Data(sealedBox.nonce)
        
        // Return both the encrypted data and nonce to use in API request
        return (sealedBox.ciphertext, nonceData)
    }
    
    // Decryption (for response or verification purposes)
    func decryptMedicalProfile(ciphertext: Data, nonce: Data) throws -> MedicalProfile {
        let sealedBox = try AES.GCM.SealedBox(nonce: AES.GCM.Nonce(data: nonce), ciphertext: ciphertext, tag: Data())
        let decryptedData = try AES.GCM.open(sealedBox, using: key)
        
        let decoder = JSONDecoder()
        return try decoder.decode(MedicalProfile.self, from: decryptedData)
    }
}
