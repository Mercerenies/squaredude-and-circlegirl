
function SetElementEvent(_owner, _element) : UndoEvent() constructor {
   owner = _owner;
   element = _element;

  static run = function() {
    owner.setActiveElement(element);
  }

}