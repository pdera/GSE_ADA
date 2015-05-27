 pro WID_MAR345_L, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_

;---- PD change 7/29/2010
; utilize include=@ command

 @WID_GSE_ADA_COMMON

;---- PD change end

 COMMON draws,DRAWA,wid_list_3a

 ;******************************* NEW CODE **********************
;Error handling
Catch, GSE_Error
if GSE_Error ne 0 then $
begin
Catch, /Cancel
;Message, 'ERROR:'
ok = Dialog_Message (!Error_State.Msg + ' Main GSE_ADA window error...', $
                    /Error)
RETURN
endif
;******************************* NEW CODE **********************


  WID_MAR345 = Widget_Base( GROUP_LEADER=wGroup, UNAME='WID_MAR345'  $
      ,XOFFSET=5 ,YOFFSET=5 ,SCR_XSIZE=1189 ,SCR_YSIZE=708  $
      ,TITLE='ATREX ver 1.0, May 26, 2015' ,SPACE=3 ,XPAD=3 ,YPAD=3)


  WID_BUTTON_0 = Widget_Button(WID_MAR345, UNAME='WID_BUTTON_0'  $
      ,XOFFSET=990 ,YOFFSET=10 ,SCR_XSIZE=80 ,SCR_YSIZE=39  $
      ,/ALIGN_CENTER ,VALUE='Close')


  WID_BUTTON_2 = Widget_Button(WID_MAR345, UNAME='WID_BUTTON_2'  $
      ,XOFFSET=619 ,YOFFSET=10 ,SCR_XSIZE=90 ,SCR_YSIZE=44  $
      ,/ALIGN_CENTER ,VALUE='Colors')


  ;WID_LABEL_9 = Widget_Label(WID_MAR345, UNAME='WID_LABEL_9'  $
  ;    ,XOFFSET=219 ,YOFFSET=8 ,SCR_XSIZE=83 ,SCR_YSIZE=18  $
  ;    ,/ALIGN_LEFT ,VALUE='Number of peaks')


 ; WID_LABEL_10 = Widget_Label(WID_MAR345, UNAME='WID_LABEL_10'  $
 ;     ,XOFFSET=19 ,YOFFSET=8 ,SCR_XSIZE=59 ,SCR_YSIZE=18 ,/ALIGN_LEFT  $
 ;     ,VALUE='Progress')


 ; WID_TEXT_8 = Widget_Text(WID_MAR345, UNAME='WID_TEXT_8'  $
 ;     ,XOFFSET=103 ,YOFFSET=5 ,SCR_XSIZE=78 ,SCR_YSIZE=21 ,XSIZE=20  $
 ;     ,YSIZE=1)


  ;WID_TEXT_10 = Widget_Text(WID_MAR345, UNAME='WID_TEXT_10'  $
  ;    ,XOFFSET=331 ,YOFFSET=3 ,SCR_XSIZE=78 ,SCR_YSIZE=21 ,XSIZE=20  $
   ;   ,YSIZE=1)


  WID_BUTTON_43dd = Widget_Button(WID_MAR345, UNAME='WID_BUTTON_43dd'  $
      ,XOFFSET=182 ,YOFFSET=5 ,SCR_XSIZE=20 ,SCR_YSIZE=22  $
      ,/ALIGN_CENTER ,VALUE='->', UVALUE='->')

  WID_BUTTON_43df = Widget_Button(WID_MAR345, UNAME='WID_BUTTON_43df'  $
      ,XOFFSET=128 ,YOFFSET=5 ,SCR_XSIZE=50 ,SCR_YSIZE=22  $
      ,/ALIGN_CENTER ,VALUE='Open', UVALUE='Open')

  WID_BUTTON_43de = Widget_Button(WID_MAR345, UNAME='WID_BUTTON_43dd'  $
      ,XOFFSET=103 ,YOFFSET=5 ,SCR_XSIZE=20 ,SCR_YSIZE=22  $
      ,/ALIGN_CENTER ,VALUE='<-', UVALUE='<-')


  WID_TAB_0 = Widget_Tab(WID_MAR345, UNAME='WID_TAB_0' ,XOFFSET=610  $
      ,YOFFSET=64 ,SCR_XSIZE=563 ,SCR_YSIZE=600)


  WID_BASE_1 = Widget_Base(WID_TAB_0, UNAME='WID_BASE_1'  $
      ,SCR_XSIZE=555 ,SCR_YSIZE=506 ,TITLE='File' ,SPACE=3 ,XPAD=3  $
      ,YPAD=3)


  WID_BASE_GONIOMETER = Widget_Base(WID_TAB_0, UNAME='WID_BASE_GONIOMETER'  $
      ,SCR_XSIZE=455 ,SCR_YSIZE=506 ,TITLE='Gonio' ,SPACE=3 ,XPAD=3  $
      ,YPAD=3)

  WID_BASE_OMEGA_ROTATION1 = Widget_Base(WID_BASE_GONIOMETER, UNAME='WID_BASE_OMEGA_ROTATION1'  $
      ,XOFFSET=142 ,YOFFSET=71 ,COLUMN=1 ,/NONEXCLUSIVE)

  WID_BUTTON_OMEGA_ROTATION = Widget_Button(WID_BASE_OMEGA_ROTATION1, UNAME='WID_BUTTON_OMEGA_ROTATION'  $
      ,/ALIGN_LEFT ,VALUE='Invert omega rotation')


  WID_LABEL_37aa = Widget_Label(WID_BASE_GONIOMETER, UNAME='WID_LABEL_37aa'  $
      ,XOFFSET=66 ,YOFFSET=41 ,/ALIGN_LEFT ,VALUE='Zero offset')


  WID_TEXT_30aa = Widget_Text(WID_BASE_GONIOMETER, UNAME='WID_TEXT_30aa'  $
      ,XOFFSET=144 ,YOFFSET=39 ,SCR_XSIZE=78 ,SCR_YSIZE=21 ,XSIZE=20  $
      ,YSIZE=1, EDITABLE=1, VALUE='-90')








  WID_TEXT_12 = Widget_Text(WID_BASE_1, UNAME='WID_TEXT_12'  $
      ,XOFFSET=175 ,YOFFSET=135 ,SCR_XSIZE=78 ,SCR_YSIZE=21 ,XSIZE=20  $
      ,YSIZE=1)


  WID_TEXT_11 = Widget_Text(WID_BASE_1, UNAME='WID_TEXT_11'  $
      ,XOFFSET=258 ,YOFFSET=135 ,SCR_XSIZE=78 ,SCR_YSIZE=21 ,XSIZE=20  $
      ,YSIZE=1)


  WID_LABEL_29 = Widget_Label(WID_BASE_1, UNAME='WID_LABEL_29'  $
      ,XOFFSET=74 ,YOFFSET=139 ,/ALIGN_LEFT ,VALUE='Range Available')


  WID_LABEL_30 = Widget_Label(WID_BASE_1, UNAME='WID_LABEL_30'  $
      ,XOFFSET=72 ,YOFFSET=84 ,/ALIGN_LEFT ,VALUE='Filename')


  WID_TEXT_9 = Widget_Text(WID_BASE_1, UNAME='WID_TEXT_9' ,XOFFSET=72  $
      ,YOFFSET=104 ,SCR_XSIZE=264 ,SCR_YSIZE=21 ,XSIZE=20 ,YSIZE=1)


  WID_BUTTON_4 = Widget_Button(WID_BASE_1, UNAME='WID_BUTTON_4'  $
      ,XOFFSET=211 ,YOFFSET=47 ,SCR_XSIZE=28 ,SCR_YSIZE=27  $
      ,/ALIGN_CENTER ,VALUE='->')


  WID_BUTTON_3 = Widget_Button(WID_BASE_1, UNAME='WID_BUTTON_3'  $
      ,XOFFSET=179 ,YOFFSET=47 ,SCR_XSIZE=27 ,SCR_YSIZE=27  $
      ,/ALIGN_CENTER ,VALUE='<-')


  WID_BUTTON_1 = Widget_Button(WID_BASE_1, UNAME='WID_BUTTON_1'  $
      ,XOFFSET=73 ,YOFFSET=47 ,SCR_XSIZE=96 ,SCR_YSIZE=27  $
      ,/ALIGN_CENTER ,VALUE='Open')


  WID_TEXT_28 = Widget_Text(WID_BASE_1, UNAME='WID_TEXT_28'  $
      ,XOFFSET=76 ,YOFFSET=200 ,SCR_XSIZE=264 ,SCR_YSIZE=21 ,XSIZE=20  $
      ,YSIZE=1)


  WID_LABEL_31 = Widget_Label(WID_BASE_1, UNAME='WID_LABEL_31'  $
      ,XOFFSET=76 ,YOFFSET=180 ,/ALIGN_LEFT ,VALUE='Image directory')


  WID_LABEL_32 = Widget_Label(WID_BASE_1, UNAME='WID_LABEL_32'  $
      ,XOFFSET=76 ,YOFFSET=233 ,/ALIGN_LEFT ,VALUE='Output'+ $
      ' directory')


  WID_TEXT_29 = Widget_Text(WID_BASE_1, UNAME='WID_TEXT_29'  $
      ,XOFFSET=76 ,YOFFSET=254 ,SCR_XSIZE=264 ,SCR_YSIZE=21 ,XSIZE=20  $
      ,YSIZE=1)


  WID_BUTTON_21 = Widget_Button(WID_BASE_1, UNAME='WID_BUTTON_21'  $
      ,XOFFSET=350 ,YOFFSET=198 ,SCR_XSIZE=28 ,SCR_YSIZE=24  $
      ,/ALIGN_CENTER ,VALUE='...')


  WID_BUTTON_22 = Widget_Button(WID_BASE_1, UNAME='WID_BUTTON_22'  $
      ,XOFFSET=351 ,YOFFSET=251 ,SCR_XSIZE=28 ,SCR_YSIZE=24  $
      ,/ALIGN_CENTER ,VALUE='...')


  WID_BASE_10 = Widget_Base(WID_BASE_1, UNAME='WID_BASE_10'  $
      ,XOFFSET=365 ,YOFFSET=50 ,TITLE='IDL' ,COLUMN=1 ,/NONEXCLUSIVE)


  WID_BUTTON_20 = Widget_Button(WID_BASE_10, UNAME='WID_BUTTON_20'  $
      ,/ALIGN_LEFT ,VALUE='Load peaktables')

 WID_BUTTON_20aa = Widget_Button(WID_BASE_10, UNAME='WID_BUTTON_20aa'  $
      ,/ALIGN_LEFT ,VALUE='Invert X')

 WID_BUTTON_20aa1 = Widget_Button(WID_BASE_10, UNAME='WID_BUTTON_20aa1'  $
      ,/ALIGN_LEFT ,VALUE='Invert Y')

