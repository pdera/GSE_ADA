;---- PD change 07/29/2010

pro WID_Peak_editor_cleanup, caller
common status, PE_open, SIM_open
   PE_open=0
end

;---- PD change end

; Modification history
;   -- 8/25/2008 PD
;       -- added intensity text boxes


pro WID_Peak_editor, GROUP_LEADER=wGroup, _EXTRA=_VWBExtra_
  common local_pt,pt, pn

; on rebuilding this file:
;    - remove text1


COMMON WID_Peak_editor_common, $
      WID_TEXT_0, $
      WID_TEXT_2, $
      WID_TEXT_3, $
      WID_TEXT_4, $
      WID_TEXT_5, $
      WID_TEXT_6, $
      WID_TEXT_7, $
      WID_TEXT_8, $
      WID_TEXT_9, $
      WID_TEXT_10, $
      WID_TEXT_11, $
      WID_TEXT_12, $
      WID_TEXT_13, $
      WID_TEXT_14, $
      WID_TEXT_15, $
      WID_TEXT_16, $
      WID_TEXT_17, $
      WID_TEXT_18, $
      WID_TEXT_19, $
      WID_TEXT_20, $
      WID_TEXT_21, $
      WID_TEXT_22, $
      WID_BUTTON_0, $
      WID_BUTTON_1, $
      WID_BUTTON_2, $
      WID_BUTTON_3, $
      WID_BUTTON_4, $
      WID_BUTTON_5, $
      WID_BUTTON_6, $
      WID_BUTTON_7, $
      WID_BUTTON_8, $
      WID_BUTTON_9, $
      WID_DRAW_0, $
      WID_DRAW_1, $
      WID_DRAW_2





  WID_BASE_0 = Widget_Base( GROUP_LEADER=wGroup, UNAME='WID_BASE_0'  $
      ,XOFFSET=5 ,YOFFSET=5 ,SCR_XSIZE=714 ,SCR_YSIZE=556  $
      ,TITLE='Peak editor' ,SPACE=3 ,XPAD=3 ,YPAD=3)


  WID_LABEL_0 = Widget_Label(WID_BASE_0, UNAME='WID_LABEL_0'  $
      ,XOFFSET=15 ,YOFFSET=16 ,/ALIGN_LEFT ,VALUE='Peak #')


  WID_TEXT_0 = Widget_Text(WID_BASE_0, UNAME='WID_TEXT_0' ,XOFFSET=60  $
      ,YOFFSET=10 ,SCR_XSIZE=54 ,SCR_YSIZE=21 ,XSIZE=20 ,YSIZE=1)


