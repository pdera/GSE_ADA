
;********************************* NEW CODE *********************
;This is a clean up procedure to assure closing of the window
;upon user mouse clicking and disposing of the window.

pro WID_Image_simulation1_Cleanup, WID_Image_simulation
common status, PE_open, SIM_open
SIM_open = 0
end
;********************************* NEW CODE *********************



pro WID_Image_simulation1_L

@Image_simmulation_common

;********************************* NEW CODE *********************
;This block is needed to assure the visibility of the simulation
;window to the main GSE window (simulation and main GSE window do
;not have parent-child relationship in this code).

common closing, Wid_Image_simulation
;********************************* NEW CODE *********************

  WID_Image_simulation = Widget_Base( GROUP_LEADER=wGroup,  $
      UNAME='WID_Image_simulation' ,XOFFSET=5 ,YOFFSET=5  $
      ,SCR_XSIZE=640 ,SCR_YSIZE=487 ,TITLE='Diffraction imag'+ $
      ' simulation / manual indexing' ,SPACE=3 ,XPAD=3 ,YPAD=3)


  WID_LABEL_0 = Widget_Label(WID_Image_simulation,  $
      UNAME='WID_LABEL_0' ,XOFFSET=23 ,YOFFSET=23 ,/ALIGN_LEFT  $
      ,VALUE='Unit cell parameters')


  WID_TEXT_0 = Widget_Text(WID_Image_simulation, UNAME='WID_TEXT_0'  $
      ,XOFFSET=54 ,YOFFSET=61 ,SCR_XSIZE=89 ,SCR_YSIZE=21 ,/EDITABLE  $
      ,XSIZE=20 ,YSIZE=1)


  WID_TEXT_1 = Widget_Text(WID_Image_simulation, UNAME='WID_TEXT_1'  $
      ,XOFFSET=54 ,YOFFSET=86 ,SCR_XSIZE=89 ,SCR_YSIZE=21 ,/EDITABLE  $
      ,XSIZE=20 ,YSIZE=1)


  WID_TEXT_2 = Widget_Text(WID_Image_simulation, UNAME='WID_TEXT_2'  $
      ,XOFFSET=54 ,YOFFSET=110 ,SCR_XSIZE=89 ,SCR_YSIZE=21 ,/EDITABLE  $
      ,XSIZE=20 ,YSIZE=1)


  WID_LABEL_1 = Widget_Label(WID_Image_simulation,  $
      UNAME='WID_LABEL_1' ,XOFFSET=24 ,YOFFSET=66 ,SCR_XSIZE=18  $
      ,SCR_YSIZE=15 ,/ALIGN_LEFT ,VALUE='a')


  WID_LABEL_2 = Widget_Label(WID_Image_simulation,  $
      UNAME='WID_LABEL_2' ,XOFFSET=23 ,YOFFSET=89 ,SCR_XSIZE=18  $
      ,SCR_YSIZE=15 ,/ALIGN_LEFT ,VALUE='b')


  WID_LABEL_3 = Widget_Label(WID_Image_simulation,  $
      UNAME='WID_LABEL_3' ,XOFFSET=23 ,YOFFSET=112 ,SCR_XSIZE=18  $
      ,SCR_YSIZE=15 ,/ALIGN_LEFT ,VALUE='c')


  WID_LABEL_4 = Widget_Label(WID_Image_simulation,  $
      UNAME='WID_LABEL_4' ,XOFFSET=159 ,YOFFSET=111 ,SCR_XSIZE=44  $
      ,SCR_YSIZE=15 ,/ALIGN_LEFT ,VALUE='gamma')


  WID_LABEL_5 = Widget_Label(WID_Image_simulation,  $
      UNAME='WID_LABEL_5' ,XOFFSET=159 ,YOFFSET=88 ,SCR_XSIZE=48  $
      ,SCR_YSIZE=15 ,/ALIGN_LEFT ,VALUE='beta')


  WID_LABEL_6 = Widget_Label(WID_Image_simulation,  $
      UNAME='WID_LABEL_6' ,XOFFSET=160 ,YOFFSET=65 ,SCR_XSIZE=50  $
      ,SCR_YSIZE=15 ,/ALIGN_LEFT ,VALUE='alpha')


  WID_TEXT_3 = Widget_Text(WID_Image_simulation, UNAME='WID_TEXT_3'  $
      ,XOFFSET=209 ,YOFFSET=111 ,SCR_XSIZE=89 ,SCR_YSIZE=21  $
      ,/EDITABLE ,XSIZE=20 ,YSIZE=1)


  WID_TEXT_4 = Widget_Text(WID_Image_simulation, UNAME='WID_TEXT_4'  $
      ,XOFFSET=209 ,YOFFSET=87 ,SCR_XSIZE=89 ,SCR_YSIZE=21 ,/EDITABLE  $
      ,XSIZE=20 ,YSIZE=1)


  WID_TEXT_5 = Widget_Text(WID_Image_simulation, UNAME='WID_TEXT_5'  $
      ,XOFFSET=209 ,YOFFSET=62 ,SCR_XSIZE=89 ,SCR_YSIZE=21 ,/EDITABLE  $
      ,XSIZE=20 ,YSIZE=1)


  WID_LIST_0 = Widget_List(WID_Image_simulation, UNAME='WID_LIST_0'  $
      ,XOFFSET=357 ,YOFFSET=246 ,SCR_XSIZE=254 ,SCR_YSIZE=131  $
      ,XSIZE=11 ,YSIZE=2)


  WID_BASE_1 = Widget_Base(WID_Image_simulation, UNAME='WID_BASE_1'  $
      ,XOFFSET=26 ,YOFFSET=206 ,TITLE='IDL' ,COLUMN=1 ,/EXCLUSIVE)


  WID_BUTTON_0 = Widget_Button(WID_BASE_1, UNAME='WID_BUTTON_0'  $
      ,/ALIGN_LEFT ,VALUE='omega')


  WID_BUTTON_1 = Widget_Button(WID_BASE_1, UNAME='WID_BUTTON_1'  $
      ,YOFFSET=22 ,/ALIGN_LEFT ,VALUE='chi')


  WID_BUTTON_2 = Widget_Button(WID_BASE_1, UNAME='WID_BUTTON_2'  $
      ,YOFFSET=44 ,/ALIGN_LEFT ,VALUE='phi')


  WID_LABEL_7 = Widget_Label(WID_Image_simulation,  $
      UNAME='WID_LABEL_7' ,XOFFSET=22 ,YOFFSET=150 ,/ALIGN_LEFT  $
      ,VALUE='Rotation')


  WID_BUTTON_3 = Widget_Button(WID_Image_simulation,  $
      UNAME='WID_BUTTON_3' ,XOFFSET=97 ,YOFFSET=234 ,SCR_XSIZE=34  $
      ,SCR_YSIZE=38 ,/ALIGN_CENTER ,VALUE='<')


  WID_BUTTON_4 = Widget_Button(WID_Image_simulation,  $
      UNAME='WID_BUTTON_4' ,XOFFSET=136 ,YOFFSET=234 ,SCR_XSIZE=34  $
      ,SCR_YSIZE=38 ,/ALIGN_CENTER ,VALUE='>')


  WID_TEXT_6 = Widget_Text(WID_Image_simulation, UNAME='WID_TEXT_6'  $
      ,XOFFSET=97 ,YOFFSET=210 ,SCR_XSIZE=72 ,SCR_YSIZE=21 ,/EDITABLE  $
      ,XSIZE=20 ,YSIZE=1)


  WID_BUTTON_5 = Widget_Button(WID_Image_simulation,  $
      UNAME='WID_BUTTON_5' ,XOFFSET=176 ,YOFFSET=209 ,/ALIGN_CENTER  $
      ,VALUE='0')


  WID_BUTTON_6 = Widget_Button(WID_Image_simulation,  $
      UNAME='WID_BUTTON_6' ,XOFFSET=143 ,YOFFSET=14 ,SCR_XSIZE=156  $
      ,SCR_YSIZE=29 ,/ALIGN_CENTER ,VALUE='Generate B')


  WID_BUTTON_7 = Widget_Button(WID_Image_simulation,  $
      UNAME='WID_BUTTON_7' ,XOFFSET=356 ,YOFFSET=386 ,SCR_XSIZE=265  $
      ,SCR_YSIZE=47 ,/ALIGN_CENTER ,VALUE='Close', tooltip = 'Closes window')


  WID_BASE_2 = Widget_Base(WID_Image_simulation, UNAME='WID_BASE_2'  $
      ,XOFFSET=355 ,YOFFSET=47 ,TITLE='IDL' ,COLUMN=1 ,/EXCLUSIVE)


  WID_BUTTON_8 = Widget_Button(WID_BASE_2, UNAME='WID_BUTTON_8'  $
      ,/ALIGN_LEFT ,VALUE='Polychromatic')


  WID_BUTTON_9 = Widget_Button(WID_BASE_2, UNAME='WID_BUTTON_9'  $
      ,YOFFSET=22 ,/ALIGN_LEFT ,VALUE='Monochromatic')


  WID_LABEL_8 = Widget_Label(WID_Image_simulation,  $
      UNAME='WID_LABEL_8' ,XOFFSET=358 ,YOFFSET=120 ,/ALIGN_LEFT  $
      ,VALUE='Incident energy range [keV]')


  WID_TEXT_7 = Widget_Text(WID_Image_simulation, UNAME='WID_TEXT_7'  $
      ,XOFFSET=358 ,YOFFSET=140 ,SCR_XSIZE=98 ,SCR_YSIZE=21  $
      ,/EDITABLE ,XSIZE=20 ,YSIZE=1)


  WID_TEXT_8 = Widget_Text(WID_Image_simulation, UNAME='WID_TEXT_8'  $
      ,XOFFSET=461 ,YOFFSET=140 ,SCR_XSIZE=98 ,SCR_YSIZE=21  $
      ,/EDITABLE ,XSIZE=20 ,YSIZE=1)


  WID_LABEL_9 = Widget_Label(WID_Image_simulation,  $
      UNAME='WID_LABEL_9' ,XOFFSET=335 ,YOFFSET=14 ,/ALIGN_LEFT  $
      ,VALUE='Peak generation')


  WID_LABEL_10 = Widget_Label(WID_Image_simulation,  $
      UNAME='WID_LABEL_10' ,XOFFSET=357 ,YOFFSET=227 ,/ALIGN_LEFT  $
      ,VALUE='Orientation matrix')


  WID_BUTTON_10 = Widget_Button(WID_Image_simulation,  $
      UNAME='WID_BUTTON_10' ,XOFFSET=510 ,YOFFSET=217 ,/ALIGN_CENTER  $
      ,VALUE='Open')


  WID_BUTTON_11 = Widget_Button(WID_Image_simulation,  $
      UNAME='WID_BUTTON_11' ,XOFFSET=553 ,YOFFSET=217 ,SCR_XSIZE=41  $
      ,SCR_YSIZE=22 ,/ALIGN_CENTER ,VALUE='Save')


  WID_TEXT_9 = Widget_Text(WID_Image_simulation, UNAME='WID_TEXT_9'  $
      ,XOFFSET=238 ,YOFFSET=252 ,SCR_XSIZE=68 ,SCR_YSIZE=21 ,XSIZE=20  $
      ,YSIZE=1)


  WID_TEXT_10 = Widget_Text(WID_Image_simulation, UNAME='WID_TEXT_10'  $
      ,XOFFSET=238 ,YOFFSET=228 ,SCR_XSIZE=68 ,SCR_YSIZE=21 ,XSIZE=20  $
      ,YSIZE=1)


  WID_TEXT_11 = Widget_Text(WID_Image_simulation, UNAME='WID_TEXT_11'  $
      ,XOFFSET=238 ,YOFFSET=203 ,SCR_XSIZE=68 ,SCR_YSIZE=21 ,XSIZE=20  $
      ,YSIZE=1)


  WID_LABEL_11 = Widget_Label(WID_Image_simulation,  $
      UNAME='WID_LABEL_11' ,XOFFSET=211 ,YOFFSET=255 ,SCR_XSIZE=18  $
      ,SCR_YSIZE=15 ,/ALIGN_LEFT ,VALUE='ph')


  WID_LABEL_12 = Widget_Label(WID_Image_simulation,  $
      UNAME='WID_LABEL_12' ,XOFFSET=211 ,YOFFSET=232 ,SCR_XSIZE=18  $
      ,SCR_YSIZE=15 ,/ALIGN_LEFT ,VALUE='ch')


  WID_LABEL_13 = Widget_Label(WID_Image_simulation,  $
      UNAME='WID_LABEL_13' ,XOFFSET=212 ,YOFFSET=209 ,SCR_XSIZE=18  $
      ,SCR_YSIZE=15 ,/ALIGN_LEFT ,VALUE='om')


  WID_DROPLIST_0 = Widget_Droplist(WID_Image_simulation,  $
      UNAME='WID_DROPLIST_0' ,XOFFSET=357 ,YOFFSET=193 ,SCR_XSIZE=132  $
      ,SCR_YSIZE=22)


  WID_LABEL_14 = Widget_Label(WID_Image_simulation,  $
      UNAME='WID_LABEL_14' ,XOFFSET=357 ,YOFFSET=174 ,/ALIGN_LEFT  $
      ,VALUE='Bravais lattice type')


  WID_BASE_0 = Widget_Base(WID_Image_simulation, UNAME='WID_BASE_0'  $
      ,XOFFSET=239 ,YOFFSET=318 ,TITLE='IDL' ,COLUMN=1 ,/EXCLUSIVE)


  WID_BUTTON_12 = Widget_Button(WID_BASE_0, UNAME='WID_BUTTON_12'  $
      ,/ALIGN_LEFT ,VALUE='UB')


  WID_BUTTON_13 = Widget_Button(WID_BASE_0, UNAME='WID_BUTTON_13'  $
      ,YOFFSET=22 ,/ALIGN_LEFT ,VALUE='Peaks')


  WID_LABEL_15 = Widget_Label(WID_Image_simulation,  $
      UNAME='WID_LABEL_15' ,XOFFSET=28 ,YOFFSET=296 ,/ALIGN_LEFT  $
      ,VALUE='Scale')


  WID_TEXT_12 = Widget_Text(WID_Image_simulation, UNAME='WID_TEXT_12'  $
      ,XOFFSET=120 ,YOFFSET=320 ,SCR_XSIZE=71 ,SCR_YSIZE=21 ,XSIZE=20  $
      ,YSIZE=1)


  WID_DROPLIST_1 = Widget_Droplist(WID_Image_simulation,  $
      UNAME='WID_DROPLIST_1' ,XOFFSET=30 ,YOFFSET=320)


  WID_TEXT_13 = Widget_Text(WID_Image_simulation, UNAME='WID_TEXT_13'  $
      ,XOFFSET=62 ,YOFFSET=350 ,SCR_XSIZE=52 ,SCR_YSIZE=21 ,XSIZE=20  $
      ,YSIZE=1)


  WID_BUTTON_14 = Widget_Button(WID_Image_simulation,  $
      UNAME='WID_BUTTON_14' ,XOFFSET=115 ,YOFFSET=350 ,SCR_XSIZE=27  $
      ,SCR_YSIZE=22 ,/ALIGN_CENTER ,VALUE='+')


  WID_BUTTON_19 = Widget_Button(WID_Image_simulation,  $
      UNAME='WID_BUTTON_19' ,XOFFSET=29 ,YOFFSET=350 ,SCR_XSIZE=27  $
      ,SCR_YSIZE=22 ,/ALIGN_CENTER ,VALUE='-')


  WID_LABEL_16 = Widget_Label(WID_Image_simulation,  $
      UNAME='WID_LABEL_16' ,XOFFSET=475 ,YOFFSET=11 ,/ALIGN_LEFT  $
      ,VALUE='Downstr. DAC opening')


  WID_TEXT_14 = Widget_Text(WID_Image_simulation, UNAME='WID_TEXT_14'  $
      ,XOFFSET=475 ,YOFFSET=44 ,SCR_XSIZE=91 ,SCR_YSIZE=21 ,/EDITABLE  $
      ,XSIZE=20 ,YSIZE=1)


  WID_BUTTON_15 = Widget_Button(WID_Image_simulation,  $
      UNAME='WID_BUTTON_15' ,XOFFSET=28 ,YOFFSET=389 ,SCR_XSIZE=119  $
      ,SCR_YSIZE=39 ,/ALIGN_CENTER ,VALUE='Refine omega')


  WID_BASE_3 = Widget_Base(WID_Image_simulation, UNAME='WID_BASE_3'  $
      ,XOFFSET=510 ,YOFFSET=193 ,TITLE='IDL' ,COLUMN=1  $
      ,/NONEXCLUSIVE)


  WID_BUTTON_16 = Widget_Button(WID_BASE_3, UNAME='WID_BUTTON_16'  $
      ,/ALIGN_LEFT ,VALUE='Generate on load')


  WID_BUTTON_17 = Widget_Button(WID_Image_simulation,  $
      UNAME='WID_BUTTON_17' ,XOFFSET=156 ,YOFFSET=389 ,SCR_XSIZE=119  $
      ,SCR_YSIZE=39 ,/ALIGN_CENTER ,VALUE='Generate')


  WID_BUTTON_18 = Widget_Button(WID_Image_simulation,  $
      UNAME='WID_BUTTON_18' ,XOFFSET=141 ,YOFFSET=144 ,SCR_XSIZE=156  $
      ,SCR_YSIZE=29 ,/ALIGN_CENTER ,VALUE='Assign hkl from d-spc')


  WID_Image_simulation.elements={WID_Image_simulation_elements_str, $
   WID_TEXT_0:WID_TEXT_0,$
   WID_TEXT_1:WID_TEXT_1,$
   WID_TEXT_2:WID_TEXT_2,$
   WID_TEXT_3:WID_TEXT_3,$
   WID_TEXT_4:WID_TEXT_4,$
   WID_TEXT_5:WID_TEXT_5,$
   WID_TEXT_6:WID_TEXT_6,$
   WID_TEXT_7:WID_TEXT_7,$
   WID_TEXT_8:WID_TEXT_8,$
   WID_TEXT_9:WID_TEXT_9,$
   WID_TEXT_10:WID_TEXT_10,$
   WID_TEXT_11:WID_TEXT_11,$
   WID_TEXT_12:WID_TEXT_12,$
   WID_TEXT_13:WID_TEXT_13,$
   WID_TEXT_14:WID_TEXT_14,$
   WID_BUTTON_0:WID_BUTTON_0,$
   WID_BUTTON_1:WID_BUTTON_1,$
   WID_BUTTON_2:WID_BUTTON_2,$
   WID_BUTTON_3:WID_BUTTON_3,$
   WID_BUTTON_4:WID_BUTTON_4,$
   WID_BUTTON_5:WID_BUTTON_5,$
   WID_BUTTON_6:WID_BUTTON_6,$
   WID_BUTTON_7:WID_BUTTON_7,$
   WID_BUTTON_8:WID_BUTTON_8,$
   WID_BUTTON_9:WID_BUTTON_9,$
   WID_BUTTON_10:WID_BUTTON_10,$
   WID_BUTTON_11:WID_BUTTON_11,$
   WID_BUTTON_12:WID_BUTTON_12,$
   WID_BUTTON_13:WID_BUTTON_13,$
   WID_BUTTON_14:WID_BUTTON_14,$
   WID_BUTTON_15:WID_BUTTON_15,$
   WID_BUTTON_16:WID_BUTTON_16,$
   WID_BUTTON_17:WID_BUTTON_17,$
   WID_BUTTON_18:WID_BUTTON_18,$
   WID_BUTTON_19:WID_BUTTON_19,$
   WID_LIST_0:WID_LIST_0,$
   WID_DROPLIST_0:WID_DROPLIST_0,$
   WID_DROPLIST_1:WID_DROPLIST_1}

   widget_control, WID_Image_simulation, set_uvalue=WID_Image_simulation

  Widget_Control, /REALIZE, WID_Image_simulation

  WID_Image_simulation_aux

  XManager, 'WID_Image_simulation1_L', WID_Image_simulation, $
            Cleanup = 'WID_Image_simulation1_Cleanup', /NO_BLOCK

end

