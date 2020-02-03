import XCTest

@testable import Architecture

final class CasePathTests: XCTestCase {

  func testExtractFromSimpleEnum() {
    struct MyError: Error, Equatable {}

    XCTAssertEqual(extractHelp(case: Result<Int, Error>.success, from: .success(42)), 42)
    XCTAssertEqual(extractHelp(case: Result<Int, Error>.failure, from: .failure(MyError())), MyError())

    XCTAssertEqual((/Result<Int, Error>.success).extract(.success(42)), 42)
    XCTAssertEqual((/Result<Int, Error>.failure).extract(.failure(MyError())), MyError())
    XCTAssertNil((/Result<Int, Error>.failure).extract(.success(42)))
    XCTAssertNil((/Result<Int, Error>.success).extract(.failure(MyError())))
  }

  func testExtractFromEnumWithLabel() {
    enum EnumWithLabeledCase {
      case labeled(label: Int)
    }

    let value = extractHelp(case: EnumWithLabeledCase.labeled, from: .labeled(label: 1))
    XCTAssertEqual(value, 1)

    XCTAssertEqual((/EnumWithLabeledCase.labeled).extract(.labeled(label: 42)), 42)
  }

  func testExtractFromEnumWithSameCaseName() {
    enum EnumWithLabeledCase {
      case labeled(label: Int)
      case labeled(anotherLabel: Int)
    }

    // Crash the compiler :(

//    var tmp = /EnumWithLabeledCase.labeled(anotherLabel:)
//    XCTAssertEqual(tmp.extract(.labeled(anotherLabel: 42)), 42)
//
//    tmp = /EnumWithLabeledCase.labeled(label:)
//    XCTAssertEqual(tmp.extract(.labeled(label: 10)), 10)

//    var value = extractHelp(case: EnumWithLabeledCase.labeled(label:),
//                            from: EnumWithLabeledCase.labeled(label: 1))
//    XCTAssertEqual(value, 1)
//
//    value = extractHelp(case: EnumWithLabeledCase.labeled(anotherLabel:),
//                        from: EnumWithLabeledCase.labeled(anotherLabel: 42))
//    XCTAssertEqual(value, 42)
  }
}
