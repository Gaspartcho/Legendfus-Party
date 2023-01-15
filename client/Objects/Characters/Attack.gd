extends Resource


#region Variables

#exports variables
export var name: String
export var cost: int

export var is_capacity: bool = false # If it is a capacity, then he only can apply this to itself.
export var is_global: bool = false # If it is global, then it applys to all his enemies, if it is global and a capacity, it applys to all his allies and himself

export var real_damage: int
export var shield_damage: int
export var movement_boost: int

export var poison_duration: int = 0 # If the attack is not a "poison" attack, leave as 0

export var attack_range: PoolVector2Array
export var nb_amunitions: int = 1

export var symbol: ImageTexture
export var attack_frames: SpriteFrames
export var attack_sound: AudioStreamMP3

#scene objects



#others



#unused variable
var _unused

#endregion