# swinsian-track-grabber

[trackupdate](https://github.com/grahams/trackupdate), the python application I wrote for logging tracks I play on [grahams' completely normal radio programme](radio.dosburros.com), presently uses subprocess to call `osascript` to run some Applescript to fetch track information.

After encountering some weird hang issues, I thought it MAY be better to write a binary to use ScriptingBridge.

This is the first real swift code i've ever written, it probably sucks and has a bunch of copypasta.

AFAICT it runs both as a script via `swift main.swift` and should compile to a binary with `swiftc -o swinsian-track-grabber main.swift`

Will emit some JSON to stdout
