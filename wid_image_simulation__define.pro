pro generate_mono, en0,en1,dac_open, brav, write=write, check_overwrite=ch, del_selected=del

COMMON draws,DRAWA,wid_list_3a
@COMMON_DATAS
COMMON image_type_and_arrays, imt, arr1, arr2,cenx, ceny, rad, rad1
if n_elements(res) gt 0 then $
begin
  opt->zero
  DAC_open=float(DAC_open)
  read_predict_settings, pred
  oadetector->generate_all_peaks, ub, opt, wv, pred, brav, DAC_open
  if exclude_corners() eq 1 then $
     opt->remove_peaks_outside_aa, oadetector
  bx=read_box_size()
  opt->set_zero_peak_box_size, bx
  gg=read_overlap_limites()
  opt->select_close_overlaps,gg[0]

  plot_image, oimage
  plot_peaks, drawA, opt, arr1, arr2
  print_peak_list, opt, wid_list_3a

  if del then opt->delete_selected

  plot_image, oimage
  plot_peaks, drawA, opt, arr1, arr2
  print_peak_list, opt, wid_list_3a

  if write eq 1 then $
  begin
   fn=out_dir+res.name0+'.pks'
   re=file_info(fn)
   if re.exists and ch eq 1 then $
   begin
    aa=dialog_message('pks file already exists - overwrite?',/question)
    if aa eq 'Yes' then $
    begin
      opt->write_object_to_file, fn
      peaktable_file=fn
    endif
   endif else $
   begin
    opt->write_object_to_file, fn
    peaktable_file=fn
   endelse
  endif
 endif else re=dialog_message('Open an image before simulating peaks')

end



pro WID_Image_simulation1_Cleanup, WID_Image_simulation
common status, PE_open, SIM_open
SIM_open = 0
end


;------------------------------------------------------------------

pro WID_Image_simulation_event, ev

 widget_control, ev.top, get_uvalue=wid
 wid->event, ev

end
;-----------------------


pro WID_Image_simulation::destroy
  widget_control, self.widgets.WID_Image_simulation, /destroy
end

;-------------------------------------
function WID_Image_simulation::wid_text_7
  return, self.widgets.wid_text_7
end
;-------------------------------------
function WID_Image_simulation::wid_text_8
  return, self.widgets.wid_text_8
end
;-------------------------------------
function WID_Image_simulation::wid_text_14
  return, self.widgets.wid_text_14
end

;-----------------------

pro WID_Image_simulation::show
  widget_control, self.widgets.WID_Image_simulation, map=1
end

;-----------------------
function WID_Image_simulation::realized
  return, widget_info(self.widgets.WID_Image_simulation, /realized)
end

;-----------------------
function WID_Image_simulation::realize
  widget_control, self.widgets.WID_Image_simulation, /realize
end

;-----------------------
pro WID_Image_simulation::hide
  widget_control, self.widgets.WID_Image_simulation, map=0
end

;-----------------------

pro WID_Image_simulation::generate_laue
COMMON draws,DRAWA,wid_list_3a
@COMMON_DATAS

COMMON image_type_and_arrays, imt, arr1, arr2,cenx, ceny, rad, rad1
  opt->zero
  widget_control, self.widgets.wid_text_7, get_value=en0
  widget_control, self.widgets.wid_text_8, get_value=en1
  widget_control, self.widgets.wid_text_14, get_value=DAC_open
  DAC_open=float(DAC_open)
  read_predict_settings, pred
  oadetector->generate_peaks_laue, ub, opt, pred, [float(en0),float(en1)], self->Bravais_type(), DAC_open

   bx=read_box_size()
   opt->set_zero_peak_box_size, bx

  plot_image, oimage
  plot_peaks, drawA, opt, arr1, arr2
  print_peak_list, opt, wid_list_3a
end

;-----------------------

pro WID_Image_simulation::generate_mono_mv
COMMON draws,DRAWA,wid_list_3a
@COMMON_DATAS

COMMON image_type_and_arrays, imt, arr1, arr2,cenx, ceny, rad, rad1
  opt->zero
  widget_control, self.widgets.wid_text_7, get_value=en0
  widget_control, self.widgets.wid_text_8, get_value=en1
  widget_control, self.widgets.wid_text_14, get_value=DAC_open
  DAC_open=float(DAC_open)
  read_predict_settings, pred
  oadetector->generate_all_peaks, ub, opt, wv, pred, self->Bravais_type(),DAC_open
  ;oadetector->generate_peaks_laue, ub, opt, pred, [float(en0),float(en1)]
  opt->remove_peaks_outside_aa, oadetector

   bx=read_box_size()
   opt->set_zero_peak_box_size, bx

  plot_image, oimage
  plot_peaks, drawA, opt, arr1, arr2
  print_peak_list, opt, wid_list_3a
end
;-----------------------

pro WID_Image_simulation::generate_mono
COMMON draws,DRAWA,wid_list_3a
@COMMON_DATAS
COMMON image_type_and_arrays, imt, arr1, arr2,cenx, ceny, rad, rad1


  widget_control, self.widgets.wid_text_7, get_value=en0
  widget_control, self.widgets.wid_text_8, get_value=en1
  widget_control, self.widgets.wid_text_14, get_value=DAC_open
  write_file=widget_info(self.widgets.WID_BUTTON_17b, /button_set)
  DAC_open=float(DAC_open)

  generate_mono, en0,en1,dac_open, self->Bravais_type(), write=write_file, check_overwrite=1, del_selected=0

  plot_image, oimage
  plot_peaks, drawA, opt, arr1, arr2
  print_peak_list, opt, wid_list_3a

end

;-----------------------
pro WID_Image_simulation::generate_mono_0
COMMON draws,DRAWA,wid_list_3a
@COMMON_DATAS

COMMON image_type_and_arrays, imt, arr1, arr2,cenx, ceny, rad, rad1
  opt->zero
  widget_control, self.widgets.wid_text_7, get_value=en0
  widget_control, self.widgets.wid_text_8, get_value=en1
  widget_control, self.widgets.wid_text_14, get_value=DAC_open
  DAC_open=float(DAC_open)
  read_predict_settings, pred
  oadetector->generate_all_peaks, ub, opt, wv, pred, self->Bravais_type(),DAC_open
  ;oadetector->generate_peaks_laue, ub, opt, pred, [float(en0),float(en1)]
  opt->remove_peaks_outside_aa, oadetector

   bx=read_box_size()
   opt->set_zero_peak_box_size, bx

  plot_image, oimage
  plot_peaks, drawA, opt, arr1, arr2
  print_peak_list, opt, wid_list_3a
