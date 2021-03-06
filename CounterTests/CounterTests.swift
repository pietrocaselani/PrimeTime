import XCTest
import ArchitectureTestable
@testable import Counter

final class CounterTests: XCTestCase {
  func testIncrDecrButtonTapped() {
    assert(
      initialValue: CounterViewState(),
      reducer: counterViewReducer,
      steps:
      Step(.send, .counter(.incrTapped)) { $0.count = 1 },
      Step(.send, .counter(.incrTapped)) { $0.count = 2 },
      Step(.send, .counter(.decrTapped)) { $0.count = 1 }
    )
  }

  func testNthPrimeButtonHappyFlow() {
    Current.nthPrime = { _ in .sync { 17 } }

    assert(
      initialValue: CounterViewState(
        isNthPrimeButtonDisabled: false,
        alertNthPrime: nil
      ),
      reducer: counterViewReducer,
      steps:
      Step(.send, .counter(.nthPrimeButtonTapped)) {
        $0.isNthPrimeButtonDisabled = true
      },
      Step(.receive, .counter(.nthPrimeResponse(Result.success(17)))) {
        $0.alertNthPrime = PrimeAlert(title: "Prime", message: "The 0th prime is 17")
        $0.isNthPrimeButtonDisabled = false
      },
      Step(.send, .counter(.nthPrimeAlertDismissed)) {
        $0.alertNthPrime = nil
      }
    )
  }
}
