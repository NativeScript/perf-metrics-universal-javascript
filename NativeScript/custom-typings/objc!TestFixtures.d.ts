
declare class TestFixtures extends NSObject {

	static alloc(): TestFixtures; // inherited from NSObject

	static new(): TestFixtures; // inherited from NSObject

	methodWithBigData(array: NSArray<any> | any[]): UIImage;

	methodWithString(aString: string): string;

	methodWithXYZ(x: number, y: number, z: number): number;

	methodWithX(x: number): number;
}
