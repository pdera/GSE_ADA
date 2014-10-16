
pro WID_filter_L, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_

COMMON WID_filter_L_common, $
  WID_DROPLIST_0, $
  WID_BUTTON_0, $ ; less than
  WID_BUTTON_1, $ ; greater than
  WID_BUTTON_2, $ ; select
  WID_BUTTON_3, $ ; close
  WID_TEXT_0

  Resolve_Routine, 'WID_filter_eventcb',/COMPILE_FULL_FILE  ; Load event callback routines

  WID_filter = Widget_Base( GROUP_LEADER=wGroup, UNAME='WID_filter'  $
      ,XOFFSET=5 ,YOFFSET=5 ,SCR_XSIZE=518 ,SCR_YSIZE=280  $
      ,TITLE='Filter peaks' ,SPACE=3 ,XPAD=3 ,YPAD=3)


  WID_DROPLIST_0 = Widget_Droplist(WID_filter, UNAME='WID_DROPLIST_0'  $
      ,XOFFSET=16 ,YOFFSET=58 ,SCR_XSIZE=147 ,SCR_YSIZE=24, UVALUE='droplist', VALUE=['Intensity','Residual'])


  WID_LABEL_0 = Widget_Label(WID_filter, UNAME='WID_LABEL_0'  $
      ,XOFFSET=17 ,YOFFSET=32 ,/ALIGN_LEFT ,VALUE='Property')


  WID_BASE_1 = Widget_Base(WID_filter, UNAME='WID_BASE_1'  $
      ,XOFFSET=181 ,YOFFSET=55 ,TITLE='IDL' ,COLUMN=1 ,/EXCLUSIVE)


  WID_BUTTON_0 = Widget_Button(WID_BASE_1, UNAME='WID_BUTTON_0'  $
      ,/ALIGN_LEFT ,VALUE='less than', UVALUE='less than')


  WID_BUTTON_1 = Widget_Button(WID_BASE_1, UNAME='WID_BUTTON_1'  $
      ,YOFFSET=33 ,/ALIGN_LEFT ,VALUE='greater than', UVALUE='greater than')


  WID_TEXT_0 = Widget_Text(WID_filter, UNAME='WID_TEXT_0'  $
      ,XOFFSET=309 ,YOFFSET=55 ,SCR_XSIZE=119 ,SCR_YSIZE=28 ,XSIZE=20  $
      ,YSIZE=1, /EDITABLE)


  WID_BUTTON_2 = Widget_Button(WID_filter, UNAME='WID_BUTTON_2'  $
      ,XOFFSET=96 ,YOFFSET=148 ,SCR_XSIZE=118 ,SCR_YSIZE=46  $
      ,/ALIGN_CENTER ,VALUE='Select', UVALUE='Select')


  WID_BUTTON_3 = Widget_Button(WID_filter, UNAME='WID_BUTTON_3'  $
      ,XOFFSET=268 ,YOFFSET=146 ,SCR_XSIZE=118 ,SCR_YSIZE=46  $
      ,/ALIGN_CENTER ,VALUE='Close', UVALUE='Close')

  Widget_Control, /REALIZE, WID_filter

  Widget_Control, WID_BUTTON_0, SET_BUTTON=1

  XManager, 'WID_filter_L', WID_filter, /NO_BLOCK

end
;-------------------------
pro WID_filter_L_event, ev
COMMON WID_filter_L_common
WIDGET_CONTROL, ev.id, get_uvalue=uv
case uv of
'Select':$
begin
 w=widget_info(WID_DROPLIST_0, /DROPLIST_SELECT)
 print, w
end
'Close':$
begin
   WIDGET_CONTROL, ev.top, /destroy
end
else:
endcase
end