//
//  DemoServer.swift
//  BrokenPipeDemo
//
//  Created by Josh Avant on 5/2/18.
//  Copyright © 2018 Josh Avant. All rights reserved.
//

import Foundation
import Telegraph

final class DemoServer {
    private let client: WebSocketClient
    private static let port: UInt16 = 9000
    
    required init() {
        let serverURL = URL(string: "http://localhost:" + String(DemoServer.port))!
        self.client = try! WebSocketClient(url: serverURL)
        
        self.client.headers["X-Name"] = "Simulator"
        self.client.delegate = self
    }
    
    func run() throws {
        self.client.connect()
        
        self.clientLog("Client is running")
    }
    
    func stop(immediately: Bool = false) {
        self.client.close(immediately: immediately)
    }
    
    func send(_ data: Data) {
        self.client.send(data: data)
    }
}

extension DemoServer: WebSocketClientDelegate {
    public func webSocketClient(_ client: WebSocketClient, didConnectToHost host: String) {
        // Raised when the web socket client has connected to the server
        self.clientLog("WebSocket connected to \(host)")
    }
    
    public func webSocketClient(_ client: WebSocketClient, didReceiveData data: Data) {
        // Raised when the web socket client received data
        self.clientLog("WebSocket received data: \(data as NSData)")
    }
    
    public func webSocketClient(_ client: WebSocketClient, didReceiveText text: String) {
        // Raised when the web socket client received text
        self.clientLog("WebSocket received text: \(text)")
    }
    
    public func webSocketClient(_ client: WebSocketClient, didDisconnectWithError error: Error?) {
        // Raised when the web socket client disconnects. Provides an error if the disconnect was unexpected.
        if let error = error {
            self.clientLog("WebSocket disconnected, error: \(error)")
        } else {
            self.clientLog("WebSocket disconnected")
        }
    }
}

// Logging Helpers
extension DemoServer {
    private func clientLog(_ message: String) {
        print("[CLIENT] \(message)")
    }
}