WIDGET_CONTROL, WID_BUTTON_20aa1, SET_BUTTON=1

 WID_BUTTON_20aa2 = Widget_Button(WID_BASE_10, UNAME='WID_BUTTON_20aa2'  $
      ,/ALIGN_LEFT ,VALUE='Transpose')

 WID_BUTTON_20aa3 = Widget_Button(WID_BASE_10, UNAME='WID_BUTTON_20aa3'  $
      ,/ALIGN_LEFT ,VALUE='Exclude corners')

  WID_TEXT_16 = Widget_Text(WID_BASE_1, UNAME='WID_TEXT_16'  $
      ,XOFFSET=126 ,YOFFSET=362 ,SCR_XSIZE=100 ,SCR_YSIZE=21  $
      ,XSIZE=20 ,YSIZE=1)


  WID_TEXT_20 = Widget_Text(WID_BASE_1, UNAME='WID_TEXT_20'  $
      ,XOFFSET=232 ,YOFFSET=362 ,SCR_XSIZE=100 ,SCR_YSIZE=21  $
      ,XSIZE=20 ,YSIZE=1)


  WID_TEXT_21 = Widget_Text(WID_BASE_1, UNAME='WID_TEXT_21'  $
      ,XOFFSET=126 ,YOFFSET=386 ,SCR_XSIZE=100 ,SCR_YSIZE=21  $
      ,XSIZE=20 ,YSIZE=1)


  WID_LABEL_1 = Widget_Label(WID_BASE_1, UNAME='WID_LABEL_1'  $
      ,XOFFSET=78 ,YOFFSET=366 ,/ALIGN_LEFT ,VALUE='Omega')


  WID_LABEL_6 = Widget_Label(WID_BASE_1, UNAME='WID_LABEL_6'  $
      ,XOFFSET=80 ,YOFFSET=388 ,SCR_XSIZE=18 ,SCR_YSIZE=18  $
      ,/ALIGN_LEFT ,VALUE='Chi')


  WID_LABEL_7 = Widget_Label(WID_BASE_1, UNAME='WID_LABEL_7'  $
      ,XOFFSET=80 ,YOFFSET=433 ,SCR_XSIZE=18 ,SCR_YSIZE=18  $
      ,/ALIGN_LEFT ,VALUE='I0')


  WID_LABEL_8 = Widget_Label(WID_BASE_1, UNAME='WID_LABEL_8'  $
      ,XOFFSET=78 ,YOFFSET=413 ,/ALIGN_LEFT ,VALUE='Exp. t')


  WID_TEXT_22 = Widget_Text(WID_BASE_1, UNAME='WID_TEXT_22'  $
      ,XOFFSET=126 ,YOFFSET=433 ,SCR_XSIZE=100 ,SCR_YSIZE=21  $
      ,XSIZE=20 ,YSIZE=1)


  WID_TEXT_23 = Widget_Text(WID_BASE_1, UNAME='WID_TEXT_23'  $
      ,XOFFSET=126 ,YOFFSET=409 ,SCR_XSIZE=100 ,SCR_YSIZE=21  $
      ,XSIZE=20 ,YSIZE=1)


  WID_BUTTON_24 = Widget_Button(WID_BASE_1, UNAME='WID_BUTTON_24'  $
      ,XOFFSET=74 ,YOFFSET=18 ,SCR_XSIZE=96 ,SCR_YSIZE=27  $
      ,/ALIGN_CENTER ,VALUE='Correlate')


  WID_BUTTON_25 = Widget_Button(WID_BASE_1, UNAME='WID_BUTTON_25'  $
      ,XOFFSET=173 ,YOFFSET=18 ,SCR_XSIZE=96 ,SCR_YSIZE=27  $
      ,/ALIGN_CENTER ,VALUE='Save')


  WID_BASE_2 = Widget_Base(WID_TAB_0, UNAME='WID_BASE_2'  $
      ,SCR_XSIZE=555 ,SCR_YSIZE=506 ,TITLE='Search' ,SPACE=3 ,XPAD=3  $
      ,YPAD=3)

  ;WID_LABEL_15a = Widget_Label(WID_BASE_2, UNAME='WID_LABEL_15a'  $
  ;    ,XOFFSET=225 ,YOFFSET=124 ,/ALIGN_LEFT ,VALUE='Min I')


  WID_LABEL_15a = Widget_Label(WID_BASE_2, UNAME='WID_LABEL_15a'  $
      ,XOFFSET=225 ,YOFFSET=130 ,/ALIGN_LEFT ,VALUE='Loc. bcgr. seg.')

  WID_LABEL_15 = Widget_Label(WID_BASE_2, UNAME='WID_LABEL_15'  $
      ,XOFFSET=225 ,YOFFSET=106 ,/ALIGN_LEFT ,VALUE='Min. count')


  WID_LABEL_16 = Widget_Label(WID_BASE_2, UNAME='WID_LABEL_16'  $
      ,XOFFSET=225 ,YOFFSET=82 ,/ALIGN_LEFT ,VALUE='Smooth window')


  WID_LABEL_17 = Widget_Label(WID_BASE_2, UNAME='WID_LABEL_17'  $
      ,XOFFSET=225 ,YOFFSET=58 ,/ALIGN_LEFT ,VALUE='Max. count')


  WID_LABEL_18 = Widget_Label(WID_BASE_2, UNAME='WID_LABEL_18'  $
      ,XOFFSET=225 ,YOFFSET=34 ,/ALIGN_LEFT ,VALUE='Grad. additive')

  ;WID_TEXT_3a = Widget_Text(WID_BASE_2, UNAME='WID_TEXT_3a'  $
  ;    ,XOFFSET=299 ,YOFFSET=123 ,SCR_XSIZE=60 ,SCR_YSIZE=21 ,XSIZE=20  $
  ;    ,YSIZE=1)


  WID_TEXT_3a = Widget_Text(WID_BASE_2, UNAME='WID_TEXT_3a'  $
      ,XOFFSET=310 ,YOFFSET=126 ,SCR_XSIZE=60 ,SCR_YSIZE=21 ,XSIZE=20  $
      ,YSIZE=1)

  WID_TEXT_3 = Widget_Text(WID_BASE_2, UNAME='WID_TEXT_3'  $
      ,XOFFSET=310 ,YOFFSET=102 ,SCR_XSIZE=60 ,SCR_YSIZE=21 ,XSIZE=20  $
      ,YSIZE=1)


  WID_TEXT_2 = Widget_Text(WID_BASE_2, UNAME='WID_TEXT_2'  $
      ,XOFFSET=310 ,YOFFSET=78 ,SCR_XSIZE=60 ,SCR_YSIZE=21 ,XSIZE=20  $
      ,YSIZE=1)


  WID_TEXT_1 = Widget_Text(WID_BASE_2, UNAME='WID_TEXT_1'  $
      ,XOFFSET=310 ,YOFFSET=54 ,SCR_XSIZE=60 ,SCR_YSIZE=21 ,XSIZE=20  $
      ,YSIZE=1)


  WID_TEXT_0 = Widget_Text(WID_BASE_2, UNAME='WID_TEXT_0'  $
      ,XOFFSET=310 ,YOFFSET=30 ,SCR_XSIZE=60 ,SCR_YSIZE=21 ,XSIZE=20  $
      ,YSIZE=1)


  WID_BUTTON_5 = Widget_Button(WID_BASE_2, UNAME='WID_BUTTON_5'  $
      ,XOFFSET=30 ,YOFFSET=31 ,SCR_XSIZE=176 ,SCR_YSIZE=30  $
      ,/ALIGN_CENTER ,VALUE='PS')

  WID_BUTTON_5s = Widget_Button(WID_BASE_2, UNAME='WID_BUTTON_5'  $
      ,XOFFSET=30 ,YOFFSET=71 ,SCR_XSIZE=176 ,SCR_YSIZE=30  $
      ,/ALIGN_CENTER ,VALUE='PS Series')

  WID_BUTTON_51M = Widget_Button(WID_BASE_2, UNAME='WID_BUTTON_51M'  $
      ,XOFFSET=30 ,YOFFSET=111 ,SCR_XSIZE=176 ,SCR_YSIZE=30  $
      ,/ALIGN_CENTER ,VALUE='Pilatus 1M')

  WID_TEXT_18 = Widget_Text(WID_BASE_2, UNAME='WID_TEXT_18'  $
      ,XOFFSET=310 ,YOFFSET=307 ,SCR_XSIZE=60 ,SCR_YSIZE=21 ,XSIZE=20  $
      ,YSIZE=1)


  WID_LABEL_20 = Widget_Label(WID_BASE_2, UNAME='WID_LABEL_20'  $
      ,XOFFSET=312 ,YOFFSET=287 ,/ALIGN_LEFT ,VALUE='Center')


  WID_LABEL_21 = Widget_Label(WID_BASE_2, UNAME='WID_LABEL_21'  $
      ,XOFFSET=381 ,YOFFSET=285 ,/ALIGN_LEFT ,VALUE='Range')


  WID_TEXT_19 = Widget_Text(WID_BASE_2, UNAME='WID_TEXT_19'  $
      ,XOFFSET=378 ,YOFFSET=307 ,SCR_XSIZE=60 ,SCR_YSIZE=21 ,XSIZE=20  $
      ,YSIZE=1)


  WID_LIST_1 = Widget_List(WID_BASE_2, UNAME='WID_LIST_1' ,XOFFSET=9  $
      ,YOFFSET=254 ,SCR_XSIZE=291 ,SCR_YSIZE=232 ,XSIZE=11 ,YSIZE=2)


  WID_BUTTON_12 = Widget_Button(WID_BASE_2, UNAME='WID_BUTTON_12'  $
      ,XOFFSET=312 ,YOFFSET=368 ,SCR_XSIZE=82 ,SCR_YSIZE=27  $
      ,/ALIGN_CENTER ,VALUE='Update')

  WID_BUTTON_13 = Widget_Button(WID_BASE_2, UNAME='WID_BUTTON_13'  $
      ,XOFFSET=312 ,YOFFSET=400 ,SCR_XSIZE=82 ,SCR_YSIZE=27  $
      ,/ALIGN_CENTER ,VALUE='Remove')

  WID_BUTTON_13a = Widget_Button(WID_BASE_2, UNAME='WID_BUTTON_13a'  $
      ,XOFFSET=412 ,YOFFSET=400 ,SCR_XSIZE=82 ,SCR_YSIZE=27  $
      ,/ALIGN_CENTER ,VALUE='Select', UVALUE='Region select')


  WID_BASE_0a = Widget_Base(WID_BASE_2, UNAME='WID_BASE_0a'  $
      ,XOFFSET=309 ,YOFFSET=154 ,TITLE='IDL' ,COLUMN=1  $
      ,/NONEXCLUSIVE)

  WID_BUTTON_9a = Widget_Button(WID_BASE_0a, UNAME='WID_BUTTON_9a'  $
      ,/ALIGN_LEFT ,VALUE='Fit peaks',UVALUE='')




  WID_BASE_0 = Widget_Base(WID_BASE_2, UNAME='WID_BASE_0'  $
      ,XOFFSET=309 ,YOFFSET=254 ,TITLE='IDL' ,COLUMN=1  $
      ,/NONEXCLUSIVE)

  WID_BUTTON_9 = Widget_Button(WID_BASE_0, UNAME='WID_BUTTON_9'  $
      ,/ALIGN_LEFT ,VALUE='Exclusions')


  WID_BUTTON_14 = Widget_Button(WID_BASE_2, UNAME='WID_BUTTON_14'  $
      ,XOFFSET=313 ,YOFFSET=431 ,SCR_XSIZE=82 ,SCR_YSIZE=27  $
      ,/ALIGN_CENTER ,VALUE='Open')


  WID_BUTTON_15 = Widget_Button(WID_BASE_2, UNAME='WID_BUTTON_15'  $
      ,XOFFSET=313 ,YOFFSET=463 ,SCR_XSIZE=82 ,SCR_YSIZE=27  $
      ,/ALIGN_CENTER ,VALUE='Save')


  WID_BUTTON_16 = Widget_Button(WID_BASE_2, UNAME='WID_BUTTON_16'  $
      ,XOFFSET=312 ,YOFFSET=336 ,SCR_XSIZE=82 ,SCR_YSIZE=27  $
      ,/ALIGN_CENTER ,VALUE='Clear')


  WID_BASE_3 = Widget_Base(WID_TAB_0, UNAME='WID_BASE_3'  $
      ,SCR_XSIZE=655 ,SCR_YSIZE=556 ,TITLE='Scan' ,SPACE=3 ,XPAD=3  $
      ,YPAD=3)


  WID_LABEL_27aaa = Widget_Label(WID_BASE_3, UNAME='WID_LABEL_27'  $
      ,XOFFSET=23 ,YOFFSET=210 ,/ALIGN_LEFT ,VALUE='Axis/energy')


  WID_DROPLIST_aaa = Widget_Droplist(WID_BASE_3, UNAME='WID_DROPLIST_aaa'  $
      ,XOFFSET=101 ,YOFFSET=208 ,SCR_XSIZE=78 ,SCR_YSIZE=21 ,XSIZE=20  $
      ,YSIZE=1, value=['omega','kappa','phi','energy'], sensitive=0)


 ; WID_LABEL_22 = Widget_Label(WID_BASE_3, UNAME='WID_LABEL_22'  $
 ;     ,XOFFSET=47 ,YOFFSET=211 ,/ALIGN_LEFT ,VALUE='Chi')


