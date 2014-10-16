pro WID_peakfit2d_commons

@COMMON_DATAS

COMMON image_type_and_arrays, imt, arr1, arr2,cenx, ceny, rad, rad1
COMMON WID_peakfit2d_elements, $
  WID_TEXT_0, $
  WID_TEXT_1, $
  WID_TEXT_2, $
  WID_TEXT_3, $
  WID_BUTTON_0, $
  WID_BUTTON_4, $
  WID_BUTTON_5, $
  WID_DRAW_0, $
  WID_DRAW_1, $
  WID_DRAW_2, $
  WID_LIST_0, $
  WID_LIST_1

end


pro WID_peakfit2d_L, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_

COMMON WID_peakfit2d_elements


  WID_peakfit2d = Widget_Base( GROUP_LEADER=wGroup,  $
      UNAME='WID_peakfit2d' ,XOFFSET=5 ,YOFFSET=5 ,SCR_XSIZE=771  $
      ,SCR_YSIZE=480 ,TITLE='IDL' ,SPACE=3 ,XPAD=3 ,YPAD=3)


  WID_DRAW_0 = Widget_Draw(WID_peakfit2d, UNAME='WID_DRAW_0'  $
      ,XOFFSET=543 ,YOFFSET=18 ,SCR_XSIZE=210 ,SCR_YSIZE=210)


  WID_LIST_0 = Widget_List(WID_peakfit2d, UNAME='WID_LIST_0'  $
      ,XOFFSET=12 ,YOFFSET=18 ,SCR_XSIZE=308 ,SCR_YSIZE=210 ,XSIZE=11  $
      ,YSIZE=2)


  WID_BUTTON_0 = Widget_Button(WID_peakfit2d, UNAME='WID_BUTTON_0'  $
      ,XOFFSET=147 ,YOFFSET=390 ,SCR_XSIZE=177 ,SCR_YSIZE=47  $
      ,/ALIGN_CENTER ,VALUE='Close')


  WID_LABEL_0 = Widget_Label(WID_peakfit2d, UNAME='WID_LABEL_0'  $
      ,XOFFSET=77 ,YOFFSET=255 ,/ALIGN_LEFT ,VALUE='Box')


  WID_DRAW_1 = Widget_Draw(WID_peakfit2d, UNAME='WID_DRAW_1'  $
      ,XOFFSET=329 ,YOFFSET=18 ,SCR_XSIZE=210 ,SCR_YSIZE=210)


  WID_TEXT_0 = Widget_Text(WID_peakfit2d, UNAME='WID_TEXT_0'  $
      ,XOFFSET=114 ,YOFFSET=249 ,SCR_XSIZE=85 ,SCR_YSIZE=21  $
      ,/EDITABLE ,XSIZE=20 ,YSIZE=1)


  WID_TEXT_1 = Widget_Text(WID_peakfit2d, UNAME='WID_TEXT_1'  $
      ,XOFFSET=203 ,YOFFSET=249 ,SCR_XSIZE=85 ,SCR_YSIZE=21  $
      ,/EDITABLE ,XSIZE=20 ,YSIZE=1)


  WID_DRAW_2 = Widget_Draw(WID_peakfit2d, UNAME='WID_DRAW_2'  $
      ,XOFFSET=543 ,YOFFSET=229 ,SCR_XSIZE=210 ,SCR_YSIZE=210)


  WID_LIST_1 = Widget_List(WID_peakfit2d, UNAME='WID_LIST_1'  $
      ,XOFFSET=330 ,YOFFSET=233 ,SCR_XSIZE=209 ,SCR_YSIZE=206  $
      ,XSIZE=11 ,YSIZE=2)


  WID_TEXT_2 = Widget_Text(WID_peakfit2d, UNAME='WID_TEXT_2'  $
      ,XOFFSET=110 ,YOFFSET=304 ,SCR_XSIZE=85 ,SCR_YSIZE=21  $
      ,/EDITABLE ,XSIZE=20 ,YSIZE=1)


  WID_LABEL_1 = Widget_Label(WID_peakfit2d, UNAME='WID_LABEL_1'  $
      ,XOFFSET=75 ,YOFFSET=285 ,/ALIGN_LEFT ,VALUE='Peak width'+ $
      ' threshold')


  WID_TEXT_3 = Widget_Text(WID_peakfit2d, UNAME='WID_TEXT_3'  $
      ,XOFFSET=199 ,YOFFSET=304 ,SCR_XSIZE=85 ,SCR_YSIZE=21  $
      ,/EDITABLE ,XSIZE=20 ,YSIZE=1)


  WID_BUTTON_4 = Widget_Button(WID_peakfit2d, UNAME='WID_BUTTON_4'  $
      ,XOFFSET=176 ,YOFFSET=349 ,SCR_XSIZE=130 ,SCR_YSIZE=26  $
      ,/ALIGN_CENTER ,VALUE='Delete peak')


  WID_BUTTON_5 = Widget_Button(WID_peakfit2d, UNAME='WID_BUTTON_5'  $
      ,XOFFSET=40 ,YOFFSET=349 ,SCR_XSIZE=130 ,SCR_YSIZE=26  $
      ,/ALIGN_CENTER ,VALUE='Process')




  Widget_Control, /REALIZE, WID_peakfit2d

  WID_peakfit2d_aux

  XManager, 'WID_peakfit2d_L', WID_peakfit2d, /NO_BLOCK

