;
; IDL Widget Interface Procedures. This Code is automatically
;     generated and should not be modified.

;
; Generated on:	05/19/2014 22:14.33
;
pro WID_BASE_calibration_event, Event

  wTarget = (widget_info(Event.id,/NAME) eq 'TREE' ?  $
      widget_info(Event.id, /tree_root) : event.id)


  wWidget =  Event.top

  case wTarget of

    Widget_Info(wWidget, FIND_BY_UNAME='WID_BUTTON_open'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        Event_Open_calibration, Event
    end
    Widget_Info(wWidget, FIND_BY_UNAME='WID_BUTTON_save'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        Event_Save_calibration, Event
    end
    Widget_Info(wWidget, FIND_BY_UNAME='WID_BUTTON_recalcXYZ'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        Event_Recalc_XYZ, Event
    end
    Widget_Info(wWidget, FIND_BY_UNAME='WID_BUTTON_recalcDetXY'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        Event_Recalc_DetXY, Event
    end
    Widget_Info(wWidget, FIND_BY_UNAME='WID_BUTTON_close'): begin
      if( Tag_Names(Event, /STRUCTURE_NAME) eq 'WIDGET_BUTTON' )then $
        Event_Close, Event
    end
    else:
  endcase

end

pro WID_BASE_calibration, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_

COMMON guis, WID_BASE_calibration

  Resolve_Routine, 'WID_calibration_eventcb',/COMPILE_FULL_FILE  ; Load event callback routines

  WID_BASE_calibration = Widget_Base( GROUP_LEADER=wGroup,  $
      UNAME='WID_BASE_calibration' ,XOFFSET=5 ,YOFFSET=5  $
      ,SCR_XSIZE=377 ,SCR_YSIZE=550 ,TITLE='Calibration' ,SPACE=3  $
      ,XPAD=3 ,YPAD=3)


  WID_TEXT_twist = Widget_Text(WID_BASE_calibration,  $
      UNAME='WID_TEXT_twist' ,XOFFSET=110 ,YOFFSET=40 ,/EDITABLE  $
      ,XSIZE=20 ,YSIZE=1)


  WID_LABEL_0 = Widget_Label(WID_BASE_calibration,  $
      UNAME='WID_LABEL_0' ,XOFFSET=30 ,YOFFSET=45 ,/ALIGN_LEFT  $
      ,VALUE='twist')


  WID_LABEL_1 = Widget_Label(WID_BASE_calibration,  $
      UNAME='WID_LABEL_1' ,XOFFSET=30 ,YOFFSET=70 ,/ALIGN_LEFT  $
      ,VALUE='pix size x')


  WID_TEXT_psizeX = Widget_Text(WID_BASE_calibration,  $
      UNAME='WID_TEXT_psizeX' ,XOFFSET=110 ,YOFFSET=65 ,/EDITABLE  $
      ,XSIZE=20 ,YSIZE=1)


  WID_TEXT_distance = Widget_Text(WID_BASE_calibration,  $
      UNAME='WID_TEXT_distance' ,XOFFSET=110 ,YOFFSET=115 ,/EDITABLE  $
      ,XSIZE=20 ,YSIZE=1)


  WID_LABEL_2 = Widget_Label(WID_BASE_calibration,  $
      UNAME='WID_LABEL_2' ,XOFFSET=30 ,YOFFSET=120 ,/ALIGN_LEFT  $
      ,VALUE='distance')


  WID_LABEL_3 = Widget_Label(WID_BASE_calibration,  $
      UNAME='WID_LABEL_3' ,XOFFSET=30 ,YOFFSET=95 ,/ALIGN_LEFT  $
      ,VALUE='pix size y')


  WID_TEXT_psizeY = Widget_Text(WID_BASE_calibration,  $
      UNAME='WID_TEXT_psizeY' ,XOFFSET=110 ,YOFFSET=90 ,/EDITABLE  $
      ,XSIZE=20 ,YSIZE=1)


  WID_TEXT_beamy = Widget_Text(WID_BASE_calibration,  $
      UNAME='WID_TEXT_beamy' ,XOFFSET=110 ,YOFFSET=190 ,/EDITABLE  $
      ,XSIZE=20 ,YSIZE=1)


  WID_LABEL_4 = Widget_Label(WID_BASE_calibration,  $
      UNAME='WID_LABEL_4' ,XOFFSET=30 ,YOFFSET=195 ,/ALIGN_LEFT  $
      ,VALUE='beam y')


  WID_LABEL_5 = Widget_Label(WID_BASE_calibration,  $
      UNAME='WID_LABEL_5' ,XOFFSET=30 ,YOFFSET=220 ,/ALIGN_LEFT  $
      ,VALUE='rotation')


  WID_TEXT_rotation = Widget_Text(WID_BASE_calibration,  $
      UNAME='WID_TEXT_rotation' ,XOFFSET=110 ,YOFFSET=215 ,/EDITABLE  $
      ,XSIZE=20 ,YSIZE=1)


  WID_TEXT_beamx = Widget_Text(WID_BASE_calibration,  $
      UNAME='WID_TEXT_beamx' ,XOFFSET=110 ,YOFFSET=165 ,/EDITABLE  $
      ,XSIZE=20 ,YSIZE=1)


  WID_LABEL_6 = Widget_Label(WID_BASE_calibration,  $
      UNAME='WID_LABEL_6' ,XOFFSET=30 ,YOFFSET=170 ,/ALIGN_LEFT  $
      ,VALUE='beam x')


  WID_LABEL_7 = Widget_Label(WID_BASE_calibration,  $
      UNAME='WID_LABEL_7' ,XOFFSET=30 ,YOFFSET=145 ,/ALIGN_LEFT  $
      ,VALUE='wavelength')


  WID_TEXT_wavelength = Widget_Text(WID_BASE_calibration,  $
      UNAME='WID_TEXT_wavelength' ,XOFFSET=110 ,YOFFSET=140  $
      ,/EDITABLE ,XSIZE=20 ,YSIZE=1)


  WID_TEXT_tilt = Widget_Text(WID_BASE_calibration,  $
      UNAME='WID_TEXT_tilt' ,XOFFSET=110 ,YOFFSET=240 ,/EDITABLE  $
      ,XSIZE=20 ,YSIZE=1)


  WID_LABEL_8 = Widget_Label(WID_BASE_calibration,  $
      UNAME='WID_LABEL_8' ,XOFFSET=30 ,YOFFSET=245 ,/ALIGN_LEFT  $
      ,VALUE='tilt')


  WID_LABEL_9 = Widget_Label(WID_BASE_calibration,  $
      UNAME='WID_LABEL_9' ,XOFFSET=30 ,YOFFSET=465 ,/ALIGN_LEFT  $
      ,VALUE='phi')


  WID_TEXT_phi = Widget_Text(WID_BASE_calibration,  $
      UNAME='WID_TEXT_phi' ,XOFFSET=110 ,YOFFSET=460 ,/EDITABLE  $
      ,XSIZE=20 ,YSIZE=1)


  WID_TEXT_alpha = Widget_Text(WID_BASE_calibration,  $
      UNAME='WID_TEXT_alpha' ,XOFFSET=110 ,YOFFSET=360 ,/EDITABLE  $
      ,XSIZE=20 ,YSIZE=1)


  WID_LABEL_10 = Widget_Label(WID_BASE_calibration,  $
      UNAME='WID_LABEL_10' ,XOFFSET=30 ,YOFFSET=365 ,/ALIGN_LEFT  $
      ,VALUE='alpha')


  WID_LABEL_11 = Widget_Label(WID_BASE_calibration,  $
      UNAME='WID_LABEL_11' ,XOFFSET=30 ,YOFFSET=390 ,/ALIGN_LEFT  $
      ,VALUE='2theta')


  WID_TEXT_2theta = Widget_Text(WID_BASE_calibration,  $
      UNAME='WID_TEXT_2theta' ,XOFFSET=110 ,YOFFSET=385 ,/EDITABLE  $
      ,XSIZE=20 ,YSIZE=1)


  WID_TEXT_kappa = Widget_Text(WID_BASE_calibration,  $
      UNAME='WID_TEXT_kappa' ,XOFFSET=110 ,YOFFSET=435 ,/EDITABLE  $
      ,XSIZE=20 ,YSIZE=1)


  WID_LABEL_12 = Widget_Label(WID_BASE_calibration,  $
      UNAME='WID_LABEL_12' ,XOFFSET=30 ,YOFFSET=440 ,/ALIGN_LEFT  $
      ,VALUE='kappa')


  WID_LABEL_13 = Widget_Label(WID_BASE_calibration,  $
      UNAME='WID_LABEL_13' ,XOFFSET=30 ,YOFFSET=415 ,/ALIGN_LEFT  $
      ,VALUE='omega')


  WID_TEXT_omega = Widget_Text(WID_BASE_calibration,  $
      UNAME='WID_TEXT_omega' ,XOFFSET=110 ,YOFFSET=410 ,/EDITABLE  $
      ,XSIZE=20 ,YSIZE=1)


  WID_BUTTON_open = Widget_Button(WID_BASE_calibration,  $
      UNAME='WID_BUTTON_open' ,XOFFSET=250 ,YOFFSET=40 ,SCR_XSIZE=94  $
      ,SCR_YSIZE=25 ,/ALIGN_CENTER ,VALUE='Open')


  WID_BUTTON_save = Widget_Button(WID_BASE_calibration,  $
      UNAME='WID_BUTTON_save' ,XOFFSET=250 ,YOFFSET=70 ,SCR_XSIZE=94  $
      ,SCR_YSIZE=25 ,/ALIGN_CENTER ,VALUE='Save')


  WID_BUTTON_recalcXYZ = Widget_Button(WID_BASE_calibration,  $
      UNAME='WID_BUTTON_recalcXYZ' ,XOFFSET=250 ,YOFFSET=100  $
      ,SCR_XSIZE=94 ,SCR_YSIZE=25 ,/ALIGN_CENTER ,VALUE='Recalc.'+ $
      ' XYZ')


  WID_BUTTON_recalcDetXY = Widget_Button(WID_BASE_calibration,  $
      UNAME='WID_BUTTON_recalcDetXY' ,XOFFSET=250 ,YOFFSET=130  $
      ,SCR_XSIZE=94 ,SCR_YSIZE=25 ,/ALIGN_CENTER ,VALUE='Recalc.'+ $
      ' DetXY')


  WID_BUTTON_close = Widget_Button(WID_BASE_calibration,  $
      UNAME='WID_BUTTON_close' ,XOFFSET=250 ,YOFFSET=455  $
      ,SCR_XSIZE=94 ,SCR_YSIZE=25 ,/ALIGN_CENTER ,VALUE='Close')


  WID_LABEL_14 = Widget_Label(WID_BASE_calibration,  $
      UNAME='WID_LABEL_14' ,XOFFSET=28 ,YOFFSET=306 ,/ALIGN_LEFT  $
      ,VALUE='No pix Y')


  WID_TEXT_nopixY = Widget_Text(WID_BASE_calibration,  $
      UNAME='WID_TEXT_nopixY' ,XOFFSET=108 ,YOFFSET=301 ,/EDITABLE  $
      ,XSIZE=20 ,YSIZE=1)


  WID_TEXT_nopixX = Widget_Text(WID_BASE_calibration,  $
      UNAME='WID_TEXT_nopixX' ,XOFFSET=108 ,YOFFSET=276 ,/EDITABLE  $
      ,XSIZE=20 ,YSIZE=1)


  WID_LABEL_15 = Widget_Label(WID_BASE_calibration,  $
      UNAME='WID_LABEL_15' ,XOFFSET=28 ,YOFFSET=281 ,/ALIGN_LEFT  $
      ,VALUE='No pix x')

  Widget_Control, /REALIZE, WID_BASE_calibration

  prepopulate_widget, WID_BASE_calibration

  XManager, 'WID_BASE_calibration', WID_BASE_calibration, /NO_BLOCK

end
;
; Empty stub procedure used for autoloading.
;
pro WID_calibration, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
  WID_BASE_calibration, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
end