;  WID_LABEL_23 = Widget_Label(WID_BASE_3, UNAME='WID_LABEL_23'  $
;      ,XOFFSET=16 ,YOFFSET=182 ,/ALIGN_LEFT ,VALUE='Goniometer')


 ; WID_BASE_7 = Widget_Base(WID_BASE_3, UNAME='WID_BASE_7'  $
 ;     ,XOFFSET=268 ,YOFFSET=17 ,TITLE='IDL' ,COLUMN=1 ,/EXCLUSIVE)


  ;WID_BUTTON_7 = Widget_Button(WID_BASE_7, UNAME='WID_BUTTON_7'  $
   ;   ,/ALIGN_LEFT ,VALUE='Omega')


  ;WID_BUTTON_8 = Widget_Button(WID_BASE_7, UNAME='WID_BUTTON_8'  $
      ;,YOFFSET=22 ,/ALIGN_LEFT ,VALUE='Energy')


  WID_LABEL_24 = Widget_Label(WID_BASE_3, UNAME='WID_LABEL_24'  $
      ,XOFFSET=22 ,YOFFSET=75 ,/ALIGN_LEFT ,VALUE='Start')


  WID_LABEL_25 = Widget_Label(WID_BASE_3, UNAME='WID_LABEL_25'  $
      ,XOFFSET=22 ,YOFFSET=99 ,/ALIGN_LEFT ,VALUE='Step')


  WID_LABEL_26 = Widget_Label(WID_BASE_3, UNAME='WID_LABEL_26'  $
      ,XOFFSET=22 ,YOFFSET=121 ,/ALIGN_LEFT ,VALUE='No images')


  WID_LABEL_27 = Widget_Label(WID_BASE_3, UNAME='WID_LABEL_27'  $
      ,XOFFSET=23 ,YOFFSET=143 ,/ALIGN_LEFT ,VALUE='Start no')


  WID_TEXT_7 = Widget_Text(WID_BASE_3, UNAME='WID_TEXT_7'  $
      ,XOFFSET=100 ,YOFFSET=141 ,SCR_XSIZE=78 ,SCR_YSIZE=21 ,XSIZE=20  $
      ,YSIZE=1)


  WID_TEXT_6 = Widget_Text(WID_BASE_3, UNAME='WID_TEXT_6'  $
      ,XOFFSET=100 ,YOFFSET=118 ,SCR_XSIZE=78 ,SCR_YSIZE=21 ,XSIZE=20  $
      ,YSIZE=1)


  WID_TEXT_5 = Widget_Text(WID_BASE_3, UNAME='WID_TEXT_5'  $
      ,XOFFSET=100 ,YOFFSET=95 ,SCR_XSIZE=78 ,SCR_YSIZE=21 ,XSIZE=20  $
      ,YSIZE=1)


  WID_TEXT_4 = Widget_Text(WID_BASE_3, UNAME='WID_TEXT_4'  $
      ,XOFFSET=100 ,YOFFSET=72 ,SCR_XSIZE=78 ,SCR_YSIZE=21 ,XSIZE=20  $
      ,YSIZE=1)


  WID_LABEL_28 = Widget_Label(WID_BASE_3, UNAME='WID_LABEL_28'  $
      ,XOFFSET=10 ,YOFFSET=47 ,/ALIGN_LEFT ,VALUE='Scan')


  ;******************************* TAKEN OUT **********************
  ;WID_BUTTON_6 = Widget_Button(WID_BASE_3, UNAME='WID_BUTTON_6'  $
   ;   ,XOFFSET=25 ,YOFFSET=245 ,SCR_XSIZE=154 ,SCR_YSIZE=33  $
    ;  ,/ALIGN_CENTER ,VALUE='Search scan')


  ;WID_BUTTON_17 = Widget_Button(WID_BASE_3, UNAME='WID_BUTTON_17'  $
   ;   ,XOFFSET=25 ,YOFFSET=281 ,SCR_XSIZE=153 ,SCR_YSIZE=32  $
    ;  ,/ALIGN_CENTER ,VALUE='Stop')


  ;WID_BUTTON_18 = Widget_Button(WID_BASE_3, UNAME='WID_BUTTON_18'  $
   ;   ,XOFFSET=213 ,YOFFSET=245 ,SCR_XSIZE=141 ,SCR_YSIZE=69  $
    ;  ,/ALIGN_CENTER ,VALUE='Merge peaktables')

  ;******************************* TAKEN OUT **********************


  ;WID_LABEL_33 = Widget_Label(WID_BASE_3, UNAME='WID_LABEL_33'  $
  ;    ,XOFFSET=214 ,YOFFSET=212 ,/ALIGN_LEFT ,VALUE='Omega')


  ;WID_TEXT_15 = Widget_Text(WID_BASE_3, UNAME='WID_TEXT_15'  $
  ;    ,XOFFSET=268 ,YOFFSET=209 ,SCR_XSIZE=78 ,SCR_YSIZE=21 ,XSIZE=20  $
  ;    ,YSIZE=1)


  ;WID_BUTTON_10 = Widget_Button(WID_BASE_3, UNAME='WID_BUTTON_10'  $
  ;    ,XOFFSET=218 ,YOFFSET=141 ,SCR_XSIZE=132 ,SCR_YSIZE=42  $
   ;   ,/ALIGN_CENTER ,VALUE='Generate set. files')


  WID_BUTTON_38 = Widget_Button(WID_BASE_3, UNAME='WID_BUTTON_38'  $
      ,XOFFSET=26 ,YOFFSET=325 ,SCR_XSIZE=153 ,SCR_YSIZE=32  $
      ,/ALIGN_CENTER ,VALUE='Compute prof. from scan')

  ;WID_BUTTON_38v = Widget_Button(WID_BASE_3, UNAME='WID_BUTTON_38v'  $
  ;    ,XOFFSET=26 ,YOFFSET=275 ,SCR_XSIZE=153 ,SCR_YSIZE=32  $
  ;    ,/ALIGN_CENTER ,VALUE='Verify angles')


 WID_BUTTON_38a = Widget_Button(WID_BASE_3, UNAME='WID_BUTTON_38a'  $
      ,XOFFSET=201 ,YOFFSET=325 ,SCR_XSIZE=153 ,SCR_YSIZE=32  $
      ,/ALIGN_CENTER ,VALUE='Merge step images')

 WID_Base_wholeseries = Widget_base(WID_BASE_3, UNAME='WID_Base_wholeseries'  $
      ,XOFFSET=370, YOFFSET=325, /NONEXCLUSIVE)


 WID_BUTTON_wholeseries = Widget_Button(WID_Base_wholeseries, UNAME='WID_Button_wholeseries',VALUE='Whole p-series')



 WID_BUTTON_38ab = Widget_Button(WID_BASE_3, UNAME='WID_BUTTON_38ab'  $
      ,XOFFSET=201 ,YOFFSET=275 ,SCR_XSIZE=153 ,SCR_YSIZE=32  $
      ,/ALIGN_CENTER ,VALUE='Integrate Pilatus', sensitive=0)

 ;WID_TABLE_pil = Widget_table(WID_BASE_3, UNAME='WID_table_pil'  $
 ;     ,XOFFSET=360 ,YOFFSET=275 ,XSIZE=1 ,YSIZE=10  $
 ;     ,/ALIGN_CENTER, /EDITABLE, COLUMN_WIDTHS=[50])

  WID_TEXT_39 = Widget_Text(WID_BASE_3, UNAME='WID_TEXT_39'  $
      ,XOFFSET=101 ,YOFFSET=408 ,SCR_XSIZE=78 ,SCR_YSIZE=21 ,XSIZE=20  $
      ,YSIZE=1)


  WID_BASE_16 = Widget_Base(WID_BASE_3, UNAME='WID_BASE_16'  $
      ,XOFFSET=76 ,YOFFSET=379 ,TITLE='IDL' ,COLUMN=1 ,/NONEXCLUSIVE)


  WID_BUTTON_37 = Widget_Button(WID_BASE_16, UNAME='WID_BUTTON_37'  $
      ,/ALIGN_LEFT ,VALUE='Detector move')


  WID_BUTTON_47 = Widget_Button(WID_BASE_3, UNAME='WID_BUTTON_47'  $
      ,XOFFSET=200 ,YOFFSET=380 ,SCR_XSIZE=153 ,SCR_YSIZE=32  $
      ,/ALIGN_CENTER ,VALUE='Omega from moving det.')

  WID_BUTTON_47a = Widget_Button(WID_BASE_3, UNAME='WID_BUTTON_47a'  $
      ,XOFFSET=200 ,YOFFSET=420 ,SCR_XSIZE=153 ,SCR_YSIZE=32  $
      ,/ALIGN_CENTER ,VALUE='Integrate series')

  WID_BUTTON_47b = Widget_Button(WID_BASE_3, UNAME='WID_BUTTON_47b'  $
      ,XOFFSET=200 ,YOFFSET=460 ,SCR_XSIZE=153 ,SCR_YSIZE=32  $
      ,/ALIGN_CENTER ,VALUE='Intens. from series', sensitive=0)


  WID_BUTTON_47c = Widget_Button(WID_BASE_3, UNAME='WID_BUTTON_47c'  $
      ,XOFFSET=200 ,YOFFSET=500 ,SCR_XSIZE=153 ,SCR_YSIZE=32  $
      ,/ALIGN_CENTER ,VALUE='Merge peak tables', UVALUE='Merge peak tables')


  WID_BUTTON_47d = Widget_Button(WID_BASE_3, UNAME='WID_BUTTON_47d'  $
      ,XOFFSET=360 ,YOFFSET=500 ,SCR_XSIZE=153 ,SCR_YSIZE=32  $
      ,/ALIGN_CENTER ,VALUE='Predict whole series', UVALUE='Predict whole series')

  WID_BASE_4 = Widget_Base(WID_TAB_0, UNAME='WID_BASE_4'  $
      ,SCR_XSIZE=455 ,SCR_YSIZE=506 ,TITLE='Predict' ,SPACE=3 ,XPAD=3  $
      ,YPAD=3)


  WID_TEXT_30 = Widget_Text(WID_BASE_4, UNAME='WID_TEXT_30'  $
      ,XOFFSET=144 ,YOFFSET=39 ,SCR_XSIZE=78 ,SCR_YSIZE=21 ,XSIZE=20  $
      ,YSIZE=1)

  WID_TEXT_31 = Widget_Text(WID_BASE_4, UNAME='WID_TEXT_31'  $
      ,XOFFSET=144 ,YOFFSET=61 ,SCR_XSIZE=78 ,SCR_YSIZE=21 ,XSIZE=20  $
      ,YSIZE=1)


  WID_LABEL_36 = Widget_Label(WID_BASE_4, UNAME='WID_LABEL_36'  $
      ,XOFFSET=66 ,YOFFSET=65 ,/ALIGN_LEFT ,VALUE='Range')


  WID_LABEL_37 = Widget_Label(WID_BASE_4, UNAME='WID_LABEL_37'  $
      ,XOFFSET=66 ,YOFFSET=41 ,/ALIGN_LEFT ,VALUE='Start')





  WID_TEXT_30r = Widget_Text(WID_BASE_4, UNAME='WID_TEXT_30r'  $
      ,XOFFSET=144 ,YOFFSET=120 ,SCR_YSIZE=21 ,XSIZE=5  $
      ,YSIZE=1, editable=1, value='5')

  WID_TEXT_31r = Widget_Text(WID_BASE_4, UNAME='WID_TEXT_31r'  $
      ,XOFFSET=144 ,YOFFSET=100 ,SCR_YSIZE=21 ,XSIZE=5  $
      ,YSIZE=1, editable=1, value='10')


  WID_LABEL_36r = Widget_Label(WID_BASE_4, UNAME='WID_LABEL_36r'  $
      ,XOFFSET=66 ,YOFFSET=122 ,/ALIGN_LEFT ,VALUE='Full overlap')


  WID_LABEL_37r = Widget_Label(WID_BASE_4, UNAME='WID_LABEL_37r'  $
      ,XOFFSET=66 ,YOFFSET=102 ,/ALIGN_LEFT ,VALUE='Part. overlap')





  WID_LABEL_37a = Widget_Label(WID_BASE_4, UNAME='WID_LABEL_37a'  $
      ,XOFFSET=320 ,YOFFSET=41 ,/ALIGN_LEFT ,VALUE='Axis/energy')

  WID_DROPLIST_aab = Widget_Droplist(WID_BASE_4, UNAME='WID_DROPLIST_aab'  $
      ,XOFFSET=320 ,YOFFSET=60 ,SCR_XSIZE=78 ,SCR_YSIZE=21 ,XSIZE=20  $
      ,YSIZE=1, value=['energy','omega'])

