import Foundation

class A: NSObject {
    @objc func doSomething(_ val: Bool) { print("A did something: \(val)") }
}
class B: A {}

let b = B()
let sel = #selector(A.doSomething(_:))
if b.responds(to: sel) {
    let imp = b.method(for: sel)
    typealias FuncType = @convention(c) (NSObject, Selector, Bool) -> Void
    let function = unsafeBitCast(imp, to: FuncType.self)
    function(b, sel, false)
}
