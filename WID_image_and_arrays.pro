pro WID_Image_and_arrays_L, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_

COMMON   WID_Image_and_arrays_elements, $
WID_TEXT_0, $
WID_TEXT_1, $
WID_BUTTON_0, $
WID_BUTTON_1, $
WID_BUTTON_1aa, $
WID_BUTTON_1bb, $
WID_BUTTON_2, $
WID_BUTTON_3, $
WID_BUTTON_1cc

  WID_Image_and_arrays = Widget_Base( GROUP_LEADER=wGroup,  $
      UNAME='WID_Image_and_arrays' ,XOFFSET=5 ,YOFFSET=5  $
      ,SCR_XSIZE=401 ,SCR_YSIZE=241 ,TITLE='Image format and size' ,SPACE=3 ,XPAD=3  $
      ,YPAD=3)


  WID_BASE_1 = Widget_Base(WID_Image_and_arrays, UNAME='WID_BASE_1'  $
      ,XOFFSET=47 ,YOFFSET=23 ,TITLE='IDL' ,COLUMN=1 ,/EXCLUSIVE)


  WID_BUTTON_0 = Widget_Button(WID_BASE_1, UNAME='WID_BUTTON_0'  $
      ,/ALIGN_LEFT ,VALUE='MAR345')

  WID_BUTTON_2 = Widget_Button(WID_BASE_1, UNAME='WID_BUTTON_2'  $
      ,YOFFSET=22 ,/ALIGN_LEFT ,VALUE='MAR230')

  WID_BUTTON_1 = Widget_Button(WID_BASE_1, UNAME='WID_BUTTON_1'  $
      ,YOFFSET=44 ,/ALIGN_LEFT ,VALUE='Tiff')

  WID_BUTTON_1aa = Widget_Button(WID_BASE_1, UNAME='WID_BUTTON_1aa'  $
      ,YOFFSET=66 ,/ALIGN_LEFT ,VALUE='Pilatus 1M Tiff')

  WID_BUTTON_1bb = Widget_Button(WID_BASE_1, UNAME='WID_BUTTON_1aa'  $
      ,YOFFSET=66 ,/ALIGN_LEFT ,VALUE='Pilatus Tiff 90 deg')

  WID_BUTTON_1cc = Widget_Button(WID_BASE_1, UNAME='WID_BUTTON_1cc'  $
      ,YOFFSET=88 ,/ALIGN_LEFT ,VALUE='HDF 5 (.h5)')

;  WID_BUTTON_2 = Widget_Button(WID_BASE_1, UNAME='WID_BUTTON_2'  $
;      ,YOFFSET=44 ,/ALIGN_LEFT ,VALUE='Bruker CCD')



  WID_TEXT_0 = Widget_Text(WID_Image_and_arrays, UNAME='WID_TEXT_0'  $
      ,XOFFSET=174 ,YOFFSET=66 ,SCR_XSIZE=62 ,SCR_YSIZE=21 ,XSIZE=20  $
      ,YSIZE=1)


  WID_LABEL_0 = Widget_Label(WID_Image_and_arrays,  $
      UNAME='WID_LABEL_0' ,XOFFSET=175 ,YOFFSET=42 ,/ALIGN_LEFT  $
      ,VALUE='Image size')


  WID_TEXT_1 = Widget_Text(WID_Image_and_arrays, UNAME='WID_TEXT_1'  $
      ,XOFFSET=241 ,YOFFSET=66 ,SCR_XSIZE=62 ,SCR_YSIZE=21 ,XSIZE=20  $
      ,YSIZE=1)


  WID_BUTTON_3 = Widget_Button(WID_Image_and_arrays,  $
      UNAME='WID_BUTTON_3' ,XOFFSET=175 ,YOFFSET=126 ,SCR_XSIZE=106  $
      ,SCR_YSIZE=43 ,/ALIGN_CENTER ,VALUE='Start')

  Widget_Control, /REALIZE, WID_Image_and_arrays

  WID_Image_and_arrays_aux

  XManager, 'WID_Image_and_arrays_L', WID_Image_and_arrays

end



