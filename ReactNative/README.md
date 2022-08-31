To Run:

* Prerequisites: [React Native development environment setup](https://reactnative.dev/docs/environment-setup)

```
ns clean
ns run ios 
```

Tap 'Run Benchmarks' button.

## Metrics

* "react-native": "0.69.3"
* Hermes with Fabric enabled

### Simulators (Debug)

* Xcode 13.4, iOS 15.5 iPhone 13 Pro Simulator
* Run on a Mac M1 Max (macOS 12.3.1) with 64 GB Memory

|   | Primitives  | Strings  | Big data marshalling  |
|---|---|---|---|
| Run 1  | 1361ms  | 215ms  | 1427ms  |
| Run 2  | 1372ms  | 211ms  | 1421ms  |
| Run 3  | 1387ms  | 212ms  | 1429ms  |


### Release Mode (Production)

* iOS 15.5 iPhone 13 Pro Device

|   | Primitives  | Strings  | Big data marshalling  |
|---|---|---|---|
| Run 1  | 1359ms  | 186ms  | 812ms  |
| Run 2  | 1362ms  | 189ms  | 824ms  |
| Run 3  | 1359ms  | 188ms  | 815ms  |


