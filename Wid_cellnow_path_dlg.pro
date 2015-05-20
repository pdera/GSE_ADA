;
; IDL Widget Interface Procedures. This Code is automatically
;     generated and should not be modified.

;
; Generated on:	05/20/2015 10:52.23
;
pro WID_BASE_0A_event, Event

  wTarget = (widget_info(Event.id,/NAME) eq 'TREE' ?  $
      widget_info(Event.id, /tree_root) : event.id)


  wWidget =  Event.top

  case wTarget of

    Widget_Info(wWidget, FIND_BY_UNAME='WID_BUTTON_0'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        Browse_CellNowDir, Event
    end
    Widget_Info(wWidget, FIND_BY_UNAME='WID_BUTTON_1'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        CloseUp, Event
    end
    else:
  endcase

end

pro WID_BASE_0A, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_

  Resolve_Routine, 'Wid_cellnow_path_dlg_eventcb',/COMPILE_FULL_FILE  ; Load event callback routines

  WID_BASE_0A = Widget_Base( GROUP_LEADER=wGroup, UNAME='WID_BASE_0A'  $
      ,XOFFSET=5 ,YOFFSET=5 ,SCR_XSIZE=300 ,SCR_YSIZE=164  $
      ,TITLE='Define Cell_Now Path' ,SPACE=3 ,XPAD=3 ,YPAD=3)


  WID_LABEL_0 = Widget_Label(WID_BASE_0A, UNAME='WID_LABEL_0'  $
      ,XOFFSET=17 ,YOFFSET=24 ,SCR_XSIZE=137 ,SCR_YSIZE=15  $
      ,/ALIGN_LEFT ,VALUE='Abs. Path To cell_now.exe')


  WID_TEXT_CellnowPath = Widget_Text(WID_BASE_0A,  $
      UNAME='WID_TEXT_CellnowPath' ,XOFFSET=17 ,YOFFSET=51  $
      ,SCR_XSIZE=255 ,SCR_YSIZE=26 ,XSIZE=20 ,YSIZE=1)


  WID_BUTTON_0 = Widget_Button(WID_BASE_0A, UNAME='WID_BUTTON_0'  $
      ,XOFFSET=179 ,YOFFSET=19 ,SCR_XSIZE=93 ,SCR_YSIZE=22  $
      ,/ALIGN_CENTER ,VALUE='BROWSE')


  WID_BUTTON_1 = Widget_Button(WID_BASE_0A, UNAME='WID_BUTTON_1'  $
      ,XOFFSET=100 ,YOFFSET=91 ,SCR_XSIZE=96 ,SCR_YSIZE=22  $
      ,/ALIGN_CENTER ,VALUE='OK')

  Widget_Control, /REALIZE, WID_BASE_0A

  XManager, 'WID_BASE_0A', WID_BASE_0A

end
;
; Empty stub procedure used for autoloading.
;
pro Wid_cellnow_path_dlg, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
  WID_BASE_0A, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
end