end
;-----------------------

function WID_Image_simulation::read_rotation_step
   widget_control, self.widgets.WID_TEXT_6, GET_VALUE=a
   return, float(a)
end

;-----------------------

function symcodes, x
case x of

;- returns number of free paranmeters in constrained lp refinement
7: s= 0 ; - triclinic
4: s= 11; - monoclinic a
5: s= 12; - monoclinic b
6: s= 13; - monoclinic c
3: s= 2 ; - orthorhombic
2: s= 3 ; - tetragonal
1: s= 4 ; - hexagonal
0: s=5  ;- cubic
endcase
return, s

end

;-----------------------
function Brav_types, sym
case sym of
'P': res=0
'A': res=1
'B': res=2
'C': res=3
'I': res=4
'F': res=5
'R': res=6
else:
endcase
return, res
end


;-----------------------

function WID_Image_simulation::index
@COMMON_DATAS
@COMMON_DATAS2
COMMON draws,DRAWA,wid_list_3a

common uc_selection, sel, li


    if opt->peakno() gt 0 then $
    begin

   print, '---- Indexing'

 ;---------- determine UB matrix with

    ab=cell_now_solution_n(1)
    if ab eq 0 then $
    begin

    ;dirs='C:\Users\przemyslaw\Dropbox (UH Mineral Physics)\software\RSV_mSXD 2.5\'
	dirs=cell_now_dir
    a=opt->save_p4p(dirs+'xxx.p4p')
    text='MYARG="'+dirs+'run_cellnow.cmd"'
    SETENV, text
    spawn, '%MYARG%'  , /LOG_OUTPUT



    lps=fltarr(6)
    V=0.0
    L=''

    read_cells_from_cellnow, lps, v, l

    WID_cell_choices, lps, v, l

    if sel eq -1 then re=dialog_message('You have to select one of the solutions') else $
    begin
    ; set Bravais lattice type
    widget_control, self.widgets.wid_droplist_0, set_droplist_select=Brav_types(strcompress(l[sel],/remove_all))

    print, 'Unit cell selected:', sel
    ab=cell_now_solution_n(sel+1)
    spawn, '%MYARG%'  , /LOG_OUTPUT

    ;dirs='C:\Users\przemyslaw\Dropbox (UH Mineral Physics)\software\RSV_mSXD 2.5\'
	dirs = cell_now_dir
    ub=ReadUBfrom_p4p(dirs+'1.p4p')
    lp= lp_from_ub(UB)
    symm=symcodes(li)
    tol=0.1
    opt->select_indexable, ub, tol

    ;plot_peaks, draw0, opt, arr1, arr2
    ;opt->delete_selected
    lp=Refine_B_against_d(ub, opt, symm)
    ;opt->delete_selected
    lp=Refine_B_against_d(ub, opt, symm)
    ;opt->delete_selected

    self->print_UB, UB
    self->print_lp, lp

     plot_image, oimage
     plot_peaks, drawA, opt, arr1, arr2
     print_peak_list, opt, wid_list_3a
     update_peakno, opt->peakno()
     return, 1
     endelse
     endif else return, -1; no cell_now
     endif else $
     begin
       re=dialog_message('You need some peaks first, to attempt indexing')
       return, -1
     endelse

  end




pro WID_Image_simulation::update_rota
COMMON rotat, rot, om, ch, ph
widget_control, self.widgets.wid_text_11, set_value=string(om, format='(F6.1)')
widget_control, self.widgets.wid_text_10, set_value=string(ch, format='(F6.1)')
widget_control, self.widgets.wid_text_9, set_value=string(ph, format='(F6.1)')
end

;-----------------------

pro WID_Image_simulation::print_LP, lp
   widget_control, self.widgets.WID_TEXT_0, sET_VALUE=string(lp[0], format='(F8.4)')
   widget_control, self.widgets.WID_TEXT_1, sET_VALUE=string(lp[1], format='(F8.4)')
   widget_control, self.widgets.WID_TEXT_2, sET_VALUE=string(lp[2], format='(F8.4)')
   widget_control, self.widgets.WID_TEXT_3, sET_VALUE=string(lp[5], format='(F8.4)')
   widget_control, self.widgets.WID_TEXT_4, sET_VALUE=string(lp[4], format='(F8.4)')
   widget_control, self.widgets.WID_TEXT_5, sET_VALUE=string(lp[3], format='(F8.4)')
end

;-----------------------

pro WID_Image_simulation::print_UB, UB
text1=string(UB[0,0],format='(F10.5)')
text1=text1+string(UB[1,0],format='(F10.5)')
text1=text1+string(UB[2,0],format='(F10.5)')
text2=string(UB[0,1],format='(F10.5)')
text2=text2+string(UB[1,1],format='(F10.5)')
text2=text2+string(UB[2,1],format='(F10.5)')
text3=string(UB[0,2],format='(F10.5)')
text3=text3+string(UB[1,2],format='(F10.5)')
text3=text3+string(UB[2,2],format='(F10.5)')
text=[text1,text2,text3]
widget_control, self.widgets.wid_list_0, set_value=text

end

;-----------------------

function WID_Image_simulation::Bravais_type
 re=widget_info(self.widgets.wid_droplist_0, /droplist_select)
 text=['P','A','B','C','I','F','Ro','Rr']
 return, text[re]
end

;-----------------------
function WID_Image_simulation::read_LP
   widget_control, self.widgets.WID_TEXT_0, GET_VALUE=a
   widget_control, self.widgets.WID_TEXT_1, GET_VALUE=b
   widget_control, self.widgets.WID_TEXT_2, GET_VALUE=c
   widget_control, self.widgets.WID_TEXT_3, GET_VALUE=ga
   widget_control, self.widgets.WID_TEXT_4, GET_VALUE=be
   widget_control, self.widgets.WID_TEXT_5, GET_VALUE=al
   lp=[float(a),float(b),float(c),float(al),float(be),float(ga)]
   return, lp
end
;------------------------------------------------------------------

function WID_Image_simulation::which_axis
  re1=widget_info(self.widgets.WID_BUTTON_0, /BUTTON_SET)
  re2=widget_info(self.widgets.WID_BUTTON_1, /BUTTON_SET)
  re3=widget_info(self.widgets.WID_BUTTON_2, /BUTTON_SET)
  if re1 eq 1 then return, 0 else $
  if re2 eq 1 then return, 1 else $
  if re3 eq 1 then return, 2
