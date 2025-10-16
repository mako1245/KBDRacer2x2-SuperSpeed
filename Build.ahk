#Requires AutoHotkey v2.0
#SingleInstance force

;* ============================================================
;* KBDRacer2x2 - AHKv2 Build Script (The Final Architecture v2)
;* ============================================================

;* === CONFIGURATION ===
projectName := "KBDRacer2x2"
versionString := "v1.0.0"
keyboardLayout := "TurkishQ" ;? "QWERTY", "TurkishQ"
finalExeName := projectName "-" versionString "-" keyboardLayout ".exe"
baseExeName := "AutoHotkey64.exe"

;* === SCRIPT START ===
try {
    MsgBox "Starting build...", "Build System", "T1"

    ;* 1. First, read the main script content.
    mainScriptContent := FileRead(A_ScriptDir "\KBDRacer2x2.ahk", "UTF-8")

    ;* 2. Pre-process the main script to inline all #Includes.
    stitchedCode := PreProcessSource(mainScriptContent)
    
    ;* 3. Now, apply layout replacements to the *entire* stitched codebase.
    finalCode := ApplyLayoutReplacements(stitchedCode, keyboardLayout)
    
    tempFile := A_Temp "\Test_build.ahk"
    iconFile := A_ScriptDir "\Resources\Icons\KBDRacer2x2-SuperSpeed.ico"
    outputFile := A_ScriptDir "\" . finalExeName
    
    if FileExist(tempFile)
        FileDelete(tempFile)
    FileAppend(finalCode, tempFile, "UTF-8")

    CompileScript(tempFile, outputFile, iconFile, baseExeName)

    if FileExist(tempFile)
        FileDelete(tempFile)
        
    MsgBox "Build successful!`n" . outputFile, "Build System"
}
catch as e {
    MsgBox "Build failed: `n`n" . e.Message, "Build System", "Icon!"
}
ExitApp

;* === HELPER FUNCTIONS ===

PreProcessSource(mainContent) {
    local mainFileDir := A_ScriptDir
    local processedCode := mainContent
    local includeRegex := 'i)#Include\s+"([^"]+)"'
    loop {
        if RegExMatch(processedCode, includeRegex, &match) {
            local absolutePath := mainFileDir "\" . match[1]
            if !FileExist(absolutePath)
                throw Error("#Include file not found: " . absolutePath)
            local includedContent := FileRead(absolutePath, "UTF-8")
            local pos := InStr(processedCode, match[0])
            local len := StrLen(match[0])
            processedCode := SubStr(processedCode, 1, pos - 1) . includedContent . SubStr(processedCode, pos + len)
        } else {
            break
        }
    }
    return processedCode
}

ApplyLayoutReplacements(sourceCode, layout) {
    if (layout == "QWERTY")
        return sourceCode
    local sourceLayoutDir := A_ScriptDir "\Layouts\KBDUS", targetLayoutDir := A_ScriptDir "\Layouts\KBDTUQ"
    local modifiedCode := sourceCode
    Loop Files, sourceLayoutDir "\*.ahk" {
        searchString := Trim(FileRead(A_LoopFileFullPath, "UTF-8"))
        replacementFilePath := StrReplace(A_LoopFileFullPath, sourceLayoutDir, targetLayoutDir)
        replacementString := Trim(FileRead(replacementFilePath, "UTF-8"))
        modifiedCode := StrReplace(modifiedCode, searchString, replacementString)
    }
    return modifiedCode
}

CompileScript(inputFile, outputFile, iconFile, baseName) {
    local installDir := RegRead("HKCU\SOFTWARE\AutoHotkey", "InstallDir")
    local compilerPath := installDir . "\Compiler\Ahk2Exe.exe"
    local baseFilePath := installDir . "\v2\" . baseName
    if !FileExist(compilerPath)
        throw Error("Compiler not found.")
    if !FileExist(baseFilePath)
        throw Error("Base EXE not found.")
    local command := Format('"{1}" /in "{2}" /out "{3}" /icon "{4}" /base "{5}"', 
        compilerPath, inputFile, outputFile, iconFile, baseFilePath)
    
    ;* The compiler must run from a directory where it can find the #Includes if they weren't inlined.
    ;* Since we are inlining everything, the working directory is less critical, but setting it
    ;* to the compiler's own directory is the most robust practice.
    SplitPath(compilerPath, , &compilerDir)
    local result := RunWait(command, compilerDir, "Hide")
    
    if (result != 0)
        throw Error("Compiler failed with exit code: " . result)
}

