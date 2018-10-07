import XCTest
@testable import Argonaut

class TestImages:XCTestCase {
    private var map:Map!
    
    override func setUp() {
        Factory.storage = MockStorage.self
        map = Map()
        map.path = URL(fileURLWithPath:NSTemporaryDirectory()).appendingPathComponent("test")
        map.zooms = [Zoom(2)]
    }
    
    override func tearDown() {
        try? FileManager.default.removeItem(at:map.path)
    }
    
    func testCropImage() {
        let image = makeImage(width:10, height:10)
        let result = map.crop(image:image, rect:CGRect(x:0, y:0, width:1, height:1))
        XCTAssertEqual(144, image.pngData()!.count)
        XCTAssertEqual(81, map.crop(image:image, rect:CGRect(x:0, y:0, width:1, height:1)).pngData()!.count)
        XCTAssertEqual(81, result.pngData()!.count)
        XCTAssertEqual(1, result.size.width)
        XCTAssertEqual(1, result.size.height)
    }
    
    func testMakeTiles() {
        map.builder = Builder()
        map.builder.url = map.path.appendingPathComponent("test")
        try! FileManager.default.createDirectory(at:map.builder.url, withIntermediateDirectories:true)
        map.makeTiles(shot:Shot(tileX:1, tileY:1, zoom:Zoom(10)), image:makeImage(width:2560, height:2560))
        for y in 0 ..< 10 {
            for x in 0 ..< 10 {
                let image = UIImage(data:
                    try! Data(contentsOf:map.builder.url.appendingPathComponent("10_\(1 + x)_\(1 + y).png")), scale:1)
                XCTAssertEqual(256, image?.size.width)
                XCTAssertEqual(256, image?.size.height)
                XCTAssertEqual(256, image?.cgImage?.width)
                XCTAssertEqual(256, image?.cgImage?.height)
            }
        }
    }
    
    private func makeImage(width:Double, height:Double) -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width:width, height:height))
        let image = UIImage(cgImage:UIGraphicsGetCurrentContext()!.makeImage()!)
        UIGraphicsEndImageContext()
        return image
    }
}
