//
//  Created by Artem Novichkov on 05.12.2024.
//
import SwiftUI
import CoreML

struct ContentView: View {

    enum Sentiment: String {
        case positive = "positive"
        case neutral = "neutral"
        case negative = "negative"

        var title: String {
            switch self {
            case .positive:
                return "👍"
            case .neutral:
                return "😐"
            case .negative:
                return "👎"
            }
        }
    }

    @State private var text: String = "Я закончил статью и очень рад"
    @State private var sentiment: Sentiment?

    var body: some View {
        NavigationView {
            TextEditor(text: $text)
                .padding()
                .navigationTitle("Sentiment Analysis")
                .navigationBarItems(trailing: Text(sentiment?.title ?? ""))
        }
        .onChange(of: text) {
            sentiment = sentiment(for: text)
        }
        .onAppear {
            sentiment = sentiment(for: text)
        }
    }

    // MARK: - Private

    private func sentiment(for text: String) -> Sentiment? {
        do {
            let classifier = try SentimentTextClassifier()
            let output = try classifier.prediction(text: text)
            return Sentiment(rawValue: output.label)
        }
        catch {
            print(error)
            return nil
        }
    }
}

#Preview {
    ContentView()
}
