![SwiftyBash Logo : When Bash meets Swift](/swiftybash.png)

![Swift 4.1 Badge](https://img.shields.io/badge/Swift-4.1-brightgreen.svg)
[![Travis Badge](https://travis-ci.org/pauljeannot/SwiftyBash.svg?branch=master)](https://travis-ci.org/pauljeannot/SwiftyBash)
![Plateform](https://img.shields.io/badge/Plateform-Mac%20%26%20Linux-lightgrey.svg)

SwiftyBash is a Swift Bash scripting &amp; piping library, written in Swift.

## 🤖 Usage

### 🚀 Simple bash command

Describe your command through a `BashCmd` object, and run it! It is that simple :

```swift
// Run `ls` in the executable directory
let ls = BashCmd("ls")
let result = try! ls.run()

// Run `git status` from ~/MyProject directory
let status = BashCmd("git", args:"status", from:"~/MyProject")
let result = try! status.run()
```

### 🤝 Pipe

You can pipe output and input stream easily, as many times as you want !

```swift
let ls = BashCmd("ls", args:"-l", from:"~/")
let grep = BashCmd("grep", args:"root")
let wc = BashCmd("wc", args:"-l")

// Use pipe() function
let result = try! ls.pipe(grep).pipe(wc).run()
```

#### Custom operator

You can use the `|` to pipe from a command to another 😻

⚠️ You have to declare the operator somewhere in your project to be able to use it !

```swift
// Operator declaration somewhere in your project
infix operator |

// Have fun ! How beautiful is it ?
let result = try! (ls | grep | wc).run()
```

### 🔥 Error handling

SwiftyBash uses Swift exception to handle error, by throwing a BashException.

```swift
let grep = BashCmd("grep", args:"hosts", "/private/etc/*")
do {
  try grep.run()
}
catch {
  if let error = error as? BashException {
    print(error.stderr) // Prints STDERR
    print(error.stdout) // Prints STDOUT
  }
}

```

### ✏️ Output type

You can chose the output type between a simple `String` or to write the output into a file.
Default is `.string(.raw)`.

#### Write into a file
```swift
let cat = BashCmd("cat", args:"file.json")
let grep = BashCmd("grep", args:"'secrets'")

// Write the result into `secrets.json`
try! (cat | grep).run(outputType:.file("secrets.json"))
```

#### Whitespaces trimming
```swift
let ls = BashCmd("ls", args:"-l")
let wc = BashCmd("wc", args:"-l")

let result = try! (ls | wc).run(outputType:.string(.raw))                 // result is `       6`
let result = try! (ls | wc).run(outputType:.string(.whiteSpacesTrimmed))  // result is `6`
```

#### Example of output

When taking the output as a string or to a file, new lines (`\n`) are kept. So, here is an example of output :

```swift
let ls = BashCmd("ls", args:"-l")
let result = try! ls.run()
print(result!)
```
*... shows ...*
```bash
total 24
-rw-r--r--+ 1 me  staff  331 12 nov 23:33 Package.resolved
-rw-r--r--+ 1 me  staff  743 12 nov 23:19 Package.swift
-rw-r--r--+ 1 me  staff   50 12 nov 23:02 README.md
drwxr-xr-x+ 3 me  staff  102 12 nov 23:02 Sources
drwxr-xr-x+ 2 me  staff   68 12 nov 23:02 Tests
```

## 🚧 Installation

SwiftyBash is currently only available for **Swift 4**. If you need Swift 3 compatibility, feel free to open an issue or to create a Pull Request 😉

### 📦 Swift Package Manager

Update your Package.swift file by adding this line to your dependencies :

```swift
    dependencies: [
      [...]
      .package(url: "https://github.com/pauljeannot/SwiftyBash.git", from: "1.0.0"),
    ]
```

Do not forget to also add it to your target dependencies :

```swift
    targets: [
        .target(
            name: "YourProject",
            dependencies: ["...", "SwiftyBash"]),
    ]
```

## 👤 Contact

If you have any question, new idea or if you find a bug (❌), feel free to open an issue or to contact me by [email](paul.jeannot95@gmail.com).