;  WID_DROPLIST_aab = Widget_Droplist(WID_BASE_4, UNAME='WID_DROPLIST_aab'  $
;      ,XOFFSET=320 ,YOFFSET=60 ,SCR_XSIZE=78 ,SCR_YSIZE=21 ,XSIZE=20  $
;      ,YSIZE=1, value=['omega','kappa','phi','energy'])


  ;WID_LABEL_38 = Widget_Label(WID_BASE_4, UNAME='WID_LABEL_38'  $
  ;    ,XOFFSET=27 ,YOFFSET=19 ,/ALIGN_LEFT ,VALUE='Goniometer')


  ;WID_LABEL_39 = Widget_Label(WID_BASE_4, UNAME='WID_LABEL_39'  $
  ;    ,XOFFSET=94 ,YOFFSET=106 ,/ALIGN_LEFT ,VALUE='Chi')


  ;WID_TEXT_34 = Widget_Text(WID_BASE_4, UNAME='WID_TEXT_34'  $
  ;    ,XOFFSET=144 ,YOFFSET=103 ,SCR_XSIZE=78 ,SCR_YSIZE=21  $
  ;    ,/EDITABLE ,XSIZE=20 ,YSIZE=1)


  WID_LABEL_50 = Widget_Label(WID_BASE_4, UNAME='WID_LABEL_50'  $
      ,XOFFSET=91 ,YOFFSET=158 ,/ALIGN_LEFT ,VALUE='h')


  WID_TEXT_38 = Widget_Text(WID_BASE_4, UNAME='WID_TEXT_38'  $
      ,XOFFSET=145 ,YOFFSET=156 ,SCR_XSIZE=78 ,SCR_YSIZE=19 ,XSIZE=20  $
      ,YSIZE=1)


  WID_TEXT_40 = Widget_Text(WID_BASE_4, UNAME='WID_TEXT_40'  $
      ,XOFFSET=233 ,YOFFSET=154 ,SCR_XSIZE=78 ,SCR_YSIZE=21 ,XSIZE=20  $
      ,YSIZE=1)


  WID_TEXT_41 = Widget_Text(WID_BASE_4, UNAME='WID_TEXT_41'  $
      ,XOFFSET=233 ,YOFFSET=177 ,SCR_XSIZE=78 ,SCR_YSIZE=22 ,XSIZE=20  $
      ,YSIZE=1)


  WID_TEXT_42 = Widget_Text(WID_BASE_4, UNAME='WID_TEXT_42'  $
      ,XOFFSET=145 ,YOFFSET=179 ,SCR_XSIZE=78 ,SCR_YSIZE=19 ,XSIZE=20  $
      ,YSIZE=1)


  WID_LABEL_51 = Widget_Label(WID_BASE_4, UNAME='WID_LABEL_51'  $
      ,XOFFSET=91 ,YOFFSET=178 ,SCR_XSIZE=18 ,SCR_YSIZE=18  $
      ,/ALIGN_LEFT ,VALUE='k')


  WID_TEXT_43 = Widget_Text(WID_BASE_4, UNAME='WID_TEXT_43'  $
      ,XOFFSET=233 ,YOFFSET=201 ,SCR_XSIZE=78 ,SCR_YSIZE=21 ,XSIZE=20  $
      ,YSIZE=1)


  WID_TEXT_44 = Widget_Text(WID_BASE_4, UNAME='WID_TEXT_44'  $
      ,XOFFSET=145 ,YOFFSET=202 ,SCR_XSIZE=78 ,SCR_YSIZE=19 ,XSIZE=20  $
      ,YSIZE=1)


  WID_LABEL_52 = Widget_Label(WID_BASE_4, UNAME='WID_LABEL_52'  $
      ,XOFFSET=92 ,YOFFSET=205 ,SCR_XSIZE=18 ,SCR_YSIZE=15  $
      ,/ALIGN_LEFT ,VALUE='l')


  ;WID_TEXT_46 = Widget_Text(WID_BASE_4, UNAME='WID_TEXT_46'  $
  ;    ,XOFFSET=323 ,YOFFSET=101 ,SCR_XSIZE=78 ,SCR_YSIZE=21  $
  ;    ,/EDITABLE ,XSIZE=20 ,YSIZE=1)


  ;WID_LABEL_53 = Widget_Label(WID_BASE_4, UNAME='WID_LABEL_53'  $
  ;    ,XOFFSET=273 ,YOFFSET=104 ,/ALIGN_LEFT ,VALUE='Omega')


  WID_BUTTON_49 = Widget_Button(WID_BASE_4, UNAME='WID_BUTTON_49'  $
      ,XOFFSET=147 ,YOFFSET=254 ,SCR_XSIZE=164 ,SCR_YSIZE=39  $
      ,/ALIGN_CENTER ,VALUE='Simulate')


  WID_BASE_5 = Widget_Base(WID_TAB_0, UNAME='WID_BASE_5'  $
      ,SCR_XSIZE=455 ,SCR_YSIZE=506 ,TITLE='Integrate' ,SPACE=3  $
      ,XPAD=3 ,YPAD=3)


  WID_BUTTON_31 = Widget_Button(WID_BASE_5, UNAME='WID_BUTTON_31'  $
      ,XOFFSET=330 ,YOFFSET=300 ,SCR_XSIZE=118 ,SCR_YSIZE=42  $
      ,/ALIGN_CENTER ,VALUE='Integrate')


  WID_DRAW_6 = Widget_Draw(WID_BASE_5, UNAME='WID_DRAW_6' ,XOFFSET=4  $
      ,YOFFSET=4 ,SCR_XSIZE=444 ,SCR_YSIZE=287)


  WID_BUTTON_33 = Widget_Button(WID_BASE_5, UNAME='WID_BUTTON_33'  $
      ,XOFFSET=330 ,YOFFSET=388 ,SCR_XSIZE=118 ,SCR_YSIZE=42  $
      ,/ALIGN_CENTER ,VALUE='Output chi file')


  WID_BASE_5a = Widget_Base(WID_BASE_5, UNAME='WID_BASE_5a'  $
      ,XOFFSET=330 ,YOFFSET=428, /NONEXCLUSIVE)

  WID_BUTTON_33b = Widget_Button(WID_BASE_5a, UNAME='WID_BUTTON_33b'  $
            ,/ALIGN_LEFT ,VALUE='Use corners')

  WID_BUTTON_33a = Widget_Button(WID_BASE_5a, UNAME='WID_BUTTON_33a'  $
          ,/ALIGN_LEFT ,VALUE='Max filter')


  WID_TEXT_46a = Widget_Text(WID_BASE_5, UNAME='WID_TEXT_46a',  XOFFSET=330  $
      ,YOFFSET=490,  /EDITABLE ,XSIZE=10 ,YSIZE=1, VALUE='50000')


  WID_TAB_0int = Widget_Tab(WID_BASE_5, UNAME='WID_TAB_int' ,XOFFSET=0  $
      ,YOFFSET=300 ,SCR_XSIZE=313 ,SCR_YSIZE=202)

  WID_BASE_cor = Widget_Base(WID_TAB_0int, UNAME='WID_BASE_INT'  $
      , TITLE='Corrections')

  WID_BASE_int = Widget_Base(WID_TAB_0int, UNAME='WID_BASE_INT'  $
      , TITLE='Integration')

  WID_BASE_omg = Widget_Base(WID_TAB_0int, UNAME='WID_BASE_INT'  $
      , TITLE='Fcf')

  WID_BASE_scale = Widget_Base(WID_TAB_0int, UNAME='WID_BASE_scale'  $
      , TITLE='Scale')

  WID_BUTTON_sc = Widget_Button(WID_BASE_scale, UNAME='WID_BUTTON_sc',  $
          VALUE='Scale', xoffset=10, yoffset=10, xsize=80)

  WID_BUTTON_select = Widget_Button(WID_BASE_scale, UNAME='WID_BUTTON_select',  $
          VALUE='Select', xoffset=100, yoffset=10, xsize=80)

  WID_text_sel1 = Widget_text(WID_BASE_scale, UNAME='WID_LABEL_sel1'  $
      ,XOFFSET=100 ,YOFFSET=40 ,/ALIGN_LEFT, xsize=8, editable=1)



  WID_base_scale_spline = Widget_base(WID_BASE_scale, UNAME='WID_LABEL_sel1'  $
      ,XOFFSET=100 ,YOFFSET=100 ,/ALIGN_LEFT, /nonexclusive)

  WID_button_spline = Widget_button(WID_base_scale_spline, UNAME='WID_LABEL_sel1'  $
      ,XOFFSET=100 ,value='Spline')

  WID_droplist_spline = Widget_droplist(WID_BASE_scale, UNAME='WID_droplist_spline'  $
          , xoffset=100, yoffset=130, xsize=60, value=['5','6','7','8','9','10','11','12','13','14'])



  WID_text_sel2 = Widget_text(WID_BASE_scale, UNAME='WID_LABEL_sel2'  $
      ,XOFFSET=100 ,YOFFSET=70 ,/ALIGN_LEFT, xsize=8, editable=1)

  WID_BUTTON_applsc = Widget_Button(WID_BASE_scale, UNAME='WID_BUTTON_applsc'  $
          ,VALUE='Apply scale', xoffset=10, yoffset=40, xsize=80)

  WID_LABEL_0f = Widget_Label(WID_BASE_scale, UNAME='WID_LABEL_0'  $
      ,XOFFSET=200 ,YOFFSET=10 ,/ALIGN_LEFT ,VALUE='Polynomial')

  WID_droplist_poly = Widget_droplist(WID_BASE_scale, UNAME='WID_droplist_poly'  $
          , xoffset=200, yoffset=30, xsize=60, value=['2','3','4'])

  WID_list_poly = Widget_list(WID_BASE_scale, UNAME='WID_list_poly'  $
          , xoffset=200, yoffset=60, xsize=14, ysize=8)

  WID_LABEL_0g = Widget_Label(WID_BASE_scale, UNAME='WID_LABEL_0'  $
      ,XOFFSET=10 ,YOFFSET=70 ,/ALIGN_LEFT ,VALUE='Laue class')

  WID_Droplist_brav = Widget_Droplist(WID_BASE_scale, UNAME='WID_Droplist_brav'  $
      ,XOFFSET=10 ,YOFFSET=90 ,SCR_XSIZE=70 $
      ,/ALIGN_CENTER, value=Laue_class_list())

  WID_LABEL_0h = Widget_Label(WID_BASE_scale, UNAME='WID_LABEL_0'  $
      ,XOFFSET=10 ,YOFFSET=120 ,/ALIGN_LEFT ,VALUE='R_int')

  WID_text_rinta = Widget_text(WID_BASE_scale, UNAME='WID_LABEL_0'  $
      ,XOFFSET=10 ,YOFFSET=140 ,/ALIGN_LEFT, xsize=10)

  WID_LABEL_0 = Widget_Label(WID_BASE_cor, UNAME='WID_LABEL_0'  $
      ,XOFFSET=19 ,YOFFSET=16 ,/ALIGN_LEFT ,VALUE='Polariz.'+ $
      ' coefficient')

  WID_TEXT_14 = Widget_Text(WID_BASE_cor, UNAME='WID_TEXT_14'  $
      ,XOFFSET=18 ,YOFFSET=34 ,SCR_XSIZE=92 ,SCR_YSIZE=21 ,/EDITABLE  $
      ,XSIZE=20 ,YSIZE=1)

  WID_TEXT_14_da1 = Widget_Text(WID_BASE_cor, UNAME='WID_TEXT_14_da1'  $
      ,XOFFSET=230 ,YOFFSET=15 ,SCR_XSIZE=60 ,SCR_YSIZE=21 ,/EDITABLE  $
      ,XSIZE=20 ,YSIZE=1)

  WID_TEXT_14_da2 = Widget_Text(WID_BASE_cor, UNAME='WID_TEXT_14_da2'  $
      ,XOFFSET=230 ,YOFFSET=40 ,SCR_XSIZE=60 ,SCR_YSIZE=21 ,/EDITABLE  $
      ,XSIZE=20 ,YSIZE=1)

  WID_TEXT_14_da3 = Widget_Text(WID_BASE_cor, UNAME='WID_TEXT_14_da3'  $
      ,XOFFSET=230 ,YOFFSET=65 ,SCR_XSIZE=60 ,SCR_YSIZE=21 ,/EDITABLE  $
      ,XSIZE=20 ,YSIZE=1)

  WID_TEXT_14_da4 = Widget_Text(WID_BASE_cor, UNAME='WID_TEXT_14_da4'  $
      ,XOFFSET=230 ,YOFFSET=90 ,SCR_XSIZE=60 ,SCR_YSIZE=21 ,/EDITABLE  $
      ,XSIZE=20 ,YSIZE=1)

  WID_TEXT_14_da5 = Widget_Text(WID_BASE_cor, UNAME='WID_TEXT_14_da5'  $
      ,XOFFSET=230 ,YOFFSET=115 ,SCR_XSIZE=60 ,SCR_YSIZE=21 ,/EDITABLE  $
      ,XSIZE=20 ,YSIZE=1)

  WID_TEXT_14_da6 = Widget_Text(WID_BASE_cor, UNAME='WID_TEXT_14_da6'  $
      ,XOFFSET=230 ,YOFFSET=140 ,SCR_XSIZE=60 ,SCR_YSIZE=21 ,/EDITABLE  $
      ,XSIZE=20 ,YSIZE=1)

  WID_droplist_var1 =  Widget_droplist(WID_base_omg, UNAME='WID_button_var1', $
      VALUE=['omega'],XOFFSET=170 ,YOFFSET=140, $
      uvalue='fcf x variable')
      ;,'2theta','azimuth','downstr. ang'

  ;WID_button_var2 =  Widget_button(WID_base_varbase, UNAME='WID_button_var2', VALUE='2theta')

  ;WID_button_var3 =  Widget_button(WID_base_varbase, UNAME='WID_button_var3', VALUE='azimuth')

  ;WID_button_var4 =  Widget_button(WID_base_varbase, UNAME='WID_button_var4', VALUE='downstr. ang')


  WID_LABEL_14_da1om = Widget_label(WID_BASE_omg, UNAME='WID_label_14_da1om'  $
      ,XOFFSET=170 ,YOFFSET=5, vALUE='Polynomial')

  WID_droplist_fcf_poly = Widget_droplist(WID_BASE_omg, UNAME='WID_droplist_poly'  $
          , xoffset=250, yoffset=5, xsize=50, value=['2','3','4'])

  WID_list_fcf_poly = Widget_list(WID_BASE_omg, UNAME='WID_label_14_da2om'  $
      ,XOFFSET=170 ,YOFFSET=30, XSIZE=10, YSIZE=5, uvalue='')

  ;WID_LABEL_14_da3om = Widget_label(WID_BASE_omg, UNAME='WID_label_14_da3om'  $
  ;    ,XOFFSET=150 ,YOFFSET=55, vALUE='poly a3')