;  WID_TEXT_1 = Widget_Text(WID_BASE_0, UNAME='WID_TEXT_1'  $
;      ,SCR_XSIZE=54 ,SCR_YSIZE=21 ,XSIZE=20 ,YSIZE=1)


  WID_LABEL_1 = Widget_Label(WID_BASE_0, UNAME='WID_LABEL_1'  $
      ,XOFFSET=15 ,YOFFSET=52 ,/ALIGN_LEFT ,VALUE='hkl')


  WID_TEXT_2 = Widget_Text(WID_BASE_0, UNAME='WID_TEXT_2' ,XOFFSET=60  $
      ,YOFFSET=45 ,SCR_XSIZE=54 ,SCR_YSIZE=21 ,/EDITABLE ,XSIZE=20  $
      ,YSIZE=1)


  WID_TEXT_3 = Widget_Text(WID_BASE_0, UNAME='WID_TEXT_3'  $
      ,XOFFSET=119 ,YOFFSET=45 ,SCR_XSIZE=54 ,SCR_YSIZE=21 ,/EDITABLE  $
      ,XSIZE=20 ,YSIZE=1)


  WID_TEXT_4 = Widget_Text(WID_BASE_0, UNAME='WID_TEXT_4'  $
      ,XOFFSET=177 ,YOFFSET=45 ,SCR_XSIZE=54 ,SCR_YSIZE=21 ,/EDITABLE  $
      ,XSIZE=20 ,YSIZE=1)


  WID_TEXT_5 = Widget_Text(WID_BASE_0, UNAME='WID_TEXT_5'  $
      ,XOFFSET=119 ,YOFFSET=81 ,SCR_XSIZE=54 ,SCR_YSIZE=21 ,XSIZE=20  $
      ,YSIZE=1)


  WID_TEXT_6 = Widget_Text(WID_BASE_0, UNAME='WID_TEXT_6' ,XOFFSET=60  $
      ,YOFFSET=81 ,SCR_XSIZE=54 ,SCR_YSIZE=21 ,XSIZE=20 ,YSIZE=1)


  WID_LABEL_2 = Widget_Label(WID_BASE_0, UNAME='WID_LABEL_2'  $
      ,XOFFSET=15 ,YOFFSET=88 ,/ALIGN_LEFT ,VALUE='detXY')


  WID_TEXT_7 = Widget_Text(WID_BASE_0, UNAME='WID_TEXT_7'  $
      ,XOFFSET=177 ,YOFFSET=113 ,SCR_XSIZE=54 ,SCR_YSIZE=21 ,XSIZE=20  $
      ,YSIZE=1)


  WID_TEXT_8 = Widget_Text(WID_BASE_0, UNAME='WID_TEXT_8'  $
      ,XOFFSET=119 ,YOFFSET=113 ,SCR_XSIZE=54 ,SCR_YSIZE=21 ,XSIZE=20  $
      ,YSIZE=1)


  WID_TEXT_9 = Widget_Text(WID_BASE_0, UNAME='WID_TEXT_9' ,XOFFSET=60  $
      ,YOFFSET=113 ,SCR_XSIZE=54 ,SCR_YSIZE=21 ,XSIZE=20 ,YSIZE=1)


  WID_LABEL_3 = Widget_Label(WID_BASE_0, UNAME='WID_LABEL_3'  $
      ,XOFFSET=15 ,YOFFSET=120 ,/ALIGN_LEFT ,VALUE='xyz')


  WID_LABEL_4 = Widget_Label(WID_BASE_0, UNAME='WID_LABEL_4'  $
      ,XOFFSET=14 ,YOFFSET=151 ,/ALIGN_LEFT ,VALUE='d-spc')


  WID_TEXT_10 = Widget_Text(WID_BASE_0, UNAME='WID_TEXT_10'  $
      ,XOFFSET=59 ,YOFFSET=144 ,SCR_XSIZE=54 ,SCR_YSIZE=21 ,XSIZE=20  $
      ,YSIZE=1)


  WID_TEXT_11 = Widget_Text(WID_BASE_0, UNAME='WID_TEXT_11'  $
      ,XOFFSET=58 ,YOFFSET=171 ,SCR_XSIZE=54 ,SCR_YSIZE=21 ,/EDITABLE  $
      ,XSIZE=20 ,YSIZE=1)


  WID_LABEL_5 = Widget_Label(WID_BASE_0, UNAME='WID_LABEL_5'  $
      ,XOFFSET=13 ,YOFFSET=178 ,/ALIGN_LEFT ,VALUE='Energy')


  WID_TEXT_12 = Widget_Text(WID_BASE_0, UNAME='WID_TEXT_12'  $
      ,XOFFSET=175 ,YOFFSET=198 ,SCR_XSIZE=54 ,SCR_YSIZE=21  $
      ,/EDITABLE ,XSIZE=20 ,YSIZE=1)


  WID_TEXT_13 = Widget_Text(WID_BASE_0, UNAME='WID_TEXT_13'  $
      ,XOFFSET=117 ,YOFFSET=198 ,SCR_XSIZE=54 ,SCR_YSIZE=21  $
      ,/EDITABLE ,XSIZE=20 ,YSIZE=1)


  WID_TEXT_14 = Widget_Text(WID_BASE_0, UNAME='WID_TEXT_14'  $
      ,XOFFSET=58 ,YOFFSET=198 ,SCR_XSIZE=54 ,SCR_YSIZE=21 ,/EDITABLE  $
      ,XSIZE=20 ,YSIZE=1)


  WID_LABEL_6 = Widget_Label(WID_BASE_0, UNAME='WID_LABEL_6'  $
      ,XOFFSET=13 ,YOFFSET=205 ,/ALIGN_LEFT ,VALUE='Gonio')


  WID_TEXT_15 = Widget_Text(WID_BASE_0, UNAME='WID_TEXT_15'  $
      ,XOFFSET=58 ,YOFFSET=222 ,SCR_XSIZE=54 ,SCR_YSIZE=21 ,/EDITABLE  $
      ,XSIZE=20 ,YSIZE=1)


  WID_TEXT_16 = Widget_Text(WID_BASE_0, UNAME='WID_TEXT_16'  $
      ,XOFFSET=117 ,YOFFSET=222 ,SCR_XSIZE=54 ,SCR_YSIZE=21  $
      ,/EDITABLE ,XSIZE=20 ,YSIZE=1)


  WID_TEXT_17 = Widget_Text(WID_BASE_0, UNAME='WID_TEXT_17'  $
      ,XOFFSET=174 ,YOFFSET=222 ,SCR_XSIZE=54 ,SCR_YSIZE=21  $
      ,/EDITABLE ,XSIZE=20 ,YSIZE=1)


  WID_BUTTON_0 = Widget_Button(WID_BASE_0, UNAME='WID_BUTTON_0'  $
      ,XOFFSET=535 ,YOFFSET=208 ,SCR_XSIZE=75 ,SCR_YSIZE=43  $
      ,/ALIGN_CENTER ,VALUE='Update')


  WID_BUTTON_1 = Widget_Button(WID_BASE_0, UNAME='WID_BUTTON_1'  $
      ,XOFFSET=616 ,YOFFSET=208 ,SCR_XSIZE=75 ,SCR_YSIZE=43  $
      ,/ALIGN_CENTER ,VALUE='Close')


  WID_DRAW_0 = Widget_Draw(WID_BASE_0, UNAME='WID_DRAW_0' ,XOFFSET=9  $
      ,YOFFSET=271 ,SCR_XSIZE=688 ,SCR_YSIZE=245)


  WID_DRAW_1 = Widget_Draw(WID_BASE_0, UNAME='WID_DRAW_1'  $
      ,XOFFSET=511 ,YOFFSET=32 ,SCR_XSIZE=170 ,SCR_YSIZE=170)


  WID_BUTTON_2 = Widget_Button(WID_BASE_0, UNAME='WID_BUTTON_2'  $
      ,XOFFSET=237 ,YOFFSET=212 ,SCR_XSIZE=21 ,SCR_YSIZE=19  $
      ,/ALIGN_CENTER ,VALUE='-X')


  WID_BUTTON_3 = Widget_Button(WID_BASE_0, UNAME='WID_BUTTON_3'  $
      ,XOFFSET=272 ,YOFFSET=187 ,SCR_XSIZE=21 ,SCR_YSIZE=19  $
      ,/ALIGN_CENTER ,VALUE='+Y')


  WID_BUTTON_4 = Widget_Button(WID_BASE_0, UNAME='WID_BUTTON_4'  $
      ,XOFFSET=305 ,YOFFSET=210 ,SCR_XSIZE=21 ,SCR_YSIZE=20  $
      ,/ALIGN_CENTER ,VALUE='+X')


  WID_BUTTON_5 = Widget_Button(WID_BASE_0, UNAME='WID_BUTTON_5'  $
      ,XOFFSET=271 ,YOFFSET=236 ,SCR_XSIZE=21 ,SCR_YSIZE=18  $
      ,/ALIGN_CENTER ,VALUE='-Y')


  WID_DRAW_2 = Widget_Draw(WID_BASE_0, UNAME='WID_DRAW_2'  $
      ,XOFFSET=325 ,YOFFSET=33 ,SCR_XSIZE=170 ,SCR_YSIZE=170)


  WID_TEXT_18 = Widget_Text(WID_BASE_0, UNAME='WID_TEXT_18' ,FRAME=1  $
      ,XOFFSET=264 ,YOFFSET=211 ,SCR_XSIZE=36 ,SCR_YSIZE=21 ,XSIZE=20  $
      ,YSIZE=1)


  WID_BUTTON_6 = Widget_Button(WID_BASE_0, UNAME='WID_BUTTON_6'  $
      ,XOFFSET=340 ,YOFFSET=208 ,SCR_XSIZE=76 ,SCR_YSIZE=22  $
      ,/ALIGN_CENTER ,VALUE='Fit')


  WID_BUTTON_7 = Widget_Button(WID_BASE_0, UNAME='WID_BUTTON_7'  $
      ,XOFFSET=256 ,YOFFSET=10 ,SCR_XSIZE=21 ,SCR_YSIZE=19  $
      ,/ALIGN_CENTER ,VALUE='<')


  WID_BUTTON_8 = Widget_Button(WID_BASE_0, UNAME='WID_BUTTON_8'  $
      ,XOFFSET=284 ,YOFFSET=9 ,SCR_XSIZE=21 ,SCR_YSIZE=20  $
      ,/ALIGN_CENTER ,VALUE='>')


  WID_BUTTON_9 = Widget_Button(WID_BASE_0, UNAME='WID_BUTTON_9'  $
      ,XOFFSET=256 ,YOFFSET=34 ,SCR_XSIZE=48 ,SCR_YSIZE=24  $
      ,/ALIGN_CENTER ,VALUE='Prof.')


  WID_TEXT_19 = Widget_Text(WID_BASE_0, UNAME='WID_TEXT_19'  $
      ,XOFFSET=325 ,YOFFSET=7 ,SCR_XSIZE=272 ,SCR_YSIZE=21 ,XSIZE=20  $
      ,YSIZE=1)


  WID_TEXT_20 = Widget_Text(WID_BASE_0, UNAME='WID_TEXT_20'  $
      ,XOFFSET=606 ,YOFFSET=6 ,SCR_XSIZE=82 ,SCR_YSIZE=22 ,XSIZE=20  $
      ,YSIZE=1)


  WID_BUTTON_10 = Widget_Button(WID_BASE_0, UNAME='WID_BUTTON_10'  $
      ,XOFFSET=255 ,YOFFSET=63 ,SCR_XSIZE=49 ,SCR_YSIZE=24  $
      ,/ALIGN_CENTER ,VALUE='Print')


  WID_TEXT_21 = Widget_Text(WID_BASE_0, UNAME='WID_TEXT_21'  $
      ,XOFFSET=117 ,YOFFSET=246 ,SCR_XSIZE=54 ,SCR_YSIZE=21  $
      ,/EDITABLE ,XSIZE=20 ,YSIZE=1)


  WID_TEXT_22 = Widget_Text(WID_BASE_0, UNAME='WID_TEXT_22'  $
      ,XOFFSET=58 ,YOFFSET=246 ,SCR_XSIZE=54 ,SCR_YSIZE=21 ,/EDITABLE  $
      ,XSIZE=20 ,YSIZE=1)


  WID_LABEL_7 = Widget_Label(WID_BASE_0, UNAME='WID_LABEL_7'  $
      ,XOFFSET=13 ,YOFFSET=250 ,/ALIGN_LEFT ,VALUE='Intensity')

  Widget_Control, /REALIZE, WID_BASE_0

  WID_Peak_editor_aux

