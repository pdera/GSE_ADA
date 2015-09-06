; 
; IDL Widget Interface Procedures. This Code is automatically 
;     generated and should not be modified.

; 
; Generated on:	09/06/2015 16:38.07
; 
pro WID_BASE_0_event, Event

  wTarget = (widget_info(Event.id,/NAME) eq 'TREE' ?  $
      widget_info(Event.id, /tree_root) : event.id)


  wWidget =  Event.top

  case wTarget of

    else:
  endcase

end

pro WID_BASE_0, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_

  Resolve_Routine, 'Wid_gonio_eventcb',/COMPILE_FULL_FILE  ; Load event callback routines
  
  WID_BASE_0 = Widget_Base( GROUP_LEADER=wGroup, UNAME='WID_BASE_0'  $
      ,XOFFSET=5 ,YOFFSET=5 ,SCR_XSIZE=516 ,SCR_YSIZE=568  $
      ,TITLE='IDL' ,SPACE=3 ,XPAD=3 ,YPAD=3)

  
  WID_BASE_1 = Widget_Base(WID_BASE_0, UNAME='WID_BASE_1' ,XOFFSET=28  $
      ,YOFFSET=34 ,SCR_XSIZE=171 ,SCR_YSIZE=143 ,TITLE='IDL' ,SPACE=3  $
      ,XPAD=3 ,YPAD=3)

  
  WID_TEXT_0 = Widget_Text(WID_BASE_1, UNAME='WID_TEXT_0' ,XOFFSET=68  $
      ,YOFFSET=19 ,SCR_XSIZE=77 ,SCR_YSIZE=21 ,XSIZE=20 ,YSIZE=1)

  
  WID_TEXT_1 = Widget_Text(WID_BASE_1, UNAME='WID_TEXT_1' ,XOFFSET=68  $
      ,YOFFSET=44 ,SCR_XSIZE=77 ,SCR_YSIZE=21 ,XSIZE=20 ,YSIZE=1)

  
  WID_TEXT_2 = Widget_Text(WID_BASE_1, UNAME='WID_TEXT_2' ,XOFFSET=68  $
      ,YOFFSET=69 ,SCR_XSIZE=77 ,SCR_YSIZE=21 ,XSIZE=20 ,YSIZE=1)

  
  WID_TEXT_3 = Widget_Text(WID_BASE_1, UNAME='WID_TEXT_3' ,XOFFSET=68  $
      ,YOFFSET=94 ,SCR_XSIZE=77 ,SCR_YSIZE=21 ,XSIZE=20 ,YSIZE=1)

  
  WID_LABEL_0 = Widget_Label(WID_BASE_1, UNAME='WID_LABEL_0'  $
      ,XOFFSET=25 ,YOFFSET=25 ,/ALIGN_LEFT ,VALUE='Mu')

  
  WID_LABEL_1 = Widget_Label(WID_BASE_1, UNAME='WID_LABEL_1'  $
      ,XOFFSET=25 ,YOFFSET=50 ,/ALIGN_LEFT ,VALUE='kEta')

  
  WID_LABEL_2 = Widget_Label(WID_BASE_1, UNAME='WID_LABEL_2'  $
      ,XOFFSET=25 ,YOFFSET=75 ,/ALIGN_LEFT ,VALUE='kappa')

  
  WID_LABEL_3 = Widget_Label(WID_BASE_1, UNAME='WID_LABEL_3'  $
      ,XOFFSET=25 ,YOFFSET=100 ,/ALIGN_LEFT ,VALUE='kPhi')

  Widget_Control, /REALIZE, WID_BASE_0

  XManager, 'WID_BASE_0', WID_BASE_0, /NO_BLOCK  

end
; 
; Empty stub procedure used for autoloading.
; 
pro Wid_gonio, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
  WID_BASE_0, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
end
