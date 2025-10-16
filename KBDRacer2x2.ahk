#Requires AutoHotkey v2.0

#SingleInstance Force

A_MaxHotkeysPerInterval := 200

;*=============-------*;
;* Auto-Execute BEGIN *;
;*--------------------*;

;? For using "vJoyMMFServer.exe"

#Include "Internal\Daemon\vJoyDaemon.ahk"

#Include "Internal\01-Globals.ahk"

#Include "Internal\02-Init.ahk"

;*------------------*;
;* Auto-Execute END *;
;*=============-----*;

#Include "Internal\03-Functions.ahk"

#Include "Internal\04-Hotkeys.ahk"

;! Build me. Now.