;---- PD change 07/29/2010

  XManager, 'WID_Peak_editor', WID_BASE_0, CLEANUP ='WID_Peak_editor_cleanup',  /NO_BLOCK

;---- PD change end
end

;--------------------------
pro plot_peak, pn, pt, oimage
common selections, selecting_status, select, excl, unselect, addpeak, mask, maskarr, zoom
  COMMON WID_Peak_editor_common
  COMMON image_type_and_arrays, imt, arr1, arr2,cenx, ceny, rad
   bs=read_box_size()
   XY=pt.peaks[pn].detxy
   if not(XY[0]-bs[0] le 0 or $
           arr1 - XY[0] le bs[0] or $
           XY[1]-bs[1] le 0 or $
           arr2 - XY[1] le bs[1]) then $
   begin
    pic=oimage->get_zoomin(XY, bs, maskarr)
    pic1=congrid(pic, 170, 170)
    iscl=read_color_scale()
    pic1=pic1<iscl[1]
    pic1=pic1>iscl[0]
    wset, wid_draw_2
    tvscl, pic1
   endif else re=dialog_message('Peak too close to the edge of the image')
  end

;--------------------------
function read_peakshift_step
  COMMON WID_Peak_editor_common
   widget_control, wid_text_18, get_value=pss
   return, float(pss)

