HEADER
; IDL Visual Widget Builder Resource file. Version 1
; Generated on:	05/20/2014 11:15.15
VERSION 1
END

WID_BASE_calibration BASE 5 5 377 550
TLB
CAPTION "Calibration"
XPAD = 3
YPAD = 3
SPACE = 3
BEGIN
  WID_TEXT_twist TEXT 110 40 0 0
  EDITABLE
  WIDTH = 20
  HEIGHT = 1
  END
  WID_LABEL_0 LABEL 30 45 0 0
  VALUE "twist"
  ALIGNLEFT
  END
  WID_LABEL_1 LABEL 30 70 0 0
  VALUE "pix size x"
  ALIGNLEFT
  END
  WID_TEXT_psizeX TEXT 110 65 0 0
  EDITABLE
  WIDTH = 20
  HEIGHT = 1
  END
  WID_TEXT_distance TEXT 110 115 0 0
  EDITABLE
  WIDTH = 20
  HEIGHT = 1
  END
  WID_LABEL_2 LABEL 30 120 0 0
  VALUE "distance"
  ALIGNLEFT
  END
  WID_LABEL_3 LABEL 30 95 0 0
  VALUE "pix size y"
  ALIGNLEFT
  END
  WID_TEXT_psizeY TEXT 110 90 0 0
  EDITABLE
  WIDTH = 20
  HEIGHT = 1
  END
  WID_TEXT_beamy TEXT 110 190 0 0
  EDITABLE
  WIDTH = 20
  HEIGHT = 1
  END
  WID_LABEL_4 LABEL 30 195 0 0
  VALUE "beam y"
  ALIGNLEFT
  END
  WID_LABEL_5 LABEL 30 220 0 0
  VALUE "rotation"
  ALIGNLEFT
  END
  WID_TEXT_rotation TEXT 110 215 0 0
  EDITABLE
  WIDTH = 20
  HEIGHT = 1
  END
  WID_TEXT_beamx TEXT 110 165 0 0
  EDITABLE
  WIDTH = 20
  HEIGHT = 1
  END
  WID_LABEL_6 LABEL 30 170 0 0
  VALUE "beam x"
  ALIGNLEFT
  END
  WID_LABEL_7 LABEL 30 145 0 0
  VALUE "wavelength"
  ALIGNLEFT
  END
  WID_TEXT_wavelength TEXT 110 140 0 0
  EDITABLE
  WIDTH = 20
  HEIGHT = 1
  END
  WID_TEXT_tilt TEXT 110 240 0 0
  EDITABLE
  WIDTH = 20
  HEIGHT = 1
  END
  WID_LABEL_8 LABEL 30 245 0 0
  VALUE "tilt"
  ALIGNLEFT
  END
  WID_LABEL_9 LABEL 30 465 0 0
  VALUE "phi"
  ALIGNLEFT
  END
  WID_TEXT_phi TEXT 110 460 0 0
  EDITABLE
  WIDTH = 20
  HEIGHT = 1
  END
  WID_TEXT_alpha TEXT 110 360 0 0
  EDITABLE
  WIDTH = 20
  HEIGHT = 1
  END
  WID_LABEL_10 LABEL 30 365 0 0
  VALUE "alpha"
  ALIGNLEFT
  END
  WID_LABEL_11 LABEL 30 390 0 0
  VALUE "2theta"
  ALIGNLEFT
  END
  WID_TEXT_2theta TEXT 110 385 0 0
  EDITABLE
  WIDTH = 20
  HEIGHT = 1
  END
  WID_TEXT_kappa TEXT 110 435 0 0
  EDITABLE
  WIDTH = 20
  HEIGHT = 1
  END
  WID_LABEL_12 LABEL 30 440 0 0
  VALUE "kappa"
  ALIGNLEFT
  END
  WID_LABEL_13 LABEL 30 415 0 0
  VALUE "omega"
  ALIGNLEFT
  END
  WID_TEXT_omega TEXT 110 410 0 0
  EDITABLE
  WIDTH = 20
  HEIGHT = 1
  END
  WID_BUTTON_open PUSHBUTTON 250 40 94 25
  VALUE "Open"
  ALIGNCENTER
  ONACTIVATE "Event_Open_calibration"
  END
  WID_BUTTON_save PUSHBUTTON 250 70 94 25
  VALUE "Save"
  ALIGNCENTER
  ONACTIVATE "Event_Save_calibration"
  END
  WID_BUTTON_recalcXYZ PUSHBUTTON 250 100 94 25
  VALUE "Recalc. XYZ"
  ALIGNCENTER
  ONACTIVATE "Event_Recalc_XYZ"
  END
  WID_BUTTON_recalcDetXY PUSHBUTTON 250 130 94 25
  VALUE "Recalc. DetXY"
  ALIGNCENTER
  ONACTIVATE "Event_Recalc_DetXY"
  END
  WID_BUTTON_close PUSHBUTTON 250 455 94 25
  VALUE "Close"
  ALIGNCENTER
  ONACTIVATE "Event_Close"
  END
  WID_LABEL_14 LABEL 28 306 0 0
  VALUE "No pix Y"
  ALIGNLEFT
  END
  WID_TEXT_tilt_0 TEXT 108 301 0 0
  EDITABLE
  WIDTH = 20
  HEIGHT = 1
  END
  WID_TEXT_nopixX TEXT 108 276 0 0
  EDITABLE
  WIDTH = 20
  HEIGHT = 1
  END
  WID_LABEL_15 LABEL 28 281 0 0
  VALUE "No pix x"
  ALIGNLEFT
  END
END
