import { Observable } from "@nativescript/core";

type IViewLabels = Array<{ label: string; benchmark: string }>;
let viewLabels: IViewLabels;

function measure(name: string, action: () => void) {
  const start = (global as any).performance.now();

  action();

  const stop = (global as any).performance.now();
  console.log(`${stop - start} ms (${name})`);
  viewLabels.push({
    label: name,
    benchmark: `${stop - start} ms`,
  });
}

export class HelloWorldModel extends Observable {
  testFixtures: TestFixtures;
  viewLabels: IViewLabels;

  constructor() {
    super();
    this.testFixtures = TestFixtures.alloc().init();
  }

  onTap() {
    setTimeout(() => {
      // on tick after the tap provides a cleaner stack trace when profiling
      this.runProfiling();
    });
  }

  private runProfiling() {
    viewLabels = [];

    measure("Primitives", () => {
      for (var i = 0; i < 1e6; i++) {
        this.testFixtures.methodWithXYZ(i, i, i);
      }
    });

    measure("Strings", () => {
      const strings = [];

      for (var i = 0; i < 100; i++) {
        strings.push("abcdefghijklmnopqrstuvwxyz" + i);
      }

      for (var i = 0; i < 100000; i++) {
        this.testFixtures.methodWithString(strings[i % strings.length]);
      }
    });

    measure("Big data marshalling", () => {
      const array = [];

      for (var i = 0; i < 1 << 16; i++) {
        array.push(i);
      }

      for (var i = 0; i < 200; i++) {
        this.testFixtures.methodWithBigData(array);
      }
    });

    this.viewLabels = viewLabels;
    this.notifyPropertyChange("viewLabels", viewLabels);
  }
}
