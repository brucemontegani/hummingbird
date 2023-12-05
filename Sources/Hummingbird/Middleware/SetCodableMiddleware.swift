//===----------------------------------------------------------------------===//
//
// This source file is part of the Hummingbird server framework project
//
// Copyright (c) 2023 the Hummingbird authors
// Licensed under Apache License v2.0
//
// See LICENSE.txt for license information
// See hummingbird/CONTRIBUTORS.txt for the list of Hummingbird authors
//
// SPDX-License-Identifier: Apache-2.0
//
//===----------------------------------------------------------------------===//

public struct HBSetCodableMiddleware<Decoder: HBRequestDecoder, Encoder: HBResponseEncoder, Context: HBBaseRequestContext>: HBMiddleware {
    let decoder: @Sendable () -> Decoder
    let encoder: @Sendable () -> Encoder

    public init(decoder: @autoclosure @escaping @Sendable () -> Decoder, encoder: @autoclosure @escaping @Sendable () -> Encoder) {
        self.decoder = decoder
        self.encoder = encoder
    }

    public func apply(to request: HBRequest, context: Context, next: any HBResponder<Context>) async throws -> HBResponse {
        var context = context
        context.coreContext.requestDecoder = self.decoder()
        context.coreContext.responseEncoder = self.encoder()
        return try await next.respond(to: request, context: context)
    }
}