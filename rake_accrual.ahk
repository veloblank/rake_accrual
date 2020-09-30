#NoEnv 
SendMode Input 
SetWorkingDir %A_ScriptDir% 
SetFormat, Float, 0.2
#SingleInstance force

numtables:=0
SaveTotalTablesOpened:=0
TotalRake:=0.00
TotalTables:=0
Total1Tables:=0
Total5Tables:=0
Total10Tables:=0
Total20Tables:=0

Menu,TableCounter, Add, Minimize To Tray, Minimize
Menu,TableCounter, Add, Reset Counter, ResetCounter
Menu,TableCounter, Add, Exit, GuiClose

Gui -MaximizeBox -MinimizeBox +AlwaysOnTop +Caption +LastFound +Border
Gui, Color, 000000
Gui, Font, s18 cWhite, Verdana

Gui,Margin,5,5,5,5
Gui, Add, Text, Center w25 vMyControl, 0
Gui, Add, Text, Left x+5 cFF8C00 vTotalRake, $0.00
Gui, Show, AutoSize, Rake
Gui, Add, Text, Left y+ cBlack vTotal5Tables, 0
Gui, Add, Text, Left x+15 cBlack vTotal10Tables, 0
Gui, Add, Text, Left x+15 cBlack vTotal20Tables, 0
Gui, Add, Text, Left x+15 cWhite vSaveTotalTablesOpened, 0
Gui, Add, Button, x+25 y7 Center w100 h25 gSubmit, Submit
TableCounterHwnd:=winExist()

OnMessage(0x201, "WM_LBUTTONDOWN")
SetTimer,TableCounter,1000
Return 

TableCounter:

  numtables := 0

  WinGet, Id, list, ahk_class PokerStarsTableFrameClass,, Program Manager
  Loop,%Id%
  {
    hwnd:=Id%A_index%

    numtables += 1
    IF hwnd not in %TableHwndList% 
    { 
      WinGetTitle, Title, ahk_id%hwnd%
      IF InStr(Title, "$5") AND InStr(Title, " Logged In as ")
      {
        TableHwndList:= TableHwndList ? TableHwndList . "," . hwnd : hwnd
        TotalRake+= 0.40
        TotalTables+= 1
        Total5Tables+= 1
        Gui Font, cGreen
        GuiControl Font, Total5Tables
      } 
      Else IF InStr(Title, "$10") AND InStr(Title, " Logged In as ")
      {
        TableHwndList:= TableHwndList ? TableHwndList . "," . hwnd : hwnd
        TotalRake+= 0.77
        TotalTables+= 1
        Total10Tables+= 1
        Gui Font, cYellow
        GuiControl Font, Total10Tables
      }
      Else IF InStr(Title, "$20") AND InStr(Title, " Logged In as ")
      {
        TableHwndList:= TableHwndList ? TableHwndList . "," . hwnd : hwnd
        TotalRake+= 1.50
        TotalTables+= 1
        Total20Tables+= 1
        Gui Font, cRed
        GuiControl Font, Total20Tables
      }
    }
  }

  IF (numtables != lasttables) OR (SaveTotalTablesOpened != TotalRake)
  {	
    IF TrayCounter 
      WinSetTitle,Ahk_id%TableCounterHwnd%,,%numtables% // %TotalRake% 

    lasttables = %numtables%
    SaveTotalTablesOpened = %Total5Tables% + %Total10Tables% + %Total20Tables%
    GuiControl,, MyControl, %numtables%
    GuiControl,, TotalRake, $%TotalRake%
    GuiControl,, Total5Tables, %Total5Tables%
    GuiControl,, Total10Tables, %Total10Tables%
    GuiControl,, Total20Tables, %Total20Tables%
    GuiControl,, SaveTotalTablesOpened, %SaveTotalTablesOpened%
  }
return

Submit:
  file := FileOpen("daily_rake.csv","a")
  FormatTime, TimeString,, ShortDate
  file.write(TimeString . "," . TotalRake . "," . TotalTables . "," . Total5Tables . "," . Total10Tables . "," . Total20Tables . ",")
  file.close()
  FileAppend, `n, daily_rake.csv
  file.write(TableHwndList)
  file.close()
  TotalRake:=0.00
Return

Minimize: 
  Gui, Minimize
  WinSetTitle, ahk_id%TableCounterHwnd%,, %numtables% // $%TotalRake%
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