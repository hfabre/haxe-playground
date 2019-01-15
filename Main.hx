enum Direction {
  Left;
  Right;
  Top;
  Bottom;
}

class Body {
    public var x : Int;
    public var y : Int;
    public var width : Int;
    public var height : Int;

    public function new(x, y, width, height) {
        this.x = x;
        this.y = y;
        this.width = height;
        this.height = height;
    }
}

class AABB {
    public static function is_colliding(main_body: Body, other_body: Body, side_by_side = true) {
        var p1x = Math.max(main_body.x, other_body.x);
        var p1y = Math.max(main_body.y, other_body.y);
        var p2x = Math.max(main_body.x + main_body.width, other_body.x + other_body.width);
        var p2y = Math.max(main_body.y + main_body.height, other_body.y + other_body.height);

        if (side_by_side && p2x - p1x >= 0 && p2y - p1y >= 0) {
            return true;
        } else if (!side_by_side && (p2x - p1x) > 0 && (p2y - p1y) > 0)  {
            return true;
        } else {
            return false;
        }
    }

    public static function collision_direction(main_body: Body, other_body: Body) {
        var left = (main_body.x + main_body.width) - other_body.x;
        var right = (other_body.x + other_body.width) - main_body.x;
        var bottom = (main_body.y + main_body.height) - other_body.y;
        var top = (other_body.y + other_body.height) - main_body.y;

        if (right < left && right < top && right < bottom) {
            return Right;
        } else if (left < top && left < bottom) {
            return Left;
        } else if (top < bottom) {
            return Top;
        } else {
            return Bottom;
        }
        
    }
}

class PhysicalObject {
    public var x : Int;
    public var y : Int;
    public var width : Int;
    public var height : Int;
    public var color: Int;
    public var body : Body;
    public var tile : h2d.Tile;
    public var bmp : h2d.Bitmap;

    public function new(x, y, color, s2d) {
        this.x = x;
        this.y = y;
        this.width = 100;
        this.height = 100;
        this.color = color;
        this.body = new Body(x, y, this.width, this.height);
        this.tile = h2d.Tile.fromColor(color, this.width, this.height);
        this.bmp = new h2d.Bitmap(this.tile, s2d);
        this.bmp.x = x;
        this.bmp.y = y;
    }

    public function move_x() {
        this.x += 1;
    }

    public function update(dt: Float) {
        update_childs_position();
    }

    private function update_childs_position() {
        this.body.x = this.x;
        this.body.y = this.y;

        this.bmp.x = this.x;
        this.bmp.y = this.y;
    }
}
    
class Main extends hxd.App {
    var player : PhysicalObject;
    var ground : PhysicalObject;

    override function init() {
        player = new PhysicalObject(0, 0, 0xFF0000, s2d);
        ground = new PhysicalObject(600, 0, 0x00FF00, s2d);
    }

    // on each frame
    override function update(dt:Float) {
        player.move_x();
        player.update(dt);

        if (AABB.is_colliding(player.body, ground.body)) {
            trace(AABB.collision_direction(player.body, ground.body));
        } else {
            trace("no collision");
        }
    }

    static function main() {
        new Main();
    }
}