end
;-----------------------

function WID_Image_simulation::change_what
re=widget_info(self.widgets.wid_button_12, /button_set)
return, re
end
;------------------------------------------------------------------

function WID_Image_simulation::simu_type
 re=widget_info(self.widgets.wid_button_8, /button_set)
 return, re
end

;------------------------------------------------------------------

pro WID_Image_simulation::update_rota
COMMON rotat, rot, om, ch, ph
widget_control, self.widgets.wid_text_11, set_value=string(om, format='(F6.1)')
widget_control, self.widgets.wid_text_10, set_value=string(ch, format='(F6.1)')
widget_control, self.widgets.wid_text_9, set_value=string(ph, format='(F6.1)')
end
;------------------------------------------------------------------


pro WID_Image_simulation::event, ev

widget_control, ev.top, get_uvalue=wid

@COMMON_DATAS

COMMON rotat, rot, om, ch, ph
COMMON draws,DRAWA,wid_list_3a
COMMON image_type_and_arrays, imt, arr1, arr2,cenx, ceny, rad, rad1
common Rota, Mtx
common status, PE_open, SIM_open


if (tag_names(ev, /structure_name) eq 'WIDGET_KILL_REQUEST') then $
begin
  print, 'kill call captured'
  widget_control, self.widgets.WID_Image_simulation, map=0
  SIM_open=0
  return
endif


case ev.id of

;----
   self.widgets.wid_button_17a:$;
   begin
    a=self->index()
   end

   self.widgets.wid_button_3:$;       '<'
   begin
     st=self->simu_type()
     wh=self->change_what()
     ax=self->which_axis()
     angle=-self->read_rotation_step()
     case self->which_axis() of
     0:om=om+angle
     1:ch=ch+angle
     2:ph=ph+angle
     endcase
     alpha=40.;40
     GenerateR, 2, alpha
     al=mtx
     ial=invert(al)
     GenerateR, 3, om
     Rom=mtx
     GenerateR, 1, ch ;
     Rch=mtx
     GenerateR, 3, ph
     Rph=mtx
     ;rot1=Rom ##( al ## Rch ## ial )## Rph
     rot1=Rom ##( Rch )## Rph
     if wh eq 1 then $
     begin ; generate new peaks
      UB=invert(rot) ## UB
      UB= rot1 ## UB
      self->print_UB, UB
      self->update_rota
      if st eq 1 then self->generate_laue else self->generate_mono
     endif else $
     begin ; apply rotation to peaks
       read_predict_settings, pred
       opt->apply_rotation_mtx, invert(rot), wv, oadetector ;nasa
       opt->apply_rotation_mtx, rot1, wv, oadetector ; nasa
       if  det_move() then opt->apply_dm, oadetector, get_md(), pred.om_start, pred.om_range ; nasa
       plot_image, oimage
       plot_peaks, drawA, opt, arr1, arr2
       print_peak_list, opt, wid_list_3a
       self->update_rota
    endelse
    rot=rot1
  end
;----
   self.widgets.wid_button_4:$;       '>'
   begin
     st=self->simu_type()
     wh=self->change_what()
     ax=self->which_axis()
     angle=self->read_rotation_step()
     case self->which_axis() of
     0:om=om+angle
     1:ch=ch+angle
     2:ph=ph+angle
     endcase
     alpha=40.
     GenerateR, 2, alpha
     al=mtx
     ial=invert(al)
     GenerateR, 3, om
     Rom=mtx
     GenerateR, 1, ch
     Rch=mtx
     GenerateR, 3, ph
     Rph=mtx
     ;rot1=Rom ##( al ## Rch ## ial )## Rph
     rot1=Rom ##( Rch)## Rph

  if wh eq 1 then $ ; change ub and generate new peaks
     begin
      UB=invert(rot) ## UB
      UB= rot1 ## UB
      self->print_UB, UB
      self->update_rota
      if st eq 1 then self->generate_laue else self->generate_mono
     endif else $
     begin
       read_predict_settings, pred
       opt->apply_rotation_mtx, invert(rot), wv, oadetector ;nasa
       opt->apply_rotation_mtx, rot1, wv, oadetector ; nasa
       if  det_move() then opt->apply_dm, oadetector, get_md(), pred.om_start, pred.om_range ; nasa
       plot_image, oimage
       plot_peaks, drawA, opt, arr1, arr2
       print_peak_list, opt, wid_list_3a
       self->update_rota
     endelse
     rot=rot1
 end

 ;----

   self.widgets.wid_button_5:$;       '0'
   begin
      wh=self->change_what()
      if wh eq 1 then $
      begin
        UB=invert(rot) ## UB
        self->print_UB, UB
        if self->simu_type() eq 1 then self->generate_laue else self->generate_mono
      endif else $
      begin
        opt->apply_rotation_mtx, invert(rot), wv, oadetector
        plot_image, oimage
        plot_peaks, drawA, opt, arr1, arr2
        print_peak_list, opt, wid_list_3a
      endelse
      rot=[[1.,0.,0.],[0.,1.,0.],[0.,0.,1.]]
      om=0.0
      ch=0.0
      ph=0.0
      self->update_rota
   end
   ;--------------------
   self.widgets.wid_button_6:$;       'Generate B'

   begin
    lp=self->Read_LP()
    UB=b_from_lp(lp)
    self->print_UB, UB
    self->generate_laue
   end
