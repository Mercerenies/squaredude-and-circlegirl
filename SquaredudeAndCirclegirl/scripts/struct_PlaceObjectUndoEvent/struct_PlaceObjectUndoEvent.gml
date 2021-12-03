
function PlaceObjectUndoEvent(_obj, _xx, _yy, _zz, _facing_dir) : UndoEvent() constructor {
  obj = _obj;
  xx = _xx;
  yy = _yy;
  zz = _zz;
  facing_dir = _facing_dir; // Optional

  static run = function() {
    if (obj.getX() >= 0) {
      obj_World.setAt(obj.getX(), obj.getY(), obj.getZ(), undefined);
    }
    obj_World.setAt(xx, yy, zz, obj);
    if (!is_undefined(facing_dir)) {
      obj.setFacingDir(facing_dir);
    }
  }

}
