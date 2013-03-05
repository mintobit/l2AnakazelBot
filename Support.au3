#Include  <Crypt.au3>
#Include  <WinAPI.au3>
#Include <Core.au3>

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