#Requires AutoHotkey v2.0

;*========-------*;
;* Globals BEGIN *;
;*---------------*;

Global g_config := Map(
    "UpdateMode", "Event",
    "TIMER_INTERVAL", 16, ;? 16ms
    "ACCEL_FACTOR", 0.30,
    "BRAKE_FACTOR", 0.30,
    "STEER_FACTOR", 0.30,
    "FullThrottlePercent", 100,
    "PartialThrottlePercent", 70,
    "LowThrottlePercent", 30,
    "FullBrakePercent", 100,
    "PartialBrakePercent", 70,
    "HardSteerAngle", 80,
    "EasySteerAngle", 40,
    "InitialTurnInAngle", 20,
    "CounterSteerAngle", 20,
    "SteeringOuterDeadzonePercent", 0,
    "AccelOuterDeadzoneMaxPercent", 100,
    "BrakeOuterDeadzoneMaxPercent", 100
)

Global g_keyState := Map(
    "E", false,
    "R", false,
    "F", false,
    "Space", false,
    "J", false,
    "I", false,
    "O", false
)

Global g_axisState := Map(
    "X", 50,
    "Y", 50,
    "Z", 50,
    "Rx", 0,
    "Ry", 0,
    "Rz", 50,
    "sl0", 0,
    "sl1", 0
)

Global g_axisTarget := Map(
    "X", 50,
    "Y", 50,
    "Z", 50,
    "Rx", 0,
    "Ry", 0,
    "Rz", 50,
    "sl0", 0,
    "sl1", 0
)

Global g_steering := false

Global g_easySteeringMode := false

Global g_loggingEnabled := false

Global g_logFile := "vjoy_definitive_log.txt"

;*========-----*;
;* Globals END *;
;*-------------*;

