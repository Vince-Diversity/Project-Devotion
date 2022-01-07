extends Resource
class_name BattleDialog

export(String, "TimelineDropdown") var timeline: String
export(String) var event_id
export(String) var event_user_name
export(String) var event_target_name
export(Array, String) var required_names # These have to be in the scene tree
