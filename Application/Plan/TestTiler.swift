import MapKit

class TestTiler:MKTileOverlay {
    var url:URL?
    
    init() {
        super.init(urlTemplate:"{z}.{x}.{y}")
        canReplaceMapContent = true
        tileSize = CGSize(width:512, height:512)
    }
    
    override func loadTile(at path:MKTileOverlayPath, result:@escaping(Data?, Error?) -> Void) {
        
        let location = url(forTilePath:path)
        print("path: \(path)")
        print("location: \(location)")
        print("composed: \(url!.appendingPathComponent(location.path))")
        result(try? Data(contentsOf:url!.appendingPathComponent(location.path)), nil)
    }
}
