import Async
import CodableKit

/// Converts encodable objects to LeafData.
public final class LeafEncoder {
    /// Create a new LeafEncoder.
    public init() {}

    /// Encode an encodable item to leaf data.
    public func encode(_ encodable: Encodable) throws -> LeafData {
        let encoder = _LeafEncoder()
        try encodable.encode(to: encoder)
        return encoder.partialData.context
    }
}

/// Internal leaf data encoder.
internal final class _LeafEncoder: Encoder {
    var codingPath: [CodingKey]
    var userInfo: [CodingUserInfoKey: Any]

    var partialData: PartialLeafData
    var context: LeafData {
        return partialData.context
    }

    init(partialData: PartialLeafData = .init(), codingPath: [CodingKey] = []) {
        self.partialData = partialData
        self.codingPath = codingPath
        self.userInfo = [:]
    }

    /// See Encoder.container
    func container<Key: CodingKey>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> {
        let keyed = LeafKeyedEncoder<Key>(
            codingPath: codingPath,
            partialData: partialData
        )
        return KeyedEncodingContainer(keyed)
    }

    /// See Encoder.unkeyedContainer
    func unkeyedContainer() -> UnkeyedEncodingContainer {
        return LeafUnkeyedEncoder(
            codingPath: codingPath,
            partialData: partialData
        )
    }

    /// See Encoder.singleValueContainer
    func singleValueContainer() -> SingleValueEncodingContainer {
        return LeafSingleValueEncoder(
            codingPath: codingPath,
            partialData: partialData
        )
    }
}

extension _LeafEncoder: StreamEncoder {
<<<<<<< HEAD
    func encodeStream<O : OutputStream>(_ stream: O) throws where O.Output == Encodable {
        self.partialData.set(to: .codableStream(stream), at: codingPath)
=======
    func encodeStream<O : OutputStream & ConnectionContext>(_ stream: O) throws where O.Output == Encodable {
        self.partialData.set(to: .stream(stream.encode()), at: codingPath)
>>>>>>> c74e1917551b9ffba8d09220bf08b7fd43a398b7
    }
}

extension _LeafEncoder: FutureEncoder {
    func encodeFuture<E>(_ future: Future<E>) throws {
        let future = future.map(to: LeafData.self) { any in
            guard let encodable = any as? Encodable else {
                throw LeafError(identifier: "not-encodable", reason: "The future found in data provided to Leaf's for rendering was not Encodable")
            }

            let encoder = _LeafEncoder(
                partialData: self.partialData,
                codingPath: self.codingPath
            )
            try encodable.encode(to: encoder)
            return encoder.context
        }
        
        self.partialData.set(to: .future(future), at: codingPath)
    }
}
