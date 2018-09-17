import XCTest
@testable import Argonaut

class TestImages:XCTestCase {
    private var map:Map!
    
    override func setUp() {
        map = Map()
    }
    
    func testCropImage() {
        let image = makeImage(width:100, height:100)
        let result = map.crop(image:image, rect:CGRect(x:0, y:0, width:1, height:1))
        XCTAssertEqual(510, image.pngData()!.count)
        XCTAssertEqual(83, map.crop(image:image, rect:CGRect(x:0, y:0, width:1, height:1)).pngData()!.count)
        XCTAssertEqual(83, result.pngData()!.count)
        XCTAssertEqual(1, result.size.width)
        XCTAssertEqual(1, result.size.height)
    }
    
    func testMakeTiles() {
        let images = map.makeTiles(image:makeImage(width:2560, height:2560))
        XCTAssertEqual(100, images.count)
        images.forEach { image in
            XCTAssertEqual(256, image.size.width)
            XCTAssertEqual(256, image.size.height)
        }
    }
    
    private func makeImage(width:Double, height:Double) -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width:width, height:height))
        UIGraphicsGetCurrentContext()!.setFillColor(UIColor.black.cgColor)
        UIGraphicsGetCurrentContext()!.fill(CGRect(x:0, y:0, width:100, height:100))
        let image = UIImage(cgImage:UIGraphicsGetCurrentContext()!.makeImage()!)
        UIGraphicsEndImageContext()
        return image
    }
}