end

;--------------------------

pro update_peak
  common local_pt
  COMMON WID_Peak_editor_common
  COMMON CLASS_peaktable_reference, ref_peaktable, ref_peak
  widget_control, wid_text_0, get_value=al
  pn=long(al)
  if pn ge 0 and pn le pt.peakno-1 then $
  begin
  ref_peak=pt.peaks[pn]
  al=''
  widget_control, wid_text_2, get_value=al
  ref_peak.hkl[0]=long(al)
  widget_control, wid_text_3, get_value=al
  ref_peak.hkl[1]=long(al)
  widget_control, wid_text_4, get_value=al
  ref_peak.hkl[2]=long(al)
  widget_control, wid_text_11, get_value=al ; energy
  ref_peak.energies[0]=float(al)
  widget_control, wid_text_12, get_value=al
  ref_peak.gonio[2]=float(al)
  widget_control, wid_text_13, get_value=al
  ref_peak.gonio[1]=float(al)
  widget_control, wid_text_14, get_value=al
  ref_peak.gonio[0]=float(al)
  widget_control, wid_text_15, get_value=al
  ref_peak.gonio[3]=float(al)
  widget_control, wid_text_16, get_value=al
  ref_peak.gonio[4]=float(al)
  widget_control, wid_text_17, get_value=al
  ref_peak.gonio[5]=float(al)
  pt.peaks[pn]=ref_peak
  endif
