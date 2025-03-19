//
//  TelegramBotUtils.swift
//  MealRecord
//
//  Created by Hui Zeng on 7/27/23.
//

import Foundation

class TelegramUtils {
    static func sendRecord(record: Record) {
        let botToken = "xxxx"
        let chatID = "xxxxx"

        // Create the message content
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        let message = """
        New Record
        Date: \(dateFormatter.string(from: record.timestamp ?? Date()))
        Meal: \(record.mealType ?? "Unknown")
        Glucose: \(record.glucoseLevel )
        Food: \(record.food ?? "GGG")
        """

        let urlString = "https://api.telegram.org/bot\(botToken)/sendMessage"
        guard let url = URL(string: urlString) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let jsonData = [
            "chat_id": chatID,
            "text": message
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: jsonData, options: [])
        } catch {
            print("Error creating JSON data: \(error)")
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error sending message to Telegram bot: \(error)")
            }
        }.resume()
    }
}
