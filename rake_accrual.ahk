#NoEnv 
#SingleInstance force
SendMode Input 
SetFormat, Float, 0.2
SetWorkingDir %A_ScriptDir% 

numtables:=0
TotalCurrentRake:=0.00

Menu,TableCounter,Add,Minimize To Tray,Minimize
Menu,TableCounter,Add,Reset Counter, ResetCounter
Menu,Tablecounter,Add,Exit,GuiClose

Gui -MaximizeBox -MinimizeBox +AlwaysOnTop +Caption +LastFound +Border
Gui, Color, 000000
Gui, Font, s14 cWhite, Verdana

Gui,Margin,5,5
Gui, Add, Text, Center cFF8C00 vTotalCurrentRake,$0.00
Gui, Add, Button, x65 y4 w100 h22 gSubmit, Submit
Gui, Show, AutoSize, Rake
TableCounterHwnd:=winExist()

OnMessage(0x201, "WM_LBUTTONDOWN")
SetTimer,TableCounter,1000
Return 

TableCounter:
  numtables := 0

  WinGet, Id, list, ahk_class PokerStarsTableFrameClass,, Program Manager
  Loop,%Id%
  {
    Hwnd:=id%A_index%

    numtables += 1
    IF Hwnd not in %TableHwndList% 
    { 
      WinGetTitle,Title,ahk_id%hwnd%
      IF InStr(Title," Logged in as ") And InStr(Title, "$100") {
        TableHwndList:= TableHwndList ? TableHwndList . "," . Hwnd : Hwnd
        TotalCurrentRake+= 7.00
      } Else if InStr(Title, " Logged in as ") And InStr(Title, "$50") {
        TableHwndList:= TableHwndList ? TableHwndList . "," . Hwnd : Hwnd
        TotalCurrentRake+= 3.66
      } Else if InStr(Title, " Logged in as ") And InStr(Title, "$20") {
        TableHwndList:= TableHwndList ? TableHwndList . "," . Hwnd : Hwnd
        TotalCurrentRake+= 1.50
      } Else if InStr(Title, " Logged in as ") And InStr(Title, "$10") {
        TableHwndList:= TableHwndList ? TableHwndList . "," . Hwnd : Hwnd
        TotalCurrentRake+= 0.77
      } Else if InStr(Title, " Logged in as ") And InStr(Title, "$5") {
        TableHwndList:= TableHwndList ? TableHwndList . "," . Hwnd : Hwnd
        TotalCurrentRake+= 0.40
      } Else if InStr(Title, " Logged in as ") And InStr(Title, "$1") {
        TableHwndList:= TableHwndList ? TableHwndList . "," . Hwnd : Hwnd
        TotalCurrentRake+= 0.09
      } Else {
        TableHwndList:= TableHwndList ? TableHwndList . "," . Hwnd : Hwnd
        TotalCurrentRake+= 0.00
      }
    }
  }

  if (numtables != lasttables) OR (SaveTotalCurrentRake != TotalCurrentRake)
  {	

    IF TrayCounter 
      WinSetTitle,Ahk_id%TableCounterHwnd%,,%numtables% / %TotalCurrentRake% 

    GuiControl,, MyControl, %numtables%
    lasttables = %numtables%
    dollar = $
    SaveTotalCurrentRake = %dollar%%TotalCurrentRake%
    GuiControl,, TotalCurrentRake,%TotalCurrentRake%
  }

return

Submit:
  file := FileOpen("daily_rake.csv","a")
  FormatTime, TimeString,, ShortDate
  file.write(TimeString . "," . TotalCurrentRake . ",")
  file.close()
  FileAppend, `n, daily_rake.csv
  TotalCurrentRake:=0.00
return

Minimize: 
  Gui,Minimize
  WinSetTitle,Ahk_id%TableCounterHwnd%,,%numtables% / %TotalCurrentRake%
Return

GuiSize:
  TrayCounter := A_EventInfo=1 ? 1 : 0
  GuiControl, MoveDraw, WinText, x0 w%A_GuiWidth%
Return

GuiContextMenu:
  Menu, TableCounter, Show 
Return

ResetCounter:
  TotalCurrentRake:=0
  GuiControl,, TotalCurrentRake,0 
Return

GuiClose:
  ExitApp
Return