end


;---------------------------------
pro print_peak_list, opt, list
 COMMON WID_peakfit2d_elements
 pt=opt->get_object()
 if pt.peakno eq 0 then tx='' else $
 begin
  nu=get_nu_from_xyz(pt.peaks[0].DetXY)
  tth=get_tth_from_xyz(pt.peaks[0].xyz)
  tx=string(0, format='(I4)')+string(pt.peaks[0].hkl[0],format='(I4)')+string(pt.peaks[0].hkl[1],format='(I4)')+string(pt.peaks[0].hkl[2],format='(I4)')+ $
  string(1.0/vlength(pt.peaks[0].xyz), format='(F8.4)')+string(tth, format='(F10.3)')+string(pt.peaks[0].gonio[5], format='(F8.1)')+string(nu, format='(F8.1)')
  for i=1, pt.peakno-1 do $
  begin
    nu=get_nu_from_xyz(pt.peaks[i].DetXY)
    tth=get_tth_from_xyz(pt.peaks[i].xyz)
    tx=[tx,string(i, format='(I4)')+string(pt.peaks[i].hkl[0],format='(I4)')+string(pt.peaks[i].hkl[1],format='(I4)')+string(pt.peaks[i].hkl[2],format='(I4)')+$
    string(1.0/vlength(pt.peaks[i].xyz), format='(F8.4)')+string(tth, format='(F10.3)')+string(pt.peaks[i].gonio[5], format='(F8.1)')+string(nu, format='(F8.1)')]
  endfor
 endelse
 widget_control, list, set_value=tx
end
;---------------------------------
pro highlit_peak, pn
 COMMON WID_peakfit2d_elements
 widget_control, wid_list_0, set_list_select=pn
end

function read_peak_selected, list

 al=widget_info(list, /LIST_SELECT)
 return, al
end
;---------------------------------
pro set_peak_selected, list, pn
 widget_control, list, SET_LIST_SELECT=pn
end
;---------------------------------




