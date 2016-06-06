package;

import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.input.mouse.FlxMouseEventManager;

class Tile extends FlxSprite
{
	static var types = ["Grassland tile 128x128.png", "Sea tile 128x128.png", "Dessertland tile 128x128.png", "Rockland tile 128x128.png", "Town NW tile 128x128.png", "Town NE tile 128x128.png", "Town SE tile 128x128.png", "Town SW tile 128x128.png","WaterCalm tile 128x128.png","Undiscovered tile 128x128.png","TownGrassland tile 128x128.png"];
	public var tileInv : Array <Int> = new Array();
	var discovered : Bool = false;
	var type: String = types[1];
	public var instanceID: Int = 0;
	
	public function new(tiletype:Int) 
	{
		super();
		
		type = types[tiletype];
		updateTile(); //sets correct image for (un)discovered tiles
		
		tileInv.push(0); // test adding water to inventory
		FlxMouseEventManager.add(this, onDown, null, null, null);
		
	}
	
	private function onDown(sprite:FlxSprite)
	{
		var player  = PlayState.instance.player;
		
		if (FlxMath.distanceBetween(player,this)==128 && this.type != "Sea tile 128x128.png" && this.type != "WaterCalm tile 128x128.png" && player.actionPoints>0)
		{
			player.moveTo(this);
			player.actionPoints -= 1;
			
			//trace(this.discovered);
			
			this.discovered = true;
			PlayState.instance.map.tiles[this.instanceID + 1].discovered = true;
			PlayState.instance.map.tiles[this.instanceID + 1].updateTile();
			PlayState.instance.map.tiles[this.instanceID - 1].discovered = true;
			PlayState.instance.map.tiles[this.instanceID - 1].updateTile();
			PlayState.instance.map.tiles[this.instanceID + 44].discovered = true;
			PlayState.instance.map.tiles[this.instanceID + 44].updateTile();
			PlayState.instance.map.tiles[this.instanceID - 44].discovered = true;
			PlayState.instance.map.tiles[this.instanceID - 44].updateTile();
			updateTile();
		}
		
	}
	function updateTile()
	{
		PlayState.instance.remove(this);
		if (type == "Town NW tile 128x128.png" || type == "Town NE tile 128x128.png" || type == "Town SE tile 128x128.png" || type == "Town SW tile 128x128.png" || type == "TownGrassland tile 128x128.png")
		{
			loadGraphic("assets/images/tiles/" + type);
			this.discovered = true;
		} else if (discovered == true)
		{
			loadGraphic("assets/images/tiles/" + type);
		} else if (discovered == false)
		{
			loadGraphic("assets/images/tiles/Undiscovered tile 128x128.png");
		}
		PlayState.instance.add(this);
	}
	public function genRandomResource()
	{
		if (this.type != "Town NW tile 128x128.png" && this.type != "Town NE tile 128x128.png" && this.type != "Town SE tile 128x128.png"  && this.type != "Town SW tile 128x128.png")
			{
				Resource.instance.generateRandomResource();
				if (Resource.instance.generatedResource == 0 || Resource.instance.generatedResource == 1 || Resource.instance.generatedResource == 2 || Resource.instance.generatedResource == 3 || Resource.instance.generatedResource == 4 || Resource.instance.generatedResource == 5)
				{
					tileInv.push(Resource.instance.generatedResource);
					trace("tile inventory " + tileInv);
				}
				Resource.instance.generatedResource = null;
			}
	}
	public function harvestResource()
	{
		
	}
}
