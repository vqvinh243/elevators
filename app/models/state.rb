class State
	include Ruby::Enum
	define :ONMOVE, "ONMOVE"
	define :WAITING, "WAITING"
	define :IDLE, "IDLE"
	define :UNDERMAINTENANCE, "UNDERMAINTENANCE"
end