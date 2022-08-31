import type { TurboModule } from 'react-native';
import { TurboModuleRegistry } from 'react-native';

export interface Spec extends TurboModule {
  //readonly getConstants: () => {};

  // your module methods go here, for example:
  methodWithXYZ(x: Int32, y: Int32, z: Int32): Int32;
  methodWithString(string: string): string;
  methodWithBigData(data: Array<Int32>): void;

}

export default TurboModuleRegistry.get<Spec>('ProfileJsi');
