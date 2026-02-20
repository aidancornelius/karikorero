// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.
//
// Created by Aidan Cornelius-Bell on 20/2/2026.

import StoreKit
import SwiftUI

@Observable
@MainActor
final class TipService {
    private(set) var product: Product?
    private(set) var isLoading: Bool = false

    var hasTipped: Bool {
        get { UserDefaults.standard.bool(forKey: "hasTipped") }
        set { UserDefaults.standard.set(newValue, forKey: "hasTipped") }
    }

    private var updatesTask: Task<Void, Never>?

    static let tipProductID = "nz.ursa.karikorero.tipjar"

    func listenForUpdates() {
        updatesTask = Task(priority: .background) { [weak self] in
            for await result in Transaction.updates {
                if case .verified(let transaction) = result,
                   transaction.productID == Self.tipProductID {
                    await MainActor.run { self?.hasTipped = true }
                    await transaction.finish()
                }
            }
        }
    }

    func loadProduct() async {
        do {
            let products = try await Product.products(for: [Self.tipProductID])
            product = products.first
            #if DEBUG
            print("[TipService] Loaded \(products.count) product(s): \(products.map(\.id))")
            #endif
        } catch {
            #if DEBUG
            print("[TipService] Failed to load products: \(error)")
            #endif
        }
    }

    func purchase() async {
        guard let product, !isLoading else { return }
        isLoading = true
        defer { isLoading = false }

        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                if case .verified(let transaction) = verification {
                    hasTipped = true
                    await transaction.finish()
                }
            case .userCancelled, .pending:
                break
            @unknown default:
                break
            }
        } catch {
            // Purchase failed — no action needed
        }
    }
}
