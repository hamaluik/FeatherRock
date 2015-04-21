import luxe.importers.tiled.TiledMap;
import luxe.options.TilemapOptions;
import luxe.tilemaps.Ortho;
import luxe.tilemaps.Tilemap;
import phoenix.geometry.Geometry;
import phoenix.geometry.QuadPackGeometry;
import phoenix.Rectangle;
import phoenix.Texture;
import phoenix.Vector;

class StaticTiledmap extends TiledMap {
	override public function display(options:TilemapVisualOptions) {
        switch(orientation) {
            case TilemapOrientation.ortho :
                visual = new StaticOrthoVisual( this, options );
            case TilemapOrientation.isometric :
                throw "StaticTiledmap does not support isometric maps at this time!";
            case TilemapOrientation.none :
        } //orientation
    } //display
} // StaticTiledmap

class StaticOrthoVisual extends TilemapVisual {
	public override function create() {
		super.create();

		var _map_scaled_tw = map.tile_width * options.scale;
		var _map_scaled_th = map.tile_height * options.scale;

		var first:Bool = true;
		//for(layer in map) {
		var layer = map.layers_ordered[2]; {
			var _layer_geom:TilemapVisualLayerGeometry = [];

			// brute-force-find the bloody texture
			var tileset = null;
			var tilesetTexture:Texture = null;
			for(y in 0...map.height) {
				for(x in 0...map.width) {
					var tile = layer.tiles[y][x];
					var ts = map.tileset_from_id( tile.id );
					if(ts != null && ts.texture != null) {
						tileset = ts;
						tilesetTexture = ts.texture;
						break;
					}
				}
				if(tilesetTexture != null) {
					break;
				}
			}
			// it damned well better be there
			if(tileset == null) throw "Null tileset, wtf?!";
			if(tileset.texture == null) throw "Null texture, wtf?!";

			var _scaled_tilewidth = tileset.tile_width*options.scale;
			var _scaled_tileheight = tileset.tile_height*options.scale;

			var _offset_x = 0;
			var _offset_y = _scaled_tileheight - _map_scaled_th;

			// create a quad-pack for the geometry
			var geom:QuadPackGeometry = new QuadPackGeometry({
				pos: map.pos,
				texture: (tileset != null) ? tileset.texture : null,
				depth: options.depth,
				group: options.group,
				visible: options.visible,
				batcher: options.batcher
			});

			// loop through each tile, adding a packing quad for it
			for(y in 0...map.height) {
				for(x in 0...map.width) {
					var uvRect:Rectangle = null;
					var tile = layer.tiles[y][x];

					if(tileset != null && tileset.texture != null) {

						var image_coord:Vector = tileset.pos_in_texture(tile.id);
						if(image_coord.x >= 0 && image_coord.y >= 0) {
							uvRect = new Rectangle(
	                            tileset.margin + ((image_coord.x * tileset.tile_width) + (image_coord.x * tileset.spacing)),
	                            tileset.margin + ((image_coord.y * tileset.tile_height) + (image_coord.y * tileset.spacing)),
	                            tileset.tile_width ,
	                            tileset.tile_height
							);
						}
					}

					if(first && uvRect != null) {
						trace({
				            x: map.pos.x + (tile.x * _map_scaled_tw) - (_offset_x),
				            y: map.pos.y + (tile.y * _map_scaled_th) - (_offset_y),
							w: _map_scaled_tw,
							h: _map_scaled_th,
							uv: uvRect
						});
						first = false;
					}

					geom.quad_add({
			            x: map.pos.x + (tile.x * _map_scaled_tw) - (_offset_x),
			            y: map.pos.y + (tile.y * _map_scaled_th) - (_offset_y),
						w: _map_scaled_tw,
						h: _map_scaled_th,
						uv: uvRect
					});
				} // for each column
			} // for each row
			geom.locked = true;
			_layer_geom.push([geom]);
		} // for each layer
	}

	override function update_tile_id( _geom:Geometry, _layer_name:String, _x:Int, _y:Int, _id:Int ) {
		throw "Not implemented yet";
	}

	override function create_tile_for_layer( layer:TileLayer, x:Int, y:Int ):Geometry {
		throw "Not implemented, don't call!";
	}
} // StaticOrthVisual