#Requires AutoHotkey v2.0

;*==========-------*;
;* Functions BEGIN *;
;*-----------------*;

ReadAndCleanIniValue(file, section, key, defaultValue) {

    local rawValue := IniRead(file, section, key, defaultValue)

    local standardizedValue := StrReplace(rawValue, "#", ";")

    local valueParts := StrSplit(standardizedValue, ";")

    Return Trim(valueParts[1])
}

LoadProfile() {

    Global g_config

    local mainConfigFile := A_ScriptDir "\config.ini", profileDir := A_ScriptDir "\Profiles\"

    local mode := ReadAndCleanIniValue(mainConfigFile, "Settings", "UpdateMode", g_config["UpdateMode"])

    local profileFilename := ReadAndCleanIniValue(mainConfigFile, "Settings", "ActiveProfile", "default.ini")

    local profileFullPath := profileDir . profileFilename

    if !FileExist(profileFullPath) {

        MsgBox("Profile not found: " . profileFullPath, "Profile Error", 16)

        g_config["UpdateMode"] := mode

    } else {

        g_config["UpdateMode"] := ReadAndCleanIniValue(profileFullPath, "Tuning", "UpdateMode", mode)
    }

    for key, defaultValue in g_config {

        if (key != "UpdateMode") {

            g_config[key] := ReadAndCleanIniValue(profileFullPath, "Tuning", key, defaultValue)
        }
    }

    ToolTip("Loaded Profile: " . profileFilename . " (" . g_config["UpdateMode"] . " mode)")

    SetTimer(() => ToolTip(), -2000)

    if (g_config["UpdateMode"] = "Stream") {

        SetTimer(UpdateLoop, g_config["TIMER_INTERVAL"])

    } else {

        SetTimer(UpdateLoop, 0)
    }
}

RemapPercent(axis, value) {

    Global g_config

    if (axis = "X") {

        local deadzone := g_config["SteeringOuterDeadzonePercent"]

        Return deadzone + ((100 - (2 * deadzone)) * (value / 100))

    } else if (axis = "Ry") {

        local max := g_config["AccelOuterDeadzoneMaxPercent"]

        Return value * (max / 100)

    } else if (axis = "Rx") {

        local max := g_config["BrakeOuterDeadzoneMaxPercent"]

        Return value * (max / 100)
    }

    Return value
}

ACCELERATE(percentage) {

    Global g_config, g_axisState, g_axisTarget

    local remappedValue := RemapPercent("Ry", percentage)

    if (g_config["UpdateMode"] = "Stream") {

        g_axisTarget["Ry"] := remappedValue

    } else {

        g_axisState["Ry"] := remappedValue

        SendCurrentAxisState()
    }
}

BRAKE(percentage) {

    Global g_config, g_axisState, g_axisTarget

    local remappedValue := RemapPercent("Rx", percentage)

    if (g_config["UpdateMode"] = "Stream") {

        g_axisTarget["Rx"] := remappedValue

    } else {

        g_axisState["Rx"] := remappedValue

        SendCurrentAxisState()
    }
}

STEER(percentage) {

    Global g_config, g_axisState, g_axisTarget, g_steering

    if (percentage = 0) {

        g_steering := false

    } else {

        g_steering := true
    }

    local value := 50 + (percentage / 2)

    local remappedValue := RemapPercent("X", value)

    if (g_config["UpdateMode"] = "Stream") {

        g_axisTarget["X"] := remappedValue

    } else {

        g_axisState["X"] := remappedValue

        SendCurrentAxisState()
    }
}

SendCurrentAxisState() {

    Global g_axisState, g_loggingEnabled, g_logFile

    local X_axisPercentage := Round(g_axisState["X"])

    local Rx_axisPercentage := Round(g_axisState["Rx"])

    local Ry_axisPercentage := Round(g_axisState["Ry"])

    local commandString := Format(

    "--axis-name X --percent {1}" . " " .
    "--axis-name Rx --percent {2}" . " " .
    "--axis-name Ry --percent {3}" . " "
        ,
    X_axisPercentage,
    Rx_axisPercentage,
    Ry_axisPercentage
    )

    if (g_loggingEnabled) {

        FileAppend(A_TickCount . "," . commandString . "`n", g_logFile)
    }

    Daemon_sendCommand(commandString)
}

UpdateLoop() {

    Global g_axisState, g_axisTarget

    Interpolate("X", g_axisTarget["X"])

    Interpolate("Rx", g_axisTarget["Rx"])

    Interpolate("Ry", g_axisTarget["Ry"])

    SendCurrentAxisState()
}

Interpolate(axisName, targetValue) {

    Global g_config, g_axisState

    local factor

    if (axisName = "X") {

        factor := g_config["STEER_FACTOR"]

    } else if (axisName = "Rx") {

        factor := g_config["BRAKE_FACTOR"]

    } else if (axisName = "Ry") {

        factor := g_config["ACCEL_FACTOR"]
    }

    local currentValue := g_axisState[axisName]

    local distance := targetValue - currentValue

    if (Abs(distance) < 0.1) {

        g_axisState[axisName] := targetValue

    } else {

        g_axisState[axisName] += distance * factor
    }
}

SetvJoyButtonState(buttonNumber, state) {

    Global g_loggingEnabled, g_logFile

    local command := Format("--button {1} --state {2}", buttonNumber, state)

    if (g_loggingEnabled) {

        FileAppend(A_TickCount . "," . command . "`n", g_logFile)
    }

    Daemon_sendCommand(command)
}

;*---------------*;
;* Functions END *;
;*==========-----*;

