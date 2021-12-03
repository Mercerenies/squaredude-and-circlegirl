
function SetActivePlayerEvent(_index) : UndoEvent() constructor {
   index = _index;

  static run = function() {
    obj_World.setChannelIndex(index);
  }

}