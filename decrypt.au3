#include <ComboConstants.au3>
#include <Crypt.au3>
#include <GUIConstantsEx.au3>
#include <MsgBoxConstants.au3>
#include <StringConstants.au3>

Local Const $iAlgorithm = $CALG_AES_256
Local $hGUI = GUICreate("Decrypter fichier", 200, 80)
Local $idSourceBrowse = GUICtrlCreateButton("Chercher fichier", 10, 5, 180, 25)
Local $idDecrypt = GUICtrlCreateButton("Decrypt", 10, 40, 180, 25)
Local $sDestinationRead = @DesktopDir & "\slmgr-decrypted.txt"
Local $sPasswordRead = "iherwfoiherghoterhvtrgtrgtrgtrgtrgoterhgoterhgoterh"
Local $sSourceRead = ""
Local $iMsg

GUISetState(@SW_SHOW, $hGUI)

Do
	$iMsg = GUIGetMsg()
	Switch $iMsg
		Case $idSourceBrowse
			Local $sSourceRead = FileOpenDialog("S�lectionner un fichier � chiffrer.", "", "All files (*.*)")     ; S�lectionne un fichier � chiffrer.
			If @error Then
				ContinueLoop
			EndIf
		Case $idDecrypt
			MsgBox(0, "", $sSourceRead)

			If StringStripWS($sSourceRead, $STR_STRIPALL) <> "" And _
					StringStripWS($sDestinationRead, $STR_STRIPALL) <> "" And _
					StringStripWS($sPasswordRead, $STR_STRIPALL) <> "" And _
					FileExists($sSourceRead) Then ; V�rifie que le fichier � chiffrer existe et qu'un mot de passe a �t� d�fini.
				If _Crypt_DecryptFile($sSourceRead, $sDestinationRead, $sPasswordRead, $iAlgorithm) Then     ; Chiffre le fichier.
					MsgBox($MB_SYSTEMMODAL, "Succ�s", "Op�ration r�ussie.")
				Else
					Switch @error
						Case 2
							MsgBox($MB_SYSTEMMODAL, "Erreur", "Impossible d'ouvrir le fichier source.")
						Case 3
							MsgBox($MB_SYSTEMMODAL, "Erreur", "Impossible d'ouvrir le fichier de destination.")
						Case 30
							MsgBox($MB_SYSTEMMODAL, "Erreur", "Impossible de cr�er la cl�.")

						Case 400 Or 500
							MsgBox($MB_SYSTEMMODAL, "Erreur", "Erreur de d�chiffrement.")

						Case Else
							MsgBox($MB_SYSTEMMODAL, "Error", "Unexpected @error = " & @error)

					EndSwitch
				EndIf
			Else
				MsgBox($MB_SYSTEMMODAL, "Erreur", "Veuillez vous assurer que l'information appropri�e a �t� entr�e correctement.")
			EndIf
	EndSwitch
Until $iMsg = $GUI_EVENT_CLOSE

GUIDelete($hGUI)
Exit(0)
