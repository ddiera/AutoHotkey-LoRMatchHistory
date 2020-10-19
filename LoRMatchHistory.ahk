#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
;#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#Include JSON.ahk ; using Cocobelgica's JSON lib - https://github.com/cocobelgica/AutoHotkey-JSON

;-----------------------------------------------------------------------------------
; 				Default Variables
;-----------------------------------------------------------------------------------

apikey := ""	; insert API key here
puuid := "pyjaDiHAmCuZUVNaLszYoQ6CMGqKnFzm8KcLjmQpR6ncW-heN-MH2POhjTpGBGBaiS1MrBh3IoyxqA" ; insert your user id here

;-----------------------------------------------------------------------------------
; 				Private Functions
;-----------------------------------------------------------------------------------

history(puuid="", apikey="")	; returns player match history data in JSON
{
URL := "https://europe.api.riotgames.com/lor/match/v1/matches/by-puuid/ /ids?api_key= "
StringReplace,URL,URL,%A_Space%,%puuid%,
StringReplace,URL,URL,%A_Space%,%apikey%,

riotapi := ComObjCreate("WinHttp.WinHttpRequest.5.1")
riotapi.Open("GET", URL, true)
riotapi.SetRequestHeader("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8")
riotapi.Send()
riotapi.WaitForResponse()
rawhistory := riotapi.ResponseText
rawhistory := varize2(rawhistory)

return rawhistory
}

match(matchid="", apikey="")	; returns selected match data in JSON
{
URL2 := "https://europe.api.riotgames.com/lor/match/v1/matches/ ?api_key= "
StringReplace,URL2,URL2,%A_Space%,%matchid%,
StringReplace,URL2,URL2,%A_Space%,%apikey%,

riotapi2 := ComObjCreate("WinHttp.WinHttpRequest.5.1")
riotapi2.Open("GET", URL2, true)
riotapi2.SetRequestHeader("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8")
riotapi2.Send()
riotapi2.WaitForResponse()
rawmatch := riotapi2.ResponseText

return rawmatch
}

account(opid="", apikey="")	; returns opponent account metadata in JSON
{
URL3 := "https://europe.api.riotgames.com/riot/account/v1/accounts/by-puuid/ ?api_key= "
StringReplace,URL3,URL3,%A_Space%,%opid%,
StringReplace,URL3,URL3,%A_Space%,%apikey%,

riotapi3 := ComObjCreate("WinHttp.WinHttpRequest.5.1")
riotapi3.Open("GET", URL3, true)
riotapi3.SetRequestHeader("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8")
riotapi3.Send()
riotapi3.WaitForResponse()
rawopaccount := riotapi3.ResponseText

return rawopaccount
}

varize2(var)			; helps with easy parsing of JSON data for match function input
{
	StringReplace,var,var,%A_space%,,a
	chars = {}"[]/
	Loop, Parse, chars,
	Stringreplace,var,var,%A_loopfield%,,a
	return var
}

;----------------------------------------------------------------------------------
;				Scripts, Hotkeys & Controls
;----------------------------------------------------------------------------------


History:		; fetches data through Riot API to populate match history

Gui,2:Add,Listview,AltSubmit Grid w875 r20 gRowSelector hwndHWND,DATE|OPPONENT|OUTCOME|OPPONENT DECK CODE|
Gui,2:default
Gui,2:Add, Button,, Copy Deck Code

LV_ModifyCol(1, "75")
LV_ModifyCol(2, "100")
LV_ModifyCol(3, "67")
LV_ModifyCol(4, "623")

Gui,2:Show,,Match History
output := history(puuid, apikey)
array := StrSplit(output,",")
Loop, 20
{	
	matchid := array[A_Index]
	output2 := match(matchid, apikey)
	parsed := JSON.Load(output2)
	date := SubStr(parsed.info.game_start_time_utc, 1, 10)
	if parsed.info.players[1].puuid = puuid
	{
		outcome := parsed.info.players[1].game_outcome
		opdeckcode := parsed.info.players[2].deck_code
		opid := parsed.info.players[2].puuid
	}
	else
	{
		outcome := parsed.info.players[2].game_outcome
		opdeckcode := parsed.info.players[1].deck_code
		opid := parsed.info.players[1].puuid
	}
	output3 := account(opid, apikey)
	parsed2 := JSON.Load(output3)
	opname := parsed2.gameName
	LV_add(, date, opname, outcome, opdeckcode)
	sleep 100
}

return


RowSelector:		; GUI subroutine to select opponent

if A_GuiEvent = Normal
rownumb := A_EventInfo

return


2ButtonCopyDeckCode:	; copy highlighted deckcode to cliboard

LV_GetText(clpbrd, rownumb, 4)
Clipboard := clpbrd

return

F7::			; exit application on F7

ExitApp

return