;--------------------
   self.widgets.wid_button_6:$;       'Change B only'

   begin
    lp=self->Read_LP()
    UB=b_from_lp(lp)
    self->print_UB, UB
    self->generate_laue
   end

   ;--------------------

   self.widgets.wid_button_10:$;       'Open UB'
   begin
     fname=dialog_pickfile(FILTER='*.ub', /READ, path=out_dir)
     if fname ne '' then $
     begin
        UB=open_UB(fname)
        lp=lp_from_ub(ub)
        self->print_UB, UB
        self->print_lp, lp
        ;re=widget_info(self.widgets.wid_button_16, /button_set)
        ;st=self->simu_type()
        ;if st eq 1 and re eq 1 then self->generate_laue else if re eq 1 then self->generate_mono
     end
   end

   ;----

      self.widgets.wid_button_11:$;       'Save UB'
   begin
     ; try to associate with image file
     tempName = res.base + '.ub'
     fname=dialog_pickfile(FILTER='*.ub', /write, FILE=tempName, default_extension='ub')
     ;fname=dialog_pickfile(FILTER='*.ub', /write, path=out_dir, default_extension='ub')
     if fname ne '' then $
     begin
        save_UB, ub, fname
     end
   end

   ;---------------

  self.widgets.wid_button_19:$;       'scale -'
  begin
    widget_control, self.widgets.WID_TEXT_13, GET_VALUE=scale
    lp=lp_from_ub(ub)
    B=b_from_lp(lp)
    U=UB # invert(B)
    lp1=lp
    lp1[0]=(1.0-scale)*lp[0]
    lp1[1]=(1.0-scale)*lp[1]
    lp1[2]=(1.0-scale)*lp[2]
    B1=b_from_lp(lp1)
    UB=U # B1
    lp=lp_from_ub(ub)
    self->print_UB, UB
    self->print_lp, lp
    if self->simu_type() eq 1 then self->generate_laue else self->generate_mono
    plot_image, oimage
    plot_peaks, drawA, opt, arr1, arr2
    print_peak_list, opt, wid_list_3a

   end

;--------------------

  self.widgets.wid_button_14:$;       'scale +'
  begin
    widget_control, self.widgets.WID_TEXT_13, GET_VALUE=scale
    scale=float(scale)
    lp=lp_from_ub(ub)
    B=b_from_lp(lp)
    U=UB # invert(B)
    lp1=lp
    lp1[0]=(1.0+scale)*lp[0]
    lp1[1]=(1.0+scale)*lp[1]
    lp1[2]=(1.0+scale)*lp[2]
    B1=b_from_lp(lp1)
    UB=U # B1
    lp=lp_from_ub(ub)
    self->print_UB, UB
    self->print_lp, lp
    if self->simu_type() eq 1 then self->generate_laue else self->generate_mono
    plot_image, oimage
    plot_peaks, drawA, opt, arr1, arr2
    print_peak_list, opt, wid_list_3a

   end

;------------------------

  self.widgets.wid_button_15:$;       'Refine omega'

  begin
  if min(UB) eq 0 and max(UB) eq 0 then re=dialog_message('Load UB matrix first') else $
  begin
   opt->refine_ind_omega, UB
   lp=lp_from_ub(ub)
   print_UB_and_lp, ub,lp,wid_list_0, opt
   print_peak_list, opt, wid_list_3a
  endelse
  end

;------------------------

   self.widgets.wid_button_18:$;       'Assign hkl'
   begin
    lp=self->Read_LP()
    pt=opt->get_object()
    ds=fltarr(pt.peakno)
    for i=0, pt.peakno-1 do $
    begin
     ds[i]=1./vlength(pt.peaks[i].xyz)
     hkls1=find_possible_hkls(ds[i],lp,0.02,[10,10,10])
     if hkls1[0,0] eq 0 then opt->select_peak, i
    endfor
    plot_image, oimage
    plot_peaks, drawA, opt, arr1, arr2
    print_peak_list, opt, wid_list_3a
    pt=opt->get_object()
    w=where(pt.peaks[0:pt.peakno-1].selected[0] eq 0)
    if w[0] ne -1 and n_elements(w) gt 1 then $
    begin
      s=reverse(sort(ds[w]))
      succ=0
      att0=0
      while succ eq 0 and att0 lt n_elements(w)-2 do $
      begin
       x1=pt.peaks[w[s[att0]]].xyz
       att1=att0+1
       while succ ne 1 and att1 lt n_elements(w)-1 do $
       begin
         x2=pt.peaks[w[s[att1]]].xyz
         a=recognize_two_vectors(x1,x2,lp,0.02, 2.0)
         if a[0] eq 1 then $
         begin
           succ=1
           pt.peaks[w[s[att0]]].hkl=a[1:3]
           pt.peaks[w[s[att1]]].hkl=a[4:6]
         endif else $
         begin
           att1=att1+1
           if att1 eq n_elements(w)-1 then att0=att0+1
         endelse
       endwhile
      endwhile
    endif
    if succ eq 1 then $
    begin
      ub=UB_from_two_vecs_and_lp(x1,x2,a[1:3],a[4:6],lp)
      ;ub[2,0:2]=-ub[2,0:2]
  ;    XYZs=pt.peaks[0:pt.peakno-1].xyz
  ;    HKLs=invert(UB) ## transpose(XYZs)
  ;    pt.peaks[0:pt.peakno-1].hkl=transpose(HKLs)
  ;    opt->set_object, pt
  ;    ub=opt->recomp_UB()
      self->print_UB, UB
      self->print_lp, lp
      plot_image, oimage
      plot_peaks, drawA, opt, arr1, arr2
      print_peak_list, opt, wid_list_3a
      re=dialog_message('Indexing successful')
    endif else re=dialog_message('Faild to index')
  end

;---------------------------


   self.widgets.wid_button_17:$;       'Generate button'
   begin
        if self->simu_type() eq 1 then self->generate_laue else self->generate_mono
        plot_image, oimage
        plot_peaks, drawA, opt, arr1, arr2
        print_peak_list, opt, wid_list_3a
   end

;---
;  self.widgets.wid_button_17:$;       'Generate button'
;  begin
;    ub1=ub
;    grid=fltarr(90,90)
;    for i=0, 89 do $
;    begin
;      ch=i*0.5
;      GenerateR, 1, ch
;      Rch=mtx
;      print, i
;     for j=0, 89 do $
;     begin
;      ph=j*0.5
 ;     GenerateR, 3, ph
 ;     Rph=mtx
 ;     rots=( Rch)## Rph
 ;     ub=rots ## ub1
 ;     self->generate_mono_0
 ;     grid[i,j]=oimage->sum_peak_intensities(opt, [3,3])
 ;    endfor ; j
 ;   endfor  ; i
 ;   tvscl, grid
 ; end

;---------------------------

  self.widgets.wid_button_7:$;       'Close'
 begin
   wid_sim->hide
   SIM_open=0
 end

 else:
 ENDCASE

end

;------------------------------------------------------------------


pro WID_Image_simulation::fillup

