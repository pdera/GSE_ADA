
pro WID_BASE_0_L, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_

  ;Resolve_Routine, 'WID_test_eventcb',/COMPILE_FULL_FILE  ; Load event callback routines

  WID_BASE_0 = Widget_Base( GROUP_LEADER=wGroup, UNAME='WID_BASE_0'  $
      ,XOFFSET=5 ,YOFFSET=5 ,SCR_XSIZE=469 ,SCR_YSIZE=233  $
      ,TITLE='IDL' ,SPACE=3 ,XPAD=3 ,YPAD=3, UVALUE='Main')


  WID_BUTTON_Open = Widget_Button(WID_BASE_0, UNAME='WID_BUTTON_Open'  $
      ,XOFFSET=11 ,YOFFSET=13 ,SCR_XSIZE=88 ,SCR_YSIZE=30  $
      ,/ALIGN_CENTER ,VALUE='Open', UVALUE='Open')


  WID_DRAW_0 = Widget_Draw(WID_BASE_0, UNAME='WID_DRAW_0'  $
      ,XOFFSET=200 ,YOFFSET=20 ,SCR_XSIZE=240 ,SCR_YSIZE=163, UVALUE='Draw')

  Widget_Control, /REALIZE, WID_BASE_0

  XManager, 'WID_BASE_0_L', WID_BASE_0, /NO_BLOCK

end


pro WID_BASE_0_L_event, ev
WIDGET_CONTROL, ev.id, GET_UVALUE=uv
print, uv
end