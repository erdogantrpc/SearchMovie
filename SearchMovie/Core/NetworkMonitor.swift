//
//  NetworkMonitor.swift
//  SearchMovie
//
//  Created by Erdoğan Turpcu on 15.07.2023.
//

import Network

protocol NetworkMonitorDelegate: AnyObject {
    func isNetworkActive(isActive: Bool)
}

class NetworkMonitor {
    static let shared = NetworkMonitor()
    weak var delegate: NetworkMonitorDelegate?
    let monitor = NWPathMonitor()
    
    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.delegate?.isNetworkActive(isActive: path.status == .satisfied)
        }

        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }

    func stopMonitoring() {
        monitor.cancel()
    }
}
