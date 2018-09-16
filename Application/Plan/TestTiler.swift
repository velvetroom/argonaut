import MapKit

class TestTiler:MKTileOverlay {
    init() {
        super.init(urlTemplate:"{x}.{y}.{z}")
        canReplaceMapContent = true
        tileSize = CGSize(width:512, height:512)
    }
    
    override func loadTile(at path:MKTileOverlayPath, result:@escaping(Data?, Error?) -> Void) {
        
        let location = url(forTilePath:path)
        print("path: \(path)")
        print("location: \(location)")
        result(try? Data(contentsOf:location), nil)
    }
}