end
;--------------------------
pro pe_print_filename, fm
  COMMON WID_Peak_editor_common
  widget_control, wid_text_19, set_value=fm
end
;--------------------------
pro pe_print_omega, om
  COMMON WID_Peak_editor_common
  widget_control, wid_text_20, set_value=string(om, format='(F6.1)')
end
;--------------------------
pro display_peak, pn, pt
  COMMON WID_Peak_editor_common
  ;pt=opt->get_object()
  widget_control, wid_text_0, set_value=string(pn, format='(I4)')
  widget_control, wid_text_2, set_value=string(pt.peaks[pn].hkl[0], format='(I3)')
  widget_control, wid_text_3, set_value=string(pt.peaks[pn].hkl[1], format='(I3)')
  widget_control, wid_text_4, set_value=string(pt.peaks[pn].hkl[2], format='(I3)')
  widget_control, wid_text_5, set_value=string(pt.peaks[pn].detXY[1], format='(F7.2)')
  widget_control, wid_text_6, set_value=string(pt.peaks[pn].detXY[0], format='(F7.2)')
  widget_control, wid_text_7, set_value=string(pt.peaks[pn].xyz[2], format='(F7.4)')
  widget_control, wid_text_8, set_value=string(pt.peaks[pn].xyz[1], format='(F7.4)')
  widget_control, wid_text_9, set_value=string(pt.peaks[pn].xyz[0], format='(F7.4)')
  widget_control, wid_text_10, set_value=string(1./vlength(pt.peaks[pn].xyz), format='(F7.4)')
  widget_control, wid_text_11, set_value=string(pt.peaks[pn].energies[0], format='(F6.2)')
  widget_control, wid_text_12, set_value=string(pt.peaks[pn].gonio[2], format='(F6.2)')
  widget_control, wid_text_13, set_value=string(pt.peaks[pn].gonio[1], format='(F6.2)')
  widget_control, wid_text_14, set_value=string(pt.peaks[pn].gonio[0], format='(F6.2)')
  widget_control, wid_text_15, set_value=string(pt.peaks[pn].gonio[3], format='(F6.2)')
  widget_control, wid_text_16, set_value=string(pt.peaks[pn].gonio[4], format='(F6.2)')
  widget_control, wid_text_17, set_value=string(pt.peaks[pn].gonio[5], format='(F6.2)')
  widget_control, wid_text_22, set_value=string(pt.peaks[pn].intAD[0], format='(F10.2)')
  widget_control, wid_text_21, set_value=string(pt.peaks[pn].intAD[1], format='(F10.2)')
end
;--------------------------

pro WID_Peak_editor_event, ev
COMMON image_type_and_arrays, imt, arr1, arr2,cenx, ceny, rad
common selections, selecting_status, select, excl, unselect, addpeak, mask, maskarr, zoom
@COMMON_DATAS

@WID_profile_film_viewer_commons

