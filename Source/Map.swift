import MapKit

public class Map {
    let directory = FileManager.default.urls(
        for:.documentDirectory, in:.userDomainMask)[0].appendingPathComponent("maps")
    
    public func create(rect:Rect, success:@escaping(URL) -> Void, fail:@escaping(Error) -> Void) {
        let url = directory.appendingPathComponent("a")
        try! FileManager.default.createDirectory(at:url, withIntermediateDirectories:true)
        success(url)
    }
}
