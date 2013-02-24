#include <ImageSearch.au3>
#include <Core.au3>
#include <Localvars.au3>
AutoItSetOption("MouseCoordMode", 1)
AutoItSetOption("TrayMenuMode", 1)

#Main and support window detection
WinWaitActive("[CLASS:l2UnrealWWindowsViewportWindow]")
$main = WinGetHandle("[ACTIVE]")
WinActivate("Program Manager")

WinWaitActive("[CLASS:l2UnrealWWindowsViewportWindow]")
$support = WinGetHandle("[ACTIVE]")
Sleep(1000)
WinSwitch()

#Coordinates and dimention detection 
GetClientCoords()
GetClientDimention()

#Obstacle bypass points
Local $xBP1 = $xClient + $width / 8
Local $yBP1 = $yClient + $height / 2

Local $xBP2 = $xClient + $width / 8
Local $yBP2 = $yClient + $height / 6 * 5

Local $xBP3 = $xClient + $width / 2
Local $yBP3 = $yClient + $height / 6 * 5

Local $xBP4 = $xClient + $width / 8 * 7
Local $yBP4 = $yClient + $height / 6 * 5

Local $xBP5 = $xClient + $width / 8 * 7
Local $yBP5 = $yClient + $height / 2

Local $xBP6 = $xClient + $width / 8 * 7
Local $yBP6 = $yClient + $height / 6 * 1

Local $xBP7 = $xClient + $width / 2
Local $yBP7 = $yClient + $height / 6 * 1

Local $xBP8 = $xClient + $width / 8
Local $yBP8 = $yClient + $height / 6 * 1

#Movement points
Local $xMP1 = $xClient + 50
Local $yMP1 = $yClient + $height / 2

Local $xMP2 = $xClient + $width / 2
Local $yMP2 = $yClient + $height / 4

Local $xMP3 = $xClient + $width - 50
Local $yMP3 = $xClient + $height / 2

While $isPaused = False
   Switch $position
   Case "Lobby"
	  BypassObstacle()
	  WinSwitch()
	  GoToNPC($riftPost)
	  MenuSelect(0)
	  Sleep(300)
	  If NoDMWindowExists() = True Then
		 _Exit()
	  EndIf
	  $position = "Room1"
	  Sleep(14000)
   Case "Room1"
	  SetTarget($Anakazel)
	  If TargetExists() Then
		 If WinActive($main) = 0 Then
			WinSwitch()
		 EndIf
		 Fight($Anakazel)
		 ManageDrop()
		 Sleep(500)
		 GoToNPC($riftBall)
		 MenuSelect(2)
		 $position = "Lobby"
		 Sleep(14000)
	  Else
		 GoToNPC($riftBall)
		 MenuSelect(1)
		 $position = "Room2"
		 Sleep(14000)
	  EndIf
   Case "Room2"
	  SetTarget($Anakazel)
	  If TargetExists() Then
		 If WinActive($main) = 0 Then
			WinSwitch()
		 EndIf
		 Fight($Anakazel)
		 ManageDrop()
		 Sleep(500)
		 GoToNPC($riftBall)
		 MenuSelect(2)
		 $position = "Lobby"
		 Sleep(14000)
	  Else
		 GoToNPC($riftBall)
		 MenuSelect(2)
		 $position = "Lobby"
		 Sleep(14000)
	  EndIf
   EndSwitch
WEnd