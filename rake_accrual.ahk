#NoEnv 
#SingleInstance force
SendMode Input 
SetFormat, Float, 0.2
SetWorkingDir %A_ScriptDir% 

numtables:=0
TotalCurrentRake:=0.00

Menu,TableCounter,Add,Reset Counter, ResetCounter
Menu,Tablecounter,Add,Exit,GuiClose

Gui -MaximizeBox -MinimizeBox +AlwaysOnTop +Caption +LastFound +Border
Gui, Show, AutoSize, Rake
Gui,Margin,5,5
Gui, Color, 000000
Gui, Font, s14 cWhite, Verdana
Gui, Add, Text, Center cFF8C00 vTotalCurrentRake,$0.00
Gui, Add, Button, x65 y4 w100 h22 gSubmit, Submit
RakeAccrualHwnd:=winExist()

OnMessage(0x201, "WM_LBUTTONDOWN")
SetTimer,TableCounter,1000
Return 

TableCounter:
  ;WinGet, OutputVar, List , WinTitle, WinText, ExcludeTitle, ExcludeText
  ;Retrieves the unique ID numbers of all existing windows that match the title/text parameters.
  ;HWND is the window handle

  WinGet, MyTablesArray, List, ahk_class PokerStarsTableFrameClass,, Program Manager
  ;MyTablesArray is set to the number of items in the array.
  Loop,%MyTablesArray%
  {

    hwnd:=MyTablesArray%A_Index%

    IF hwnd not in %TableHwndList% 
    { 
      ;WinGetTitle retrieves the title of the specified window.
      WinGetTitle,Title,ahk_id%hwnd%
      IF InStr (Title, "$100") {
        TableHwndList:= TableHwndList ? TableHwndList . "," . Hwnd : Hwnd
        TotalCurrentRake+= 7.00
      } Else if InStr(Title, "$50") {
        TableHwndList:= TableHwndList ? TableHwndList . "," . Hwnd : Hwnd
        TotalCurrentRake+= 3.66
      } Else if InStr(Title, "$20") {
        TableHwndList:= TableHwndList ? TableHwndList . "," . Hwnd : Hwnd
        TotalCurrentRake+= 1.50
      } Else if InStr(Title, "$10") {
        TableHwndList:= TableHwndList ? TableHwndList . "," . Hwnd : Hwnd
        TotalCurrentRake+= 0.77
      } Else if InStr(Title, "$5") {
        TableHwndList:= TableHwndList ? TableHwndList . "," . Hwnd : Hwnd
        TotalCurrentRake+= 0.40
      } Else if InStr(Title, "$1") {
        TableHwndList:= TableHwndList ? TableHwndList . "," . Hwnd : Hwnd
        TotalCurrentRake+= 0.09
      } Else {
        TableHwndList:= TableHwndList ? TableHwndList . "," . hwnd : hwnd
        TotalCurrentRake+= 0.00
      }
    }
  }

Submit:
  file := FileOpen("daily_rake.csv","a")
  FormatTime, TimeString,, ShortDate
  file.write(TimeString . "," . TotalCurrentRake . ",")
  file.close()
  FileAppend, `n, daily_rake.csv
  TotalCurrentRake:=0.00
return

ResetCounter:
  TotalCurrentRake:=0
  GuiControl,, TotalCurrentRake,0 
Return

GuiClose:
  ExitApp
Return