COMMON rotat, rot, om, ch, ph
om=0.0
ch=0.0
ph=0.0

   widget_control, self.widgets.WID_TEXT_0, SET_VALUE='3.00'
   widget_control, self.widgets.WID_TEXT_1, SET_VALUE='3.00'
   widget_control, self.widgets.WID_TEXT_2, SET_VALUE='3.00'
   widget_control, self.widgets.WID_TEXT_3, SET_VALUE='90.0'
   widget_control, self.widgets.WID_TEXT_4, SET_VALUE='90.0'
   widget_control, self.widgets.WID_TEXT_5, SET_VALUE='90.0'
   widget_control, self.widgets.WID_TEXT_14, SET_VALUE='18'
   widget_control, self.widgets.WID_TEXT_9, SET_VALUE='0.0'
   widget_control, self.widgets.WID_TEXT_10, SET_VALUE='0.0'
   widget_control, self.widgets.WID_TEXT_11, SET_VALUE='0.0'
   widget_control, self.widgets.WID_TEXT_13, SET_VALUE='0.002'
   widget_control, self.widgets.WID_TEXT_13, EDITABLE=1
   widget_control, self.widgets.WID_BUTTON_12, /SET_BUTTON
   text=['P','A','B','C','I','F','Ro','Rr']
   text1=['a','b','c','alpha','beta','gamma', 'V']
   widget_control, self.widgets.WID_DROPLIST_0, SET_VALUE=text
   widget_control, self.widgets.WID_DROPLIST_1, SET_VALUE=text1
   widget_control, self.widgets.WID_DROPLIST_1, SET_Droplist_select=6
   widget_control, self.widgets.WID_BUTTON_0, SET_BUTTON=1
   widget_control, self.widgets.WID_BUTTON_9, SET_BUTTON=1
   widget_control, self.widgets.WID_TEXT_7, SET_VALUE='5.0'
   widget_control, self.widgets.WID_TEXT_8, SET_VALUE='25.0'
   widget_control, self.widgets.WID_TEXT_6, SET_VALUE='1.0'

   rot=[[1.,0.,0.],[0.,1.,0.],[0.,0.,1.]]
end

;------------------------------------------------------------------
;------------------------------------------------------------------
;------------------------------------------------------------------

