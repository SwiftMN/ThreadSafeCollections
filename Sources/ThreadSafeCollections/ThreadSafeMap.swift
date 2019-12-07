import Foundation

public class ThreadSafeMap<K: Hashable, V> {
  
  private var items = [K: V]()
  private var itemQueue: DispatchQueue
  
  public init(identifier: String = UUID().uuidString) {
    itemQueue = DispatchQueue(
      label: "ThreadSafeMap.\(String(describing: K.self)).\(String(describing: V.self)).queue.\(identifier)",
      qos: .userInitiated,
      attributes: .concurrent,
      target: DispatchQueue.global(qos: .userInitiated)
    )
  }
  
  public func get(_ key: K) -> V? {
    var value: V?
    itemQueue.sync { // safely read
      value = self.items[key]
    }
    return value
  }
  
  public func put(_ key: K, _ value: V?) {
    itemQueue.async(flags: .barrier) { // safely write
      self.items[key] = value
    }
  }
  
  public func removeAll() {
    itemQueue.async(flags: .barrier) { // safely write
      self.items.removeAll()
    }
  }
  
  public func removeValue(forKey key: K) {
    itemQueue.async(flags: .barrier) { // safely write
      self.items.removeValue(forKey: key)
    }
  }
  
  public func getAll() -> [K: V] {
    var allItems = [K: V]()
    itemQueue.sync { // safely read
      allItems = self.items
    }
    return allItems
  }
  
  public func putAll(_ allItems: [K: V]) {
    itemQueue.async(flags: .barrier) { // safely write
      self.items = allItems
    }
  }
  
  public subscript(key: K) -> V? {
    get {
      return self.get(key)
    }
    set(newValue) {
      self.put(key, newValue)
    }
  }
  
  public func count() -> Int {
    var count = 0
    itemQueue.sync { // safely read
      count = self.items.count
    }
    return count
  }
}