;---

  WID_LABEL_14_da1 = Widget_label(WID_BASE_cor, UNAME='WID_label_14_da1'  $
      ,XOFFSET=150 ,YOFFSET=15, vALUE='diam. height')

  WID_LABEL_14_da2 = Widget_label(WID_BASE_cor, UNAME='WID_label_14_da2'  $
      ,XOFFSET=150 ,YOFFSET=40, vALUE='cBN. height')

  WID_LABEL_14_da3 = Widget_label(WID_BASE_cor, UNAME='WID_label_14_da3'  $
      ,XOFFSET=150 ,YOFFSET=65, vALUE='cBN. large d')

  WID_LABEL_14_da4 = Widget_label(WID_BASE_cor, UNAME='WID_label_14_da4'  $
      ,XOFFSET=150 ,YOFFSET=90, vALUE='cBN. small d')

  WID_LABEL_14_da5 = Widget_label(WID_BASE_cor, UNAME='WID_label_14_da5'  $
      ,XOFFSET=150 ,YOFFSET=115, vALUE='cBN. mu')

  WID_LABEL_14_da6 = Widget_label(WID_BASE_cor, UNAME='WID_label_14_da6'  $
      ,XOFFSET=150 ,YOFFSET=140, vALUE='omega 0')




  WID_LABEL_12 = Widget_Label(WID_BASE_int, UNAME='WID_LABEL_12'  $
      ,XOFFSET=19 ,YOFFSET=61 ,/ALIGN_LEFT ,VALUE='2theta range')


  WID_TEXT_26 = Widget_Text(WID_BASE_int, UNAME='WID_TEXT_26'  $
      ,XOFFSET=20 ,YOFFSET=80 ,SCR_XSIZE=92 ,SCR_YSIZE=21 ,/EDITABLE  $
      ,XSIZE=20 ,YSIZE=1)


  WID_LABEL_13 = Widget_Label(WID_BASE_int, UNAME='WID_LABEL_13'  $
      ,XOFFSET=22 ,YOFFSET=109 ,/ALIGN_LEFT ,VALUE='chi range')


  WID_TEXT_49 = Widget_Text(WID_BASE_int, UNAME='WID_TEXT_49'  $
      ,XOFFSET=121 ,YOFFSET=128 ,SCR_XSIZE=92 ,SCR_YSIZE=21  $
      ,/EDITABLE ,XSIZE=20 ,YSIZE=1)


  WID_TEXT_50 = Widget_Text(WID_BASE_int, UNAME='WID_TEXT_50'  $
      ,XOFFSET=21 ,YOFFSET=128 ,SCR_XSIZE=92 ,SCR_YSIZE=21 ,/EDITABLE  $
      ,XSIZE=20 ,YSIZE=1)


  WID_BASE_12 = Widget_Base(WID_BASE_int, UNAME='WID_BASE_12'  $
      ,XOFFSET=236 ,YOFFSET=301 ,TITLE='IDL' ,COLUMN=1 ,/EXCLUSIVE)


  WID_BUTTON_11 = Widget_Button(WID_BASE_12, UNAME='WID_BUTTON_11'  $
      ,/ALIGN_LEFT ,VALUE='2theta')


  WID_BUTTON_42 = Widget_Button(WID_BASE_12, UNAME='WID_BUTTON_42'  $
      ,YOFFSET=22 ,/ALIGN_LEFT ,VALUE='chi')


  WID_BUTTON_50 = Widget_Button(WID_BASE_5, UNAME='WID_BUTTON_50'  $
      ,XOFFSET=330 ,YOFFSET=344 ,SCR_XSIZE=118 ,SCR_YSIZE=42  $
      ,/ALIGN_CENTER ,VALUE='Cake')


  ;WID_TEXT_51 = Widget_Text(WID_BASE_5, UNAME='WID_TEXT_51'  $
  ;    ,XOFFSET=115 ,YOFFSET=334 ,SCR_XSIZE=92 ,SCR_YSIZE=21  $
  ;    ,/EDITABLE ,XSIZE=20 ,YSIZE=1)


;  WID_TEXT_52 = Widget_Text(WID_BASE_5, UNAME='WID_TEXT_52'  $
;      ,XOFFSET=118 ,YOFFSET=379 ,SCR_XSIZE=92 ,SCR_YSIZE=21  $
;      ,/EDITABLE ,XSIZE=20 ,YSIZE=1)

 WID_TEXT_52 = Widget_Text(WID_BASE_int, UNAME='WID_TEXT_52'  $
      ,XOFFSET=118 ,YOFFSET=79 ,SCR_XSIZE=92 ,SCR_YSIZE=21  $
      ,/EDITABLE ,XSIZE=20 ,YSIZE=1)


  WID_BASE_13 = Widget_Base(WID_BASE_cor, UNAME='WID_BASE_13'  $
      ,XOFFSET=0 ,YOFFSET=80 ,TITLE='IDL' ,COLUMN=1  $
      ,/NONEXCLUSIVE)

  WID_BUTTON_51a = Widget_Button(WID_BASE_13, UNAME='WID_BUTTON_51a'  $
      ,/ALIGN_LEFT ,VALUE='DAC abs.')



  ;WID_BASE_13omg = Widget_Base(WID_BASE_omg, UNAME='WID_BASE_13'  $
  ;    ,XOFFSET=0 ,YOFFSET=2 ,TITLE='IDL' ,COLUMN=1  $
  ;    ,/NONEXCLUSIVE)

  ;WID_BUTTON_51aomg = Widget_Button(WID_BASE_omg, UNAME='WID_BUTTON_51aomg'  $
  ;    ,/ALIGN_LEFT ,VALUE='om poly. correction')
  ;'Open fcf file'

 WID_text_fcf_file  = Widget_text(WID_BASE_omg, UNAME='WID_BUTTON_51aomg'  $
     , xoffset=10, yoffset=5, xsize=13, uvalue='')

 WID_button_fcf_file  = Widget_button(WID_BASE_omg, UNAME='WID_BUTTON_51aomg'  $
     , xoffset=105, yoffset=5, value='File', uvalue='Open fcf file')

  WID_BASE_fcf_spline = Widget_Base(WID_BASE_omg, UNAME='WID_BASE_13aa'  $
      ,XOFFSET=5 ,YOFFSET=140 ,TITLE='IDL' ,COLUMN=1  $
      ,/NONEXCLUSIVE)

  WID_BUTTON_fcf_spline = Widget_Button(WID_BASE_fcf_spline, UNAME='WID_BUTTON_51aomg'  $
      ,/ALIGN_LEFT ,VALUE='Spline')

  WID_droplist_fcf_spline = Widget_droplist(WID_BASE_omg, UNAME='WID_BASE_13aa'  $
      ,XOFFSET=70 ,YOFFSET=140 ,value=['5','6','7','8','9','10'])

  WID_BUTTON_fcf = Widget_Button(WID_BASE_omg, UNAME='WID_BUTTON_fcf', XSIZE=90  $
      ,/ALIGN_CENTER ,VALUE='Compare',YOFFSET=35 ,XOFFSET=10, UVALUE='Compare fcf')

  WID_BUTTON_fcf_sel = Widget_Button(WID_BASE_omg, UNAME='WID_BUTTON_fcf_sel', XSIZE=90  $
      ,/ALIGN_CENTER ,VALUE='Select',YOFFSET=60 ,XOFFSET=10, UVALUE='WID_BUTTON_fcf_sel')

  WID_BUTTON_fcf_appl = Widget_Button(WID_BASE_omg, UNAME='WID_BUTTON_fcf_appl', XSIZE=90  $
      ,/ALIGN_CENTER ,VALUE='Apply cor.',YOFFSET=85 ,XOFFSET=10, UVALUE='WID_BUTTON_fcf_appl')

  WID_BUTTON_fcf_hkl = Widget_Button(WID_BASE_omg, UNAME='WID_BUTTON_fcf_appl', XSIZE=90  $
      ,/ALIGN_CENTER ,VALUE='Update hkl',YOFFSET=110 ,XOFFSET=10, UVALUE='Update hkl')

  WID_text_fcf_1 = Widget_Text(WID_BASE_omg, UNAME='WID_BUTTON_fcf_sel', XSIZE=5  $
      ,/ALIGN_CENTER ,VALUE=' 0.5',YOFFSET=60 ,XOFFSET=105, UVALUE='WID_text_fcf_1', /EDITABLE)

  WID_text_fcf_2 = Widget_Text(WID_BASE_omg, UNAME='WID_BUTTON_fcf_appl', XSIZE=5  $
      ,/ALIGN_CENTER ,VALUE='-0.5',YOFFSET=85 ,XOFFSET=105, UVALUE='WID_text_fcf_2', /EDITABLE)


  WID_BUTTON_51 = Widget_Button(WID_BASE_13, UNAME='WID_BUTTON_51'  $
      ,/ALIGN_LEFT ,VALUE='Lorenz')


