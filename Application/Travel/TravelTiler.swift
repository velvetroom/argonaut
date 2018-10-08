import MapKit

class TravelTiler:MKTileOverlay {
    var url = FileManager.default.urls(for:.documentDirectory, in:.userDomainMask)[0].appendingPathComponent("map")
    private let fallback = #imageLiteral(resourceName: "iconTile.pdf").pngData()!
    
    init() {
        super.init(urlTemplate:"{z}_{x}_{y}")
        canReplaceMapContent = true
        tileSize = CGSize(width:256, height:256)
    }
    
    override func loadTile(at path:MKTileOverlayPath, result:@escaping(Data?, Error?) -> Void) {
        if let data = try? Data(contentsOf:url.appendingPathComponent("\(url(forTilePath:path).path).png")) {
            result(data, nil)
        } else {
            result(fallback, nil)
        }
    }
}