;-----------------------------------
function which_image_type
COMMON   WID_Image_and_arrays_elements
a1=widget_info(wid_button_0, /button_set)
a2=widget_info(wid_button_1, /button_set)
a3=widget_info(wid_button_2, /button_set)
a4=widget_info(wid_button_1aa, /button_set)
a5=widget_info(wid_button_1bb, /button_set)
a6=widget_info(wid_button_1cc, /button_set)
widget_control, wid_text_0, get_value=xpn
widget_control, wid_text_1, get_value=ypn
xpn=long(xpn)
xpn=xpn[0]
ypn=long(ypn)
ypn=ypn[0]
if a1 eq 1 then return, [5, xpn, ypn]
if a2 eq 1 then return, [4, xpn, ypn]
if a3 eq 1 then return, [5, xpn, ypn]
if a4 eq 1 then return, [4, xpn, ypn]
if a5 eq 1 then return, [4, xpn, ypn]
if a6 eq 1 then return, [6, xpn, ypn] ; hdf 5 type is '6'

end
;-----------------------------------
pro WID_Image_and_arrays_L_event, ev
COMMON   WID_Image_and_arrays_elements
COMMON image_type_and_arrays, imt, arr1, arr2,cenx, ceny, rad, rad1
WIDGET_CONTROL, ev.id, get_uvalue=uv
case uv of
'Start':$
 begin
   a=which_image_type()
   imt=a[0]
   arr1=a[1]
   arr2=a[2]
   WIDGET_CONTROL, ev.top, /destroy
 end
 'MAR345':$
 begin
  WIDGET_CONTROL, WID_TEXT_0, SET_VALUE='3450'
  WIDGET_CONTROL, WID_TEXT_1, SET_VALUE='3450'
 end
 'MAR230':$
 begin
  WIDGET_CONTROL, WID_TEXT_0, SET_VALUE='2300'
  WIDGET_CONTROL, WID_TEXT_1, SET_VALUE='2300'
 end
 'Tiff':$
 begin
  WIDGET_CONTROL, WID_TEXT_0, SET_VALUE='2048'
  WIDGET_CONTROL, WID_TEXT_1, SET_VALUE='2048'
end
 'Pilatus 1M Tiff':$
 begin
  WIDGET_CONTROL, WID_TEXT_0, SET_VALUE='981'
  WIDGET_CONTROL, WID_TEXT_1, SET_VALUE='1043'
end
 'Pilatus Tiff 90 deg':$
 begin
  WIDGET_CONTROL, WID_TEXT_0, SET_VALUE='195'
  WIDGET_CONTROL, WID_TEXT_1, SET_VALUE='487'
end
'HDF 5':$
 begin
  WIDGET_CONTROL, WID_TEXT_0, SET_VALUE='2048'
  WIDGET_CONTROL, WID_TEXT_1, SET_VALUE='2048'
end
else:
endcase
end


pro WID_Image_and_arrays_aux
COMMON   WID_Image_and_arrays_elements
WIDGET_CONTROL, WID_TEXT_0, SET_VALUE='2048'
WIDGET_CONTROL, WID_TEXT_1, SET_VALUE='2048'
WIDGET_CONTROL, WID_TEXT_0, EDITABLE=1
WIDGET_CONTROL, WID_TEXT_1, EDITABLE=1
WIDGET_CONTROL, WID_BUTTON_0, SET_UVALUE='MAR345'
WIDGET_CONTROL, WID_BUTTON_1, SET_BUTTON=1
WIDGET_CONTROL, WID_BUTTON_1, SET_UVALUE='Tiff'
WIDGET_CONTROL, WID_BUTTON_1aa, SET_UVALUE='Pilatus 1M Tiff'
WIDGET_CONTROL, WID_BUTTON_1bb, SET_UVALUE='Pilatus Tiff 90 deg'
WIDGET_CONTROL, WID_BUTTON_1cc, SET_UVALUE='HDF 5'
WIDGET_CONTROL, WID_BUTTON_2, SET_UVALUE='MAR230'
WIDGET_CONTROL, WID_BUTTON_3, SET_UVALUE='Start'

end

