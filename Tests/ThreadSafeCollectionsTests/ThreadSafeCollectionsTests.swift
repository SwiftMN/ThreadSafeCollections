import XCTest
@testable import ThreadSafeCollections

final class ThreadSafeCollectionsTests: XCTestCase {
  
  func testMap() {
    let m = ThreadSafeMap<Int, Int>()
    (0...99).forEach { i in
      m.put(i, i)
      XCTAssertEqual(i, m.get(i))
      m.removeValue(forKey: i)
      XCTAssertNil(m.get(i))
      m[i] = i
      XCTAssertEqual(i, m[i])
    }
    XCTAssertEqual(100, m.count())
    let items = m.getAll()
    m.removeAll()
    XCTAssertEqual(0, m.count())
    m.putAll(items)
    XCTAssertEqual(100, m.count())
  }
  
  func testList() {
    let m = ThreadSafeList<Int>()
    (0...99).forEach { i in
      m.append(i)
      XCTAssertEqual(i, m.get(i))
      let removed = m.remove(at: i)
      XCTAssertEqual(removed, i)
      XCTAssertNil(m.get(i))
      m[i] = i
      XCTAssertEqual(i, m[i])
    }
    XCTAssertEqual(100, m.count())
    let items = m.getAll()
    m.removeAll()
    XCTAssertEqual(0, m.count())
    m.append(contentsOf: items)
    XCTAssertEqual(100, m.count())
    XCTAssertTrue(m.contains(where: { $0 == 5 }))
    XCTAssertEqual(5, m.first(where: { $0 == 5 }))
    m.removeAll(where: { $0 == 5 })
    XCTAssertFalse(m.contains(where: { $0 == 5 }))
    XCTAssertNil(m.first(where: { $0 == 5 }))
  }
  
}
