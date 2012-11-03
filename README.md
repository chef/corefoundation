
CoreFoundation
==============

FFI based wrappers for a subset of core foundation: various bits of CFString, CFData, CFArray, CFDictionary are available. Not that useful on its own but a useful building block for writing ffi wrappers of other OS X libraries.

Although the CF collection classes can store arbitrary pointer sized values this wrapper only supports storing CFTypes.

The CF namespace has the raw FFI generated method calls but it's usually easier to use the wrapper classes: `CF::String`, `CF::Date`, `CF::Array`, `CF::Dictionary`, `CF::Boolean` which try to present a rubyish view of the world (for example `CF::Array` implements `Enumerable`)

These implement methods for creating new instances from ruby objects (eg `CF::String.from_string("hello world")`) but you can also pass build them from an `FFI::Pointer`).

Converting
===========

`CF::Base` objects has a `to_ruby` that creates a ruby object of the most approprite type (`String` for `CF::String`, `Time` for `CF::Date`, `Integer` or `Float` for `CF::Number` etc). The collection classes call `to_ruby` on their contents too.

In addition to the methods on the wrapper classes themselves, the ruby classes are extended with a `to_cf` method. Because CoreFoundation strings aren't arbitrary collections of bytes, `String#to_cf` will return a `CF::Data` if the string has the ASCII-8BIT encoding and a `CF::String` if not.

If you have an `FFI::Pointer` or a raw address then you can create a wrapper by passing it to `new`, for example `CF::String.new(some_pointer)`. This does *not* check that the pointer is actually a `CFString`. You can use `CF::Base.typecast` to construct an instance of the appropriate subclass, for example `CF::Base.typecast(some_pointer)` would return a `CF::String` if `some_pointer` was in fact a `CFStringRef`.

Memory Management
=================

The convenience methods for creating CF objects will release the cf object when they are garbage collected. Methods on the convenience classes will usually retain the result and mark it for releasing when they are garbage collected (for example `CF::Dictionary#[]` retains the returned value). You don't need to do any extra memory management on these.

If you pass an `FFI::Pointer` to `new` or `typecast` no assumptions are made for you. You should call `retain` or `release` to manage it manually. As an alternative to calling `release` manually,  the `release_on_gc` method adds a finalizer to the wrapper that will call `CFRelease` on the Core Foundation object when the wrapper is garbage collected. You will almost certainly crash your ruby interpreter if you overrelease an object and you will leak memory if you overretain one.

If you use the raw api (eg `CF.CFArrayCreate`) then you're on your own.


Compatibility
=============
Requires ruby 1.9 due to use of encoding related methods. Should work in MRI and jruby. Not compatible with rubinius due to rubinius' ffi implemenation not supporting certain features.

License
=======

Released under the MIT license. See LICENSE
