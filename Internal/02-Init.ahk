#Requires AutoHotkey v2.0

;*=====--------*;
;* Init BEGIN  *;
;*-------------*;

if (!Daemon_Init()) {

    MsgBox("Fatal error connecting to vJoyMMFServer.", "Connection Error", 16)

    ExitApp
}

ToolTip("KBDRacer2x2: Definitive Edition - Initialized")

SetTimer(() => ToolTip(), -2000)

Daemon_sendCommand("--axis-name X --percent 50 --axis-name Rx --percent 0 --axis-name Ry --percent 0")

SetvJoyButtonState(1, "u")

LoadProfile()

if (g_config["UpdateMode"] = "Stream") {

    SetTimer(UpdateLoop, g_config["TIMER_INTERVAL"])
}

Return 

;*=====------*;
;* Init END  *;
;*-----------*;

