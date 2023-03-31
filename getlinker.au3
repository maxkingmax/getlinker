#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=Untitled.ico
#AutoIt3Wrapper_Outfile=getlinker.exe
#AutoIt3Wrapper_Outfile_x64=getlinker_X64.exe
#AutoIt3Wrapper_Compile_Both=y
#AutoIt3Wrapper_Res_Comment=提取各种链接及提取文本
#AutoIt3Wrapper_Res_Description=getlinker
#AutoIt3Wrapper_Res_Fileversion=1.0.0.0
#AutoIt3Wrapper_Res_ProductName=getlinker
#AutoIt3Wrapper_Res_ProductVersion=1.0
#AutoIt3Wrapper_Res_CompanyName=homemade
#AutoIt3Wrapper_Res_LegalCopyright=no
#AutoIt3Wrapper_Res_LegalTradeMarks=no
#AutoIt3Wrapper_Res_Language=2052
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#NoTrayIcon
;取链儿.au3

#include "getlinker.isf"
#include <Array.au3>
#include <Misc.au3>
_Singleton ( "getlinker" , 0 )



Global $cl = 'magnet\:\?xt\=urn\:btih\:[a-fA-F0-9]{40}';'(/^magnet:\?xt=urn:btih:[0-9a-fA-F]{40,}.*$/)'
Global $ed = 'ed2k\:\/\/\|file\|.+?\|\d{1,}\|[0-9a-fA-F]{32}.*?\|\/'
Global $sha = '115\:\/\/.+?\|\d+\|[0-9a-fA-F]{40}\|[0-9a-fA-F]{40}'
Global $url = 'https?\:\/\/.+'

GUISetState(@SW_SHOW, $getlinker)
getclip()
    ; Loop until the user exits.
    While 1
        Switch GUIGetMsg()
            Case $GUI_EVENT_CLOSE, $idOK
                ExitLoop
			case $clip
				getclip()
			case $open
				openfile()
			Case $save
					writefile()
			Case $getlink
						getlink()
			Case $GUI_EVENT_DROPPED
				; If the value of @GUI_DropId is $idLabel, then set the label of the dragged file.
				If @GUI_DropId = $txt Then opendropfile()

        EndSwitch
    WEnd


func getclip()
	$source = ClipGet()
	if stringlen($source) > 0 Then 
		guictrlsetdata($txt, $source)
	EndIf
EndFunc

Func openfile()
	$sourcefile = FileOpenDialog("导入文件", "", "文本文件 (*.txt)|全部 (*.*)" , '', "", $getlinker)
	if not @error Then 
		$sfile = FileOpen($sourcefile)
		$source = fileread($sfile)
			if stringlen($source) > 0 Then 
				guictrlsetdata($txt, $source)
			EndIf
			fileclose($sfile)
	EndIf
EndFunc
Func opendropfile()
	$sourcefile = @GUI_DragFile
	if not @error Then 
		$sfile = FileOpen($sourcefile)
		$source = fileread($sfile)
			if stringlen($source) > 0 Then 
				guictrlsetdata($txt, $source)
			EndIf
			fileclose($sfile)
	EndIf
EndFunc

Func writefile()
	$writedata = guictrlread( $link)
	ConsoleWrite($writedata)
	$tgfile = FileSaveDialog("导出文件", "", "文本文件 (*.txt)|全部 (*.*)" , '', 'links', $getlinker)
	if not @error then 
		$sfile = fileopen($tgfile, 1 + 8)
		if stringlen($writedata) > 0 Then
		FileWrite($sfile,$writedata )
		EndIf
		fileclose($sfile)
	EndIf
EndFunc

func getlink()
	local $templist[1] 
	$sourcetxt = guictrlread($txt)
	$linkcl = stringregexp($sourcetxt, $cl, 3)
;~ 	_ArrayDisplay($linkcl)
	if not @error then 
		if guictrlread($magx ) = $GUI_CHECKED Then 	_ArrayConcatenate($templist, $linkcl)
	EndIf	

	$link115 = stringregexp($sourcetxt, $sha, 3)
;~ 	_ArrayDisplay($link115)
;~ 	ConsoleWrite(guictrlread($shax ) &  $GUI_CHECKED)
	if not @error then 
	if guictrlread($shax ) = $GUI_CHECKED Then  _ArrayConcatenate($templist, $link115)
	EndIf	
	$linked2k = stringregexp($sourcetxt, $ed, 3)
	if not @error then 
	if guictrlread($ed2kx ) = $GUI_CHECKED Then _ArrayConcatenate($templist, $linked2k)
	EndIf
	$linkurl = stringregexp($sourcetxt, $url, 3)
	if not @error then 
	if guictrlread($urlx ) = $GUI_CHECKED Then _ArrayConcatenate($templist, $linkurl)
	EndIf	
	if guictrlread($myexp) <> '' Then 
	$linkmy = stringregexp($sourcetxt, guictrlread($myexp), 3)
	if not @error then 
	 _ArrayConcatenate($templist, $linkmy)
	EndIf		
	EndIf 
	
	
	
	
		$sting = _ArrayToString($templist,@CRLF )
		guictrlsetdata($link, $sting)
		if guictrlread($putclip) And UBound($putclip)>1 = $GUI_CHECKED then _ArrayToClip ($templist, @CRLF)
	
EndFunc