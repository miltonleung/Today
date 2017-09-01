import Foundation
import BrightFutures

internal typealias JSON = [String: Any]
internal typealias JSONArray = [JSON]

internal protocol Parser {
    associatedtype Input
    associatedtype Output
    func parse(_: Input) -> Output?
}

extension Parser {
    func parse(_ input: Input) -> Future<Output, NSError> {
        guard let value = parse(input) else {
            return Future(error: ParsingError.standard.error)
        }
        return Future(value: value)
    }
}
