//  Copyright (c) 2015 Rob Rix. All rights reserved.

import Foundation

/// A type that can represent either failure with an error or success with a result value.
public protocol ResultType {
    associatedtype Value
    associatedtype Error: Swift.Error
    
    /// Constructs a successful result wrapping a `value`.
    init(value: Value)
    
    /// Constructs a failed result wrapping an `error`.
    init(error: Error)
    
    /// Case analysis for ResultType.
    ///
    /// Returns the value produced by appliying `ifFailure` to the error if self represents a failure, or `ifSuccess` to the result value if self represents a success.
    func analysis<U>(ifSuccess: (Value) -> U, ifFailure: (Error) -> U) -> U
}

public extension ResultType {
    /// Returns the value if self represents a success, `nil` otherwise.
    var value: Value? {
        return analysis(ifSuccess: { $0 }, ifFailure: { _ in nil })
    }
    
    /// Returns the error if self represents a failure, `nil` otherwise.
    var error: Error? {
        return analysis(ifSuccess: { _ in nil }, ifFailure: { $0 })
    }
}

/// An enum representing either a failure with an explanatory error, or a success with a result value.
public enum Result<T, Error: Swift.Error>: ResultType, CustomStringConvertible, CustomDebugStringConvertible {
    case success(T)
    case failure(Error)
    
    // MARK: Constructors
    
    /// Constructs a success wrapping a `value`.
    public init(value: T) {
        self = .success(value)
    }
    
    /// Constructs a failure wrapping an `error`.
    public init(error: Error) {
        self = .failure(error)
    }
    
    /// Constructs a result from an Optional, failing with `Error` if `nil`
    public init(_ value: T?, failWith: @autoclosure () -> Error) {
        self = value.map(Result.success) ?? .failure(failWith())
    }
    
    /// Constructs a result from a function that uses `throw`, failing with `Error` if throws
    public init(_ f: @autoclosure () throws -> T) {
        do {
            self = .success(try f())
        } catch {
            self = .failure(error as! Error)
        }
    }
    
    // MARK: Deconstruction
    
    /// Returns the value from `Success` Results or `throw`s the error
    public func dematerialize() throws -> T {
        switch self {
        case let .success(value):
            return value
        case let .failure(error):
            throw error
        }
    }
    
    /// Case analysis for Result.
    ///
    /// Returns the value produced by applying `ifFailure` to `Failure` Results, or `ifSuccess` to `Success` Results.
    public func analysis<Result>(ifSuccess: (T) -> Result, ifFailure: (Error) -> Result) -> Result {
        switch self {
        case let .success(value):
            return ifSuccess(value)
        case let .failure(value):
            return ifFailure(value)
        }
    }
    
    // MARK: Higher-order functions
    
    /// Returns a new Result by mapping `Success`es’ values using `transform`, or re-wrapping `Failure`s’ errors.
    public func map<U>(_ transform: (T) -> U) -> Result<U, Error> {
        return flatMap { .success(transform($0)) }
    }
    
    /// Returns the result of applying `transform` to `Success`es’ values, or re-wrapping `Failure`’s errors.
    public func flatMap<U>(_ transform: (T) -> Result<U, Error>) -> Result<U, Error> {
        return analysis(
            ifSuccess: transform,
            ifFailure: Result<U, Error>.failure)
    }
    
    /// Returns `self.value` if this result is a .Success, or the given value otherwise. Equivalent with `??`
    public func recover(_ value: @autoclosure () -> T) -> T {
        switch self {
        case let .success(value):
            return value
        default:
            return value()
        }
    }
    
    /// Returns this result if it is a .Success, or the given result otherwise. Equivalent with `??`
    public func recoverWith(_ result: @autoclosure () -> Result<T,Error>) -> Result<T,Error> {
        return analysis(
            ifSuccess: { _ in self },
            ifFailure: { _ in result() })
    }
    
    /// Transform a function from one that uses `throw` to one that returns a `Result`
    //	public static func materialize<T, U>(f: T throws -> U) -> T -> Result<U, ErrorType> {
    //		return { x in
    //			do {
    //				return .Success(try f(x))
    //			} catch {
    //				return .Failure(error)
    //			}
    //		}
    //	}
    
    // MARK: Errors
    
    /// The domain for errors constructed by Result.
    public static var errorDomain: String { return "com.antitypical.Result" }
    
    /// The userInfo key for source functions in errors constructed by Result.
    public static var functionKey: String { return "\(errorDomain).function" }
    
    /// The userInfo key for source file paths in errors constructed by Result.
    public static var fileKey: String { return "\(errorDomain).file" }
    
    /// The userInfo key for source file line numbers in errors constructed by Result.
    public static var lineKey: String { return "\(errorDomain).line" }

    // MARK: CustomStringConvertible
    
    public var description: String {
        return analysis(
            ifSuccess: { ".Success(\($0))" },
            ifFailure: { ".Failure(\($0))" })
    }
    
    // MARK: CustomDebugStringConvertible
    
    public var debugDescription: String {
        return description
    }
}

extension Result {
    // Return the value if it's a .Success or throw the error if it's a .Failure
    func resolve() throws -> T {
        switch self {
        case Result.success(let value): return value
        case Result.failure(let error): throw error
        }
    }
    
    // Construct a .Success if the expression returns a value or a .Failure if it throws
    init(f: () throws -> T) {
        do    { self = .success(try f()) }
        catch { self = .failure(error as! Error) }
    }
}