;---------------------------------
pro print_peakfit_results, list, A, agv_diff, max_diff, min_diff
 tx=$
 ['mean background '+string(A[0], format='(F12.2)'), $
 'scale factor    '+string(A[1], format='(F12.2)'), $
 'width in X      '+string(A[2], format='(F12.2)'), $
 'width in Y      '+string(A[3], format='(F12.2)'), $
 'center X        '+string(A[4], format='(F12.2)'), $
 'center Y        '+string(A[5], format='(F12.2)'), $
 'rotation        '+string(A[6], format='(F12.2)'), $
 'Average diff    '+string(agv_diff, format='(F12.2)'), $
 'Max diff        '+string(max_diff, format='(F12.2)'), $
 'Min diff        '+string(min_diff, format='(F12.2)')]
 widget_control, list, set_value=tx
end
;---------------------------------




pro WID_peakfit2d_L_event, ev

common datas
COMMON image_type_and_arrays
COMMON WID_peakfit2d_elements

WIDGET_CONTROL, ev.id, get_uvalue=uv
case uv of
'Close':$
 begin
  WIDGET_CONTROL, ev.top, /destroy
 end
 'Peak list':$
 begin
   bs=read_box_size(wid_text_0,wid_text_1)
   pn=read_peak_selected(wid_list_0)
   pt=opt->get_object()
   XY=pt.peaks[pn].detxy
   pic=oimage->get_zoomin(XY, bs)
   pic1=congrid(pic, 210, 210)
   wset, wid_draw_1
   tvscl, pic1
   Gauss = GAUSS2DFIT( pic, A, /TILT)
   pic2=congrid(Gauss, 210, 210)
   wset, wid_draw_0
   tvscl, pic2
   pic3=pic1-pic2
   agv_diff=total(pic3)/n_elements(pic3)
   max_diff=max(pic3)
   min_diff=min(pic3)
   wset, wid_draw_2
   tvscl, pic3
   ;print_peakfit_results,wid_list_1 A, agv_diff, max_diff, min_diff
 end
 'Process':$
 begin
   bs=read_box_size(wid_text_0,wid_text_1)
   pt=opt->get_object()
   for pn=opt->peakno()-1, 0, -1 do $
   begin
    XY=pt.peaks[pn].detxy
    pic=oimage->get_zoomin(XY, bs)
    Gauss = GAUSS2DFIT( pic, A, /TILT)
    if finite(A[1]) eq 1 and A[2] gt 0. and A[3] gt 0 then $
    begin
     pt.peaks[pn].intAD[0]=A[1]*A[2]*A[3]
     pt.peaks[pn].intAD[1]=A[1]*A[2]*A[3]/100.
    endif else $
    begin
      opt->set_object, pt
      opt->delete_peak, pn
      pt=opt->get_object()
    end
   endfor
   opt->set_object, pt
 end
 'Delete peak':$
 begin
   pn=read_peak_selected(wid_list_0)
   opt->delete_peak, pn
   print_peak_list, opt, wid_list_0
   if pn lt opt->peakno()-1 then highlit_peak, pn
 end


else:
endcase

end

;-------------------------

pro WID_peakfit2d_aux, ev

COMMON WID_peakfit2d_elements

 widget_control, WID_TEXT_0, set_uvalue=''
 widget_control, WID_TEXT_1, set_uvalue=''

 widget_control, WID_TEXT_0, set_value='20'
 widget_control, WID_TEXT_1, set_value='20'

 widget_control, WID_BUTTON_0, set_uvalue='Close'
 widget_control, WID_BUTTON_5, set_uvalue='Process'
 widget_control, WID_BUTTON_4, set_uvalue='Delete peak'
 widget_control, WID_DRAW_0, set_uvalue=''
 widget_control, WID_DRAW_1, set_uvalue=''
 widget_control, WID_DRAW_2, set_uvalue=''

 widget_control, WID_DRAW_0, get_value=WID_DRAW_0
 widget_control, WID_DRAW_1, get_value=WID_DRAW_1
 widget_control, WID_DRAW_2, get_value=WID_DRAW_2


 widget_control, WID_LIST_0, set_uvalue='Peak list'
 widget_control, WID_LIST_1, set_uvalue=''

end