common status, PE_open, SIM_open

  COMMON WID_Peak_editor_common
  common local_pt
  widget_control, ev.id, get_uvalue=uv
  if n_elements(uv) ne 0 then case uv of
  'Update':$
  begin
    update_peak
    opt->set_object, pt
  end
  '-X':$
  begin
   pt.peaks[pn].detxy[0]=pt.peaks[pn].detxy[0]-read_peakshift_step()
   plot_peak, pn, pt, oimage
   display_peak, pn, pt
  end
  '+Y':$
  begin
   pt.peaks[pn].detxy[1]=pt.peaks[pn].detxy[1]+read_peakshift_step()
   plot_peak, pn, pt, oimage
   display_peak, pn, pt
   end
  '+X':$
  begin
   pt.peaks[pn].detxy[0]=pt.peaks[pn].detxy[0]+read_peakshift_step()
   plot_peak, pn, pt, oimage
   display_peak, pn, pt
   end
  '-Y':$
  begin
   pt.peaks[pn].detxy[1]=pt.peaks[pn].detxy[1]-read_peakshift_step()
   plot_peak, pn, pt, oimage
   display_peak, pn, pt
   end
  'fit':$
  begin
   bs=read_box_size()
   pt.peaks[pn].detxy[0]=pt.peaks[pn].detxy[0]+read_peakshift_step()
   XY=pt.peaks[pn].detxy
   if not(XY[0]-bs[0] le 0 or $
           arr1 - XY[0] le bs[0] or $
           XY[1]-bs[1] le 0 or $
           arr2 - XY[1] le bs[1]) then $
   begin
    pic=oimage->get_zoomin(XY, bs, maskarr)
    pic1=congrid(pic, 170, 170)
    wset, wid_draw_2
    tvscl, pic1
    display_peak, pn, pt

    Gauss = GAUSS2DFIT( pic, A, /TILT)
    pic2=congrid(Gauss, 170, 170)
    wset, wid_draw_1
    tvscl, pic2

    pt.peaks[pn].DetXY[0]= (A[4]-bs[0])+XY[0]
    pt.peaks[pn].DetXY[1]= (A[5]-bs[1])+XY[1]



  endif else re=dialog_message('Peak too close to the edge of the image')
  end
  '<':$
  begin
       if res.name0 ne '' and res.seq-1 ge f0 then $
     begin
       res.seq=res.seq-1
       fn=generate_fname(res)
       res=analyse_fname(fn, dir, 3)
       pe_print_filename, res.name0
       pe_print_omega, omega_from_scan(res.seq)
       oimage->load_image, fn, oadetector


       bs=read_box_size()
       pt.peaks[pn].detxy[1]=pt.peaks[pn].detxy[1]-2
       XY=pt.peaks[pn].detxy
       if not(XY[0]-bs[0] le 0 or $
           arr1 - XY[0] le bs[0] or $
           XY[1]-bs[1] le 0 or $
           arr2 - XY[1] le bs[1]) then $
      begin
       pic=oimage->get_zoomin(XY, bs, maskarr)
       pic1=congrid(pic, 170, 170)
       iscl=read_color_scale()
       pic1=pic1<iscl[1]
       pic1=pic1>iscl[0]
       wset, wid_draw_2
       tvscl, pic1
       display_peak, pn, pt
      end
      end
  end
  '>':$
begin
     if res.name0 ne '' and res.seq+1 le f1 then $
     begin
       res.seq=res.seq+1
       fn=generate_fname(res)
       res=analyse_fname(fn, dir, 3)
       pe_print_filename, res.name0
       pe_print_omega, omega_from_scan(res.seq)
       oimage->load_image, fn, oadetector


       bs=read_box_size()
       pt.peaks[pn].detxy[1]=pt.peaks[pn].detxy[1]-2
       XY=pt.peaks[pn].detxy
       if not(XY[0]-bs[0] le 0 or $
           arr1 - XY[0] le bs[0] or $
           XY[1]-bs[1] le 0 or $
           arr2 - XY[1] le bs[1]) then $
      begin
       pic=oimage->get_zoomin(XY, bs, maskarr)
       pic1=congrid(pic, 170, 170)
       iscl=read_color_scale()
       pic1=pic1<iscl[1]
       pic1=pic1>iscl[0]
       wset, wid_draw_2
       tvscl, pic1
       display_peak, pn, pt
      end
      end
 end
 'prof':$
  begin
       prof=fltarr(im_seq_n())
       b=fltarr(170)
       if res.name0 ne '' then  $
       begin
       for i=0, im_seq_n()-1 do $
       begin
        res.seq=i+im_seq_0()
        print,res.seq
        fn=generate_fname(res)
        res=analyse_fname(fn, dir, 3)
        oimage->load_image, fn, oadetector
        bs=read_box_size()
        XY=pt.peaks[pn].detxy
        if not(XY[0]-bs[0] le 0 or $
            arr1 - XY[0] le bs[0] or $
            XY[1]-bs[1] le 0 or $
            arr2 - XY[1] le bs[1]) then $
        begin
         pic=oimage->get_zoomin(XY, bs, maskarr)
         pic1=congrid(pic, 170, 170)
         prof[i]=total(pic)
         if i eq 0 then film=pic1 else $
         begin
           film=[[film],[pic1]]
         end
        endif
        update_progress, float(i+1)/float(im_seq_n())
      endfor

      iscl=read_color_scale()
      film=film<iscl[1]
      film=film>iscl[0]

      for i=0, 169 do b[i]=max(film)
      for i=0, im_seq_n()-1 do $
      begin
        film[0:169,i*170]=b
      endfor
      wset, wid_draw_0
      plot, prof
      re=dialog_message('Omega profile computation complete')
      WID_profile_film_viewer_L, 26
      wset, film_draw
      tvscl, transpose(film)
      for i=0, f1-f0 do $
      begin
        om=omega_from_scan(i+im_seq_0())
        xyouts, i*170+5,5,string(om,format='(F6.1)'),/device, CHARSIZE=1.5, CHARTHICK=1.5, color='FFFFFF'XL
      endfor
      endif
  end

  'Close':$
  BEGIN
   widget_control, ev.top, /destroy
   PE_open=0
  END
  else:
  endcase