;  WID_BASE_14 = Widget_Base(WID_BASE_5, UNAME='WID_BASE_14'  $
;      ,XOFFSET=257 ,YOFFSET=476 ,TITLE='IDL' ,COLUMN=1  $
;      ,/NONEXCLUSIVE)


  WID_BUTTON_52 = Widget_Button(WID_BASE_13, UNAME='WID_BUTTON_52'  $
      ,/ALIGN_LEFT ,VALUE='Polariz.')

  WID_BUTTON_52ab = Widget_Button(WID_BASE_13, UNAME='WID_BUTTON_52ab'  $
      ,/ALIGN_LEFT ,VALUE='Vert polar.')


  WID_BUTTON_open_abs = Widget_Button(WID_BASE_cor, UNAME='WID_BUTTON_open_abs'  $
      ,/ALIGN_LEFT ,VALUE='Open abs',XOFFSET=85 ,YOFFSET=70, UVALUE='Open abs', xsize=60)

  WID_BUTTON_save_abs = Widget_Button(WID_BASE_cor, UNAME='WID_BUTTON_save_abs'  $
      ,/ALIGN_LEFT ,VALUE='Save abs',XOFFSET=85 ,YOFFSET=95, UVALUE='Save abs', xsize=60)

  WID_BUTTON_export_abs = Widget_Button(WID_BASE_cor, UNAME='WID_BUTTON_export_abs'  $
      ,/ALIGN_LEFT ,VALUE='Exp. abs',XOFFSET=85 ,YOFFSET=120, UVALUE='Export abs', xsize=60)

  WID_BUTTON_import_abs = Widget_Button(WID_BASE_cor, UNAME='WID_BUTTON_import_abs'  $
      ,/ALIGN_LEFT ,VALUE='Imp. abs',XOFFSET=85 ,YOFFSET=145, UVALUE='Import abs', xsize=60)


  WID_LABEL_5 = Widget_Label(WID_BASE_cor, UNAME='WID_LABEL_5'  $
      ,XOFFSET=239 ,YOFFSET=403 ,/ALIGN_LEFT ,VALUE='I corrections')


  WID_BASE_6 = Widget_Base(WID_TAB_0, UNAME='WID_BASE_6'  $
      ,SCR_XSIZE=455 ,SCR_YSIZE=506 ,TITLE='Calibration' ,SPACE=3  $
      ,XPAD=3 ,YPAD=3)


  WID_LABEL_47 = Widget_Label(WID_BASE_6, UNAME='WID_LABEL_47'  $
      ,XOFFSET=130 ,YOFFSET=208 ,/ALIGN_LEFT ,VALUE='tilt')


  WID_LABEL_46 = Widget_Label(WID_BASE_6, UNAME='WID_LABEL_46'  $
      ,XOFFSET=130 ,YOFFSET=184 ,/ALIGN_LEFT ,VALUE='rotation')


  WID_LABEL_45 = Widget_Label(WID_BASE_6, UNAME='WID_LABEL_45'  $
      ,XOFFSET=131 ,YOFFSET=160 ,/ALIGN_LEFT ,VALUE='beam y')


  WID_LABEL_44 = Widget_Label(WID_BASE_6, UNAME='WID_LABEL_44'  $
      ,XOFFSET=131 ,YOFFSET=137 ,/ALIGN_LEFT ,VALUE='beam x')


  WID_LABEL_43 = Widget_Label(WID_BASE_6, UNAME='WID_LABEL_43'  $
      ,XOFFSET=131 ,YOFFSET=114 ,/ALIGN_LEFT ,VALUE='wavelength')


  WID_LABEL_42 = Widget_Label(WID_BASE_6, UNAME='WID_LABEL_42'  $
      ,XOFFSET=131 ,YOFFSET=91 ,/ALIGN_LEFT ,VALUE='distance')


  WID_LABEL_41 = Widget_Label(WID_BASE_6, UNAME='WID_LABEL_41'  $
      ,XOFFSET=131 ,YOFFSET=67 ,/ALIGN_LEFT ,VALUE='pix size y')


  WID_LABEL_40 = Widget_Label(WID_BASE_6, UNAME='WID_LABEL_40'  $
      ,XOFFSET=131 ,YOFFSET=45 ,/ALIGN_LEFT ,VALUE='pix size x')

  WID_LABEL_40a = Widget_Label(WID_BASE_6, UNAME='WID_LABEL_40a'  $
      ,XOFFSET=131 ,YOFFSET=23 ,/ALIGN_LEFT ,VALUE='twist')

  WID_TEXT_83a = Widget_Text(WID_BASE_6, UNAME='WID_TEXT_83a'  $
      ,XOFFSET=212 ,YOFFSET=20 ,/EDITABLE ,XSIZE=20 ,YSIZE=1)

  WID_TEXT_83 = Widget_Text(WID_BASE_6, UNAME='WID_TEXT_83'  $
      ,XOFFSET=212 ,YOFFSET=135 ,/EDITABLE ,XSIZE=20 ,YSIZE=1)


  WID_TEXT_82 = Widget_Text(WID_BASE_6, UNAME='WID_TEXT_82'  $
      ,XOFFSET=212 ,YOFFSET=158 ,/EDITABLE ,XSIZE=20 ,YSIZE=1)


  WID_TEXT_81 = Widget_Text(WID_BASE_6, UNAME='WID_TEXT_81'  $
      ,XOFFSET=212 ,YOFFSET=182 ,/EDITABLE ,XSIZE=20 ,YSIZE=1)


  WID_TEXT_80 = Widget_Text(WID_BASE_6, UNAME='WID_TEXT_80'  $
      ,XOFFSET=212 ,YOFFSET=205 ,/EDITABLE ,XSIZE=20 ,YSIZE=1)


  WID_TEXT_32 = Widget_Text(WID_BASE_6, UNAME='WID_TEXT_32'  $
      ,XOFFSET=212 ,YOFFSET=113 ,/EDITABLE ,XSIZE=20 ,YSIZE=1)


  WID_TEXT_33 = Widget_Text(WID_BASE_6, UNAME='WID_TEXT_33'  $
      ,XOFFSET=212 ,YOFFSET=90 ,/EDITABLE ,XSIZE=20 ,YSIZE=1)


  WID_TEXT_35 = Widget_Text(WID_BASE_6, UNAME='WID_TEXT_35'  $
      ,XOFFSET=212 ,YOFFSET=66 ,/EDITABLE ,XSIZE=20 ,YSIZE=1)


  WID_TEXT_36 = Widget_Text(WID_BASE_6, UNAME='WID_TEXT_36'  $
      ,XOFFSET=212 ,YOFFSET=43 ,/EDITABLE ,XSIZE=20 ,YSIZE=1)

;====
 WID_TEXT_83ad = Widget_Text(WID_BASE_6, UNAME='WID_TEXT_83ad'  $
      ,XOFFSET=352 ,YOFFSET=20 ,/EDITABLE ,XSIZE=10 ,YSIZE=1)

 WID_TEXT_36d = Widget_Text(WID_BASE_6, UNAME='WID_TEXT_36d'  $
      ,XOFFSET=352 ,YOFFSET=43 ,/EDITABLE ,XSIZE=10 ,YSIZE=1)

  WID_TEXT_35d = Widget_Text(WID_BASE_6, UNAME='WID_TEXT_35d'  $
      ,XOFFSET=352 ,YOFFSET=66 ,/EDITABLE ,XSIZE=10 ,YSIZE=1)

  WID_TEXT_33d = Widget_Text(WID_BASE_6, UNAME='WID_TEXT_33d'  $
      ,XOFFSET=352 ,YOFFSET=90 ,/EDITABLE ,XSIZE=10 ,YSIZE=1)


 WID_TEXT_32d = Widget_Text(WID_BASE_6, UNAME='WID_TEXT_32d'  $
      ,XOFFSET=352 ,YOFFSET=113 ,/EDITABLE ,XSIZE=10 ,YSIZE=1)

  WID_TEXT_83d = Widget_Text(WID_BASE_6, UNAME='WID_TEXT_83d'  $
      ,XOFFSET=352 ,YOFFSET=135 ,/EDITABLE ,XSIZE=10 ,YSIZE=1)


  WID_TEXT_82d = Widget_Text(WID_BASE_6, UNAME='WID_TEXT_82d'  $
      ,XOFFSET=352 ,YOFFSET=158 ,/EDITABLE ,XSIZE=10 ,YSIZE=1)


  WID_TEXT_81d = Widget_Text(WID_BASE_6, UNAME='WID_TEXT_81d'  $
      ,XOFFSET=352 ,YOFFSET=182 ,/EDITABLE ,XSIZE=10 ,YSIZE=1)


  WID_TEXT_80d = Widget_Text(WID_BASE_6, UNAME='WID_TEXT_80d'  $
      ,XOFFSET=352 ,YOFFSET=205 ,/EDITABLE ,XSIZE=10 ,YSIZE=1)





;====


  WID_BUTTON_26 = Widget_Button(WID_BASE_6, UNAME='WID_BUTTON_26'  $
      ,XOFFSET=100 ,YOFFSET=311 ,SCR_XSIZE=123 ,SCR_YSIZE=29  $
      ,/ALIGN_CENTER ,VALUE='Open')


  WID_BUTTON_27 = Widget_Button(WID_BASE_6, UNAME='WID_BUTTON_27'  $
      ,XOFFSET=235 ,YOFFSET=311 ,SCR_XSIZE=123 ,SCR_YSIZE=29  $
      ,/ALIGN_CENTER ,VALUE='Save')


  WID_BUTTON_34 = Widget_Button(WID_BASE_6, UNAME='WID_BUTTON_34'  $
      ,XOFFSET=100 ,YOFFSET=343 ,SCR_XSIZE=257 ,SCR_YSIZE=39  $
      ,/ALIGN_CENTER ,VALUE='Recalculate XYZ')


  WID_BUTTON_36 = Widget_Button(WID_BASE_6, UNAME='WID_BUTTON_36'  $
      ,XOFFSET=100 ,YOFFSET=384 ,SCR_XSIZE=257 ,SCR_YSIZE=39  $
      ,/ALIGN_CENTER ,VALUE='Recalculate DetXY')

  WID_Droplist_36aa = Widget_Droplist(WID_BASE_6, UNAME='WID_Droplist_36aa'  $
      ,XOFFSET=370 ,YOFFSET=384 ,SCR_XSIZE=80 ,SCR_YSIZE=39  $
      ,/ALIGN_CENTER, value=['CeO2','LaB6','Neon','CO2'])


WID_BUTTON_36aa = Widget_Button(WID_BASE_6, UNAME='WID_BUTTON_36aa'  $
      ,XOFFSET=100 ,YOFFSET=424 ,SCR_XSIZE=125 ,SCR_YSIZE=39  $
      ,/ALIGN_CENTER ,VALUE='Refine cal.')


WID_BUTTON_36ad = Widget_Button(WID_BASE_6, UNAME='WID_BUTTON_36ad'  $
      ,XOFFSET=232 ,YOFFSET=424 ,SCR_XSIZE=125 ,SCR_YSIZE=39  $
      ,/ALIGN_CENTER ,VALUE='Fine tune')

WID_BUTTON_36ac = Widget_Button(WID_BASE_6, UNAME='WID_BUTTON_36ac'  $
      ,XOFFSET=10 ,YOFFSET=424 ,SCR_XSIZE=70 ,SCR_YSIZE=39  $
      ,/ALIGN_CENTER ,VALUE='Test')

WID_TEXT_36ac = Widget_Text(WID_BASE_6, UNAME='WID_TEXT_36ac'  $
      ,XOFFSET=10 ,YOFFSET=464 ,XSIZE=10 ,VALUE='2.0', EDITABLE=1)





WID_base_DSRing = Widget_Base(WID_BASE_6, UNAME='WID_base_DSring'  $
      ,XOFFSET=10 ,YOFFSET=485, /NONEXCLUSIVE)

WID_but_36ac = Widget_Button(WID_base_DSRing, UNAME='WID_But_36ac'  $
      ,VALUE='Show rings')




WID_BUTTON_36ab = Widget_Button(WID_BASE_6, UNAME='WID_BUTTON_36ab'  $
      ,XOFFSET=100 ,YOFFSET=464 ,SCR_XSIZE=257 ,SCR_YSIZE=39  $
      ,/ALIGN_CENTER ,VALUE='Refine Pilatus')


WID_base_ref_cal_type = Widget_base(WID_BASE_6, UNAME='WID_base_ref_cal'  $
      ,XOFFSET=360 ,YOFFSET=234, /ALIGN_LEFT, /EXCLUSIVE)

WID_BUTTON_refine_calt_p = Widget_Button(WID_base_ref_cal_type, UNAME='WID_BUTTON_refine_cal_p'  $
      ,/ALIGN_Left ,VALUE='Fit2d')

WID_BUTTON_refine_calt_s = Widget_Button(WID_base_ref_cal_type, UNAME='WID_BUTTON_refine_cal_s'  $
      ,/ALIGN_Left ,VALUE='Dera')

WIDGET_CONTROL, WID_BUTTON_refine_calt_s, SET_BUTTON=1

WID_base_ref_cal = Widget_base(WID_BASE_6, UNAME='WID_base_ref_cal'  $
      ,XOFFSET=360 ,YOFFSET=324, /ALIGN_LEFT, /EXCLUSIVE)

WID_BUTTON_refine_cal_p = Widget_Button(WID_BASE_ref_cal, UNAME='WID_BUTTON_refine_cal_p'  $
      ,/ALIGN_Left ,VALUE='Powder')

