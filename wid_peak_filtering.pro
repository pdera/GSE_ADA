;
; IDL Widget Interface Procedures. This Code is automatically
;     generated and should not be modified.

;
; Generated on:	05/27/2015 10:23.59
;
pro WID_BASE_peak_filtering_event, Event

  wTarget = (widget_info(Event.id,/NAME) eq 'TREE' ?  $
      widget_info(Event.id, /tree_root) : event.id)


  wWidget =  Event.top

  case wTarget of

    else:
  endcase

end

pro WID_BASE_peak_filtering, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_

  Resolve_Routine, 'wid_peak_filtering_eventcb',/COMPILE_FULL_FILE  ; Load event callback routines

  WID_BASE_peak_filtering = Widget_Base( GROUP_LEADER=wGroup,  $
      UNAME='WID_BASE_peak_filtering' ,XOFFSET=5 ,YOFFSET=5  $
      ,SCR_XSIZE=132 ,SCR_YSIZE=384 ,TITLE='IDL' ,SPACE=3 ,XPAD=3  $
      ,YPAD=3)


;-------- peak filtering controls

  WID_BASE_1 = Widget_Base(WID_BASE_peak_filtering,  $
      UNAME='WID_BASE_1' ,XOFFSET=8 ,YOFFSET=19 ,SCR_XSIZE=95  $
      ,SCR_YSIZE=258 ,TITLE='IDL' ,SPACE=3 ,XPAD=3 ,YPAD=3)


  WID_TEXT_0 = Widget_Text(WID_BASE_1, UNAME='WID_TEXT_0' ,XOFFSET=5  $
      ,YOFFSET=30 ,SCR_XSIZE=40 ,SCR_YSIZE=21 ,XSIZE=20 ,YSIZE=1)


  WID_TEXT_1 = Widget_Text(WID_BASE_1, UNAME='WID_TEXT_1' ,XOFFSET=5  $
      ,YOFFSET=80 ,SCR_XSIZE=40 ,SCR_YSIZE=21 ,XSIZE=20 ,YSIZE=1)


  WID_TEXT_2 = Widget_Text(WID_BASE_1, UNAME='WID_TEXT_2' ,XOFFSET=5  $
      ,YOFFSET=130 ,SCR_XSIZE=40 ,SCR_YSIZE=21 ,XSIZE=20 ,YSIZE=1)


  WID_TEXT_3 = Widget_Text(WID_BASE_1, UNAME='WID_TEXT_3' ,XOFFSET=5  $
      ,YOFFSET=180 ,SCR_XSIZE=40 ,SCR_YSIZE=21 ,XSIZE=20 ,YSIZE=1)


  WID_TEXT_4 = Widget_Text(WID_BASE_1, UNAME='WID_TEXT_4' ,XOFFSET=5  $
      ,YOFFSET=230 ,SCR_XSIZE=40 ,SCR_YSIZE=21 ,XSIZE=20 ,YSIZE=1)


  WID_BASE_2 = Widget_Base(WID_BASE_1, UNAME='WID_BASE_2' ,XOFFSET=5  $
      ,TITLE='IDL' ,COLUMN=1 ,/NONEXCLUSIVE)


  WID_BUTTON_0 = Widget_Button(WID_BASE_2, UNAME='WID_BUTTON_0'  $
      ,/ALIGN_LEFT ,VALUE='Min I')


  WID_BASE_3 = Widget_Base(WID_BASE_1, UNAME='WID_BASE_3' ,XOFFSET=5  $
      ,YOFFSET=50 ,TITLE='IDL' ,COLUMN=1 ,/NONEXCLUSIVE)


  WID_BUTTON_1 = Widget_Button(WID_BASE_3, UNAME='WID_BUTTON_1'  $
      ,/ALIGN_LEFT ,VALUE='Max I')


  WID_BASE_4 = Widget_Base(WID_BASE_1, UNAME='WID_BASE_4' ,XOFFSET=5  $
      ,YOFFSET=100 ,TITLE='IDL' ,COLUMN=1 ,/NONEXCLUSIVE)


  WID_BUTTON_2 = Widget_Button(WID_BASE_4, UNAME='WID_BUTTON_2'  $
      ,/ALIGN_LEFT ,VALUE='Max width')


  WID_BASE_5 = Widget_Base(WID_BASE_1, UNAME='WID_BASE_5' ,XOFFSET=5  $
      ,YOFFSET=150 ,TITLE='IDL' ,COLUMN=1 ,/NONEXCLUSIVE)


  WID_BUTTON_3 = Widget_Button(WID_BASE_5, UNAME='WID_BUTTON_3'  $
      ,/ALIGN_LEFT ,VALUE='Max diff')


  WID_BASE_6 = Widget_Base(WID_BASE_1, UNAME='WID_BASE_6' ,XOFFSET=5  $
      ,YOFFSET=200 ,TITLE='IDL' ,COLUMN=1 ,/NONEXCLUSIVE)


  WID_BUTTON_4 = Widget_Button(WID_BASE_6, UNAME='WID_BUTTON_4'  $
      ,/ALIGN_LEFT ,VALUE='Total diff')


 ;------------------------------

  Widget_Control, /REALIZE, WID_BASE_peak_filtering

  XManager, 'WID_BASE_peak_filtering', WID_BASE_peak_filtering, /NO_BLOCK

end
;
; Empty stub procedure used for autoloading.
;
pro wid_peak_filtering, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
  WID_BASE_peak_filtering, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
end
