#NoEnv 
SendMode Input 
SetWorkingDir %A_ScriptDir% 
SetFormat, Float, 0.2
#SingleInstance force

numtables:=0
TotalRake:=0

Menu,TableCounter,Add,Minimize To Tray,Minimize
Menu,TableCounter,Add,Reset Counter, ResetCounter
Menu,Tablecounter,Add,Exit,GuiClose

Gui -MaximizeBox -MinimizeBox +AlwaysOnTop +Caption +LastFound +Border
Gui, Color, 000000
Gui, Font, s20 cWhite, Verdana

Gui,Margin,5,5
Gui, Add, Text, Center vMyControl, 0
Gui, Add, Text, Center x+5 w100 cFF8C00 vTotalRake, 0
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
    Hwnd:=Id%A_index%

    numtables += 1
    IF Hwnd not in %TableHwndList% 
    { 
      WinGettitle,Title,ahk_id%hwnd%
      IF InStr(Title, "$5") AND InStr(Title, " Logged In as ")
      {
        TableHwndList:= TableHwndList ? TableHwndList . "," . Hwnd : Hwnd
        TotalRake+= 0.40
      }
    }
  }

  if (numtables != lasttables) OR (SaveTotalTablesOpened != TotalRake)
  {	

    IF TrayCounter 
      WinSetTitle,Ahk_id%TableCounterHwnd%,,%numtables% / %TotalRake% 

    GuiControl,, MyControl, %numtables%
    lasttables = %numtables%
    SaveTotalTablesOpened = %TotalRake%
    GuiControl,, TotalRake, %TotalRake%
  }
return

Minimize: 
  Gui,Minimize
  WinSetTitle,Ahk_id%TableCounterHwnd%,,%numtables% / %TotalRake%
Return

GuiSize:
  TrayCounter := A_EventInfo=1 ? 1 : 0
  GuiControl, MoveDraw, WinText, x0 w%A_GuiWidth%
Return

GuiContextMenu:
  Menu, TableCounter, Show 
Return

ResetCounter:
  TotalRake:=0
  GuiControl,, TotalRake,0 
Return

GuiClose:
  ExitApp
Return