WID_BUTTON_refine_cal_s = Widget_Button(WID_BASE_ref_cal, UNAME='WID_BUTTON_refine_cal_s'  $
      ,/ALIGN_Left ,VALUE='Single crystal', sensitive=0)


WID_base_ref = Widget_base(WID_BASE_6, UNAME='WID_base_ref'  $
      ,XOFFSET=360 ,YOFFSET=424, /ALIGN_LEFT, /NONEXCLUSIVE)

WID_BUTTON_refine_B = Widget_Button(WID_BASE_ref, UNAME='WID_BUTTON_refine_B'  $
      ,/ALIGN_Left ,VALUE='Refine B', sensitive=0)

WID_BUTTON_refine_al = Widget_Button(WID_BASE_ref, UNAME='WID_BUTTON_refine_al'  $
      ,/ALIGN_Left ,VALUE='Refine al', sensitive=0)

WID_BUTTON_refine_twist = Widget_Button(WID_BASE_ref, UNAME='WID_BUTTON_refine_twist'  $
      ,/ALIGN_Left ,VALUE='Refine twist')

  WID_TEXT_36b = Widget_Text(WID_BASE_6, UNAME='WID_TEXT_36b'  $
      ,XOFFSET=214 ,YOFFSET=258 ,/EDITABLE ,XSIZE=20 ,YSIZE=1)


  WID_TEXT_36a = Widget_Text(WID_BASE_6, UNAME='WID_TEXT_36a'  $
      ,XOFFSET=214 ,YOFFSET=235 ,/EDITABLE ,XSIZE=20 ,YSIZE=1)


  WID_TEXT_36c = Widget_Text(WID_BASE_6, UNAME='WID_TEXT_36c'  $
      ,XOFFSET=214 ,YOFFSET=281 ,/EDITABLE ,XSIZE=20 ,YSIZE=1)


  WID_LABEL_48 = Widget_Label(WID_BASE_6, UNAME='WID_LABEL_48'  $
      ,XOFFSET=132 ,YOFFSET=237 ,/ALIGN_LEFT ,VALUE='kappa')


  WID_LABEL_49 = Widget_Label(WID_BASE_6, UNAME='WID_LABEL_49'  $
      ,XOFFSET=132 ,YOFFSET=261 ,/ALIGN_LEFT ,VALUE='2theta')

  WID_LABEL_49aa = Widget_Label(WID_BASE_6, UNAME='WID_LABEL_49'  $
      ,XOFFSET=132 ,YOFFSET=285 ,/ALIGN_LEFT ,VALUE='alpha')

  WID_BASE_9 = Widget_Base(WID_TAB_0, UNAME='WID_BASE_9'  $
      ,SCR_XSIZE=580 ,SCR_YSIZE=606 ,TITLE='Peaks' ,SPACE=3 ,XPAD=3  $
      ,YPAD=3)


 WID_BUTTON_41aw = Widget_Button(WID_BASE_9, UNAME='WID_BUTTON_41'  $
      ,XOFFSET=210 ,YOFFSET=8 ,SCR_XSIZE=64 ,SCR_YSIZE=24  $
      ,/ALIGN_CENTER ,VALUE='TDS', UVALUE='TDS')


  WID_BUTTON_28 = Widget_Button(WID_BASE_9, UNAME='WID_BUTTON_28'  $
      ,XOFFSET=72 ,YOFFSET=10 ,SCR_XSIZE=65 ,SCR_YSIZE=24  $
      ,/ALIGN_CENTER ,VALUE='Open')


  WID_BUTTON_29 = Widget_Button(WID_BASE_9, UNAME='WID_BUTTON_29'  $
      ,XOFFSET=140 ,YOFFSET=10 ,SCR_XSIZE=65 ,SCR_YSIZE=24  $
      ,/ALIGN_CENTER ,VALUE='Save')


  WID_BUTTON_30 = Widget_Button(WID_BASE_9, UNAME='WID_BUTTON_30'  $
      ,XOFFSET=10 ,YOFFSET=10 ,SCR_XSIZE=56 ,SCR_YSIZE=49  $
      ,/ALIGN_CENTER ,VALUE='Clear')


  WID_BUTTON_32 = Widget_Button(WID_BASE_9, UNAME='WID_BUTTON_32'  $
      ,XOFFSET=10 ,YOFFSET=61 ,SCR_XSIZE=56 ,SCR_YSIZE=25  $
      ,/ALIGN_CENTER ,VALUE='Delete')


  WID_LIST_3 = Widget_List(WID_BASE_9, UNAME='WID_LIST_3' ,XOFFSET=15  $
      ,YOFFSET=359 ,SCR_XSIZE=199 ,SCR_YSIZE=199 ,XSIZE=11 ,YSIZE=2)

  WID_DRAW_1 = Widget_Draw(WID_BASE_9, UNAME='WID_DRAW_1' ,XOFFSET=15  $
      ,YOFFSET=153 ,SCR_XSIZE=200 ,SCR_YSIZE=200)

  WID_DRAW_2 = Widget_Draw(WID_BASE_9, UNAME='WID_DRAW_2'  $
      ,XOFFSET=218 ,YOFFSET=152 ,SCR_XSIZE=200 ,SCR_YSIZE=200)

  WID_DRAW_5 = Widget_Draw(WID_BASE_9, UNAME='WID_DRAW_5'  $
      ,XOFFSET=218 ,YOFFSET=358 ,SCR_XSIZE=200 ,SCR_YSIZE=200)


  WID_BUTTON_35 = Widget_Button(WID_BASE_9, UNAME='WID_BUTTON_35'  $
      ,XOFFSET=140 ,YOFFSET=35 ,SCR_XSIZE=65 ,SCR_YSIZE=24  $
      ,/ALIGN_CENTER ,VALUE='Update file')


  WID_BUTTON_39 = Widget_Button(WID_BASE_9, UNAME='WID_BUTTON_39'  $
      ,XOFFSET=72 ,YOFFSET=35 ,SCR_XSIZE=65 ,SCR_YSIZE=24  $
      ,/ALIGN_CENTER ,VALUE='Reload')



  WID_BUTTON_45 = Widget_Button(WID_BASE_9, UNAME='WID_BUTTON_45'  $
      ,XOFFSET=72 ,YOFFSET=60 ,SCR_XSIZE=65 ,SCR_YSIZE=24  $
      ,/ALIGN_CENTER ,VALUE='Peak fit')


  WID_TEXT_37 = Widget_Text(WID_BASE_9, UNAME='WID_TEXT_37'  $
      ,XOFFSET=331 ,YOFFSET=65 ,SCR_XSIZE=39 ,SCR_YSIZE=21 ,/EDITABLE  $
      ,XSIZE=20 ,YSIZE=1)


  WID_LABEL_4 = Widget_Label(WID_BASE_9, UNAME='WID_LABEL_4'  $
      ,XOFFSET=300 ,YOFFSET=69 ,/ALIGN_LEFT ,VALUE='Box')

  WID_LABEL_4a = Widget_Label(WID_BASE_9, UNAME='WID_LABEL_4a'  $
      ,XOFFSET=18 ,YOFFSET=95 ,/ALIGN_LEFT ,VALUE='Laue class')

  WID_LABEL_4b = Widget_Label(WID_BASE_9, UNAME='WID_LABEL_4b'  $
      ,XOFFSET=18 ,YOFFSET=120 ,/ALIGN_LEFT ,VALUE='R(int)')

  WID_Droplist_4aa = Widget_Droplist(WID_BASE_9, UNAME='WID_Droplist_4aa'  $
      ,XOFFSET=80 ,YOFFSET=92 ,SCR_XSIZE=87 $
      ,/ALIGN_CENTER, value=Laue_class_list())

  WID_TEXT_37aa = Widget_Text(WID_BASE_9, UNAME='WID_TEXT_37aa'  $
      ,XOFFSET=79 ,YOFFSET=118 ,XSIZE=13 ,YSIZE=1)


;  WID_TEXT_45 = Widget_Text(WID_BASE_9, UNAME='WID_TEXT_45'  $
;      ,XOFFSET=378 ,YOFFSET=65 ,SCR_XSIZE=38 ,SCR_YSIZE=21 ,/EDITABLE  $
;      ,XSIZE=20 ,YSIZE=1)


  WID_BUTTON_40 = Widget_Button(WID_BASE_9, UNAME='WID_BUTTON_40'  $
      ,XOFFSET=140 ,YOFFSET=60 ,SCR_XSIZE=65 ,SCR_YSIZE=24  $
      ,/ALIGN_CENTER ,VALUE='Export')


  WID_BUTTON_41 = Widget_Button(WID_BASE_9, UNAME='WID_BUTTON_41'  $
      ,XOFFSET=210 ,YOFFSET=34 ,SCR_XSIZE=64 ,SCR_YSIZE=24  $
      ,/ALIGN_CENTER ,VALUE='Observed')

;------

  WID_BUTTON_411 = Widget_Button(WID_BASE_9, UNAME='WID_BUTTON_411'  $
      ,XOFFSET=300 ,YOFFSET=94 ,SCR_XSIZE=70 ,SCR_YSIZE=24  $
      ,/ALIGN_CENTER ,VALUE='Change size')

  WID_BASE_bsize = Widget_Base(WID_BASE_9, UNAME='WID_BASE_bsize'  $
      ,XOFFSET=370 ,YOFFSET=94 ,COLUMN=1 ,/EXCLUSIVE)

  WID_BUTTON_412 = Widget_Button(WID_BASE_bsize, UNAME='WID_BUTTON_412'  $
      ,/ALIGN_LEFT ,VALUE='One')

  WID_BUTTON_413 = Widget_Button(WID_BASE_bsize, UNAME='WID_BUTTON_413'  $
      ,/ALIGN_LEFT ,VALUE='All')


  WID_BASE_fun = Widget_Base(WID_BASE_9, UNAME='WID_BASE_fun'  $
      ,XOFFSET=430 ,YOFFSET=120 ,COLUMN=1 ,/EXCLUSIVE)

  WID_BUTTON_412z = Widget_Button(WID_BASE_fun, UNAME='WID_BUTTON_412a'  $
      ,/ALIGN_LEFT ,VALUE='Gauss 1D', UVALUE='', sensitive=0)


  WID_BUTTON_412a = Widget_Button(WID_BASE_fun, UNAME='WID_BUTTON_412a'  $
      ,/ALIGN_LEFT ,VALUE='Gauss 2D')

  WID_BUTTON_413a = Widget_Button(WID_BASE_fun, UNAME='WID_BUTTON_413a'  $
      ,/ALIGN_LEFT ,VALUE='pseudo-Voigt')



  WID_BASE_pd = Widget_Base(WID_BASE_9, UNAME='WID_BASE_fun'  $
      ,XOFFSET=430 ,YOFFSET=200 ,COLUMN=1 ,/EXCLUSIVE)

  WID_BUTTON_412b = Widget_Button(WID_BASE_pd, UNAME='WID_BUTTON_412a'  $
      ,/ALIGN_LEFT ,VALUE='Current img')

  WID_BUTTON_413b = Widget_Button(WID_BASE_pd, UNAME='WID_BUTTON_413a'  $
      ,/ALIGN_LEFT ,VALUE='Series', sensitive=0)




