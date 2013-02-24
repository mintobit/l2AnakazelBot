#Include  <Crypt.au3>
#Include  <WinAPI.au3>

Global Const $UHID_MB = 0x00
Global Const $UHID_BIOS = 0x01
Global Const $UHID_CPU = 0x02
Global Const $UHID_HDD = 0x04

;ConsoleWrite(_UniqueHardwaeIDv1() & @CR)
;ConsoleWrite(_UniqueHardwaeIDv1(BitOR($UHID_MB, $UHID_BIOS)) & @CR)
;ConsoleWrite(_UniqueHardwaeIDv1(BitOR($UHID_MB, $UHID_BIOS, $UHID_CPU)) & @CR)
;ConsoleWrite(_UniqueHardwaeIDv1(BitOR($UHID_MB, $UHID_BIOS, $UHID_CPU, $UHID_HDD)) & @CR)

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

Func _UniqueHardwaeIDv1($iFlags = 0)

    Local $oService = ObjGet('winmgmts:\\.\root\cimv2')

    If Not IsObj($oService) Then
        Return SetError(1, 0, '')
    EndIf

    Local $tSPQ, $tSDD, $oItems, $hFile, $Hash, $Ret, $Str, $Hw = '', $Result = 0

    $oItems = $oService.ExecQuery('SELECT * FROM Win32_ComputerSystemProduct')
    If Not IsObj($oItems) Then
        Return SetError(2, 0, '')
    EndIf
    For $Property In $oItems
        $Hw &= $Property.IdentifyingNumber
        $Hw &= $Property.Name
        $Hw &= $Property.SKUNumber
        $Hw &= $Property.UUID
        $Hw &= $Property.Vendor
        $Hw &= $Property.Version
    Next
    $Hw = StringStripWS($Hw, 8)
    If Not $Hw Then
        Return SetError(3, 0, '')
    EndIf
    If BitAND($iFlags, 0x01) Then
        $oItems = $oService.ExecQuery('SELECT * FROM Win32_BIOS')
        If Not IsObj($oItems) Then
            Return SetError(2, 0, '')
        EndIf
        $Str = ''
        For $Property In $oItems
            $Str &= $Property.IdentificationCode
            $Str &= $Property.Manufacturer
            $Str &= $Property.Name
            $Str &= $Property.SerialNumber
            $Str &= $Property.SMBIOSMajorVersion
            $Str &= $Property.SMBIOSMinorVersion
;           $Str &= $Property.Version
        Next
        $Str = StringStripWS($Str, 8)
        If $Str Then
            $Result += 0x01
            $Hw &= $Str
        EndIf
    EndIf
    If BitAND($iFlags, 0x02) Then
        $oItems = $oService.ExecQuery('SELECT * FROM Win32_Processor')
        If Not IsObj($oItems) Then
            Return SetError(2, 0, '')
        EndIf
        $Str = ''
        For $Property In $oItems
            $Str &= $Property.Architecture
            $Str &= $Property.Family
            $Str &= $Property.Level
            $Str &= $Property.Manufacturer
            $Str &= $Property.Name
            $Str &= $Property.ProcessorId
            $Str &= $Property.Revision
            $Str &= $Property.Version
        Next
        $Str = StringStripWS($Str, 8)
        If $Str Then
            $Result += 0x02
            $Hw &= $Str
        EndIf
    EndIf
    If BitAND($iFlags, 0x04) Then
        $oItems = $oService.ExecQuery('SELECT * FROM Win32_PhysicalMedia')
        If Not IsObj($oItems) Then
            Return SetError(2, 0, '')
        EndIf
        $Str = ''
        $tSPQ = DllStructCreate('dword;dword;byte[4]')
        $tSDD = DllStructCreate('ulong;ulong;byte;byte;byte;byte;ulong;ulong;ulong;ulong;dword;ulong;byte[512]')
        For $Property In $oItems
            $hFile = _WinAPI_CreateFile($Property.Tag, 2, 0, 0)
            If Not $hFile Then
                ContinueLoop
            EndIf
            $Ret = DllCall('kernel32.dll', 'int', 'DeviceIoControl', 'ptr', $hFile, 'dword', 0x002D1400, 'ptr', DllStructGetPtr($tSPQ), 'dword', DllStructGetSize($tSPQ), 'ptr', DllStructGetPtr($tSDD), 'dword', DllStructGetSize($tSDD), 'dword*', 0, 'ptr', 0)
            If (Not @error) And ($Ret[0]) And (Not DllStructGetData($tSDD, 5)) Then
                Switch DllStructGetData($tSDD, 11)
                    Case 0x03, 0x0B ; ATA, SATA
                        $Str &= $Property.SerialNumber
                EndSwitch
            EndIf
            _WinAPI_CloseHandle($hFile)
        Next
        $Str = StringStripWS($Str, 8)
        If $Str Then
            $Result += 0x04
            $Hw &= $Str
        EndIf
    EndIf
    $Hash = _Crypt_HashData($Hw, $CALG_MD5)
    If @error Then
        Return SetError(4, 0, '')
    EndIf
    $Hash = StringTrimLeft($Hash, 2)
    Return SetError(0, $Result, '{' & StringMid($Hash, 1, 8) & '-' & StringMid($Hash, 9, 4) & '-' & StringMid($Hash, 13, 4) & '-' & StringMid($Hash, 17, 4) & '-' & StringMid($Hash, 21, 12) & '}')
EndFunc   ;==>_UniqueHardwaeIDv1