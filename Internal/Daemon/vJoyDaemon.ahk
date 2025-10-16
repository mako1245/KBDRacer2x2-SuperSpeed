;*============-------*;
;* vJoy Daemon BEGIN *;
;*-------------------*;

#Requires AutoHotkey v2.0

;* --- Global STATE FOR THE DAEMON LIBRARY ---

Global g_DaemonPID := 0
Global g_hMapFile := 0
Global g_pMapView := 0
Global g_hEvent := 0

;* --- FUNCTIONS ---

Daemon_Init() {

    Global g_DaemonPID, g_hMapFile, g_pMapView, g_hEvent

    local workingDir := A_ScriptDir '\vJoyMMFServer'
    local serverExePath := workingDir '\vJoyMMFServer.exe'
    
    local tempPID := 0
    Run(serverExePath, workingDir, "Hide", &tempPID)
    g_DaemonPID := tempPID
    
    Sleep(1000)

    g_hMapFile := DllCall("OpenFileMapping", "UInt", 0x000F001F, "Int", false, "Str", "VJoyCommandBus", "UPtr")
    g_pMapView := DllCall("MapViewOfFile", "UPtr", g_hMapFile, "UInt", 0x000F001F, "UInt", 0, "UInt", 0, "UPtr", 0, "UPtr")
    g_hEvent := DllCall("OpenEvent", "UInt", 0x001F0003, "Int", false, "Str", "VJoyCommandEvent", "UPtr")

    if !(g_pMapView && g_hEvent) {
    
        MsgBox("FATAL: Failed to connect to vJoyMMFServer daemon. Exiting.", "Connection Error", 48)

        ExitApp
    }
    
    OnExit(Daemon_Shutdown)

    Return true
}

Daemon_sendCommand(commandString) {

    Global g_pMapView, g_hEvent

    if !(g_pMapView && g_hEvent) {

        Return
    }

    local requiredSize := StrPut(commandString, "UTF-8")
    local utf8Buffer := Buffer(requiredSize)
    StrPut(commandString, utf8Buffer, "UTF-8")

    NumPut("Int", requiredSize - 1, g_pMapView, 0)
    DllCall("RtlMoveMemory", "UPtr", g_pMapView + 4, "Ptr", utf8Buffer, "UPtr", requiredSize - 1)
    DllCall("SetEvent", "UPtr", g_hEvent)
}

Daemon_Shutdown(*) {

    Global g_DaemonPID, g_hMapFile, g_pMapView, g_hEvent

    if (g_pMapView) {

        DllCall("UnmapViewOfFile", "UPtr", g_pMapView)
    }

    if (g_hMapFile) {
    
        DllCall("CloseHandle", "UPtr", g_hMapFile)
    }

    if (g_hEvent) {
    
        DllCall("CloseHandle", "UPtr", g_hEvent)
    }
    
    if (g_DaemonPID && ProcessExist(g_DaemonPID)) {
    
        ProcessClose(g_DaemonPID)
    }
}

;*-----------------*;
;* vJoy Daemon END *;
;*============-----*;