;-------- peak filtering controls

  aWID_BASE_1 = Widget_Base(WID_BASE_9,  $
      UNAME='aWID_BASE_1' ,XOFFSET=430 ,YOFFSET=260 ,SCR_XSIZE=95  $
      ,SCR_YSIZE=258 ,TITLE='IDL' ,SPACE=3 ,XPAD=3 ,YPAD=3)


  aWID_TEXT_0 = Widget_Text(aWID_BASE_1, UNAME='aWID_TEXT_0' ,XOFFSET=5  $
      ,YOFFSET=30 ,SCR_XSIZE=40 ,SCR_YSIZE=21 ,XSIZE=20 ,YSIZE=1)


  aWID_TEXT_1 = Widget_Text(aWID_BASE_1, UNAME='aWID_TEXT_1' ,XOFFSET=5  $
      ,YOFFSET=80 ,SCR_XSIZE=40 ,SCR_YSIZE=21 ,XSIZE=20 ,YSIZE=1)


  aWID_TEXT_2 = Widget_Text(aWID_BASE_1, UNAME='aWID_TEXT_2' ,XOFFSET=5  $
      ,YOFFSET=130 ,SCR_XSIZE=40 ,SCR_YSIZE=21 ,XSIZE=20 ,YSIZE=1)


  aWID_TEXT_3 = Widget_Text(aWID_BASE_1, UNAME='aWID_TEXT_3' ,XOFFSET=5  $
      ,YOFFSET=180 ,SCR_XSIZE=40 ,SCR_YSIZE=21 ,XSIZE=20 ,YSIZE=1)


  aWID_TEXT_4 = Widget_Text(aWID_BASE_1, UNAME='aWID_TEXT_4' ,XOFFSET=5  $
      ,YOFFSET=230 ,SCR_XSIZE=40 ,SCR_YSIZE=21 ,XSIZE=20 ,YSIZE=1)


  aWID_BASE_2 = Widget_Base(aWID_BASE_1, UNAME='aWID_BASE_2' ,XOFFSET=5  $
      ,TITLE='IDL' ,COLUMN=1 ,/NONEXCLUSIVE)


  aWID_BUTTON_0 = Widget_Button(aWID_BASE_2, UNAME='aWID_BUTTON_0'  $
      ,/ALIGN_LEFT ,VALUE='Min I')


  aWID_BASE_3 = Widget_Base(aWID_BASE_1, UNAME='aWID_BASE_3' ,XOFFSET=5  $
      ,YOFFSET=50 ,TITLE='IDL' ,COLUMN=1 ,/NONEXCLUSIVE)


  aWID_BUTTON_1 = Widget_Button(aWID_BASE_3, UNAME='aWID_BUTTON_1'  $
      ,/ALIGN_LEFT ,VALUE='Max I')


  aWID_BASE_4 = Widget_Base(aWID_BASE_1, UNAME='aWID_BASE_4' ,XOFFSET=5  $
      ,YOFFSET=100 ,TITLE='IDL' ,COLUMN=1 ,/NONEXCLUSIVE)


  aWID_BUTTON_2 = Widget_Button(aWID_BASE_4, UNAME='aWID_BUTTON_2'  $
      ,/ALIGN_LEFT ,VALUE='Max width')


  aWID_BASE_5 = Widget_Base(aWID_BASE_1, UNAME='aWID_BASE_5' ,XOFFSET=5  $
      ,YOFFSET=150 ,TITLE='IDL' ,COLUMN=1 ,/NONEXCLUSIVE)


  aWID_BUTTON_3 = Widget_Button(aWID_BASE_5, UNAME='aWID_BUTTON_3'  $
      ,/ALIGN_LEFT ,VALUE='Max diff')


  aWID_BASE_6 = Widget_Base(aWID_BASE_1, UNAME='aWID_BASE_6' ,XOFFSET=5  $
      ,YOFFSET=200 ,TITLE='IDL' ,COLUMN=1 ,/NONEXCLUSIVE)


  aWID_BUTTON_4 = Widget_Button(aWID_BASE_6, UNAME='aWID_BUTTON_4'  $
      ,/ALIGN_LEFT ,VALUE='Total diff')


 ;------------------------------



  WID_text_10 = Widget_text(WID_BASE_9, UNAME='WID_text_10'  $
      ,/ALIGN_LEFT ,VALUE='0',XOFFSET=430 ,YOFFSET=536, xsize=6)

;------
;------

  WID_BUTTON_511 = Widget_Button(WID_BASE_9, UNAME='WID_BUTTON_511'  $
      ,XOFFSET=175 ,YOFFSET=94 ,SCR_XSIZE=50 ,SCR_YSIZE=24  $
      ,/ALIGN_CENTER ,VALUE='Move')

  WID_BASE_pts = Widget_Base(WID_BASE_9, UNAME='WID_BASE_bsize'  $
      ,XOFFSET=230 ,YOFFSET=94 ,COLUMN=1 ,/EXCLUSIVE)

  WID_BUTTON_512 = Widget_Button(WID_BASE_pts, UNAME='WID_BUTTON_512'  $
      ,/ALIGN_LEFT ,VALUE='PT1')

  WID_BUTTON_513 = Widget_Button(WID_BASE_pts, UNAME='WID_BUTTON_513'  $
      ,/ALIGN_LEFT ,VALUE='PT2')

;------

  WID_TEXT_48 = Widget_Text(WID_BASE_9, UNAME='WID_TEXT_48'  $
      ,XOFFSET=298 ,YOFFSET=37 ,SCR_XSIZE=47 ,SCR_YSIZE=21 ,/EDITABLE  $
      ,XSIZE=20 ,YSIZE=1)


  WID_BASE_8 = Widget_Base(WID_BASE_9, UNAME='WID_BASE_8'  $
      ,XOFFSET=281 ,YOFFSET=6 ,TITLE='IDL' ,COLUMN=1 ,/NONEXCLUSIVE)


  WID_BUTTON_19 = Widget_Button(WID_BASE_8, UNAME='WID_BUTTON_19'  $
      ,SCR_XSIZE=72 ,SCR_YSIZE=20 ,/ALIGN_LEFT ,VALUE='hkl labels')


  WID_BUTTON_46 = Widget_Button(WID_BASE_9, UNAME='WID_BUTTON_46'  $
      ,XOFFSET=209 ,YOFFSET=60 ,SCR_XSIZE=65 ,SCR_YSIZE=24  $
      ,/ALIGN_CENTER ,VALUE='Edit')


  WID_BASE_15 = Widget_Base(WID_BASE_9, UNAME='WID_BASE_15'  $
      ,XOFFSET=430 ,YOFFSET=6   $
      ,TITLE='IDL' ,COLUMN=1 ,/NONEXCLUSIVE)


  WID_BUTTON_23 = Widget_Button(WID_BASE_15, UNAME='WID_BUTTON_23'  $
      ,SCR_XSIZE=84 ,SCR_YSIZE=20 ,/ALIGN_LEFT ,VALUE='Constrain'+ $
      ' tilt', sensitive=0)

  WID_BUTTON_23a = Widget_Button(WID_BASE_15, UNAME='WID_BUTTON_23a'  $
      ,SCR_XSIZE=84 ,SCR_YSIZE=20 ,/ALIGN_LEFT ,VALUE='Prefitting', sensitive=0)


  WID_BUTTON_23b = Widget_Button(WID_BASE_15, UNAME='WID_BUTTON_23b'  $
      ,SCR_XSIZE=84 ,SCR_YSIZE=20 ,/ALIGN_LEFT ,VALUE='Symm. correl.', uvalue='', sensitive=0)


  WID_BUTTON_23c = Widget_Button(WID_BASE_15, UNAME='WID_BUTTON_23c'  $
      ,SCR_XSIZE=84 ,SCR_YSIZE=20 ,/ALIGN_LEFT ,VALUE='Upd. on brws', uvalue='')


  WID_BASE_11 = Widget_Base(WID_TAB_0, UNAME='WID_BASE_11'  $
      ,SCR_XSIZE=455 ,SCR_YSIZE=506 ,TITLE='Zoom' ,SPACE=3 ,XPAD=3  $
      ,YPAD=3)


  WID_DRAW_3 = Widget_Draw(WID_BASE_11, UNAME='WID_DRAW_3' ,XOFFSET=2  $
      ,YOFFSET=74 ,SCR_XSIZE=428 ,SCR_YSIZE=428)


  ; ************************** NEW CODE ***************************
  WID_BASE_HELP = Widget_Base(WID_TAB_0, UNAME='WID_BASE_HELP'  $
      ,SCR_XSIZE=455 ,SCR_YSIZE=506 ,TITLE='Help' ,SPACE=3 ,XPAD=3  $
      ,YPAD=3)

  WID_LIST_INFO = Widget_List(WID_BASE_HELP, UNAME='WID_LIST_INFO'  $
      ,XOFFSET=17 ,YOFFSET=30 ,SCR_XSIZE=415 ,SCR_YSIZE=130 , XSIZE=20  $
      ,YSIZE=1, SENSITIVE = 0)

  WID_BUTTON_HELP = Widget_Button(WID_BASE_HELP, UNAME='WID_BUTTON_HELP'  $
      ,XOFFSET=111 ,YOFFSET=214 ,SCR_XSIZE=215 ,SCR_YSIZE=50  $
      ,/ALIGN_CENTER ,VALUE='Help', sensitive=0)

  WID_BASE_OMEGA_ROTATION = Widget_Base(WID_BASE_3, UNAME='WID_BASE_OMEGA_ROTATION'  $
      ,XOFFSET=300 ,YOFFSET=71 ,COLUMN=1 ,/NONEXCLUSIVE)

;  WID_BUTTON_OMEGA_ROTATION = Widget_Button(WID_BASE_OMEGA_ROTATION, UNAME='WID_BUTTON_OMEGA_ROTATION'  $
;      ,/ALIGN_LEFT ,VALUE='Invert omega rotation')

  WID_BUTTON_dynamic_mask = Widget_Button(WID_BASE_OMEGA_ROTATION, UNAME='WID_BUTTON_dynamic_mask'  $
      ,/ALIGN_LEFT ,VALUE='Dynamic mask', sensitive=0)

 WID_Label_opening = Widget_label(WID_BASE_3, UNAME='WID_label_opening'  $
      ,XOFFSET=220 ,YOFFSET=80 , value='DAC opening')

  WID_TEXT_opening = Widget_Text(WID_BASE_3, UNAME='WID_TEXT_48'  $
      ,XOFFSET=220 ,YOFFSET=101 ,/EDITABLE  $
      ,XSIZE=6 ,YSIZE=1)

  ; *************************** NEW CODE ***************************

  ;WID_DROPLIST_0 = Widget_Droplist(WID_BASE_11,  $
  ;    UNAME='WID_DROPLIST_0' ,XOFFSET=4 ,YOFFSET=41)


  WID_DRAW_0 = Widget_Draw(WID_MAR345, UNAME='WID_DRAW_0' ,XOFFSET=4  $
      ,YOFFSET=63 ,SCR_XSIZE=600 ,SCR_YSIZE=600)


  WID_LABEL_11 = Widget_Label(WID_MAR345, UNAME='WID_LABEL_11'  $
      ,XOFFSET=20 ,YOFFSET=5 ,SCR_XSIZE=64 ,SCR_YSIZE=18  $
      ,/ALIGN_LEFT ,VALUE='File')


  WID_TEXT_17 = Widget_Text(WID_MAR345, UNAME='WID_TEXT_17'  $
      ,XOFFSET=103 ,YOFFSET=29 ,SCR_XSIZE=307 ,SCR_YSIZE=21 ,XSIZE=20  $
      ,YSIZE=1)


  WID_TEXT_24 = Widget_Text(WID_MAR345, UNAME='WID_TEXT_24'  $
      ,XOFFSET=765 ,YOFFSET=13 ,SCR_XSIZE=66 ,SCR_YSIZE=21 ,XSIZE=20  $
      ,YSIZE=1)


  WID_TEXT_25 = Widget_Text(WID_MAR345, UNAME='WID_TEXT_25'  $
      ,XOFFSET=765 ,YOFFSET=36 ,SCR_XSIZE=66 ,SCR_YSIZE=21 ,XSIZE=20  $
      ,YSIZE=1)


  WID_LABEL_2 = Widget_Label(WID_MAR345, UNAME='WID_LABEL_2'  $
      ,XOFFSET=726 ,YOFFSET=19 ,/ALIGN_LEFT ,VALUE='max')


  WID_LABEL_3 = Widget_Label(WID_MAR345, UNAME='WID_LABEL_3'  $
      ,XOFFSET=725 ,YOFFSET=39 ,/ALIGN_LEFT ,VALUE='min')


  WID_BUTTON_43 = Widget_Button(WID_MAR345, UNAME='WID_BUTTON_43'  $
      ,XOFFSET=550 ,YOFFSET=10 ,SCR_XSIZE=61 ,SCR_YSIZE=22  $
      ,/ALIGN_CENTER ,VALUE='Save')


  WID_BUTTON_44 = Widget_Button(WID_MAR345, UNAME='WID_BUTTON_44'  $
      ,XOFFSET=550 ,YOFFSET=35 ,SCR_XSIZE=61 ,SCR_YSIZE=22  $
      ,/ALIGN_CENTER ,VALUE='Print')

  ;widget_control, WID_button_var1, set_button=1

  wid_list_3a=wid_list_3

; text_27 is the invisible text widget in Integrate

  Widget_Control, /REALIZE, WID_MAR345

  WID_MAR345_aux

  XManager, 'WID_MAR345_L', WID_MAR345, $
            Cleanup = 'WID_MAR345_Cleanup', /NO_BLOCK

end
