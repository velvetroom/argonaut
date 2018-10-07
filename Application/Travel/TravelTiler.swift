import MapKit

class TravelTiler:MKTileOverlay {
    var url = FileManager.default.urls(for:.documentDirectory, in:.userDomainMask)[0].appendingPathComponent("map")
    
    init() {
        super.init(urlTemplate:"{z}_{x}_{y}")
        canReplaceMapContent = true
        tileSize = CGSize(width:256, height:256)
    }
    
    override func loadTile(at path:MKTileOverlayPath, result:@escaping(Data?, Error?) -> Void) {
        result(try? Data(contentsOf:url.appendingPathComponent("\(url(forTilePath:path).path).png")), nil)
    }
}
