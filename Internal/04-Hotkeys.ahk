#Requires AutoHotkey v2.0

;*========-------*;
;* Hotkeys BEGIN *;
;*---------------*;

;* Ctrl+F5 to change/refresh car profile

^F5:: { ;? "Ctrl"+"F5"

    LoadProfile()
}

;? Ctrl+F6 to start/stop "vJoy Device #1" command logging

; ^F6:: { ;? "Ctrl"+"F6"

;     Global g_loggingEnabled, g_logFile

;     g_loggingEnabled := !g_loggingEnabled

;     ToolTip("Logging " . (g_loggingEnabled ? "Enabled" : "Disabled"))

;     SetTimer(() => ToolTip(), -2000)

;     if (g_loggingEnabled) {

;         FileAppend("--- New Definitive Log Session Started at " . A_Now . " ---`n", g_logFile)
;     }
; }

;* --- Accelerator ---

*~r:: { ;? "R" key down

    g_keyState["R"] := true

    if (g_axisState["Rx"] < g_config["FullBrakePercent"]) {

        if (g_keyState["I"]) {

            if (g_keyState["J"]) {

                ACCELERATE(g_config["FullThrottlePercent"])

            } else {

                ACCELERATE(g_config["PartialThrottlePercent"])
            }
        } else {

            ACCELERATE(g_config["FullThrottlePercent"])
        }
    } else {

        ACCELERATE(0)
    }
}

*i:: { ;? "I" key down

    g_keyState["I"] := true

    if (g_keyState["R"] or g_easySteeringMode) {

        ACCELERATE(0)

    } else if (!g_keyState["R"] and g_axisState["Rx"] < g_config["FullBrakePercent"]) {

        ACCELERATE(g_config["LowThrottlePercent"])
    }
}

*r up:: { ;? "R" key up

    g_keyState["R"] := false

    Global g_steering, g_easySteeringMode, g_config

    if (g_steering) {

        g_easySteeringMode := true

        if (g_axisState["Rx"] < g_config["FullBrakePercent"]) {

            ACCELERATE(g_config["FullThrottlePercent"])
        }

        if (g_keyState["E"]) {

            STEER(-g_config["HardSteerAngle"])

        } else if (g_keyState["F"]) {

            STEER(g_config["HardSteerAngle"])
        }
    }

    if (g_keyState["I"]) {

        if (g_axisState["Rx"] > 0) {

            ACCELERATE(0)

        } else {

            ACCELERATE(g_config["LowThrottlePercent"])
        }
    } else {

        if (!g_easySteeringMode) {

            ACCELERATE(0)
        }
    }
}

*i up:: { ;? "I" key up

    g_keyState["I"] := false

    Global g_config

    if (g_keyState["R"] and g_axisState["Rx"] < g_config["FullBrakePercent"]) {

        ACCELERATE(g_config["FullThrottlePercent"])

    } else if (g_easySteeringMode and g_axisState["Rx"] < g_config["FullBrakePercent"]) {

        ACCELERATE(g_config["FullThrottlePercent"])

    } else {

        ACCELERATE(0)
    }
}

;* --- Brakes ---

*j:: { ;? "J" key press

    g_keyState["J"] := true

    if (g_keyState["O"]) {

        BRAKE(g_config["FullBrakePercent"])

    } else {

        BRAKE(g_config["PartialBrakePercent"])
    }
}

*j up:: { ;? "J" key unpress

    g_keyState["J"] := false

    if (g_keyState["O"]) {

        BRAKE(g_config["FullBrakePercent"])

    } else {

        BRAKE(0)
    }
}

*o:: { ;? "O" key press

    g_keyState["O"] := true

    BRAKE(g_config["FullBrakePercent"])

    if (g_axisState["Ry"] > 0) {

        ACCELERATE(0)
    }
}

*o up:: { ;? "O" key unpress

    g_keyState["O"] := false

    Global g_config

    if (g_keyState["J"]) {

        BRAKE(g_config["PartialBrakePercent"])

    } else {

        BRAKE(0)
    }

    if (g_easySteeringMode and !g_keyState["I"]) {

        ACCELERATE(g_config["FullThrottlePercent"])

    } else if (g_keyState["R"] and !g_keyState["I"]) {

        ACCELERATE(g_config["FullThrottlePercent"])

    } else if (g_keyState["I"]) {

        ACCELERATE(0)
    }
}

;* --- Steering ---

*e:: { ;? "E" key press

    g_keyState["E"] := true

    Global g_config

    if (g_axisState["Ry"] == g_config["FullThrottlePercent"]) {

        if (g_keyState["F"]) {

            STEER(g_config["CounterSteerAngle"])

        } else {

            if (!g_steering) {

                STEER(-g_config["InitialTurnInAngle"])

            } else {

                STEER(-g_config["HardSteerAngle"])
            }
        }
    } else {
        if (g_keyState["F"]) {
            STEER(0)
        } else {
            STEER(-g_config["HardSteerAngle"])
        }
    }
}

*e up:: { ;? "E" Key unpress

    g_keyState["E"] := false

    Global g_easySteeringMode, g_config

    if (g_keyState["F"]) {

        if (g_axisState["Ry"] > 0) {

            STEER(g_config["HardSteerAngle"])

        } else {

            STEER(g_config["EasySteerAngle"])
        }

    } else {

        STEER(0)

        if (!g_keyState["R"]) {

            g_easySteeringMode := false

            if (!g_keyState["I"]) {

                ACCELERATE(0)
            }
        }
    }
}

*f:: { ;? "F" key press

    g_keyState["F"] := true

    Global g_config

    if (g_axisState["Ry"] == g_config["FullThrottlePercent"]) {

        if (g_keyState["E"]) {

            STEER(-g_config["CounterSteerAngle"])

        } else {

            if (!g_steering) {

                STEER(g_config["InitialTurnInAngle"])

            } else {

                STEER(g_config["HardSteerAngle"])
            }
        }
    } else {

        if (g_keyState["E"]) {

            STEER(0)

        } else {

            STEER(g_config["HardSteerAngle"])
        }
    }
}

*f up:: { ;? "F" key unpress

    g_keyState["F"] := false

    Global g_easySteeringMode, g_config

    if (g_keyState["E"]) {

        if (g_axisState["Ry"] > 0) {

            STEER(-g_config["HardSteerAngle"])

        } else {

            STEER(-g_config["EasySteerAngle"])
        }
    } else {

        STEER(0)

        if (!g_keyState["R"]) {

            g_easySteeringMode := false

            if (!g_keyState["I"]) {

                ACCELERATE(0)
            }
        }
    }
}

;* --- Handbrake ---

*Space:: { ;? "Space" key press

    g_keyState["Space"] := true

    SetvJoyButtonState(1, "p")
}

*Space up:: { ;? "Space" key unpress

    g_keyState["Space"] := false

    SetvJoyButtonState(1, "u")
}

;*========-----*;
;* Hotkeys END *;
;*-------------*;

