import MapKit

class TravelTiler:MKTileOverlay {
    var url:URL!
    
    init() {
        super.init(urlTemplate:"{z}_{x}_{y}")
        canReplaceMapContent = true
        tileSize = CGSize(width:512, height:512)
    }
    
    override func loadTile(at path:MKTileOverlayPath, result:@escaping(Data?, Error?) -> Void) {
        result(try? Data(contentsOf:url!.appendingPathComponent("\(url(forTilePath:path).path).png")), nil)
    }
}