function WID_Image_simulation::init


  self.widgets.WID_Image_simulation = Widget_Base(UNAME='WID_Image_simulation' ,XOFFSET=5 ,YOFFSET=5  $
      ,SCR_XSIZE=640 ,SCR_YSIZE=487 ,TITLE='Diffraction imag'+ $
      ' simulation / manual indexing' ,SPACE=3 ,XPAD=3 ,YPAD=3, /tlb_kill_request_events)


  self.widgets.WID_LABEL_0 = Widget_Label(self.widgets.WID_Image_simulation,  $
      UNAME='WID_LABEL_0' ,XOFFSET=23 ,YOFFSET=23 ,/ALIGN_LEFT  $
      ,VALUE='Unit cell parameters')


  self.widgets.WID_TEXT_0 = Widget_Text(self.widgets.WID_Image_simulation, UNAME='WID_TEXT_0'  $
      ,XOFFSET=54 ,YOFFSET=61 ,SCR_XSIZE=89 ,SCR_YSIZE=21 ,/EDITABLE  $
      ,XSIZE=20 ,YSIZE=1)


  self.widgets.WID_TEXT_1 = Widget_Text(self.widgets.WID_Image_simulation, UNAME='WID_TEXT_1'  $
      ,XOFFSET=54 ,YOFFSET=86 ,SCR_XSIZE=89 ,SCR_YSIZE=21 ,/EDITABLE  $
      ,XSIZE=20 ,YSIZE=1)


  self.widgets.WID_TEXT_2 = Widget_Text(self.widgets.WID_Image_simulation, UNAME='WID_TEXT_2'  $
      ,XOFFSET=54 ,YOFFSET=110 ,SCR_XSIZE=89 ,SCR_YSIZE=21 ,/EDITABLE  $
      ,XSIZE=20 ,YSIZE=1)


  self.widgets.WID_LABEL_1 = Widget_Label(self.widgets.WID_Image_simulation,  $
      UNAME='WID_LABEL_1' ,XOFFSET=24 ,YOFFSET=66 ,SCR_XSIZE=18  $
      ,SCR_YSIZE=15 ,/ALIGN_LEFT ,VALUE='a')


  self.widgets.WID_LABEL_2 = Widget_Label(self.widgets.WID_Image_simulation,  $
      UNAME='WID_LABEL_2' ,XOFFSET=23 ,YOFFSET=89 ,SCR_XSIZE=18  $
      ,SCR_YSIZE=15 ,/ALIGN_LEFT ,VALUE='b')


  self.widgets.WID_LABEL_3 = Widget_Label(self.widgets.WID_Image_simulation,  $
      UNAME='WID_LABEL_3' ,XOFFSET=23 ,YOFFSET=112 ,SCR_XSIZE=18  $
      ,SCR_YSIZE=15 ,/ALIGN_LEFT ,VALUE='c')


  self.widgets.WID_LABEL_4 = Widget_Label(self.widgets.WID_Image_simulation,  $
      UNAME='WID_LABEL_4' ,XOFFSET=159 ,YOFFSET=111 ,SCR_XSIZE=44  $
      ,SCR_YSIZE=15 ,/ALIGN_LEFT ,VALUE='gamma')


  self.widgets.WID_LABEL_5 = Widget_Label(self.widgets.WID_Image_simulation,  $
      UNAME='WID_LABEL_5' ,XOFFSET=159 ,YOFFSET=88 ,SCR_XSIZE=48  $
      ,SCR_YSIZE=15 ,/ALIGN_LEFT ,VALUE='beta')


  self.widgets.WID_LABEL_6 = Widget_Label(self.widgets.WID_Image_simulation,  $
      UNAME='WID_LABEL_6' ,XOFFSET=160 ,YOFFSET=65 ,SCR_XSIZE=50  $
      ,SCR_YSIZE=15 ,/ALIGN_LEFT ,VALUE='alpha')


  self.widgets.WID_TEXT_3 = Widget_Text(self.widgets.WID_Image_simulation, UNAME='WID_TEXT_3'  $
      ,XOFFSET=209 ,YOFFSET=111 ,SCR_XSIZE=89 ,SCR_YSIZE=21  $
      ,/EDITABLE ,XSIZE=20 ,YSIZE=1)


  self.widgets.WID_TEXT_4 = Widget_Text(self.widgets.WID_Image_simulation, UNAME='WID_TEXT_4'  $
      ,XOFFSET=209 ,YOFFSET=87 ,SCR_XSIZE=89 ,SCR_YSIZE=21 ,/EDITABLE  $
      ,XSIZE=20 ,YSIZE=1)


  self.widgets.WID_TEXT_5 = Widget_Text(self.widgets.WID_Image_simulation, UNAME='WID_TEXT_5'  $
      ,XOFFSET=209 ,YOFFSET=62 ,SCR_XSIZE=89 ,SCR_YSIZE=21 ,/EDITABLE  $
      ,XSIZE=20 ,YSIZE=1)


  self.widgets.WID_LIST_0 = Widget_List(self.widgets.WID_Image_simulation, UNAME='WID_LIST_0'  $
      ,XOFFSET=357 ,YOFFSET=246 ,SCR_XSIZE=254 ,SCR_YSIZE=131  $
      ,XSIZE=11 ,YSIZE=2)


  self.widgets.WID_BASE_1 = Widget_Base(self.widgets.WID_Image_simulation, UNAME='WID_BASE_1'  $
      ,XOFFSET=26 ,YOFFSET=206 ,TITLE='IDL' ,COLUMN=1 ,/EXCLUSIVE)


  self.widgets.WID_BUTTON_0 = Widget_Button(self.widgets.WID_BASE_1, UNAME='WID_BUTTON_0'  $
      ,/ALIGN_LEFT ,VALUE='omega')


  self.widgets.WID_BUTTON_1 = Widget_Button(self.widgets.WID_BASE_1, UNAME='WID_BUTTON_1'  $
      ,YOFFSET=22 ,/ALIGN_LEFT ,VALUE='chi')


  self.widgets.WID_BUTTON_2 = Widget_Button(self.widgets.WID_BASE_1, UNAME='WID_BUTTON_2'  $
      ,YOFFSET=44 ,/ALIGN_LEFT ,VALUE='phi')


  self.widgets.WID_LABEL_7 = Widget_Label(self.widgets.WID_Image_simulation,  $
      UNAME='WID_LABEL_7' ,XOFFSET=22 ,YOFFSET=150 ,/ALIGN_LEFT  $
      ,VALUE='Rotation')


  self.widgets.WID_BUTTON_3 = Widget_Button(self.widgets.WID_Image_simulation,  $
      UNAME='WID_BUTTON_3' ,XOFFSET=97 ,YOFFSET=234 ,SCR_XSIZE=34  $
      ,SCR_YSIZE=38 ,/ALIGN_CENTER ,VALUE='<')


  self.widgets.WID_BUTTON_4 = Widget_Button(self.widgets.WID_Image_simulation,  $
      UNAME='WID_BUTTON_4' ,XOFFSET=136 ,YOFFSET=234 ,SCR_XSIZE=34  $
      ,SCR_YSIZE=38 ,/ALIGN_CENTER ,VALUE='>')


  self.widgets.WID_TEXT_6 = Widget_Text(self.widgets.WID_Image_simulation, UNAME='WID_TEXT_6'  $
      ,XOFFSET=97 ,YOFFSET=210 ,SCR_XSIZE=72 ,SCR_YSIZE=21 ,/EDITABLE  $
      ,XSIZE=20 ,YSIZE=1)


  self.widgets.WID_BUTTON_5 = Widget_Button(self.widgets.WID_Image_simulation,  $
      UNAME='WID_BUTTON_5' ,XOFFSET=176 ,YOFFSET=209 ,/ALIGN_CENTER  $
      ,VALUE='0')


  self.widgets.WID_BUTTON_6 = Widget_Button(self.widgets.WID_Image_simulation,  $
      UNAME='WID_BUTTON_6' ,XOFFSET=143 ,YOFFSET=5 ,SCR_XSIZE=156  $
      ,SCR_YSIZE=20 ,/ALIGN_CENTER ,VALUE='Generate B')

  self.widgets.WID_BUTTON_6a = Widget_Button(self.widgets.WID_Image_simulation,  $
      UNAME='WID_BUTTON_6a' ,XOFFSET=143 ,YOFFSET=27 ,SCR_XSIZE=156  $
      ,SCR_YSIZE=20 ,/ALIGN_CENTER ,VALUE='Change B only')

  self.widgets.WID_BUTTON_7 = Widget_Button(self.widgets.WID_Image_simulation,  $
      UNAME='WID_BUTTON_7' ,XOFFSET=356 ,YOFFSET=386 ,SCR_XSIZE=265  $
      ,SCR_YSIZE=47 ,/ALIGN_CENTER ,VALUE='Close', tooltip = 'Closes window')


  self.widgets.WID_BASE_2 = Widget_Base(self.widgets.WID_Image_simulation, UNAME='WID_BASE_2'  $
      ,XOFFSET=355 ,YOFFSET=47 ,TITLE='IDL' ,COLUMN=1 ,/EXCLUSIVE)


  self.widgets.WID_BUTTON_8 = Widget_Button(self.widgets.WID_BASE_2, UNAME='WID_BUTTON_8'  $
      ,/ALIGN_LEFT ,VALUE='Polychromatic')


  self.widgets.WID_BUTTON_9 = Widget_Button(self.widgets.WID_BASE_2, UNAME='WID_BUTTON_9'  $
      ,YOFFSET=22 ,/ALIGN_LEFT ,VALUE='Monochromatic')


  self.widgets.WID_LABEL_8 = Widget_Label(self.widgets.WID_Image_simulation,  $
      UNAME='WID_LABEL_8' ,XOFFSET=358 ,YOFFSET=120 ,/ALIGN_LEFT  $
      ,VALUE='Incident energy range [keV]')


  self.widgets.WID_TEXT_7 = Widget_Text(self.widgets.WID_Image_simulation, UNAME='WID_TEXT_7'  $
      ,XOFFSET=358 ,YOFFSET=140 ,SCR_XSIZE=98 ,SCR_YSIZE=21  $
      ,/EDITABLE ,XSIZE=20 ,YSIZE=1)


  self.widgets.WID_TEXT_8 = Widget_Text(self.widgets.WID_Image_simulation, UNAME='WID_TEXT_8'  $
      ,XOFFSET=461 ,YOFFSET=140 ,SCR_XSIZE=98 ,SCR_YSIZE=21  $
      ,/EDITABLE ,XSIZE=20 ,YSIZE=1)


  self.widgets.WID_LABEL_9 = Widget_Label(self.widgets.WID_Image_simulation,  $
      UNAME='WID_LABEL_9' ,XOFFSET=335 ,YOFFSET=14 ,/ALIGN_LEFT  $
      ,VALUE='Peak generation')


  self.widgets.WID_LABEL_10 = Widget_Label(self.widgets.WID_Image_simulation,  $
      UNAME='WID_LABEL_10' ,XOFFSET=357 ,YOFFSET=227 ,/ALIGN_LEFT  $
      ,VALUE='Orientation matrix')


  self.widgets.WID_BUTTON_10 = Widget_Button(self.widgets.WID_Image_simulation,  $
      UNAME='WID_BUTTON_10' ,XOFFSET=510 ,YOFFSET=217 ,/ALIGN_CENTER  $
      ,VALUE='Open')


  self.widgets.WID_BUTTON_11 = Widget_Button(self.widgets.WID_Image_simulation,  $
      UNAME='WID_BUTTON_11' ,XOFFSET=553 ,YOFFSET=217 ,SCR_XSIZE=41  $
      ,SCR_YSIZE=22 ,/ALIGN_CENTER ,VALUE='Save')


  self.widgets.WID_TEXT_9 = Widget_Text(self.widgets.WID_Image_simulation, UNAME='WID_TEXT_9'  $
      ,XOFFSET=238 ,YOFFSET=252 ,SCR_XSIZE=68 ,SCR_YSIZE=21 ,XSIZE=20  $
      ,YSIZE=1)


  self.widgets.WID_TEXT_10 = Widget_Text(self.widgets.WID_Image_simulation, UNAME='WID_TEXT_10'  $
      ,XOFFSET=238 ,YOFFSET=228 ,SCR_XSIZE=68 ,SCR_YSIZE=21 ,XSIZE=20  $
      ,YSIZE=1)


  self.widgets.WID_TEXT_11 = Widget_Text(self.widgets.WID_Image_simulation, UNAME='WID_TEXT_11'  $
      ,XOFFSET=238 ,YOFFSET=203 ,SCR_XSIZE=68 ,SCR_YSIZE=21 ,XSIZE=20  $
      ,YSIZE=1)


  self.widgets.WID_LABEL_11 = Widget_Label(self.widgets.WID_Image_simulation,  $
      UNAME='WID_LABEL_11' ,XOFFSET=211 ,YOFFSET=255 ,SCR_XSIZE=18  $
      ,SCR_YSIZE=15 ,/ALIGN_LEFT ,VALUE='ph')


  self.widgets.WID_LABEL_12 = Widget_Label(self.widgets.WID_Image_simulation,  $
      UNAME='WID_LABEL_12' ,XOFFSET=211 ,YOFFSET=232 ,SCR_XSIZE=18  $
      ,SCR_YSIZE=15 ,/ALIGN_LEFT ,VALUE='ch')


  self.widgets.WID_LABEL_13 = Widget_Label(self.widgets.WID_Image_simulation,  $
      UNAME='WID_LABEL_13' ,XOFFSET=212 ,YOFFSET=209 ,SCR_XSIZE=18  $
      ,SCR_YSIZE=15 ,/ALIGN_LEFT ,VALUE='om')


  self.widgets.WID_DROPLIST_0 = Widget_Droplist(self.widgets.WID_Image_simulation,  $
      UNAME='WID_DROPLIST_0' ,XOFFSET=357 ,YOFFSET=193 ,SCR_XSIZE=132  $
      ,SCR_YSIZE=22)


  self.widgets.WID_LABEL_14 = Widget_Label(self.widgets.WID_Image_simulation,  $
      UNAME='WID_LABEL_14' ,XOFFSET=357 ,YOFFSET=174 ,/ALIGN_LEFT  $
      ,VALUE='Bravais lattice type')









  self.widgets.WID_BASE_0 = Widget_Base(self.widgets.WID_Image_simulation, UNAME='WID_BASE_0'  $
      ,XOFFSET=239 ,YOFFSET=318 ,TITLE='IDL' ,COLUMN=1 ,/EXCLUSIVE)


  self.widgets.WID_BUTTON_12 = Widget_Button(self.widgets.WID_BASE_0, UNAME='WID_BUTTON_12'  $
      ,/ALIGN_LEFT ,VALUE='UB')


  self.widgets.WID_BUTTON_13 = Widget_Button(self.widgets.WID_BASE_0, UNAME='WID_BUTTON_13'  $
      ,YOFFSET=22 ,/ALIGN_LEFT ,VALUE='Peaks')


  self.widgets.WID_LABEL_15 = Widget_Label(self.widgets.WID_Image_simulation,  $
      UNAME='WID_LABEL_15' ,XOFFSET=28 ,YOFFSET=296 ,/ALIGN_LEFT  $
      ,VALUE='Scale')


  self.widgets.WID_TEXT_12 = Widget_Text(self.widgets.WID_Image_simulation, UNAME='WID_TEXT_12'  $
      ,XOFFSET=120 ,YOFFSET=320 ,SCR_XSIZE=71 ,SCR_YSIZE=21 ,XSIZE=20  $
      ,YSIZE=1)


  self.widgets.WID_DROPLIST_1 = Widget_Droplist(self.widgets.WID_Image_simulation,  $
      UNAME='WID_DROPLIST_1' ,XOFFSET=30 ,YOFFSET=320)


  self.widgets.WID_TEXT_13 = Widget_Text(self.widgets.WID_Image_simulation, UNAME='WID_TEXT_13'  $
      ,XOFFSET=62 ,YOFFSET=350 ,SCR_XSIZE=52 ,SCR_YSIZE=21 ,XSIZE=20  $
      ,YSIZE=1)


  self.widgets.WID_BUTTON_14 = Widget_Button(self.widgets.WID_Image_simulation,  $
      UNAME='WID_BUTTON_14' ,XOFFSET=115 ,YOFFSET=350 ,SCR_XSIZE=27  $
      ,SCR_YSIZE=22 ,/ALIGN_CENTER ,VALUE='+')


  self.widgets.WID_BUTTON_19 = Widget_Button(self.widgets.WID_Image_simulation,  $
      UNAME='WID_BUTTON_19' ,XOFFSET=29 ,YOFFSET=350 ,SCR_XSIZE=27  $
      ,SCR_YSIZE=22 ,/ALIGN_CENTER ,VALUE='-')


  self.widgets.WID_LABEL_16 = Widget_Label(self.widgets.WID_Image_simulation,  $
      UNAME='WID_LABEL_16' ,XOFFSET=475 ,YOFFSET=11 ,/ALIGN_LEFT  $
      ,VALUE='Downstr. DAC opening')


  self.widgets.WID_TEXT_14 = Widget_Text(self.widgets.WID_Image_simulation, UNAME='WID_TEXT_14'  $
      ,XOFFSET=475 ,YOFFSET=44 ,SCR_XSIZE=91 ,SCR_YSIZE=21 ,/EDITABLE  $
      ,XSIZE=20 ,YSIZE=1)


