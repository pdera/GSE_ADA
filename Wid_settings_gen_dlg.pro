;
; IDL Widget Interface Procedures. This Code is automatically
;     generated and should not be modified.

;
; Generated on:	05/12/2015 10:28.36
;
pro WID_BASE_0_event, Event

  wTarget = (widget_info(Event.id,/NAME) eq 'TREE' ?  $
      widget_info(Event.id, /tree_root) : event.id)


  wWidget =  Event.top

  case wTarget of

    ;Widget_Info(wWidget, FIND_BY_UNAME='WID_BASE_0'): begin
    ;  if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BASE' )then $
    ;    newSize, Event
    ;end
    Widget_Info(wWidget, FIND_BY_UNAME='WID_BUTTON_0'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        Closeup, Event
    end
    Widget_Info(wWidget, FIND_BY_UNAME='WID_BUTTON_1'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        Generate_and_end, Event
    end
    else:
  endcase

end

pro WID_BASE_0, fn, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_

  Resolve_Routine, 'Wid_settings_gen_dlg_eventcb',/COMPILE_FULL_FILE  ; Load event callback routines

  WID_BASE_0 = Widget_Base( GROUP_LEADER=wGroup, UNAME='WID_BASE_0'  $
      ,XOFFSET=5 ,YOFFSET=5 ,SCR_XSIZE=240 ,SCR_YSIZE=330  $
      ,/TLB_SIZE_EVENTS  $
      ,TITLE='Generate Settings File' ,SPACE=3 ,XPAD=3 ,YPAD=3)


  WID_LABEL_0 = Widget_Label(WID_BASE_0, UNAME='WID_LABEL_0'  $
      ,XOFFSET=9 ,YOFFSET=9 ,SCR_XSIZE=200 ,SCR_YSIZE=15 ,/ALIGN_LEFT  $
      ,VALUE='Gen. Settings File, Push Ignore to Skip')


  WID_BUTTON_0 = Widget_Button(WID_BASE_0, UNAME='WID_BUTTON_0'  $
      ,XOFFSET=120 ,YOFFSET=250 ,/ALIGN_CENTER ,VALUE='Ignore')


  WID_BUTTON_1 = Widget_Button(WID_BASE_0, UNAME='WID_BUTTON_1'  $
      ,XOFFSET=33 ,YOFFSET=250 ,/ALIGN_CENTER ,VALUE='Generate')


  WID_LABEL_1 = Widget_Label(WID_BASE_0, UNAME='WID_LABEL_1'  $
      ,XOFFSET=11 ,YOFFSET=42 ,SCR_XSIZE=81 ,SCR_YSIZE=15  $
      ,/ALIGN_LEFT ,VALUE='Start Angle')


  startAngLE = Widget_Text(WID_BASE_0, UNAME='startAngLE'  $
      ,XOFFSET=119 ,YOFFSET=37 ,SCR_XSIZE=84 ,SCR_YSIZE=23 ,XSIZE=20  $
      ,YSIZE=1,/editable)


  WID_LABEL_2 = Widget_Label(WID_BASE_0, UNAME='WID_LABEL_2'  $
      ,XOFFSET=15 ,YOFFSET=67 ,SCR_XSIZE=84 ,SCR_YSIZE=18  $
      ,/ALIGN_LEFT ,VALUE='Angle Increment')


  angIncLE = Widget_Text(WID_BASE_0, UNAME='angIncLE' ,XOFFSET=119  $
      ,YOFFSET=67 ,SCR_XSIZE=85 ,SCR_YSIZE=25 ,XSIZE=20 ,YSIZE=1,/editable)


  WID_LABEL_3 = Widget_Label(WID_BASE_0, UNAME='WID_LABEL_3'  $
      ,XOFFSET=16 ,YOFFSET=97 ,SCR_XSIZE=91 ,SCR_YSIZE=15  $
      ,/ALIGN_LEFT ,VALUE='Start Number')


  WID_LABEL_4 = Widget_Label(WID_BASE_0, UNAME='WID_LABEL_4'  $
      ,XOFFSET=16 ,YOFFSET=127 ,SCR_XSIZE=79 ,SCR_YSIZE=15  $
      ,/ALIGN_LEFT ,VALUE='Number of Images')


  ;WID_LABEL_5 = Widget_Label(WID_BASE_0, UNAME='WID_LABEL_5'  $
  ;   ,XOFFSET=16 ,YOFFSET=157 ,SCR_XSIZE=71 ,SCR_YSIZE=15  $
  ;   ,/ALIGN_LEFT ,VALUE='Status :')


  ;WID_TEXT_2 = Widget_Text(WID_BASE_0, UNAME='WID_TEXT_2'  $
  ;    ,XOFFSET=119 ,YOFFSET=97 ,SCR_XSIZE=84 ,SCR_YSIZE=25 ,XSIZE=20  $
  ;    ,YSIZE=1)


  startNumLE = Widget_Text(WID_BASE_0, UNAME='startNumLE'  $
      ,XOFFSET=119 ,YOFFSET=97 ,SCR_XSIZE=84 ,SCR_YSIZE=25 ,XSIZE=20  $
      ,YSIZE=1, /align_left)


  numImagesLE = Widget_Text(WID_BASE_0, UNAME='numImagesLE'  $
      ,XOFFSET=119 ,YOFFSET=127 ,SCR_XSIZE=84 ,SCR_YSIZE=25 ,XSIZE=20  $
      ,YSIZE=1, /align_left)


  ;WID_TEXT_5 = Widget_Text(WID_BASE_0, UNAME='WID_TEXT_5' ,XOFFSET=14  $
  ;   ,YOFFSET=187 ,SCR_XSIZE=190 ,SCR_YSIZE=25 ,XSIZE=20 ,YSIZE=1)

  WID_LABEL_ch = Widget_Label(WID_BASE_0, UNAME='WID_LABEL_ch'  $
      ,XOFFSET=16 ,YOFFSET=157 ,SCR_XSIZE=91 ,SCR_YSIZE=15  $
      ,/ALIGN_LEFT ,VALUE='chi')

  chiLE = Widget_Text(WID_BASE_0, UNAME='chiLE'  $
      ,XOFFSET=119 ,YOFFSET=157 ,SCR_XSIZE=84 ,SCR_YSIZE=25 ,XSIZE=20  $
      ,YSIZE=1,/editable,value='0.')

  WID_LABEL_detect = Widget_Label(WID_BASE_0, UNAME='WID_LABEL_detect'  $
      ,XOFFSET=16 ,YOFFSET=187 ,SCR_XSIZE=91 ,SCR_YSIZE=15  $
      ,/ALIGN_LEFT ,VALUE='Detector')

  detectLE = Widget_Text(WID_BASE_0, UNAME='detectLE'  $
      ,XOFFSET=119 ,YOFFSET=187 ,SCR_XSIZE=84 ,SCR_YSIZE=25 ,XSIZE=20  $
      ,YSIZE=1,/editable,value='0.')

  WID_LABEL_exp = Widget_Label(WID_BASE_0, UNAME='WID_LABEL_exp'  $
      ,XOFFSET=16 ,YOFFSET=217 ,SCR_XSIZE=91 ,SCR_YSIZE=15  $
      ,/ALIGN_LEFT ,VALUE='Expos. Time')

  exposLE = Widget_Text(WID_BASE_0, UNAME='exposLE'  $
      ,XOFFSET=119 ,YOFFSET=217 ,SCR_XSIZE=84 ,SCR_YSIZE=25 ,XSIZE=20  $
      ,YSIZE=1,/editable,value='0.')

  Widget_Control, startNumLE, set_value=fn(2)
  numims = string(fix(fn(3))-fix(fn(2))+1)
  Widget_Control, numImagesLE, set_value=numims
  Widget_control, WID_BASE_0, set_uvalue=fn
  Widget_Control, /REALIZE, WID_BASE_0

  XManager, 'WID_BASE_0', WID_BASE_0, /NO_BLOCK

end
;
; Empty stub procedure used for autoloading.
;
pro Wid_settings_gen_dlg, fn, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
  ;WID_BASE_0, fn, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
  WID_BASE_0, fn, GROUP_LEADER=wGroup, _EXTRA=fn
end
