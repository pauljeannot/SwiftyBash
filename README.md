![SwiftyBash Logo](/swiftybash.png)

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

You can pipe output and input stream easily :

```swift
let ls = BashCmd("ls", from:"~/")
let grep = BashCmd("grep", args:"root")

// Use pipe() function
let result = try! ls.pipe(grep).run()

// Or use the | custom operator 😻
let result = try! (ls | grep).run()
```

### 🔥 Error handling

SwiftyBash uses Swift exception to handle error, by throwing a BashException.

```swift
let grep = BashCmd("grep", args:"hosts", "/private/etc/*")
do {
  try grep.run()
}
catch {
  if let error = error as? BashException
    print(error.stderr) // Prints STDERR
    print(error.stdout) // Prints STDOUT
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
try! (cat | grep).run(.file("secrets.json"))
```

#### Whitespaces trimming
```swift
let ls = CmdBash("ls")
let wc = CmdBash("wc", args:"-l")

let result = try! (ls | wc).run(.string(.whiteSpacesTrimmed)) // result is `       6`
let result = try! (ls | wc).run(.string(.raw)) // result is `6`
```
