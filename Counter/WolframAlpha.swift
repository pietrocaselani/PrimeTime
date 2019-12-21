import Architecture
import Foundation
import RxSwift

private let wolframAlphaApiKey = "6H69Q3-828TKQJ4EP"

struct WolframAlphaResult: Decodable {
  let queryresult: QueryResult

  struct QueryResult: Decodable {
    let pods: [Pod]

    struct Pod: Decodable {
      let primary: Bool?
      let subpods: [SubPod]

      struct SubPod: Decodable {
        let plaintext: String
      }
    }
  }
}

func nthPrime(_ n: Int) -> Effect<Int> {
  return wolframAlpha(query: "prime \(n)").flatMap { result -> Observable<Int> in
    guard let value = wolframAlphaResultToInt(result) else { return Observable.empty() }
    return Observable.just(value)
  }.eraseToEffect()
}

private func wolframAlphaResultToInt(_ result: WolframAlphaResult) -> Int? {
  let text = result
    .queryresult
    .pods
    .first { $0.primary == .some(true) }?
    .subpods
    .first?
    .plaintext

  return text.flatMap(Int.init)
}

func wolframAlpha(query: String) -> Effect<WolframAlphaResult> {
  var components = URLComponents(string: "https://api.wolframalpha.com/v2/query")!
  components.queryItems = [
    URLQueryItem(name: "input", value: query),
    URLQueryItem(name: "format", value: "plaintext"),
    URLQueryItem(name: "output", value: "JSON"),
    URLQueryItem(name: "appid", value: wolframAlphaApiKey),
  ]

  guard let request = (components.url.map { URLRequest.init(url: $0) }) else { return Effect.empty().eraseToEffect() }

  return URLSession.shared.rx
    .data(request: request)
    .map { try JSONDecoder().decode(WolframAlphaResult.self, from: $0) }
    .eraseToEffect()
}
