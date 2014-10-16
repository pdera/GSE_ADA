
pro WID_detector_calibration_L, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_

  WID_detector_calibration = Widget_Base( GROUP_LEADER=wGroup,  $
      UNAME='WID_detector_calibration' ,XOFFSET=5 ,YOFFSET=5  $
      ,SCR_XSIZE=612 ,SCR_YSIZE=558 ,TITLE='Refine detector'+ $
      ' calibrations' ,SPACE=3 ,XPAD=3 ,YPAD=3)


  WID_TEXT_pt1 = Widget_Text(WID_detector_calibration,  $
      UNAME='WID_TEXT_pt1' ,XOFFSET=21 ,YOFFSET=76 ,SCR_XSIZE=225  $
      ,SCR_YSIZE=20 ,XSIZE=20 ,YSIZE=1)


  WID_BUTTON_open_pt1 = Widget_Button(WID_detector_calibration,  $
      UNAME='WID_BUTTON_open_pt1' ,XOFFSET=20 ,YOFFSET=51  $
      ,SCR_XSIZE=48 ,SCR_YSIZE=20 ,/ALIGN_CENTER ,VALUE='Open')


  WID_BUTTON_open_cal1 = Widget_Button(WID_detector_calibration,  $
      UNAME='WID_BUTTON_open_cal1' ,XOFFSET=260 ,YOFFSET=52  $
      ,SCR_XSIZE=48 ,SCR_YSIZE=20 ,/ALIGN_CENTER ,VALUE='Open')


  WID_TEXT_cal1 = Widget_Text(WID_detector_calibration,  $
      UNAME='WID_TEXT_cal1' ,XOFFSET=260 ,YOFFSET=77 ,SCR_XSIZE=225  $
      ,SCR_YSIZE=20 ,XSIZE=20 ,YSIZE=1)


  WID_TEXT_cal2 = Widget_Text(WID_detector_calibration,  $
      UNAME='WID_TEXT_cal2' ,XOFFSET=259 ,YOFFSET=129 ,SCR_XSIZE=225  $
      ,SCR_YSIZE=20 ,XSIZE=20 ,YSIZE=1)


  WID_BUTTON_open_cal2 = Widget_Button(WID_detector_calibration,  $
      UNAME='WID_BUTTON_open_cal2' ,XOFFSET=259 ,YOFFSET=104  $
      ,SCR_XSIZE=48 ,SCR_YSIZE=20 ,/ALIGN_CENTER ,VALUE='Open')


  WID_BUTTON_open_pt2 = Widget_Button(WID_detector_calibration,  $
      UNAME='WID_BUTTON_open_pt2' ,XOFFSET=19 ,YOFFSET=103  $
      ,SCR_XSIZE=48 ,SCR_YSIZE=20 ,/ALIGN_CENTER ,VALUE='Open')


  WID_TEXT_pt2 = Widget_Text(WID_detector_calibration,  $
      UNAME='WID_TEXT_pt2' ,XOFFSET=19 ,YOFFSET=128 ,SCR_XSIZE=225  $
      ,SCR_YSIZE=20 ,XSIZE=20 ,YSIZE=1)


  WID_BASE_1 = Widget_Base(WID_detector_calibration,  $
      UNAME='WID_BASE_1' ,XOFFSET=503 ,YOFFSET=76 ,TITLE='IDL'  $
      ,COLUMN=1 ,/NONEXCLUSIVE)


  WID_BUTTON_use1 = Widget_Button(WID_BASE_1, UNAME='WID_BUTTON_use1'  $
      ,/ALIGN_LEFT ,VALUE='Use')


  WID_BASE_2 = Widget_Base(WID_detector_calibration,  $
      UNAME='WID_BASE_2' ,XOFFSET=503 ,YOFFSET=127 ,TITLE='IDL'  $
      ,COLUMN=1 ,/NONEXCLUSIVE)


  WID_BUTTON_use2 = Widget_Button(WID_BASE_2, UNAME='WID_BUTTON_use2'  $
      ,/ALIGN_LEFT ,VALUE='Use')


  WID_BASE_3 = Widget_Base(WID_detector_calibration,  $
      UNAME='WID_BASE_3' ,XOFFSET=503 ,YOFFSET=179 ,TITLE='IDL'  $
      ,COLUMN=1 ,/NONEXCLUSIVE)


  WID_BUTTON_use3 = Widget_Button(WID_BASE_3, UNAME='WID_BUTTON_use3'  $
      ,/ALIGN_LEFT ,VALUE='Use')


  WID_TEXT_pt3 = Widget_Text(WID_detector_calibration,  $
      UNAME='WID_TEXT_pt3' ,XOFFSET=19 ,YOFFSET=180 ,SCR_XSIZE=225  $
      ,SCR_YSIZE=20 ,XSIZE=20 ,YSIZE=1)


  WID_BUTTON_open_pt3 = Widget_Button(WID_detector_calibration,  $
      UNAME='WID_BUTTON_open_pt3' ,XOFFSET=19 ,YOFFSET=155  $
      ,SCR_XSIZE=48 ,SCR_YSIZE=20 ,/ALIGN_CENTER ,VALUE='Open')


  WID_BUTTON_open_cal3 = Widget_Button(WID_detector_calibration,  $
      UNAME='WID_BUTTON_open_cal3' ,XOFFSET=259 ,YOFFSET=156  $
      ,SCR_XSIZE=48 ,SCR_YSIZE=20 ,/ALIGN_CENTER ,VALUE='Open')


  WID_TEXT_cal3 = Widget_Text(WID_detector_calibration,  $
      UNAME='WID_TEXT_cal3' ,XOFFSET=259 ,YOFFSET=181 ,SCR_XSIZE=225  $
      ,SCR_YSIZE=20 ,XSIZE=20 ,YSIZE=1)


  WID_LABEL_0 = Widget_Label(WID_detector_calibration,  $
      UNAME='WID_LABEL_0' ,XOFFSET=70 ,YOFFSET=21 ,/ALIGN_LEFT  $
      ,VALUE='Peak table')


  WID_LABEL_1 = Widget_Label(WID_detector_calibration,  $
      UNAME='WID_LABEL_1' ,XOFFSET=302 ,YOFFSET=22 ,/ALIGN_LEFT  $
      ,VALUE='Calibration')


  WID_LABEL_2 = Widget_Label(WID_detector_calibration,  $
      UNAME='WID_LABEL_2' ,XOFFSET=156 ,YOFFSET=225 ,/ALIGN_LEFT  $
      ,VALUE='Orientation matrix')


  WID_BUTTON_open_ub = Widget_Button(WID_detector_calibration,  $
      UNAME='WID_BUTTON_open_ub' ,XOFFSET=20 ,YOFFSET=223  $
      ,SCR_XSIZE=48 ,SCR_YSIZE=20 ,/ALIGN_CENTER ,VALUE='Open')


  WID_LIST_output = Widget_List(WID_detector_calibration,  $
      UNAME='WID_LIST_output' ,XOFFSET=258 ,YOFFSET=246  $
      ,SCR_XSIZE=334 ,SCR_YSIZE=198 ,XSIZE=11 ,YSIZE=2)


  WID_BUTTON_close = Widget_Button(WID_detector_calibration,  $
      UNAME='WID_BUTTON_close' ,XOFFSET=497 ,YOFFSET=482  $
      ,SCR_XSIZE=95 ,SCR_YSIZE=33 ,/ALIGN_CENTER ,VALUE='Close')


  WID_BUTTON_save_cal3 = Widget_Button(WID_detector_calibration,  $
      UNAME='WID_BUTTON_save_cal3' ,XOFFSET=311 ,YOFFSET=156  $
      ,SCR_XSIZE=48 ,SCR_YSIZE=20 ,/ALIGN_CENTER ,VALUE='Save')


  WID_BUTTON_save_cal2 = Widget_Button(WID_detector_calibration,  $
      UNAME='WID_BUTTON_save_cal2' ,XOFFSET=311 ,YOFFSET=104  $
      ,SCR_XSIZE=48 ,SCR_YSIZE=20 ,/ALIGN_CENTER ,VALUE='Save')


  WID_BUTTON_save_cal1 = Widget_Button(WID_detector_calibration,  $
      UNAME='WID_BUTTON_save_cal1' ,XOFFSET=312 ,YOFFSET=52  $
      ,SCR_XSIZE=48 ,SCR_YSIZE=20 ,/ALIGN_CENTER ,VALUE='Save')


  WID_BUTTON_Help = Widget_Button(WID_detector_calibration,  $
      UNAME='WID_BUTTON_Help' ,XOFFSET=399 ,YOFFSET=482 ,SCR_XSIZE=95  $
      ,SCR_YSIZE=33 ,/ALIGN_CENTER ,VALUE='Help')


  WID_LIST_ub = Widget_List(WID_detector_calibration,  $
      UNAME='WID_LIST_ub' ,XOFFSET=21 ,YOFFSET=247 ,SCR_XSIZE=219  $
      ,SCR_YSIZE=197 ,XSIZE=11 ,YSIZE=2)

  Widget_Control, /REALIZE, WID_detector_calibration

  WID_detector_calibration_aux

  XManager, 'WID_detector_calibration_L', WID_detector_calibration, /NO_BLOCK

end
