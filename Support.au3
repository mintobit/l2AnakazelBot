#Include  <Crypt.au3>
#Include  <WinAPI.au3>

AutoItSetOption("TrayMenuMode", 1)
HotKeySet("{NUMPADADD}", "ToggleSupport")
HotKeySet("{INSERT}", "_Exit")

#Support window detection
WinWaitActive("[CLASS:l2UnrealWWindowsViewportWindow]")
$support = WinGetHandle("[ACTIVE]")
WinActivate("Program Manager")

#keys
$Healkey = "{F1}"
$MPkey = "{F2}"
$ManaBurnkey = "{F3}"
$Prayerkey = "{F4}"

#vars
Local $isPaused = True

_Main()

Func SupportSend($key)
   ControlSend($support, "", "", $key)
EndFunc

Func _Main()
   While True
	  Sleep(10)
   WEnd
EndFunc

Func ToggleSupport()
   $isPaused = Not $isPaused
   SupportSend($Prayerkey)
   While $isPaused = False
	  SupportSend($Healkey)
	  SupportSend($Healkey)
	  SupportSend($Healkey)
	  SupportSend($ManaBurnkey)
	  Sleep(1000)
	  SupportSend($MPkey)
   Wend
EndFunc

Func _Exit()
   Exit
EndFunc