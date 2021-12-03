
// This singleton designates the end of an undo "event". When the undo
// manager hits one of these, it stops backtracking.
#macro UndoCut global.__singleton_UndoCut
UndoCut = {};
