import React from 'react';
import {useState} from 'react';
import {
  SafeAreaView,
  ScrollView,
  StatusBar,
  StyleSheet,
  Text,
  useColorScheme,
  View,
  Button,
  NativeModules,
  ActivityIndicator,
} from 'react-native';
import ProfileJSI from 'react-native-turbo-module-test';
import {Colors, Header} from 'react-native/Libraries/NewAppScreen';
NativeModules.ProfileJsiOld.jsinstall();

function str2ab(str) {
  var buf = new ArrayBuffer(str.length * 2 + 2); // 2 bytes for each char
  var bufView = new Uint16Array(buf);
  for (var i = 0, strLen = str.length; i < strLen; i++) {
    bufView[i] = str.charCodeAt(i);
  }
  bufView[strLen] = 0;
  return buf;
}

declare function methodWithXYZ(x: number, y: number, z: number): number;
declare function methodWithString(string: string): string;
declare function methodWithBigData(data: number[]): any;
declare function methodWithStringAsArrayBuffer(
  arraybuffer: ArrayBuffer,
): string;
declare function methodWithBigDataArrayBuffer(arraybuffer: ArrayBuffer): void;

function measure(name: string, action: () => void) {
  const start = (global as any).performance.now();

  action();

  const stop = (global as any).performance.now();
  const result = `${stop - start} ms (${name})`;
  console.log(result);
  return result;
}

const App = () => {
  const isDarkMode = useColorScheme() === 'dark';

  const [runNumber, setRunNumber] = useState<number>(0);
  const [results, setResults] = useState<string[]>([]);
  const [isProfiling, setIsProfiling] = useState<boolean>(false);

  const backgroundStyle = {
    backgroundColor: isDarkMode ? Colors.darker : Colors.lighter,
  };

  const runProfile = async () => {
    if (isProfiling) {
      return;
    }
    setIsProfiling(true);
    setRunNumber(prev => prev + 1);
    await new Promise<void>(resolve => requestAnimationFrame(() => resolve()));

    const newResults = [];

    newResults.push(
      measure('Primitives', function () {
        for (var i = 0; i < 1e6; i++) {
          methodWithXYZ(i, i, i);
        }
      }),
    );

    newResults.push(
      measure('Strings', () => {
        const strings = [];

        for (var i = 0; i < 100; i++) {
          strings.push('abcdefghijklmnopqrstuvwxyz' + i);
        }

        for (var i = 0; i < 100000; i++) {
          methodWithString(strings[i % strings.length]);
        }
      }),
    );

    newResults.push(
      measure('Big data marshalling', () => {
        const array = [];

        for (var i = 0; i < 1 << 16; i++) {
          array.push(i);
        }

        for (var i = 0; i < 200; i++) {
          methodWithBigData(array);
        }
      }),
    );

    newResults.push(
      measure('Strings with arraybuffer', () => {
        const strings = [];

        for (var i = 0; i < 100; i++) {
          strings.push(str2ab('abcdefghijklmnopqrstuvwxyz' + i.toString()));
        }

        for (var i = 0; i < 100000; i++) {
          methodWithStringAsArrayBuffer(strings[i % strings.length]);
        }
      }),
    );

    newResults.push(
      measure('Big data marshalling with arraybuffer', () => {
        const array = new Uint8Array(1 << 16);

        for (var i = 0; i < 1 << 16; i++) {
          array[i] = i;
        }

        for (var i = 0; i < 200; i++) {
          methodWithBigDataArrayBuffer(array.buffer);
        }
      }),
    );

    newResults.push(
      measure('Primitives TurboModule', function () {
        for (var i = 0; i < 1e6; i++) {
          ProfileJSI.methodWithXYZ(i, i, i);
        }
      }),
    );

    newResults.push(
      measure('Strings TurboModule', () => {
        const strings = [];

        for (var i = 0; i < 100; i++) {
          strings.push('abcdefghijklmnopqrstuvwxyz' + i);
        }

        for (var i = 0; i < 100000; i++) {
          ProfileJSI.methodWithString(strings[i % strings.length]);
        }
      }),
    );

    newResults.push(
      measure('Big data marshalling TurboModule', () => {
        const array = [];

        for (var i = 0; i < 1 << 16; i++) {
          array.push(i);
        }

        for (var i = 0; i < 200; i++) {
          ProfileJSI.methodWithBigData(array);
        }
      }),
    );

    setResults(newResults);
    setIsProfiling(false);
  };

  return (
    <SafeAreaView style={backgroundStyle}>
      <StatusBar barStyle={isDarkMode ? 'light-content' : 'dark-content'} />
      <ScrollView
        contentInsetAdjustmentBehavior="automatic"
        style={backgroundStyle}>
        <Header />
        <View
          style={{
            backgroundColor: isDarkMode ? Colors.black : Colors.white,
          }}>
          <Button
            title="Run profile"
            onPress={runProfile}
            disabled={isProfiling}
          />
          <ActivityIndicator animating={isProfiling} hidesWhenStopped={true} />
          <Text style={styles.results} selectable>
            {results.join('\n')}
          </Text>
        </View>
      </ScrollView>
    </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  sectionContainer: {
    marginTop: 32,
    paddingHorizontal: 24,
  },
  sectionTitle: {
    fontSize: 24,
    fontWeight: '600',
  },
  sectionDescription: {
    marginTop: 8,
    fontSize: 18,
    fontWeight: '400',
  },
  highlight: {
    fontWeight: '700',
  },
  results: {
    marginTop: 24,
    paddingHorizontal: 12,
  },
});

export default App;
