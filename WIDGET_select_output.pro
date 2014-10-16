pro WIDGET_select_output, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_

COMMON WIDGET_select_output_common, $
WID_BUTTON_0, $
WID_BUTTON_1, $
WID_BUTTON_2

  WID_BASE_0 = Widget_Base( GROUP_LEADER=wGroup, UNAME='WID_BASE_0'  $
      ,XOFFSET=5 ,YOFFSET=5 ,SCR_XSIZE=241 ,SCR_YSIZE=142  $
      ,TITLE='Select output format' ,SPACE=3 ,XPAD=3 ,YPAD=3)


  WID_BASE_1 = Widget_Base(WID_BASE_0, UNAME='WID_BASE_1' ,XOFFSET=55  $
      ,YOFFSET=15 ,TITLE='IDL' ,COLUMN=1 ,/EXCLUSIVE)


  WID_BUTTON_0 = Widget_Button(WID_BASE_1, UNAME='WID_BUTTON_0'  $
      ,/ALIGN_LEFT ,VALUE='Unit_cell output')


  WID_BUTTON_1 = Widget_Button(WID_BASE_1, UNAME='WID_BUTTON_1'  $
      ,YOFFSET=22 ,/ALIGN_LEFT ,VALUE='Long output')


  WID_BUTTON_2 = Widget_Button(WID_BASE_0, UNAME='WID_BUTTON_2'  $
      ,XOFFSET=48 ,YOFFSET=74 ,SCR_XSIZE=144 ,SCR_YSIZE=22  $
      ,/ALIGN_CENTER ,VALUE='OK')

  Widget_Control, /REALIZE, WID_BASE_0

  WIDGET_select_output_aux

  XManager, 'WIDGET_select_output', WID_BASE_0, /NO_BLOCK

end

;------------------------

pro WIDGET_select_output_event, ev
COMMON WIDGET_select_output_common
 WIDGET_CONTROL, ev.id, GET_UVALUE=uv
 case uv of
 'OK':$
 begin
     WIDGET_CONTROL, ev.top, /destroy
 end
 else:
 endcase
end

;------------------------

pro WIDGET_select_output_aux
COMMON WIDGET_select_output_common
widget_control, wid_button_0, set_uvalue=''
widget_control, wid_button_1, set_uvalue=''
widget_control, wid_button_2, set_uvalue='OK'
end