;  self.widgets.WID_BUTTON_15 = Widget_Button(self.widgets.WID_Image_simulation,  $
;      UNAME='WID_BUTTON_15' ,XOFFSET=28 ,YOFFSET=389 ,SCR_XSIZE=119  $
;      ,SCR_YSIZE=39 ,/ALIGN_CENTER ,VALUE='Refine omega')


  ;self.widgets.WID_BASE_3 = Widget_Base(self.widgets.WID_Image_simulation, UNAME='WID_BASE_3'  $
  ;    ,XOFFSET=510 ,YOFFSET=193 ,TITLE='IDL' ,COLUMN=1  $
  ;    ,/NONEXCLUSIVE)


  ;self.widgets.WID_BUTTON_16 = Widget_Button(self.widgets.WID_BASE_3, UNAME='WID_BUTTON_16'  $
  ;    ,/ALIGN_LEFT ,VALUE='Generate on load')


  self.widgets.WID_BUTTON_17 = Widget_Button(self.widgets.WID_Image_simulation,  $
      UNAME='WID_BUTTON_17' ,XOFFSET=150 ,YOFFSET=389 ,SCR_XSIZE=100  $
      ,SCR_YSIZE=30 ,/ALIGN_CENTER ,VALUE='Generate')


  self.widgets.WID_BASE_3a = Widget_Base(self.widgets.WID_Image_simulation, UNAME='WID_BASE_3a'  $
      ,XOFFSET=150 ,YOFFSET=420 ,TITLE='IDL' ,COLUMN=1  $
      ,/NONEXCLUSIVE)

 self.widgets.WID_BUTTON_17b = Widget_Button(self.widgets.WID_BASE_3a,  $
      UNAME='WID_BUTTON_17b' ,/ALIGN_CENTER ,VALUE='Update pks file')


  self.widgets.WID_BUTTON_17a = Widget_Button(self.widgets.WID_Image_simulation,  $
      UNAME='WID_BUTTON_17a' ,XOFFSET=50 ,YOFFSET=389 ,SCR_XSIZE=100  $
      ,SCR_YSIZE=30 ,/ALIGN_CENTER ,VALUE='Index')


  self.widgets.WID_BUTTON_18 = Widget_Button(self.widgets.WID_Image_simulation,  $
      UNAME='WID_BUTTON_18' ,XOFFSET=141 ,YOFFSET=144 ,SCR_XSIZE=156  $
      ,SCR_YSIZE=29 ,/ALIGN_CENTER ,VALUE='Assign hkl from d-spc')

  Widget_Control, self.widgets.WID_Image_simulation, set_uvalue=self

  Widget_Control, /REALIZE, self.widgets.WID_Image_simulation

  self->fillup

  XManager, 'WID_Image_simulation', self.widgets.WID_Image_simulation, $
            Cleanup = 'WID_Image_simulation1_Cleanup', /NO_BLOCK

  return, 1