end
;--------------------------



pro WID_Peak_editor_aux
  COMMON WID_Peak_editor_common
  COMMON image_type_and_arrays, imt, arr1, arr2,cenx, ceny, rad
  common datas
  common local_pt

  widget_control, wid_text_0, set_uvalue=''
  widget_control, wid_text_2, set_uvalue=''
  widget_control, wid_text_3, set_uvalue=''
  widget_control, wid_text_4, set_uvalue=''
  widget_control, wid_text_5, set_uvalue=''
  widget_control, wid_text_6, set_uvalue=''
  widget_control, wid_text_7, set_uvalue=''
  widget_control, wid_text_8, set_uvalue=''
  widget_control, wid_text_9, set_uvalue=''
  widget_control, wid_text_10, set_uvalue=''
  widget_control, wid_text_11, set_uvalue=''
  widget_control, wid_text_12, set_uvalue=''
  widget_control, wid_text_13, set_uvalue=''
  widget_control, wid_text_14, set_uvalue=''
  widget_control, wid_text_15, set_uvalue=''
  widget_control, wid_text_16, set_uvalue=''
  widget_control, wid_text_17, set_uvalue=''
  widget_control, wid_text_18, set_uvalue=''
  widget_control, wid_text_18, editable=1
  widget_control, wid_text_18, set_value='2'
  widget_control, wid_text_19, set_uvalue=''
  widget_control, wid_text_20, set_uvalue=''
  widget_control, wid_text_21, set_uvalue=''
  widget_control, wid_text_22, set_uvalue=''
  widget_control, wid_button_0, set_uvalue='Update'
  widget_control, wid_button_1, set_uvalue='Close'
  widget_control, wid_button_2, set_uvalue='-X'
  widget_control, wid_button_3, set_uvalue='+Y'
  widget_control, wid_button_4, set_uvalue='+X'
  widget_control, wid_button_5, set_uvalue='-Y'
  widget_control, wid_button_6, set_uvalue='fit'
  widget_control, wid_button_7, set_uvalue='<'
  widget_control, wid_button_8, set_uvalue='>'
  widget_control, wid_button_9, set_uvalue='prof'

  widget_control, wid_draw_0, get_value=wid_draw_0
  widget_control, wid_draw_1, get_value=wid_draw_1
  widget_control, wid_draw_2, get_value=wid_draw_2

  display_peak, pn, pt
  plot_peak, pn, pt, oimage

    pe_print_filename, res.name0
    pe_print_omega, omega_from_scan(res.seq)

;  endif else re=dialog_message('Peak too close to the edge of the image')

end
;--------------------------

pro Peak_editor, pl, opti
common datas
common local_pt
pn=pl
pt=opt->get_object()
  if pn ge 0 and pn le opt->peakno()-1 then $
  begin
   WID_Peak_editor



  end
end

;--------------------------

pro ed
end

