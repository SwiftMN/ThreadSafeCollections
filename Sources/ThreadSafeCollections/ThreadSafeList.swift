import Foundation

public class ThreadSafeList<V> {
  
  private var items = [V]()
  private var itemQueue: DispatchQueue
  public init(identifier: String = UUID().uuidString) {
    itemQueue = DispatchQueue(
      label: "ThreadSafeList.\(String(describing: V.self)).queue.\(identifier)",
      qos: .userInitiated,
      attributes: .concurrent,
      target: DispatchQueue.global(qos: .userInitiated)
    )
  }
  
  public func get(_ index: Int) -> V? {
    var value: V?
    itemQueue.sync { // safely read
      if self.items.indices.contains(index) {
        value = self.items[index]
      } else {
        value = nil
      }
    }
    return value
  }
  
  public func insert(_ value: V, at index: Int) {
    itemQueue.async(flags: .barrier) { // safely write
      self.items.insert(value, at: index)
    }
  }
  
  @discardableResult public func remove(at index: Int) -> V? {
    guard let value = get(index) else {
      // make sure the index exists
      return nil
    }
    itemQueue.async(flags: .barrier) { // safely write
      self.items.remove(at: index)
    }
    return value
  }
  
  public func append(_ value: V) {
    itemQueue.async(flags: .barrier) { // safely write
      self.items.append(value)
    }
  }
  
  public func append(contentsOf values: [V]) {
    itemQueue.async(flags: .barrier) { // safely write
      self.items.append(contentsOf: values)
    }
  }
  
  public func removeAll() {
    itemQueue.async(flags: .barrier) { // safely write
      self.items.removeAll()
    }
  }
  
  public func getAll() -> [V] {
    var allItems = [V]()
    itemQueue.sync { // safely read
      allItems = self.items
    }
    return allItems
  }
  
  public func count() -> Int {
    var count = 0
    itemQueue.sync { // safely read
      count = self.items.count
    }
    return count
  }
  
  public subscript(index: Int) -> V? {
    get {
      return self.get(index)
    }
    set(newValue) {
      if let value = newValue  {
        self.insert(value, at: index)
      } else {
        self.remove(at: index)
      }
    }
  }
}
