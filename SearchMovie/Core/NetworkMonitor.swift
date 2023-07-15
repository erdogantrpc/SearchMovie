//
//  NetworkMonitor.swift
//  SearchMovie
//
//  Created by Erdoğan Turpcu on 15.07.2023.
//

import Network

class NetworkMonitor {
    static let shared = NetworkMonitor()
    let monitor = NWPathMonitor()
    
    func startMonitoring(isNetworkActive: ((Bool) -> Void)?) {
        monitor.pathUpdateHandler = { path in
            isNetworkActive?(path.status == .satisfied)
        }

        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }

    func stopMonitoring() {
        monitor.cancel()
    }
}
