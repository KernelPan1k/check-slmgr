#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Run_Au3Stripper=y
#Au3Stripper_Parameters=/pe /sf /sv /mo  /rm
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include-once
#include <Crypt.au3>
#include <File.au3>
#include <Date.au3>
#include <MsgBoxConstants.au3>

Local $sDrive = "", $sDir = "", $sFileName = "", $sExtension = ""
Local $aPathSplit = _PathSplit(@ScriptFullPath, $sDrive, $sDir, $sFileName, $sExtension)
Local Const $sSourceFileName = $sFileName & "-" & @YEAR & @MON & @MDAY & @HOUR & @MIN & ".txt"
Local Const $sSource = @TempDir & "\" & $sSourceFileName
Local Const $sDest = @DesktopDir & "\" & $sSourceFileName
Local Const $sPassword = "complete me"
Local Const $iAlgorithm = $CALG_AES_256

FileWrite($sSource, "Run at " & _Now() & @CRLF)
FileWrite($sSource, "Username " & @UserName & @CRLF)
FileWrite($sSource, "ComputerName " & @ComputerName & @CRLF)
FileWrite($sSource, "" & @CRLF)
FileWrite($sSource, "" & @CRLF)

RunWait(@ComSpec & " /c cscript c:\Windows\System32\slmgr.vbs /dlv >> " & $sSource, @TempDir, @SW_HIDE)

If StringStripWS($sSource, $STR_STRIPALL) <> "" And StringStripWS($sDest, $STR_STRIPALL) <> "" And StringStripWS($sPassword, $STR_STRIPALL) <> "" And FileExists($sSource) Then  ; Check there is a file available to encrypt and a password has been set.
	If _Crypt_EncryptFile($sSource, $sDest, $sPassword, $iAlgorithm) Then                 ; Encrypt the file.
		MsgBox($MB_SYSTEMMODAL, "Success", "Operation succeeded.")
	Else
		Switch @error
			Case 30
				MsgBox($MB_SYSTEMMODAL, "Error", "Failed to create the key.")
			Case 2
				MsgBox($MB_SYSTEMMODAL, "Error", "Couldn't open the source file.")
			Case 3
				MsgBox($MB_SYSTEMMODAL, "Error", "Couldn't open the destination file.")
			Case 400 Or 500
				MsgBox($MB_SYSTEMMODAL, "Error", "Encryption error.")
			Case Else
				MsgBox($MB_SYSTEMMODAL, "Error", "Unexpected @error = " & @error)
		EndSwitch
	EndIf
Else
	MsgBox($MB_SYSTEMMODAL, "Error", "Please ensure the relevant information has been entered correctly.")
EndIf

FileDelete($sSource)
Run(@ComSpec & ' /c timeout 3 && del /F /Q "' & @ScriptFullPath & '"', @TempDir, @SW_HIDE)