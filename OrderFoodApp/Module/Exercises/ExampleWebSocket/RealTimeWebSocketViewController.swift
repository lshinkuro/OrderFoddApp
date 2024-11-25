//
//  RealTimeWebSocketViewController.swift
//  OrderFoodApp
//
//  Created by Phincon on 20/11/24.
//

import Foundation
import UIKit
import SnapKit
import Starscream

// MARK: - Welcome
struct StockModel: Codable {
    let data: [StockDataModel]
    let type: String
}

// MARK: - Datum
struct StockDataModel: Codable {
    let p: Double
    let s: String
    let t: Int
    let v: Double
}


struct StockData: Codable {
    let symbol: String
    let price: Double?
    
    enum CodingKeys: String, CodingKey {
        case symbol
        case price = "p" // Sesuaikan dengan struktur JSON Anda
    }
}

class RealTimeStockViewController: UIViewController, WebSocketDelegate {
    func didReceive(event: Starscream.WebSocketEvent, client: any Starscream.WebSocketClient) {
        switch event {
        case .connected(let headers):
            print("WebSocket connected: \(headers)")
            subscribeToStocks(["AAPL", "BINANCE:BTCUSDT", "IC MARKETS:1"])
        case .disconnected(let reason, let code):
            print("WebSocket disconnected: \(reason) with code: \(code)")
        case .text(let string):
            handleIncomingMessage(string)
        case .binary(let data):
            print("Received binary data: \(data.count) bytes")
        case .cancelled:
            print("WebSocket cancelled")
        case .error(let error):
            print("WebSocket error: \(String(describing: error))")
        default:
            break
        }
    }
    
    private var tableView = UITableView()
    private var stockData: [StockDataModel] = []

    private var socket: WebSocket?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupWebSocket()
    }

    // MARK: - Setup UI
    private func setupUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    // MARK: - WebSocket Setup
    private func setupWebSocket() {
        guard let url = URL(string: "wss://ws.finnhub.io?token=csuo9bhr01qgo8ni8gr0csuo9bhr01qgo8ni8grg") else {
            print("Invalid WebSocket URL")
            return
        }
        var request = URLRequest(url: url)
        request.timeoutInterval = 10
        socket = WebSocket(request: request)
        socket?.delegate = self
        socket?.connect()
    }

    // MARK: - WebSocket Delegate
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .connected(let headers):
            print("WebSocket connected: \(headers)")
            subscribeToStocks(["AAPL", "BINANCE:BTCUSDT", "IC MARKETS:1"])
        case .disconnected(let reason, let code):
            print("WebSocket disconnected: \(reason) with code: \(code)")
        case .text(let string):
            handleIncomingMessage(string)
        case .binary(let data):
            print("Received binary data: \(data.count) bytes")
        case .cancelled:
            print("WebSocket cancelled")
        case .error(let error):
            print("WebSocket error: \(String(describing: error))")
        default:
            break
        }
    }

    // MARK: - Subscribe and Handle Messages
    private func subscribeToStocks(_ symbols: [String]) {
        symbols.forEach { symbol in
            let message = [
                "type": "subscribe",
                "symbol": symbol
            ]
            sendMessage(message: message)
        }
    }

    private func sendMessage(message: [String: Any]) {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: message)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                socket?.write(string: jsonString)
            }
        } catch {
            print("Failed to encode message: \(error)")
        }
    }

    private func handleIncomingMessage(_ text: String) {
        guard let data = text.data(using: .utf8) else { return }
        
        do {
            // Decode incoming JSON
            let stockResponse = try JSONDecoder().decode(StockModel.self, from: data)
            updateStockData(stockResponse.data)
        } catch {
            print("Failed to decode message: \(error)")
        }
    }

    private func updateStockData(_ newData: [StockDataModel]) {
        DispatchQueue.main.async {
            // Update the data source
            self.stockData = newData
            self.tableView.reloadData()
        }
    }

    deinit {
        socket?.disconnect()
    }
}

// MARK: - UITableViewDataSource
extension RealTimeStockViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stockData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let stock = stockData[indexPath.row]
        cell.textLabel?.text = "\(stock.s): $\(stock.p)"
        return cell
    }
}
