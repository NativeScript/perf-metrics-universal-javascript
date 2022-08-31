To Run:

* Prerequisites: [NativeScript development environment setup](https://docs.nativescript.org/environment-setup.html)

```
ns clean
ns run ios 
```

Tap 'Run Benchmarks' button.

## Metrics

* "@nativescript/core": "8.3.3"
* "@nativescript/ios": "8.3.3"

### Simulators (Debug)

* Xcode 13.4, iOS 15.5 iPhone 13 Pro Simulator
* Run on a Mac M1 Max (macOS 12.3.1) with 64 GB Memory

|   | Primitives  | Strings  | Big data marshalling  |
|---|---|---|---|
| Run 1  | 289ms  | 57ms  | 1052ms  |
| Run 2  | 298ms  | 58ms  | 1048ms  |
| Run 3  | 304ms  | 59ms  | 1061ms  |


### Release Mode (Production)

* iOS 15.5 iPhone 13 Pro Device

|   | Primitives  | Strings  | Big data marshalling  |
|---|---|---|---|
| Run 1  | 258ms  | 49ms  | 1010ms  |
| Run 2  | 262ms  | 52ms  | 1014ms  |
| Run 3  | 261ms  | 54ms  | 1012ms  |



