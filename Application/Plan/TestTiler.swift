import MapKit

class TestTiler:MKTileOverlay {
    var url:URL?
    
    init() {
        super.init(urlTemplate:"{z}_{x}_{y}")
        canReplaceMapContent = true
        tileSize = CGSize(width:512, height:512)
    }
    
    override func loadTile(at path:MKTileOverlayPath, result:@escaping(Data?, Error?) -> Void) {
        let location = url(forTilePath:path)
        result(try? Data(contentsOf:url!.appendingPathComponent("\(location.path).png")), nil)
    }
}
