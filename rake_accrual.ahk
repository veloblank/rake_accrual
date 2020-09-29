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

    IF hwnd not in %TableHwndList% { 
      WinGetTitle,Title,ahk_id%hwnd%
      IF InStr(Title, " Logged in as ") {
        TableHwndList:= TableHwndList ? TableHwndList . "," . Hwnd : Hwnd
        TotalCurrentRake+= .40
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
