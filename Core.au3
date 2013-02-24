Func _Main()
   While True
	  Sleep(10)
   WEnd
EndFunc

Func WinSwitch()
   If WinActive($main) = 0 Then
	  Command("target", "%party1")
	  Sleep(600)
	  Send($ptLeaderkey)
	  WinActivate($main)
   Else
	  Command("target", "%party1")
	  Sleep(600)
	  Send($ptLeaderkey)
	  WinActivate($support)
   EndIf
   Sleep(2000)
EndFunc
   
Func SetTarget($targetName)
   CancelTarget()
   Command("target", $targetName)
   $prevTarget = $targetName
   Sleep(500)
EndFunc

Func RestoreTarget()
   If $prevTarget = "" Then
	  Return False
   Else
	  SetTarget($prevTarget)
   EndIf
   Sleep(300)
EndFunc

Func CancelTarget()
   Send("{ESCAPE}")
   Sleep(200)
EndFunc

Func TargetExists()
   $result = _ImageSearch("img/targetwin.bmp", 0, $x, $y, 0)
   if $result = 1 Then
	  Return True
   Else
	  Return False
   EndIf
EndFunc

Func GoToNPC($NPCName)
   CancelTarget()
   While TargetExists() = False
	  SetTarget($NPCName)
	  Sleep(1000)
   WEnd
   While NPCWindowExists() = False
	  Command("attack")
	  Sleep(700)
	  If $NPCName = $riftPost And NPCWindowExists() = False And IsMoving() = False Then
		 BypassObstacle()
	  EndIf
	  SetTarget($NPCName)
   WEnd
EndFunc

Func NPCWindowExists()
   $result = _ImageSearch("img/npcwin.bmp", 0, $x, $y, 0)
   If $result = 1 Then
	  Return True
   Else
	  Return False
   EndIf
EndFunc

Func Command($action, $option=False)
   If $option Then
	  Send("{ENTER}/" & $action & " " & $option & "{ENTER}")
   Else
	  Send("{ENTER}/" & $action & "{ENTER}")
   EndIf
EndFunc

Func MenuSelect($menuEntry)
   $Entries[0] = "img/iwanttogototheinnerspaceoftherift.bmp"
   $Entries[1] = "img/usechancecard.bmp"
   $Entries[2] = "img/iwanttogiveup.bmp"
   $result = _ImageSearch($Entries[$menuEntry], 1, $x, $y, 50)
   If $result = 1 Then
	  MouseClick("left", $x, $y)
   EndIf
EndFunc

Func GetClientCoords()
   $pos = WinGetPos("")
   $xClient = $pos[0]
   $yClient = $pos[1]
EndFunc

Func ByPass($xP1, $yP1, $xP2, $yP2, $xP3, $yP3, $delay)
   MouseMove($xP1, $yP1, 0)
   MouseClick("left")
   Sleep($delay)
   MouseMove($xP2, $yP2, 0)
   MouseClick("left")
   Sleep($delay)
   MouseMove($xP3, $yP3, 0)
   MouseClick("left")
   Sleep($delay)
EndFunc

Func BypassObstacle()
   $random = Random(1, 8, 1)
   Switch $random
   Case 1
	  Bypass($xBP3, $yBP3, $xBP2, $yBP2, $xBP1, $yBP1, 1000)
   Case 2
	  Bypass($xBP3, $yBP3, $xBP4, $yBP4, $xBP5, $yBP5, 1000)
   Case 3
	  Bypass($xBP7, $yBP7, $xBP8, $yBP8, $xBP1, $yBP1, 1000)
   Case 4
	  Bypass($xBP7, $yBP7, $xBP6, $yBP6, $xBP5, $yBP5, 1000)
   Case 5
	  Bypass($xBP1, $yBP1, $xBP8, $yBP8, $xBP7, $yBP7, 1000)
   Case 6
	  Bypass($xBP5, $yBP5, $xBP6, $yBP6, $xBP7, $yBP7, 1000)
   Case 7
	  Bypass($xBP5, $yBP5, $xBP4, $yBP4, $xBP3, $yBP3, 1000)
   Case 8
	  Bypass($xBP1, $yBP1, $xBP2, $yBP2, $xBP3, $yBP3, 1000)
   EndSwitch
EndFunc

Func GetClientDimention()
   $dim = WinGetClientSize("[ACTIVE]")
   $width = $dim[0]
   $height = $dim[1]
EndFunc

Func IsMoving()
   $exMP1 = PixelGetColor($xMP1, $yMP1)
   $exMP2 = PixelGetColor($xMP2, $yMP2)
   $exMP3 = PixelGetColor($xMP3, $yMP3)
   Sleep(500)
   $MP1 = PixelGetColor($xMP1, $yMP1)
   $MP2 = PixelGetColor($xMP2, $yMP2)
   $MP3 = PixelGetColor($xMP3, $yMP3)
   If $exMP1 = $MP1 And $exMP2 = $MP2 Then
	  Return False
   ElseIf $exMP3 = $MP3 And $exMP2 = $MP2 Then
	  Return False
   ElseIf $exMP3 = $MP3 And $exMP1 = $MP1 Then
	  Return False
   Else
	  Return True
   EndIf   
EndFunc

Func NoDMWindowExists()
   $result = _ImageSearch("img/nodm.bmp", 0, $x, $y, 50)
   If $result = 1 Then
	  Return True
   Else
	  Return False
   EndIf
EndFunc

Func Fight($targetName)
   Send("{F3}")
   Send($supportToggle)
   SetTarget($targetName)
   While HasHP()
	  For $i = 0 To 30 Step +1 
		 Send($attackSkillkey)
		 Sleep(25)
	  Next
	  Send($MPkey)
   WEnd
   For $i = 0 To 30 Step +1 
	  Send($attackSkillkey)
	  Sleep(25)
   Next
   Send("{F3}")
   Send($supportToggle)
EndFunc

Func HasHP()
   If TargetExists() = False Then
	  RestoreTarget()
   EndIf
   If Hex(PixelGetColor($x+16, $y+30), 6) = 940000 Then
	  Return True
   Else
	  Return False
   EndIf
EndFunc

Func ManageDrop()
   For $i = 0 To 12 Step +1
	  Command("pickup")
	  Sleep(2000)
   Next
EndFunc

Func _Exit()
   Exit
EndFunc