end


;------------------------------------------------------------------
;------------------------------------------------------------------
;------------------------------------------------------------------

pro WID_Image_simulation__define

common closing, Wid_Image_simulation

  widgets={WID_Image_simulation_widgets, $
  WID_Image_simulation:0L, $
  WID_LABEL_0:0L, $
  WID_TEXT_0:0L, $
  WID_TEXT_1:0L, $
  WID_TEXT_2:0L, $
  WID_LABEL_1:0L, $
  WID_LABEL_2:0L, $
  WID_LABEL_3:0L, $
  WID_LABEL_4:0L, $
  WID_LABEL_5:0L, $
  WID_LABEL_6:0L, $
  WID_TEXT_3:0L, $
  WID_TEXT_4:0L, $
  WID_TEXT_5:0L, $
  WID_LIST_0:0L, $
  WID_BASE_1:0L, $
  WID_BASE_3a:0L, $
  WID_BUTTON_0:0L, $
  WID_BUTTON_1:0L, $
  WID_BUTTON_2:0L, $
  WID_LABEL_7:0L, $
  WID_BUTTON_3:0L, $
  WID_BUTTON_4:0L, $
  WID_TEXT_6:0L, $
  WID_BUTTON_5:0L, $
  WID_BUTTON_6:0L, $
  WID_BUTTON_6a:0L, $
  WID_BUTTON_7:0L, $
  WID_BASE_2:0L, $
  WID_BUTTON_8:0L, $
  WID_BUTTON_9:0L, $
  WID_LABEL_8:0L, $
  WID_TEXT_7:0L, $
  WID_TEXT_8:0L, $
  WID_LABEL_9:0L, $
  WID_LABEL_10:0L, $
  WID_BUTTON_10:0L, $
  WID_BUTTON_11:0L, $
  WID_TEXT_9:0L, $
  WID_TEXT_10:0L, $
  WID_TEXT_11:0L, $
  WID_LABEL_11:0L, $
  WID_LABEL_12:0L, $
  WID_LABEL_13:0L, $
  WID_DROPLIST_0:0L, $
  WID_LABEL_14:0L, $
  WID_BASE_0:0L, $
  WID_BUTTON_12:0L, $
  WID_BUTTON_13:0L, $
  WID_LABEL_15:0L, $
  WID_TEXT_12:0L, $
  WID_DROPLIST_1:0L, $
  WID_TEXT_13 :0L, $
  WID_BUTTON_14:0L, $
  WID_BUTTON_19:0L, $
  WID_LABEL_16:0L, $
  WID_TEXT_14 :0L, $
  WID_BUTTON_15:0L, $
  ;WID_BASE_3 :0L, $
  ;WID_BUTTON_16:0L, $
  WID_BUTTON_17:0L, $
  WID_BUTTON_17a:0L, $
  WID_BUTTON_17b:0L, $
  WID_BUTTON_18:0L}

  WID_Image_simulation={WID_Image_simulation, widgets:widgets}

end
