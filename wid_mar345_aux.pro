;
;
;+
;NAME:
;	WID_MAR345_COMMONS
;
;PURPOSE :
; 	Reads the common blocks for the GSE_ADA package. This allows for the sharing and passing
; 	of variables and controls from one routine or procedure to another.
;
;AUTHOR :
; 	Przemyslaw Dera
;
;
;Categories:
; 	Event callback routine handler from the WID_MAR345 Main Window widget and
;	associated buttons.
;
;Example :
; 	This procedure takes no arguments. It is simply inserted in a line at the near top of the procedure
; 	requiring access to the common variables and controls.
; 	wid_mar345_commons
;-


function how_many_digits, fn
 len=strlen(fn)
 dot=strpos(fn,'.',/REVERSE_SEARCH)
 und=strpos(fn,'_',/REVERSE_SEARCH)
 if dot-und-1 le 5 and und ne -1 then return, dot-und-1 else return, 0
end

;

pro WID_MAR345_commons

@COMMON_DATAS

COMMON image_type_and_arrays, imt, arr1, arr2,cenx, ceny, rad, rad1
COMMON cont, contextBase, contextBase3
common selections, selecting_status, select, excl, unselect, addpeak, mask, maskarr, zoom, unmask
common mcoordinates, x, y, x1, y1, ox, oy
COMMON EX, EXCLUSIONS
COMMON prof, profiles
COMMON CLASS_peaktable_reference, ref_peaktable, ref_peak

;--- PD change 07/29/2010

 @WID_GSE_ADA_COMMON

;--- PD change end

;******************************* NEW CODE **********************
;Error handling
Catch, GSE_Error
IF GSE_Error NE 0 THEN $
BEGIN
Catch, /Cancel
;Message, 'ERROR:'
ok = Dialog_Message (!Error_State.Msg + ' Returning...', $
                    /Error)
RETURN
ENDIF
;******************************* NEW CODE **********************


end


;/// Routines for interaction with the main GUI
;+
;NAME:
; 	Check_mask_file
;PURPOSE :
; 	Checks for the presence of a mask file, that given by resname.base+.msk
;	If the file exists, it is loaded into memory and available for use.
;
;-


;-----------------------------------
pro check_mask_file
common selections, selecting_status, select, excl, unselect, addpeak, mask, maskarr, zoom, unmask
@COMMON_DATAS


       fn=generate_fname(res)
       res=analyse_fname(fn, dir, 3)
       name=out_dir+res.name0+'.msk'
       re=file_info(name)
       if re.exists eq 1 then maskarr=read_tiff(name)*1L else maskarr[*,*]=1

end

;-----------------------------------
;+
;NAME:
;	moving_detector_trajectory
;PURPOSE:
;	Calculate trajectory based upon peak and distance.
;
;CATEGORY:
;	XRD Collection Configuration
;
;CALLING SEQUENCE:
; 	dxy = moving_detector_trajectory(pp, dist)
;INPUTS:
; 	pp: Peak
;	dist: Distance
;-

function moving_detector_trajectory, pp, dist
;pp - peak number
common datas
     ktth=read_kappa_and_ttheta()
     capture_calibration, oadetector, wv
     pt=opt->get_object()
     pt.peaks[pp].gonio[1]=ktth[1]
     pt.peaks[pp].gonio[4]=ktth[0]
     DXY=fltarr(2,1000)
     DXY[0:1,0]=oadetector->calculate_pixels_from_xyz(pt.peaks[pp].xyz, pt.peaks[pp].gonio)
     od=oadetector->get_object()
     dist0=od.dist
     dd=dist/1000.0
     j=1
     for i=1, 1000-1 do $
     begin
      od.dist=dist0+float(i)*dd
      oadetector->set_object, od
      xy=oadetector->calculate_pixels_from_xyz(pt.peaks[pp].xyz, pt.peaks[pp].gonio)
      DXY[0:1,i]=[round(xy[0]),round(xy[1])]
     ; if (abs(round(xy[0])-round(DXY[0,j-1]))) gt 0 or  (abs(round(xy[1])-round(DXY[1,j-1]))) gt 0 then $
     ; begin
     ;   DXY[0:1,j]=[round(xy[0]),round(xy[1])]
     ;   j=j+1
     ; endif
     endfor
     od.dist=dist0
     oadetector->set_object, od
     return, dxy
end
;-----------------------------------
pro calc_omega_from_md_traj, mov, rot0, rot
common datas
COMMON image_type_and_arrays
@WID_GSE_ADA_COMMON

  pt=opt->get_object()
  for pn=0, pt.peakno-1 do $
  begin
   ;---------- detector trajectory analysis ------------
   xy=moving_detector_trajectory(pn, mov)
   x0=(xy[0,0]/float(arr1))
   y0=(xy[1,0]/float(arr2))
   x1=(xy[0,999]/float(arr1))
   y1=(xy[1,999]/float(arr2))
   wset, draw0
   plots, x0,y0, /normal
   plots, x1,y1, /continue, /normal
  ;-- locate new position
   im=oimage->get_object()
   profile=fltarr(1000)
   xx=fltarr(1000)
   for i=0, 999 do $
   begin
    xx[i]=rot0+i*rot/1000.0
    if xy[0,i] gt 0 and xy[0,i] lt arr1 and $
       xy[1,i] gt 0 and xy[1,i] lt arr2 then profile[i] = im.img[xy[0,i],xy[1,i]] else profile[i]=0
   end
   ;window
   ;plot, xx,profile
   yy=gaussfit(xx,profile,A, nterms=3)
   pt.peaks[pn].gonio[3]=A[1]
   ;print, A[1],'       ',pt.peaks[pn].gonio[3]
  endfor
   opt->set_object, pt
 end
;-----------------------------------

pro plot_ds_ring, tth, scale1, scale2, erasea
common datas
COMMON WID_MAR345_elements

     wset, draw0
     device, decomposed=1
     if erasea eq 1 then $
     plot_image, oimage
     path=oadetector->generate_ds_ring(tth)
     plots, path[0,0]/scale1, path[0,1]/scale2, /device, color='FF00FB'XL
     for i=1,359 do  plots, path[i,0]/scale1, path[i,1]/scale2, color='FF00FB'XL, /continue, /device
     plots, path[0,0]/scale1, path[0,1]/scale2, /device, /continue, color='FF00FB'XL
     device, decomposed=0

end

;---------------------------------------

function load_exclusions, fn
 re=file_info(fn)
 if re.exists eq 1 then $
 begin
   excl=[0.,0.]
   a1=0.0
   a2=0.0
   free_lun, 6
   openr, 6, fn
   readf, 6, a1, a2
   excl[0,0]=a1
   excl[1,0]=a2
   while not eof(6) do $
   begin
     readf, 6, a1, a2
     excl=[[excl],[a1,a2]]
   endwhile
 end
 return, excl
end
;-------------------------------
pro save_exclusions, fn, excl
   sz=n_elements(excl)/2
   free_lun, 6
   openw, 6, fn
   for i=0, sz-1 do printf, 6, excl[0,i],excl[1,i], format='(F10.3,F10.3)'
   close, 6
   free_lun, 6
end

;--------------------------------------

pro Print_exclusions, excl
COMMON WID_MAR345_elements
sz=n_elements(excl)/2
if not (sz eq 1 and excl[0,0] eq 0. and excl[1,0] eq 0.) then $
begin
 if sz ne 0 then tex=[[string(excl[0,0], format='(F10.3)')+string(excl[1,0], format='(F10.3)')]]
 if sz ge 2 then for i=1, sz-1 do tex=[tex,[string(excl[0,i], format='(F10.3)')+string(excl[1,i], format='(F10.3)')]]
 widget_control, wid_list_1, set_value=tex
end else widget_control, wid_list_1, set_value=''
end
;--------------------------------

pro read_last_directories
common datas
 re=file_info('last_directory.txt')
 if re.exists eq 1 then $
 begin
  dir=''
  out_dir=''
  cell_now_dir=''
  ldirfile = 'last_directory.txt'
  nlines = file_lines (ldirfile)

  openr, 6, ldirfile
  readf, 6, dir
  if nlines gt 1 then $
  	readf, 6, out_dir
  if nlines gt 2 then $
  	readf, 6, cell_now_dir

  ;print, cell_now_dir
  close, 6
  free_lun, 6
 end
end
;--------------------------------

pro save_last_directories
common datas
 free_lun, 6
 openw, 6, 'last_directory.txt'
 printf, 6, dir
 printf, 6, out_dir
 printf, 6, cell_now_dir
 close, 6
 free_lun, 6
end

;--------------------------------
function read_settings_file, fname
;goto, skip
  res=fltarr(2)
  al=''
  om1=-100.0
  om2=-100.0
  ch1=-1000.
  ch2=-1000.
  tth= -1000.
  time=-1000

  re=file_info(fname)
  if re.exists eq 1 then $
  begin
    free_lun, 6
    openr, 6, fname
    if re.size eq 136 then $ ;ccd
    begin
      readf, 6,al,om1, format='(A11,F13.4)'
      readf, 6,al,om2, format='(A11,F13.4)'
      readf, 6,al,ch1, format='(A11,F16.10)'
      readf, 6,al,tth, format='(A11,F16.10)'
      readf, 6,al,time, format='(A11,F13.4)'
    end

    if re.size eq 130 then $ ;self generate
    begin
      readf, 6,al,om1, format='(A11,F13.4)'
      readf, 6,al,om2, format='(A11,F13.4)'
      readf, 6,al,ch1, format='(A11,F16.10)'
      readf, 6,al,tth, format='(A11,F16.10)'
      readf, 6,al,time, format='(A11,F13.4)'
    end

    if re.size eq 314 then $ ; mar345 HPCAT
    begin
     readf, 6,al,om1, format='(A20,F13.4)'
     readf, 6,al,ome, format='(A20,F10.5)'
     om2=ome-om1
    end
    close, 6
    free_lun, 6
  endif
  return, [om1, om2, ch1, tth, time]
  skip:
end

;--------------------------------

pro print_UB_and_lp, ub,lp,wid, optable1
if total(ub) ne 0 then $
  fom=optable1->indexing_FOM(UB, 0)
;  omdif=optable1->aver_ang_error(UB)
  list=['UB matrix:']
  list=[list,string(ub[0,0])+'  '+string(ub[1,0])+'  '+string(ub[2,0])]
  list=[list,string(ub[0,1])+'  '+string(ub[1,1])+'  '+string(ub[2,1])]
  list=[list,string(ub[0,2])+'  '+string(ub[1,2])+'  '+string(ub[2,2])]
  list=[list,'----------------------------------']
  list=[list,'Unit cell parameters:']
  list=[list,string(lp[0])+'  '+string(lp[1])+'  '+string(lp[2])]
  list=[list,string(lp[3])+'  '+string(lp[4])+'  '+string(lp[5])]
  list=[list,'----------------------------------']
  sz=size(lp)
  sz=sz[1]
  if sz eq 12 then $
  begin
   list=[list,'Estimated standatd deviations:']
   tex=''
   tex1=''
   for i=6, 8 do tex=tex+string(lp[i])+'  '
   for i=9, 11 do tex1=tex1+string(lp[i])+'  '
   list=[list,tex,tex1]
  endif
  if total(ub) ne 0 then $
   list=[list,'Chi^2='+string(fom)]

  WIDGET_CONTROL, wid, SET_VALUE=list
end

;--------------------------------

pro read_predict_settings, pred

  COMMON WID_MAR345_elements

  widget_control, wid_text_30, get_value=om_start
  widget_control, wid_text_31, get_value=om_range
  ;widget_control, wid_text_34, get_value=chi
  ;widget_control, wid_text_39, get_value=d
  d=0.5
  widget_control, wid_text_38, get_value=h1
  widget_control, wid_text_40, get_value=h2
  widget_control, wid_text_42, get_value=k1
  widget_control, wid_text_41, get_value=k2
  widget_control, wid_text_44, get_value=l1
  widget_control, wid_text_43, get_value=l2
  ;--------- PD change ------
  ;--------- 6/23/2010 ------
  ;--- variables assigned with get_value are string type -
  ;--- they need to be converted to float before arithmetics is done with them
  om_start=float(om_start)
  om_range=float(om_range)

  chi=0


  pred.om_start  =  float(om_start)
  pred.om_range = float(om_range)
  pred.chi       = float(chi)
  pred.d         = float(d)
  pred.h1        = fix(h1)
  pred.h2        = fix(h2)
  pred.k1        = fix(k1)
  pred.k2        = fix(k2)
  pred.l1        = fix(l1)
  pred.l2        = fix(l2)

end
;--------------------------------

;******************************* TAKEN OUT ***************
;function check_stops
;COMMON WID_MAR345_elements
;stops=0
;event=widget_event(WID_button_17, /nowait)
;if event.id eq WID_button_17 then $
;begin
;  stops=1
;  print, '--- stop button pressed ---'
;end
;return, stops

;end


;******************************* TAKEN OUT ***************
;--------------------------------

function load_peak_tables
 COMMON WID_MAR345_elements
 re=widget_info(wid_button_20, /button_set)
 return, re
end
;--------------------------------

pro save_cal, fn, oad, wv
if fn ne '' then $
begin
 nudel=read_kappa_and_ttheta()
 ad=oad->get_object()
 free_lun,2
 openw, 2, fn
 PRINTF, 2,  ad.psizex
 PRINTF, 2,  ad.psizey
 PRINTF, 2,  ad.dist
 PRINTF, 2,  wv
 PRINTF, 2,  ad.beamx
 PRINTF, 2,  ad.beamy
 PRINTF, 2,  ad.tiltom
 PRINTF, 2,  ad.tiltch

 PRINTF, 2,  ad.angle ; twist
 PRINTF, 2,  ad.alpha ; alpha

 PRINTF, 2,  nudel[0] ; Nu
 PRINTF, 2,  nudel[1] ; Del

 close, 2
endif
end

;----------------------

pro load_cal, fn, oad, wv
if fn ne '' then $
begin
 on_ioerror, err
 valid=0
 ad=oad->get_object()
 a=0.0
 free_lun,2
 openr, 2, fn
 readF, 2,aa
 ad.psizex=aa
 readF, 2, aa
 ad.psizey=aa
 readF, 2,  aa
 ad.dist=aa
 readF, 2,  aa
 wv=aa
 readF, 2,  aa
 ad.beamx=aa
 readF, 2,  aa
 ad.beamy=aa
 readF, 2,  aa
 ad.tiltom=aa
 readF, 2,  aa
 ad.tiltch=aa

 if not eof(2) then $ ; format including twist and alpha
 begin
  readF, 2,  aa
  ad.angle=aa
  readF, 2,  aa
  ad.alpha=aa
 endif else $
 begin
  ad.angle=0.000
  ad.alpha=0.000
 endelse


 if not eof(2) then $ ; format including Nu and Del
 begin
  readF, 2,  aa
  ad.Nu=aa
  readF, 2,  aa
  ad.Del=aa
 endif else $
 begin
  ad.Nu=0.000
  ad.Del=0.000
 endelse

 close, 2
 oad->set_object, ad
 valid=1
 endif
 err: IF ~ valid THEN re=dialog_message('Improper file format')
end

;----------------------


;--------------------------------------

pro capture_calibration, oad, wv
 ad=oad->get_object()
 COMMON WID_MAR345_elements
 WIDGET_CONTROL, WID_TEXT_83a, GET_VALUE=twist
 WIDGET_CONTROL, WID_TEXT_36, GET_VALUE=PIXX
 WIDGET_CONTROL, WID_TEXT_35, GET_VALUE=PIXY
 WIDGET_CONTROL, WID_TEXT_33, GET_VALUE=DIST
 WIDGET_CONTROL, WID_TEXT_32, GET_VALUE=WAVE
 WIDGET_CONTROL, WID_TEXT_83, GET_VALUE=BEAMX
 WIDGET_CONTROL, WID_TEXT_82, GET_VALUE=BEAMY
 WIDGET_CONTROL, WID_TEXT_81, GET_VALUE=ROTA
 WIDGET_CONTROL, WID_TEXT_80, GET_VALUE=TILT

 ;WIDGET_CONTROL, WID_TEXT_36c, GET_VALUE=alpha
 ad.psizex=float(pixx)
 ad.psizey=float(pixy)
 ad.dist=float(dist)
 wv=float(wave)
 ad.beamx=float(beamx)
 ad.beamy=float(beamy)
 ad.angle=float(twist)
; ad.alpha=float(alpha)
 ad.tiltom=float(rota)
 ad.tiltch=float(tilt)
 oad->set_object, ad
end

;---------------------------------

PRO print_calibration, oad, wv

 COMMON WID_MAR345_elements
 ad=oad->get_object()
 WIDGET_CONTROL, WID_TEXT_36, SET_VALUE=string(ad.psizex)
 ;WIDGET_CONTROL, WID_TEXT_36c, SET_VALUE=string(ad.alpha)
 WIDGET_CONTROL, WID_TEXT_35, SET_VALUE=string(ad.psizey)
 WIDGET_CONTROL, WID_TEXT_33, SET_VALUE=string(ad.dist)
 WIDGET_CONTROL, WID_TEXT_32, SET_VALUE=string(wv)
 WIDGET_CONTROL, WID_TEXT_83, SET_VALUE=string(ad.beamx)
 WIDGET_CONTROL, WID_TEXT_83a, SET_VALUE=string(ad.angle)
 WIDGET_CONTROL, WID_TEXT_82, SET_VALUE=string(ad.beamy)
 WIDGET_CONTROL, WID_TEXT_81, SET_VALUE=string(ad.tiltom)
 WIDGET_CONTROL, WID_TEXT_80, SET_VALUE=string(ad.tiltch)


 WIDGET_CONTROL, WID_TEXT_36a, SET_VALUE=string(ad.nu)
 WIDGET_CONTROL, WID_TEXT_36b, SET_VALUE=string(ad.del)

end

;--------------------------------------

pro read_ps_settings, a1, a2, a3, a4, a5
  COMMON WID_MAR345_elements
  widget_control, wid_text_0, get_value=aa1
  widget_control, wid_text_1, get_value=aa2
  widget_control, wid_text_2, get_value=aa3
  widget_control, wid_text_3, get_value=aa4
  widget_control, wid_text_3a, get_value=aa5
  a1=long(aa1)
  a2=long(aa2)
  a3=long(aa3)
  a4=long(aa4)
  a5=long(aa5)
  a1=a1[0]
  a2=a2[0]
  a3=a3[0]
  a4=a4[0]
  a5=a5[0]
end

;--------------------------------------
;******************************** NEW CODE **********************
pro EventOmega
ok = Dialog_Message (['Please make sure that', $
                      'you have picked proper', $
                      'sence of rotation with a check box',$
                      'named: "Omega rotation inversion"'], $
                    /CENTER, $
                    TITLE = 'OMEGA ROTATION REMINDER')
end
;******************************** NEW CODE **********************




pro WID_MAR345_L_event, ev
@COMMON_DATAS
@COMMON_DATAS2
COMMON WID_MAR345_elements
COMMON image_type_and_arrays
COMMON cont
common selections
common mcoordinates
COMMON EX
COMMON prof
COMMON CLASS_peaktable_reference
;COMMON WID_Image_simulation_elements
common status, PE_open, SIM_open
common calib_ref, zeroref
common closing, Wid_Image_simulation

 WIDGET_CONTROL, ev.id, GET_UVALUE=uv
 if ev.id eq WID_LIST_TASK then return
 if n_elements(uv)  ne 0 then case uv of
 ;******************************** NEW CODE **********************
 'Omega Start Event': $
 begin
 ;Remind user each time they type to examine the
 ;state of omega rotation check box before undertaking
 ;simulation.
 	if ev.type eq 0 then $
 	begin
 	EventOmega
 	endif
 end
 'Omega Range Event': $
 begin
 ;Remind user each time they type to examine the
 ;state of omega rotation check box before undertaking
 ;simulation.
 	if ev.type eq 0 then $
 	begin
 	EventOmega
 	endif
 end

;---------------------------------------

'Open fcf file':$ ;----- new fcf button
begin
 re=dialog_pickfile(/read,filter='*.fcf',  path=out_dir)
 if re ne '' then widget_control, WID_text_fcf_file, set_value=re
end
;---------------------------------------


;---------------------------------------

'TDS':$
begin
 SIZ=50
 if total(ub) eq 0 then $
 begin
   re=dialog_message('Open UB matrix file first')
 endif else $
 begin
 pn=read_peak_selected(wid_list_3)
 if pn ge 0 and pn lt opt->peakno() then $
 begin
    pt=opt->get_object()
	print, 'HKL', pt.peaks[pn].hkl
	print, 'XYZ', pt.peaks[pn].xyz
	xyz=pt.peaks[pn].xyz
	detXY=pt.peaks[pn].DetXY
    gonio=pt.peaks[pn].gonio
    if 	min(detXY-siz) lt 0 or max(detXY+siz) gt arr1 then $
    begin
      re=dialog_message('Peak too close to the image edge')
    endif else $
    begin
	fi=dialog_pickfile(default_extension='txt', path=dir)
	if fi ne '' then $
	begin
	  get_lun, lu
	  openw, lu, fi
	  im=oimage->get_object()
      for x=-siz, siz do $
	     for y=-siz, siz do $
	     begin
	       dx=[DetXY[0]+x,DetXY[1]+y]
	       xyz=oadetector->calculate_XYZ_from_pixels_mono(dx, gonio, wv)
	       hkl=transpose(invert(UB) ## xyz)
	       printf, lu, long(dx), hkl,  im.img[dx[0],dx[1]], format='(I6, I6, F8.4, F8.4,  F8.4,  F10.2)'
	     endfor
	     close, lu
	  	 free_lun, lu
	  	 re=dialog_message('TDS file successfully exported')
	endif
	endelse ; too close

 endif
 endelse
 end


;---------------------------------------
'Compare fcf':$
begin
    widget_control, WID_text_fcf_file, get_value=re
    if re ne '' then $
    begin
     fcf=reaf_fcf4(re)
     if fcf_spline() eq 0 then $
     begin

     if  not(n_elements(fcf) eq 1 and fcf[0] eq 0) then $
     begin
      a=n_elements(fcf)
      ad=oadetector->get_object()
      if a[0] ne -1 and opt->peakno()-1 ne 0 then $
      begin
       pt=opt->get_object()
       ff=match_fcf(pt, fcf)
       n=where(ff gt 0)
       res=poly_fit(ff[n],pt.peaks[n].intad[0],1)
       sc=res[1]
       ch=read_fcf_var()
       case ch of
       1: x=pt.peaks[n].gonio[3] ; ---- omega from peak table
       2: x=get_tth_from_xyz(pt.peaks[n].xyz)
       3: x=oadetector->get_nu_from_pix(pt.peaks[n].DetXY)
       4: x=oadetector->calculate_psi_angles(pt.peaks[n].gonio, pt.peaks[n].DetXY)
       else :
       endcase
       y=(pt.peaks[n].intad[0]/sc-ff[n])/ff[n]
       ii=where(y lt 1.0 and y gt -1.0)
       if ii[0] ne -1 then $
       begin
       res=poly_fit(x[ii],y[ii],2, status=status, chisq=chisq)

       wset, wid_draw_6
       device, decomposed=1
       case ch of
       1: plot, pt.peaks[n[ii]].gonio[3], (pt.peaks[n[ii]].intad[0]/sc-ff[n[ii]])/ff[n[ii]], thick=0, symsize=0.5, psym=6, background='FFFFFF'xl, color='000000'xl
       2: plot, get_tth_from_xyz(pt.peaks[n[ii]].xyz), (pt.peaks[n[ii]].intad[0]/sc-ff[n[ii]])/ff[n[ii]], thick=0, symsize=0.5, psym=6, background='FFFFFF'xl, color='000000'xl
       3: plot, oadetector->get_nu_from_pix(pt.peaks[n[ii]].DetXY), (pt.peaks[n[ii]].intad[0]/sc-ff[n[ii]])/ff[n[ii]], thick=0, symsize=0.5, psym=6, background='FFFFFF'xl, color='000000'xl
       4: plot, oadetector->calculate_psi_angles(pt.peaks[n[ii]].gonio, pt.peaks[n[ii]].DetXY), (pt.peaks[n[ii]].intad[0]/sc-ff[n[ii]])/ff[n[ii]], thick=0, symsize=0.5, psym=6, background='FFFFFF'xl, color='000000'xl
       else:
       endcase
       b=sort(x)
       yc=res[2]*x*x+res[1]*x+res[0]
       oplot, x[b], yc[b], color='FF00FF'xl, thick=2.0
     endif ; fcf ok
    end
   endif
   end else $; polynomial
   begin;--- spline

    a=n_elements(fcf)
    ad=oadetector->get_object()
    if a[0] ne -1 and opt->peakno()-1 ne 0 then $
    begin
     pt=opt->get_object()
     ff=match_fcf(pt, fcf)
     n=where(ff gt 0)
;     sc=mean(pt.peaks[n].intad[0]/ff[n])
     res=poly_fit(ff[n],pt.peaks[n].intad[0],1)
     print, 'scaling: ', res[0:1]
     sc=res[1]
     print, sc, n_elements(n)
     ch=read_fcf_var()
     case ch of
     1: x=pt.peaks[n].gonio[3] ; ---- omega from peak table
     2: x=get_tth_from_xyz(pt.peaks[n].xyz)
     3: x=oadetector->get_nu_from_pix(pt.peaks[n].DetXY)
     4: x=oadetector->calculate_psi_angles(pt.peaks[n].gonio, pt.peaks[n].DetXY)
     else :
     endcase
     y=(pt.peaks[n].intad[0]/sc-ff[n])/ff[n]
     ii=where(y lt 1.0 and y gt -1.0)
     if ii[0] ne -1 then $
     begin

    s=sort(x[ii])
    x1=x[[ii[s]]]
    y1=y[[ii[s]]]
    a=interval_nodes(x1 , y1, fcf_spline())
    s=sort(x)
    x2=x[s]
    bb = SPLINE( a[*,0], a[*,1], x2)

     wset, wid_draw_6
     device, decomposed=1

     case ch of
     1: plot, pt.peaks[n[ii]].gonio[3], (pt.peaks[n[ii]].intad[0]/sc-ff[n[ii]])/ff[n[ii]], thick=0, symsize=0.5, psym=6, background='FFFFFF'xl, color='000000'xl
     2: plot, get_tth_from_xyz(pt.peaks[n[ii]].xyz), (pt.peaks[n[ii]].intad[0]/sc-ff[n[ii]])/ff[n[ii]], thick=0, symsize=0.5, psym=6, background='FFFFFF'xl, color='000000'xl
     3: plot, oadetector->get_nu_from_pix(pt.peaks[n[ii]].DetXY), (pt.peaks[n[ii]].intad[0]/sc-ff[n[ii]])/ff[n[ii]], thick=0, symsize=0.5, psym=6, background='FFFFFF'xl, color='000000'xl
     4: plot, oadetector->calculate_psi_angles(pt.peaks[n[ii]].gonio, pt.peaks[n[ii]].DetXY), (pt.peaks[n[ii]].intad[0]/sc-ff[n[ii]])/ff[n[ii]], thick=0, symsize=0.5, psym=6, background='FFFFFF'xl, color='000000'xl
     else:
     endcase
     oplot, x2, bb, color='FF00FF'xl, thick=2.0
     end
end
   endelse ;spline
   end; filename ok
end

'SaveProj' :$
	begin
		print, 'in here'
		zeroOff = gonio_zero_offset()
		omRotation = read_om_rotation_dir()
		resVal = read_inversions ()
		case resVal of
			1: begin
				rex = 0
				rey = 1
				tra = 1
				end
			2 : begin
				rex = 1
				rey = 1
				tra = 0
				end
			3 : begin
				rex = 1
				rey = 0
				tra = 0
				end
			4 : begin
				rex = 0
				rey = 0
				tra = 1
				end
			5 : begin
				rex = 1
				rey = 0
				tra = 0
				end
			6 : begin
				rex = 1
				rey = 1
				tra = 1
				end
			7 : begin
				rex = 0
				rey = 1
				tra = 0
				end
		endcase

		widget_control, Wid_Image_simulation->wid_text_14(), get_value=DAC_open
  		DAC_open=float(DAC_open)
  		cor = I_corrections()
  		DAC_abs = cor(0)
  		outFile = res.base+'_projset.txt'
		outFile = dialog_pickfile (/write, File=outFile, filter='*.txt')
		openw,lun, outFile, /get_lun
		printf,lun, 'Zero Offset    : '+string(zeroOff)
		printf,lun, 'Omega Rotation : '+string(omRotation)
		printf,lun, 'X inversion    : '+string(rex)
		printf,lun, 'Y inversion    : '+string(rey)
		printf,lun, 'Transpose      : '+string(tra)
		printf,lun, 'DAC Opening    : '+string(DAC_open)
		printf,lun, 'DAC abs status : '+string(DAC_abs)
		close,lun
		;stop
	end


;---------------------------------------
  'WID_BUTTON_fcf_appl':$
begin
    widget_control, WID_text_fcf_file, get_value=re
    if re ne '' then $
    begin
     fcf=reaf_fcf4(re)
     if fcf_spline() eq 0 then $
     begin

     if  not(n_elements(fcf) eq 1 and fcf[0] eq 0) then $
     begin
      a=n_elements(fcf)
      ad=oadetector->get_object()
      if a[0] ne -1 and opt->peakno()-1 ne 0 then $
      begin
       pt=opt->get_object()
       ff=match_fcf(pt, fcf)
       n=where(ff gt 0)
       res=poly_fit(ff[n],pt.peaks[n].intad[0],1)
       sc=res[1]
       ch=read_fcf_var()
       case ch of
       1: x=pt.peaks[n].gonio[3] ; ---- omega from peak table
       2: x=get_tth_from_xyz(pt.peaks[n].xyz)
       3: x=oadetector->get_nu_from_pix(pt.peaks[n].DetXY)
       4: x=oadetector->calculate_psi_angles(pt.peaks[n].gonio, pt.peaks[n].DetXY)
       else :
       endcase
       y=(pt.peaks[n].intad[0]/sc-ff[n])/ff[n]
       ii=where(y lt 1.0 and y gt -1.0)
       if ii[0] ne -1 then $
       begin
       res=poly_fit(x[ii],y[ii],2, status=status, chisq=chisq)

       ;widget_control, WID_TEXT_14_da1om, set_value=string(res[2], format='(F9.5)')
       ;widget_control, WID_TEXT_14_da2om, set_value=string(res[1], format='(F9.5)')
       ;widget_control, WID_TEXT_14_da3om, set_value=string(res[0], format='(F9.5)')

       wset, wid_draw_6
       device, decomposed=1
       case ch of
       1: plot, pt.peaks[n[ii]].gonio[3], (pt.peaks[n[ii]].intad[0]/sc-ff[n[ii]])/ff[n[ii]], thick=0, symsize=0.5, psym=6, background='FFFFFF'xl, color='000000'xl
       2: plot, get_tth_from_xyz(pt.peaks[n[ii]].xyz), (pt.peaks[n[ii]].intad[0]/sc-ff[n[ii]])/ff[n[ii]], thick=0, symsize=0.5, psym=6, background='FFFFFF'xl, color='000000'xl
       3: plot, oadetector->get_nu_from_pix(pt.peaks[n[ii]].DetXY), (pt.peaks[n[ii]].intad[0]/sc-ff[n[ii]])/ff[n[ii]], thick=0, symsize=0.5, psym=6, background='FFFFFF'xl, color='000000'xl
       4: plot, oadetector->calculate_psi_angles(pt.peaks[n[ii]].gonio, pt.peaks[n[ii]].DetXY), (pt.peaks[n[ii]].intad[0]/sc-ff[n[ii]])/ff[n[ii]], thick=0, symsize=0.5, psym=6, background='FFFFFF'xl, color='000000'xl
       else:
       endcase
       b=sort(x)
       yc=res[2]*x*x+res[1]*x+res[0]
       oplot, x[b], yc[b], color='FF00FF'xl, thick=2.0

       for i=0, pt.peakno do $
       begin
         xa=pt.peaks[i].gonio[3]
         m=res[2]*xa*xa+res[1]*xa+res[0]
         pt.peaks[i].intad[0]=pt.peaks[i].intad[0]*(1.0-m)
         pt.peaks[i].intad[1]=pt.peaks[i].intad[1]*(1.0-m)
       endfor
       opt->set_object, pt

     endif ; fcf ok
    end
   endif
   end else $; polynomial
   begin;--- spline

    a=n_elements(fcf)
    ad=oadetector->get_object()
    if a[0] ne -1 and opt->peakno()-1 ne 0 then $
    begin
     pt=opt->get_object()
     ff=match_fcf(pt, fcf)
     n=where(ff gt 0)
     ch=read_fcf_var()
     case ch of
     1: x=pt.peaks[n].gonio[3] ; ---- omega from peak table
     2: x=get_tth_from_xyz(pt.peaks[n].xyz)
     3: x=oadetector->get_nu_from_pix(pt.peaks[n].DetXY)
     4: x=oadetector->calculate_psi_angles(pt.peaks[n].gonio, pt.peaks[n].DetXY)
     else :
     endcase
     y=(pt.peaks[n].intad[0]/sc-ff[n])/ff[n]
     ii=where(y lt 1.0 and y gt -1.0)
     if ii[0] ne -1 then $
     begin

    s=sort(x[ii])
    x1=x[[ii[s]]]
    y1=y[[ii[s]]]
    a=interval_nodes(x1 , y1, fcf_spline())
    s=sort(x)
    x2=x[s]
    bb = SPLINE( a[*,0], a[*,1], x2)

     wset, wid_draw_6
     device, decomposed=1

     case ch of
     1: plot, pt.peaks[n[ii]].gonio[3], (pt.peaks[n[ii]].intad[0]/sc-ff[n[ii]])/ff[n[ii]], thick=0, symsize=0.5, psym=6, background='FFFFFF'xl, color='000000'xl
     2: plot, get_tth_from_xyz(pt.peaks[n[ii]].xyz), (pt.peaks[n[ii]].intad[0]/sc-ff[n[ii]])/ff[n[ii]], thick=0, symsize=0.5, psym=6, background='FFFFFF'xl, color='000000'xl
     3: plot, oadetector->get_nu_from_pix(pt.peaks[n[ii]].DetXY), (pt.peaks[n[ii]].intad[0]/sc-ff[n[ii]])/ff[n[ii]], thick=0, symsize=0.5, psym=6, background='FFFFFF'xl, color='000000'xl
     4: plot, oadetector->calculate_psi_angles(pt.peaks[n[ii]].gonio, pt.peaks[n[ii]].DetXY), (pt.peaks[n[ii]].intad[0]/sc-ff[n[ii]])/ff[n[ii]], thick=0, symsize=0.5, psym=6, background='FFFFFF'xl, color='000000'xl
     else:
     endcase
     oplot, x2, bb, color='FF00FF'xl, thick=2.0

       for i=0, pt.peakno do $
       begin


 case ch of
     	 1: xa=pt.peaks[i].gonio[3] ; ---- omega from peak table
     	 2: xa=get_tth_from_xyz(pt.peaks[i].xyz)
     	 3: xa=oadetector->get_nu_from_pix(pt.peaks[i].DetXY)
     	 4: xa=oadetector->calculate_psi_angles(pt.peaks[i].gonio, pt.peaks[i].DetXY)
     	 endcase
     	 ma=abs(x2-xa[0])
     	 mi=min(ma, f)
         ;f=where(x2 eq xa)
         m=bb[f[0]]
         pt.peaks[i].intad[0]=pt.peaks[i].intad[0]*(1.0-m)
         pt.peaks[i].intad[1]=pt.peaks[i].intad[1]*(1.0-m)
       endfor
       opt->set_object, pt


     end
end
   endelse ;spline
   end; filename ok
end




'Update hkl':$
begin
  widget_control, WID_text_fcf_file, get_value=re
  if re ne '' then $
  begin
   len=strlen(re)
   nam=strmid(re,0,len-3)+'hkl'
   print, nam
   opt->save_hkl, nam
  end
end

'WID_BUTTON_fcf_sel':$
begin
    widget_control, WID_text_fcf_file, get_value=re
    if re ne '' then $
    begin
     fcf=reaf_fcf4(re)

     if  not(n_elements(fcf) eq 1 and fcf[0] eq 0) then $
     begin
      a=n_elements(fcf)
      ad=oadetector->get_object()
      if a[0] ne -1 and opt->peakno()-1 ne 0 then $
      begin
       pt=opt->get_object()
       ff=match_fcf(pt, fcf)
       n=where(ff gt 0)
       res=poly_fit(ff[n],pt.peaks[n].intad[0],1)
       sc=res[1]
       ch=read_fcf_var()
       case ch of
        1: x=pt.peaks[n].gonio[3] ; ---- omega from peak table
        2: x=get_tth_from_xyz(pt.peaks[n].xyz)
        3: x=oadetector->get_nu_from_pix(pt.peaks[n].DetXY)
        4: x=oadetector->calculate_psi_angles(pt.peaks[n].gonio, pt.peaks[n].DetXY)
       else :
       endcase
       y=(pt.peaks[n].intad[0]/sc-ff[n])/ff[n]
       ii=where(y lt 1.0 and y gt -1.0)
       if ii[0] ne -1 then $
       begin

       wset, wid_draw_6
       device, decomposed=1
       case ch of
 		1: xxx=pt.peaks[n[ii]].gonio[3]
        2: xxx=get_tth_from_xyz(pt.peaks[n[ii]].xyz)
        3: xxx=oadetector->get_nu_from_pix(pt.peaks[n[ii]].DetXY)
        4: xxx=oadetector->calculate_psi_angles(pt.peaks[n[ii]].gonio, pt.peaks[n[ii]].DetXY)
       endcase
         yyy=(pt.peaks[n[ii]].intad[0]/sc-ff[n[ii]])/ff[n[ii]]
         plot, xxx, (pt.peaks[n[ii]].intad[0]/sc-ff[n[ii]])/ff[n[ii]], thick=0, symsize=0.5, psym=6, background='FFFFFF'xl, color='000000'xl
         hh=read_fcf_select_th()
         w1=where (yyy gt  hh[0])
         w2=where (yyy lt  hh[1])
         if w1[0] ne -1 then pt.peaks[n[ii[w1]]].selected[0]=1
         if w2[0] ne -1 then pt.peaks[n[ii[w2]]].selected[0]=1
         opt->set_object, pt
         if w1[0] ne -1 then oplot, xxx[w1], [(pt.peaks[n[ii[w1]]].intad[0]/sc-ff[n[ii[w1]]])/ff[n[ii[w1]]]], thick=0, symsize=0.5, psym=6, color='00ff00'xl
         if w2[0] ne -1 then oplot, xxx[w2], [(pt.peaks[n[ii[w2]]].intad[0]/sc-ff[n[ii[w2]]])/ff[n[ii[w2]]]], thick=0, symsize=0.5, psym=6, color='00ff00'xl
       end ; ii[0] ne -1
     end ; peak table not empty
     end ; fcf ok
   end; filename ok
end


;--------------------------------------
  'Open abs':$
     begin
      print, 'open abs'
      re=dialog_pickfile(/read, filter='*.txt',  path=dir)
      if re ne '' then $
      begin
      get_lun, lu
      va=''
      openr, lu, re
      readf, lu, va
      widget_control, WID_TEXT_14_da1, set_value=va
      readf, lu, va
      widget_control, WID_TEXT_14_da2, set_value=va
      readf, lu, va
      widget_control, WID_TEXT_14_da3, set_value=va
      readf, lu, va
      widget_control, WID_TEXT_14_da4, set_value=va
      readf, lu, va
      widget_control, WID_TEXT_14_da5, set_value=va
      readf, lu, va
      widget_control, WID_TEXT_14_da6, set_value=va
      close, lu
      endif
     end

  'Save abs':$
     begin
      print, 'save abs'
      re=dialog_pickfile(/write, filter='*.txt',  path=dir, default_extension='txt')
      get_lun, lu
      openw, lu, re
        widget_control, WID_TEXT_14_da1, get_value=va
        printf, lu, va
        widget_control, WID_TEXT_14_da2, get_value=va
        printf, lu, va
        widget_control, WID_TEXT_14_da3, get_value=va
        printf, lu, va
        widget_control, WID_TEXT_14_da4, get_value=va
        printf, lu, va
        widget_control, WID_TEXT_14_da5, get_value=va
        printf, lu, va
        widget_control, WID_TEXT_14_da6, get_value=va
        printf, lu, va
      close, lu
     end
  'Test calibration':$
  begin
    plot_image, oimage
    detector_calibration_test_points
  end
  'Refine calibration':$
  begin
    re=which_calibration()
    if re eq 0 then $
    begin
    if total(ub) ne 0.0 then $
    begin

    U=U_from_UB(ub)
    lp=lp_from_ub(ub)
    B=b_from_lp(lp)

    if determ(u) lt 0 then $
    begin

     inv=[[-1,0,0],[0,-1,0],[0,0,-1]]
     u1=inv # U
     print, determ(u1)

    endif else $
    begin
      inv=[[1,0,0],[0,1,0],[0,0,1]]
      u1=u
    endelse


    angs=euler_decomposition(U1)
    u2=euler_composition([angs[0],angs[1],angs[2]])
    du=inv # u2

    print

    print, total(du-u)
    ;al=get_alpha()

    N=opt->peakno()
    pt=opt->get_object()
    x=pt.peaks[0:N-1].detxy[0] ; measured pixel coordinate X
    y=pt.peaks[0:N-1].detxy[1];  measured pixel coordinate Y
    ERR=pt.peaks[0:N-1].detxy[1]/100.
    y=fltarr(N)
    ;ERR=fltarr(N)
    for i=0, N-1 do ERR[i]=1.0
    fa = {X:x, Y:y, ERR:err}

    p0=fltarr(10)
    ad=oadetector->get_object()

    p0[0]=ad.dist
    p0[1]=ad.beamx
    p0[2]=ad.beamy
    p0[3]=ad.angle
    p0[4]=ad.tiltom
    p0[5]=ad.tiltch

    p0[6]=angs[0]
    p0[7]=angs[1]
    p0[8]=angs[2]
    p0[9]=ad.alpha

    parinfo = replicate({value:0.D, fixed:0, limited:[0,0], $
                       limits:[0.D,0], tied:''}, 10)

    parinfo[*].value=p0
    parinfo[0].fixed=0
    parinfo[1].fixed=0
    parinfo[2].fixed=0
    parinfo[3].fixed=0
    parinfo[4].fixed=0
    parinfo[5].fixed=0

    re=widget_info(WID_BUTTON_refine_B, /button_set)
    re1=widget_info(WID_BUTTON_refine_al, /button_set)

if refine_twist() eq 0 then $
  begin
    p0[3]=0
    parinfo[3].value=0
    parinfo[3].fixed  = 1
  endif else parinfo[3].fixed  = 0

    if re1 eq 1 then $
     parinfo[9].fixed=0 else $
     parinfo[9].fixed=1

    if re eq 1 then $
    begin
     parinfo[6].fixed=0
     parinfo[7].fixed=0
     parinfo[8].fixed=1
    endif else $
    begin
     parinfo[6].fixed=1
     parinfo[7].fixed=1
     parinfo[8].fixed=1
    endelse

    p = mpfit('MYFUN_CAL_OPT', p0, functargs=fa,PERROR=PE, PARINFO=parinfo, BESTNORM=bestnorm)


    DOF     = N_ELEMENTS(X) - N_ELEMENTS(P) ; deg of freedom
    PCERROR = PE * SQRT(BESTNORM / DOF)   ; scaled uncertainties



  WIDGET_CONTROL, WID_TEXT_83ad, SET_VALUE=string(PCERROR[3], format='(F6.4)')
  WIDGET_CONTROL, WID_TEXT_36d , SET_VALUE=''
  WIDGET_CONTROL, WID_TEXT_35d , SET_VALUE=''
  WIDGET_CONTROL, WID_TEXT_33d , SET_VALUE=string(PCERROR[0], format='(F6.4)') ;distance
  WIDGET_CONTROL, WID_TEXT_32d , SET_VALUE=''
  WIDGET_CONTROL, WID_TEXT_83d , SET_VALUE=string(PCERROR[1], format='(F6.4)');beamx
  WIDGET_CONTROL, WID_TEXT_82d , SET_VALUE=string(PCERROR[2], format='(F6.4)');beamy
  WIDGET_CONTROL, WID_TEXT_81d , SET_VALUE=string(PCERROR[4], format='(F6.4)')
  WIDGET_CONTROL, WID_TEXT_80d , SET_VALUE=string(PCERROR[5], format='(F6.4)')

;    nam='cal_refine.txt'
;    get_lun, lu
;    openw, lu, nam
;    printf, lu, 'Starting calibration:'
;    printf, lu,  p0
;    printf, lu, 'Optimized calibration:'
;    printf, lu, p
;    printf, lu, 'Estimated standard deviations:'
;    printf, lu,  PCERROR
;    close, lu
;    spawn, 'start '+nam


 ;   print, p0
 ;   print, p
 ;   print, PCERROR

;    re=dialog_message(/question, 'Do you want to apply the changes?')

   ;if re eq 'Yes' or re eq 'yes' then $
   begin

    ad=oadetector->get_object()

    ad.dist   = p[0]
    ad.beamx  = p[1]
    ad.beamy  = p[2]
    ad.angle  = p[3]
    ad.tiltom = p[4]
    ad.tiltch = p[5]
    ad.alpha  = p[9]

    oadetector->set_object, ad

    print_calibration, oadetector, wv

    u2=euler_composition([p[6],p[7],p[8]])
    du=inv # u2

    ub=du ## b


   endif
  endif else re=dialog_message('UB matrix is unacceptable')
  endif else $
  begin
  detector_calibration_refinemnt,esd;--- end of single crystal calibration
  WIDGET_CONTROL, WID_TEXT_83ad, SET_VALUE=string(esd[3], format='(F6.4)')
  WIDGET_CONTROL, WID_TEXT_36d , SET_VALUE=''
  WIDGET_CONTROL, WID_TEXT_35d , SET_VALUE=''
  WIDGET_CONTROL, WID_TEXT_33d , SET_VALUE=string(esd[0], format='(F6.4)') ;distance
  WIDGET_CONTROL, WID_TEXT_32d , SET_VALUE=''
  WIDGET_CONTROL, WID_TEXT_83d , SET_VALUE=string(esd[1], format='(F6.4)');beamx
  WIDGET_CONTROL, WID_TEXT_82d , SET_VALUE=string(esd[2], format='(F6.4)');beamy
  WIDGET_CONTROL, WID_TEXT_81d , SET_VALUE=string(esd[4], format='(F6.4)')
  WIDGET_CONTROL, WID_TEXT_80d , SET_VALUE=string(esd[5], format='(F6.4)')

  endelse
  end


  'Export abs':$
     begin
      print, 'export abs'
      re=dialog_pickfile(/write, filter='*.txt',  path=dir, default_extension='txt')
      get_lun, lu
      a=generate_abs()
      s=n_elements(a)/2
      if s gt 0 then $
      begin
        openw, lu, re
          for i=0, s-1 do $
          begin
            printf, lu, a[0,i], a[1,i]
          endfor
        close, lu
      endif
     end

  'Import abs':$
     begin
     on_IOERROR, en
      print, 'Import abs'
      re=dialog_pickfile(/write, filter='*.txt',  path=dir, default_extension='txt')
      get_lun, lu
      reg=file_info(re)
      re1=0.0
      re2=0.0
      tab=fltarr(200,2)
      nop=0
      if reg.exists eq 1 then $
      begin
       openr, lu, re
       while not eof(lu) do $
       begin
        readf, lu, re1, re2
        print, re1,re2
        tab[nop,0]=re1
        tab[nop,1]=re2
        nop=nop+1
       endwhile
       tab[*,1]=tab[*,1]/max(tab[*,1])
       close, lu
       wset, wid_draw_6
       a=generate_abs()
       s=n_elements(a)/2
       device, decomposed=1
       plot, tab[0:nop-1,0],tab[0:nop-1,1], xrange=[min(tab[0:nop-1,0]),max(tab[0:nop-1,0])], background='FFFFFF'xl, color='000000'xl
       oplot, a[0,*],a[1,*], color='0000FF'xl
       device, decomposed=0
      endif ; file exists
      en:
     end



'Dac absorption':$
begin
       wset, wid_draw_6
       a=generate_abs(-35, 35)
       s=n_elements(a)/2
       device, decomposed=1
       n=n_elements(tab)
       if n gt 0 and nop gt 0 then $
       begin
        plot, tab[0:nop-1,0],tab[0:nop-1,1], xrange=[min(tab[0:nop-1,0]),max(tab[0:nop-1,0])], background='FFFFFF'xl, color='000000'xl
        oplot, a[0,*],a[1,*], color='0000FF'xl
       endif else $
       begin
         plot, a[0,*],a[1,*], color='0000FF'xl, background='FFFFFF'xl
       endelse
       device, decomposed=0
end

 ;******************************** NEW CODE **********************
 'Open':$
 begin
  fn=dialog_pickfile(/read, filter=['*.mar3450','*.mar2300', '*.tiff', '*.tif'], path=dir, get_path=dir)
  openimage:
  if fn ne '' then $
  begin
   save_last_directories
   widget_control, wid_text_28, set_value=dir
   extno=how_many_digits(fn)
   res=analyse_fname(fn, dir, extno) ; -1 means that there is no sequence number
   if extno ge 1 then $
   begin

   my_f=res.seq
   res.extno=extno
   fileparms = strarr(4)
   fileparms(0) = fn
   fileparms(1) = dir
   f0=find_series_start(res)
   f1=find_series_end(res)
   fileparms(2) = f0
   fileparms(3) = f1

   ;--------------
   ; open first settings file

       res.seq=f0
       fn=generate_fname(res, extno)
       om=read_settings_file(fn+'.txt')
       if not(om[0] eq -100 and om[1] eq -100) then $
       begin
          widget_control, wid_text_4, set_value=strcompress(string(read_om_rotation_dir()*(om[0]-gonio_zero_offset()), format='(F12.2)'),/remove_all)
          widget_control, wid_text_5, set_value=strcompress(string(read_om_rotation_dir()*om[1], format='(F12.2)'),/remove_all)
       endif else begin
       		wid_settings_gen_dlg,fileparms
       endelse
   ;--------------
   ; check for ub file and give option to open existing ub files
   if assign_cal() then $
   begin
   ubfile = res.base + '.ub'
   FExists = FILE_TEST(ubfile)
   if max(ub) gt 0 and  FExists ne 1 then begin
   		; ask user if they wish to associate an existing UB file
   		status = dialog_message ("Would you like to associate the current UB with this file series", /question)
   		if status eq 'Yes' then begin
	 		save_UB, UB, ubfile
	 		message_string = 'Wrote UB File : '+ubfile
	 		status = dialog_message (message_string, /Information)
	 	endif
	endif
    endif

   widget_control, wid_text_12, set_value=string(f0, format='(I4)')
   widget_control, wid_text_11, set_value=string(f1, format='(I4)')
   widget_control, wid_text_6, set_value=string(f1-f0+1, format='(I4)')
   widget_control, wid_text_7, set_value=string(f0, format='(I4)')

   res.seq=my_f
   fn=generate_fname(res,extno)

   endif

   widget_control, wid_text_17, set_value=res.name0
   widget_control, wid_text_9, set_value=res.name0



   oimage->load_image, fn, oadetector
   detectFileSpecific = res.base+'.cal'

   if FILE_TEST(detectFileSpecific) then begin
   	load_cal,detectFileSpecific, oadetector, wv
   endif else if assign_cal() then $
   begin
   		ok = Dialog_Message (['No associated cal file found', $
                      'Do you want to associate current', $
                      'calibration to that series'], $
                    /CENTER, /question, $
                    TITLE = 'No Associaated Cal File Found')
		if ok eq 'Yes' then begin
   				outfileTmp = res.base+'.cal'


   				capture_calibration, oadetector, wv
   				save_cal, 'last_calibration.cal', oadetector, wv
    			save_cal, outfileTmp, oadetector, wv
   		endif

   	endif
   	; then check for ub file
   	ubFileSpecific = res.base+'.ub'
   	if FILE_TEST(ubFileSpecific) then begin

   	 UB=open_UB(ubFileSpecific)
     lp=lp_from_ub(UB)
     Wid_Image_simulation->print_UB,UB
     Wid_Image_simulation->print_lp,lp

  	endif


   ;oimage->append_image, fn, oadetector

   print_calibration, oadetector, wv
   device, decomposed=0

          ; Dynamic mask
       if  dynamic_mask_on() then $
       begin
        t1=SYSTIME(/SECONDS )
                ;*************************************
		  mydll='AD_image8.dll'
 		  re=file_info(mydll)
 		  if re.exists eq 1 then $
 		  begin
           ad=oadetector->get_object()
 		   beamxy=[double(ad.beamX),double(ad.beamY)]
    	   tiltmtx=oadetector->tilt_mtx()
 	       psize=[double(ad.psizeX),double(ad.psizeY)]
           nopix=[Long(ad.nopixX),Long(ad.nopixY)]
           dist=double(ad.dist)
           kath=read_kappa_and_ttheta()
           om=[-101,1]
           status=call_external(mydll, 'IDL_dynamic_mask', maskarr, DIST, beamxy, nopix, tiltMtx, psize, double(kath[1]),double(om[0]+90.0),double(get_dac_opening()))
          endif else re=dialog_message('DLL library not found',/message)
        ;*************************************
        t2=SYSTIME(/SECONDS )
        print, 'Time for computing mask = ', t2-t1
       endif

  re=WIDGET_INFO(WID_BUTTON_33a, /BUTTON_SET)
  if re eq 1 then $
  begin
   WIDGET_CONTROL, WID_TEXT_46a, GET_VALUE=a
   a=float(a)
   a=a[0]
   im=oimage->get_object()
   w=where(im.img gt a)
   if w[0] ne -1 then maskarr[w]=0
  endif

   plot_image, oimage

;-----------------
  re=WIDGET_INFO(WID_BUTTON_33a, /BUTTON_SET) ; max filter
  if re eq 1 then $
  begin
   WIDGET_CONTROL, WID_TEXT_46a, GET_VALUE=a
   a=float(a)
   a=a[0]
   im=oimage->get_object()
   w=where(im.img gt a)
   if w[0] ne -1 then maskarr[w]=0
   plot_image, oimage
   ys=long(w/arr1)
   xs=w-ys*arr1
   wset, draw0
   device, decomposed=1
   for i=0L, n_elements(xs)-1 do $
   plots, xs[i]/float(arr1), ys[i]/float(arr2), color='FF0000'XL, /normal, psym=2, symsize=0.5
   device, decomposed=0

  endif
;-----------------



   el=load_peak_tables()
   re=file_info(out_dir+res.name0+'.pks')
   if el eq 1 and re.exists then $
   begin
    opt->read_object_from_file, out_dir+res.name0+'.pks'
    update_peakno, opt->peakno()
    print_peak_list, opt, wid_list_3
    plot_peaks, draw0, opt, arr1, arr2
    peaktable_file=out_dir+res.name0+'.pks'
   end


  im=oimage->get_object()
  b=where(im.img gt 0)
  print, 'median intenity: ', median(im.img[b])
  wset, wid_draw_6
  c=histogram(im.img[b], locations=x, max=1000, min=10, binsize=10)
  plot, x, c





  endif
 end

'Omega from Moving Detector':$
 begin
   widget_control, wid_text_39, get_value=mov
   widget_control, wid_text_4, get_value=rot0
   widget_control, wid_text_5, get_value=rot
   mov=float(mov)
   rot=float(rot)
   rot0=float(rot0)
   calc_omega_from_md_traj, mov, rot0,rot
   capture_calibration, oadetector, wv
   opt->calculate_all_xyz_from_pix, oadetector, wv
   print_peak_list, opt, wid_list_3
 end

 'Correlate1':$
 begin
  fna=dialog_pickfile(/read, filter=['*.mar3450','*.mar2300', '*.tiff', '*.tif'], path=dir, get_path=dir)
  if fna ne '' then $
  begin
   oimage2=obj_new('adimage_CLASS')
   oimage2->set_detector_format, imt
   oimage2->load_image, fna, oadetector
   img2=oimage2->get_object()
   ad=oadetector->get_object()
   oimage->correlate, ad, img2, 0.1
   obj_destroy,oimage2
   plot_image, oimage

   ;el=load_peak_tables()
   ;re=file_info(out_dir+res.name0+'.pks')
   ;if el eq 1 and re.exists then $
   ;begin
     ;opt->read_object_from_file, out_dir+res.name0+'.pks'
     ;update_peakno, opt->peakno()
     ;print_peak_list, opt, wid_list_3
     ;plot_peaks, draw0, opt, arr1, arr2
   ;end
    om=read_settings_file(dir+res.name0+'.txt')
    if not(om[0] eq -100 and om[1] eq -100) then $
    begin
     widget_control, wid_text_16, set_value=string(om[0], format='(F6.1)')
     widget_control, wid_text_20, set_value=string(om[1], format='(F6.1)')
     widget_control, wid_text_21, set_value=string(om[2], format='(F6.1)')
    endif
  endif
 end
  'Correlate':$
 ;'SubtrImg':$
 begin
   fna=dialog_pickfile(/read, filter=['*.mar3450','*.mar2300', '*.tiff', '*.tif'], path=dir, get_path=dir)
  if fna ne '' then $
  begin
   oimage2=obj_new('adimage_CLASS')
   oimage2->set_detector_format, imt
   oimage2->load_image, fna, oadetector
   img2=oimage2->get_object()
   img1=oimage->get_object()
   img1.img=img1.img-img2.img+100.
   oimage->set_object, img1
   obj_destroy,oimage2
   plot_image, oimage
   ;el=load_peak_tables()
   ;re=file_info(out_dir+res.name0+'.pks')
   ;if el eq 1 and re.exists then $
   ;begin
     ;opt->read_object_from_file, out_dir+res.name0+'.pks'
     ;update_peakno, opt->peakno()
     ;print_peak_list, opt, wid_list_3
     ;plot_peaks, draw0, opt, arr1, arr2
   ;end
    om=read_settings_file(dir+res.name0+'.txt')
    if not(om[0] eq -100 and om[1] eq -100) then $
    begin
     widget_control, wid_text_16, set_value=string(om[0], format='(F6.1)')
     widget_control, wid_text_20, set_value=string(om[1], format='(F6.1)')
     widget_control, wid_text_21, set_value=string(om[2], format='(F6.1)')
    endif
  endif

 end

'AddImg':$
begin
   fna=dialog_pickfile(/read, filter=['*.mar3450','*.mar2300', '*.tiff', '*.tif'], path=dir, get_path=dir)
  if fna ne '' then $
  begin
   oimage2=obj_new('adimage_CLASS')
   oimage2->set_detector_format, imt
   oimage2->load_image, fna, oadetector
   img2=oimage2->get_object()
   img1=oimage->get_object()
   img1.img=img1.img+img2.img
   oimage->set_object, img1
   obj_destroy,oimage2
   plot_image, oimage
   ;el=load_peak_tables()
   ;re=file_info(out_dir+res.name0+'.pks')
   ;if el eq 1 and re.exists then $
   ;begin
     ;opt->read_object_from_file, out_dir+res.name0+'.pks'
     ;update_peakno, opt->peakno()
     ;print_peak_list, opt, wid_list_3
     ;plot_peaks, draw0, opt, arr1, arr2
   ;end
    om=read_settings_file(dir+res.name0+'.txt')
    if not(om[0] eq -100 and om[1] eq -100) then $
    begin
     widget_control, wid_text_16, set_value=string(om[0], format='(F6.1)')
     widget_control, wid_text_20, set_value=string(om[1], format='(F6.1)')
     widget_control, wid_text_21, set_value=string(om[2], format='(F6.1)')
    endif
  endif

 end
 'SaveImg':$
 begin
  fna=dialog_pickfile(/write, filter=['*.mar3450','*.mar2300', '*.tiff', '*.tif'], path=dir, get_path=dir, default_extension='tif')
  if fna ne '' then $
  begin
   img=oimage->get_object()
   write_tiff, fna, reverse(img.img,2), /long
  endif
 end
 'Colors':$
 begin
  xloadct,GROUP=ev.top, /MODAL
  free_lun, 2
  openw, 2, 'colors.ct'
  TVLCT, V1, V2, V3, /get
  printf, 2 , V1
  printf, 2 , V2
  printf, 2 , V3
  close, 2
  free_lun, 2
  plot_image, oimage
   ;el=load_peak_tables()
   ;re=file_info(out_dir+res.name0+'.pks')
   ;if el eq 1 and re.exists then $
   ;begin
;     opt->read_object_from_file, out_dir+res.name0+'.pks'
     ;update_peakno, opt->peakno()


     ;plot_peaks, draw0, opt, arr1, arr2
   ;end
 end
 'PS':$; ---- Peak search
 begin
   if test_write(out_dir) eq 1 then $
   begin
    opt->initialize
    plot_image, oimage
    pn=PS(0.0,3, prog=1)
    update_peakno, opt->peakno()
    plot_image, oimage
    plot_peaks, draw0, opt, arr1, arr2
    print_peak_list, opt, wid_list_3
   endif else re=Dialog_message('You do not have write permission for the output directory. Please, select a different directory.')

 end

'PS Series':$; ---- Peak search for series of images
 begin
   if test_write(dir) eq 1 then $
   begin
    lp=PS_Series()
    if lp[0] eq 0 then merge_peak_tables_in_series
   endif
 end


'PS Series Pilatus 1M':$
begin
  fil='f:\refined_cell_parametersO.txt'
  get_lun, ln
  openw, ln, fil
  printf, ln, ''
  close, ln
  free_lun, ln

  fil2='f:\refined_cell_parametersC.txt'
  get_lun, ln
  openw, ln, fil2
  printf, ln, ''
  close, ln
  free_lun, ln


  fil1='f:\file_names.txt'
  get_lun, ln
  openw, ln, fil1
  printf, ln, ''
  close, ln
  next=1
  fn=generate_fname(res)
  b=strpos(fn, '_P0')
  l=strlen(fn)
  cc=strmid(fn, 0, b+2)
  dd=strmid(fn, b+6, l-(b+7-4))
  print, fn
  print, cc
  print, dd

  for i=0, 300 do $
  begin
    t0=systime(/seconds)
    name=cc+string(i, format='(I04)')+dd
    re=file_info(name)
    res=analyse_fname(name, '', 3)
    f0=find_series_start(res)
    f1=find_series_end(res)
    print, name, re.exists, f0, f1
    if (re.exists eq 1) and (f0 eq 1) and (f1 eq 68) then $
    begin
     lp=PS_Series()

     get_lun, ln
     openu, ln, fil, /append
     printf, ln, lp[*,0]
     close, ln
     free_lun, ln

     get_lun, ln
     openu, ln, fil2, /append
     printf, ln, lp[*,1]
     close, ln
     free_lun, ln

     t1=systime(/seconds)
     get_lun, ln
     openu, ln, fil1, /append
     printf, ln, name+string(opt->peakno(), format='(I6)')+string(t1-t0, format='(F10.2)')
     close, ln
     free_lun, ln

    endif
  endfor
 print, '------------------------- FINISHED ----------------------------'

end

 '->':$
 begin
     if res.name0 ne '' and res.seq+1 le f1 then $
     begin
       res.seq=res.seq+1
       fn=generate_fname(res)
       res=analyse_fname(fn, dir, 3)
       widget_control, wid_text_17, set_value=res.name0
       widget_control, wid_text_9, set_value=res.name0
       oimage->load_image, fn, oadetector
       check_mask_file

       om=read_settings_file(dir+res.name0+'.txt')
       if not(om[0] eq -100 and om[1] eq -100) then $
       begin
        print, om
        widget_control, wid_text_16, set_value=string(om[0], format='(F6.1)')
        widget_control, wid_text_20, set_value=string(om[1], format='(F6.1)')
        widget_control, wid_text_21, set_value=string(om[2], format='(F6.1)')
       endif
       ; Dynamic mask
       if  dynamic_mask_on() then $
       begin
        t1=SYSTIME(/SECONDS )
        ;*************************************
		  mydll='AD_image8.dll'
 		  re=file_info(mydll)
 		  if re.exists eq 1 then $
 		  begin
           ad=oadetector->get_object()
 		   beamxy=[double(ad.beamX),double(ad.beamY)]
    	   tiltmtx=oadetector->tilt_mtx()
 	       psize=[double(ad.psizeX),double(ad.psizeY)]
           nopix=[Long(ad.nopixX),Long(ad.nopixY)]
           dist=double(ad.dist)
           kath=read_kappa_and_ttheta()
           status=call_external(mydll, 'IDL_dynamic_mask', maskarr, DIST, beamxy, nopix, tiltMtx, psize, double(kath[1]),double(om[0]+90.0),double(get_dac_opening()))
           write_tiff, out_dir+res.name0+'.msk', maskarr

          endif else re=dialog_message('DLL library not found',/message)
        ;*************************************
        ; oadetector->visible_mask, maskarr, [0,0,0,om[0]+90.,0,0], 30., wv
        t2=SYSTIME(/SECONDS )
        print, 'Time for computing mask = ', t2-t1
              endif

       plot_image, oimage

;-----------------
  re=WIDGET_INFO(WID_BUTTON_33a, /BUTTON_SET) ; max filter
  if re eq 1 then $
  begin
   WIDGET_CONTROL, WID_TEXT_46a, GET_VALUE=a
   a=float(a)
   a=a[0]
   im=oimage->get_object()
   w=where(im.img gt a)
   if w[0] ne -1 then maskarr[w]=0
   plot_image, oimage
   ys=long(w/arr1)
   xs=w-ys*arr1
   wset, draw0
   device, decomposed=1
   for i=0L, n_elements(xs)-1 do $
   plots, xs[i]/float(arr1), ys[i]/float(arr2), color='FF0000'XL, /normal, psym=2, symsize=0.5
   device, decomposed=0

  endif
;-----------------

   el=load_peak_tables()
   re=file_info(out_dir+res.name0+'.pks')
   if el eq 1 and re.exists then $
   begin
     opt->read_object_from_file, out_dir+res.name0+'.pks'
     update_peakno, opt->peakno()
     plot_peaks, draw0, opt, arr1, arr2
     peaktable_file=out_dir+res.name0+'.pks'
    end
    plot_peaks, draw0, opt, arr1, arr2

   end
 end
  '<-':$
 begin
     if res.name0 ne '' and res.seq-1 ge f0 then $
     begin
       res.seq=res.seq-1
       fn=generate_fname(res)
       res=analyse_fname(fn, dir, 3)
       widget_control, wid_text_17, set_value=res.name0
       widget_control, wid_text_9, set_value=res.name0
       oimage->load_image, fn, oadetector
       check_mask_file
       om=read_settings_file(dir+res.name0+'.txt')
       if not(om[0] eq -100 and om[1] eq -100) then $
       begin
        widget_control, wid_text_16, set_value=string(om[0], format='(F6.1)')
        widget_control, wid_text_20, set_value=string(om[1], format='(F6.1)')
        widget_control, wid_text_21, set_value=string(om[2], format='(F6.1)')
       endif
       ; Dynamic mask
       if  dynamic_mask_on() then $
       begin
        t1=SYSTIME(/SECONDS )
        ;*************************************
		  mydll='AD_image8.dll'
 		  re=file_info(mydll)
 		  if re.exists eq 1 then $
 		  begin
           ad=oadetector->get_object()
 		   beamxy=[double(ad.beamX),double(ad.beamY)]
    	   tiltmtx=oadetector->tilt_mtx()
 	       psize=[double(ad.psizeX),double(ad.psizeY)]
           nopix=[Long(ad.nopixX),Long(ad.nopixY)]
           dist=double(ad.dist)
           kath=read_kappa_and_ttheta()
           status=call_external(mydll, 'IDL_dynamic_mask', maskarr, DIST, beamxy, nopix, tiltMtx, psize, double(kath[1]),double(om[0]+90.0),double(get_dac_opening()))
          endif else re=dialog_message('DLL library not found',/message)
        ;*************************************
        t2=SYSTIME(/SECONDS )
        print, 'Time for computing mask = ', t2-t1
       endif
              plot_image, oimage

;-----------------
  re=WIDGET_INFO(WID_BUTTON_33a, /BUTTON_SET) ; max filter
  if re eq 1 then $
  begin
   WIDGET_CONTROL, WID_TEXT_46a, GET_VALUE=a
   a=float(a)
   a=a[0]
   im=oimage->get_object()
   w=where(im.img gt a)
   if w[0] ne -1 then maskarr[w]=0
   plot_image, oimage
   ys=long(w/arr1)
   xs=w-ys*arr1
   wset, draw0
   device, decomposed=1
   for i=0L, n_elements(xs)-1 do $
   plots, xs[i]/float(arr1), ys[i]/float(arr2), color='FF0000'XL, /normal, psym=2, symsize=0.5
   device, decomposed=0

  endif
;-----------------

   el=load_peak_tables()
   re=file_info(out_dir+res.name0+'.pks')
   if el eq 1 and re.exists then $
   begin
     opt->read_object_from_file, out_dir+res.name0+'.pks'
     update_peakno, opt->peakno()
     plot_peaks, draw0, opt, arr1, arr2
     peaktable_file=out_dir+res.name0+'.pks'
   end
    ;    plot_peaks, draw0, opt, arr1, arr2

    ;   om=read_settings_file(dir+res.name0+'.txt')
    ;if not(om[0] eq -100 and om[1] eq -100) then $
    ;begin
     ;widget_control, wid_text_16, set_value=string(om[0], format='(F6.1)')
     ;widget_control, wid_text_20, set_value=string(om[1], format='(F6.1)')
     ;widget_control, wid_text_21, set_value=string(om[2], format='(F6.1)')
;endif

     end
 end
 'Open calibration':$
 begin
   fn=dialog_pickfile(/read,filter='*.cal', path=out_dir)
   if fn ne '' then $
   load_cal, fn, oadetector, wv
   print_calibration, oadetector, wv
   save_cal, 'last_calibration.cal', oadetector, wv
 end
 'Save calibration':$
 begin
   outfileTmp = res.base+'.cal'
   ;stop
   fn=dialog_pickfile(/write, filter='*.cal', File=outfileTmp, DEFAULT_EXTENSION='.cal') ;, path=out_dir)
   if fn ne '' then $
   begin
    capture_calibration, oadetector, wv
    save_cal, fn, oadetector, wv
    save_cal, 'last_calibration.cal', oadetector, wv
   end
 end

 'Stop series search':$
  begin

  end
 'Merge peak tables':$
  begin
   merge_peak_tables_in_series
  end
 'Read UB matrix':$
  begin
     fname=dialog_pickfile(FILTER='*.ub', /READ, path=out_dir)
     if fname ne '' then $
     begin
        UB=open_UB(fname)
        lp=lp_from_ub(ub)
        print_UB_and_lp, ub,lp,wid_list_2, opt
     end
  end

 'Predict whole series' :$
 begin
   ;---- check if there is a ub mtx
   if max(ub) ne 0 then $
   begin
     widget_control, Wid_Image_simulation->wid_text_14(), get_value=DAC_open

 	 cgProgressBar = Obj_New("CGPROGRESSBAR", /Cancel)
 	 cgProgressBar -> Start
     if res.name0 ne '' then $
     begin
        widget_control, wid_text_7, get_value=i0
        widget_control, wid_text_6, get_value=ni
        ni=fix(ni)
        i0=fix(i0)
    	res.seq=i0[0]
    	fn=generate_fname(res)
    	res=analyse_fname(fn, dir, 3)
        for i=0, ni[0]-1 do $
   		begin
    		res.seq=i0[0]+i
    		fn=generate_fname(res)
    		res=analyse_fname(fn, dir, 3)
        	oimage->load_image, fn, oadetector
        	check_mask_file
        	om=read_settings_file(dir+res.name0+'.txt')
        	pt_file=dir+res.name0+'.pks'
        	if not(om[0] eq -100 and om[1] eq -100) then $
        	begin
         		widget_control, wid_text_16, set_value=string(om[0], format='(F6.1)')
         		widget_control, wid_text_20, set_value=string(om[1], format='(F6.1)')
         		widget_control, wid_text_21, set_value=string(om[2], format='(F6.1)')
        	endif
     		generate_mono, om[0],om[1],dac_open, Wid_Image_simulation->Bravais_type(), write=0, check_overwrite=0, del_selected=1

     		plot_image, oimage
     		update_peakno, opt->peakno()
     		plot_peaks, draw0, opt, arr1, arr2
     		print_peak_list, opt, wid_list_3

            ;---- filter observed

  			a=oimage->calculate_local_background(0)
  			widget_control, wid_text_48, get_value=obs
  			obs=float(obs)
  			opt->unselect_all
  			pt=opt->get_object()
  			for pn=0, opt->peakno()-1 do $
  			begin
  				bs=[long(pt.peaks[pn].intssd[0]),long(pt.peaks[pn].intssd[0])]
    			xy=pt.peaks[pn].detXY
 	 			bs=[2,2]
         		pic=oimage->get_zoomin(XY, bs, maskarr)
    			med=median(pic)
    			if (max(pic)-med)  lt obs then opt->select_peak, pn
  			endfor

     		plot_image, oimage
     		update_peakno, opt->peakno()
     		plot_peaks, draw0, opt, arr1, arr2
     		print_peak_list, opt, wid_list_3
  			opt->delete_selected
     		plot_image, oimage
     		update_peakno, opt->peakno()
     		plot_peaks, draw0, opt, arr1, arr2
     		print_peak_list, opt, wid_list_3

			;---- fit peaks

   			fit_all_peaks, prog=0
   			print_peak_list, opt, wid_list_3
   			plot_image, oimage
   			plot_peaks, draw0, opt, arr1, arr2
   			update_peakno, opt->peakno()
  			opt->delete_selected

            ; filter one more time
 			pt=opt->get_object()
  			for pn=0, opt->peakno()-1 do $
  			begin
  				bs=[long(pt.peaks[pn].intssd[0]),long(pt.peaks[pn].intssd[0])]
    			xy=pt.peaks[pn].detXY
 	 			bs=[2,2]
         		pic=oimage->get_zoomin(XY, bs, maskarr)
    			med=median(pic)
    			if (max(pic)-med)  lt obs then opt->select_peak, pn
  			endfor

  			opt->delete_selected
  			opt->write_object_to_file, pt_file
     		plot_image, oimage
     		update_peakno, opt->peakno()
     		plot_peaks, draw0, opt, arr1, arr2
     		print_peak_list, opt, wid_list_3



             IF cgProgressBar -> CheckCancel() THEN BEGIN
                ok = Dialog_Message('Operation canceled')
                cgProgressBar -> Destroy
                RETURN
             ENDIF
             cgProgressBar -> Update, (float(i)/(ni[0]-1))*100.0

   		endfor
        cgProgressBar -> Destroy
        merge_peak_tables_in_series
        print_R_int, Rint(get_laue_class(), opt)
        re=dialog_message('Whole series peak prediction completed')
  	 endif
   end else re=dialog_message('UB matrix has not yet been defined')

 end


 'Pick image directory':$
  begin
    fn=dialog_pickfile(/directory, path=dir, get_path=dira)
    if dira ne '' then $
    begin
      dir=dira
      widget_control, wid_text_28, set_value=dira
      save_last_directories
    end
  end
 'Pick output directory':$
  begin
    fn=dialog_pickfile(/directory, path=out_dir, get_path=out_dira)
    if out_dira ne '' then $
    begin
     out_dir=out_dira
     widget_control, wid_text_29, set_value=out_dir
     save_last_directories
    end

  end
  ;'Load peak tables' :$
  ;begin
     ;if load_peak_tables() eq 1 then $
     ;begin
       ;if out_dir eq '' then $
       ;begin
         ;r=dialog_message('Select output directory first')
         ;widget_control, wid_button_20, set_button=0
       ;end
     ;end
  ;end
 'Open PT':$
 begin
   fn=dialog_pickfile(/read, filter='*.pks', path=out_dir)
   if fn ne '' then $
   begin
      opt->read_object_from_file, fn
      bx=read_box_size(wid_text_37,wid_text_37)
      opt->set_zero_peak_box_size, bx
      ;opt->set_peak_box_size, bx[0]
      update_peakno, opt->peakno()
      plot_peaks, draw0, opt, arr1, arr2
      print_peak_list, opt, wid_list_3
      print_R_int, Rint(get_laue_class(), opt)
      peaktable_file=fn
   end
 end

 'Update PT':$
   begin
      if peaktable_file ne '' then opt->write_object_to_file, peaktable_file
       re=dialog_message('Peak table has been updated')
   end
 'Reload PT':$
   begin
      re=file_info(peaktable_file)
      if re.exists eq 1 then $
      begin
       opt->read_object_from_file, peaktable_file
       update_peakno, opt->peakno()
       plot_peaks, draw0, opt, arr1, arr2
       print_peak_list, opt, wid_list_3
       re=dialog_message('Peak table has been reloaded')
      end
   end

 'Save PT':$
 begin
   ty=omega_or_energy()
   if ty eq 1 then $
   begin
     opt->set_energy, a_to_kev(wv)
   end
   fn=dialog_pickfile(/write, filter='*.pks', DEFAULT_EXTENSION='.pks', path=out_dir)
   if fn ne '' then opt->write_object_to_file, fn, 1
   peaktable_file=fn
 end
'Generate peaks':$
 begin
  opt->zero
  read_predict_settings, pred
  oadetector->generate_all_peaks, ub, opt, wv, pred
  update_peakno, opt->peakno()
  plot_peaks, draw0, opt, arr1, arr2
  ;WID_peakfit2d_L
  print_peak_list, opt, wid_list_3

 end
 'Clear peaktable':$
 begin
   re=dialog_message('Are you sure?', /question)
   if re eq 'yes' or re eq 'Yes' then $
   begin
    opt->zero
    plot_image, oimage
    print_peak_list, opt, wid_list_3
   end

 end
  'Imax':$
 begin
   isc=read_color_scale()
   plot_image, oimage
   ;el=load_peak_tables()
   ;re=file_info(out_dir+res.name0+'.pks')
   ;if el eq 1 and re.exists then $
   ;begin
;     opt->read_object_from_file, out_dir+res.name0+'.pks'
 ;    update_peakno, opt->peakno()
  ;   plot_peaks, draw0, opt, arr1, arr2
   ;end
 end
 'Imin':$
 begin
   widget_control, wid_text_24, get_value=imax
   widget_control, wid_text_25, get_value=imin
   imax=long(imax)
   imin=long(imin)
   imax=imax[0]
   imin=imin[0]
   im=oimage->get_object()
   data1=congrid(im.img[0:arr1-1,0:arr2-1], 600,600)
   data1=data1<imax
   data1=data1>imin
   wset, draw0
   tvscl, data1, true=0
;   el=load_peak_tables()
 ;  re=file_info(out_dir+res.name0+'.pks')
  ; if el eq 1 and re.exists then $
   ;begin
     ;opt->read_object_from_file, out_dir+res.name0+'.pks'
     ;update_peakno, opt->peakno()
     ;plot_peaks, draw0, opt, arr1, arr2
   ;end
 end


 ;------------------
 'Cake':$
 begin
    capture_calibration, oadetector, wv
    npointst=800
    npointsc=300
    Int=oimage->calculate_cake(oadetector, npointst,npointsc,[double(0),double(30)], [double(-180.),double(180.)])
    oimage->replace_image,congrid(Int[*,*], arr1,arr2)
    plot_image, oimage
 end;
 ;------------------
 'Integrate chi1':$
 begin
   capture_calibration, oadetector, wv
   npoints=2000
   time0= SYSTIME(/SECONDS)
   ;Int=oimage->integrate(oadetector, 1500, [1.,30.])
   x1=[0,0]
   x2=[0,arr2]
   x3=[arr1,0]
   x4=[arr1,arr2]

   x5=[arr1/2,0]
   x6=[arr1/2,arr2]
   x7=[0,arr2/2]
   x8=[arr1,arr2/2]

   an=read_kappa_and_ttheta()
   gonio=fltarr(6)
   gonio[1]=an[1]

   aa=    [oadetector->calculate_tth_from_pixels(x1,gonio),$
           oadetector->calculate_tth_from_pixels(x2,gonio),$
           oadetector->calculate_tth_from_pixels(x3,gonio),$
           oadetector->calculate_tth_from_pixels(x4,gonio), $
           oadetector->calculate_tth_from_pixels(x5,gonio),$
           oadetector->calculate_tth_from_pixels(x6,gonio),$
           oadetector->calculate_tth_from_pixels(x7,gonio),$
           oadetector->calculate_tth_from_pixels(x8,gonio)]

   m1=min(aa)
   m2=max(aa)
   m1=0
   re=widget_info(wid_button_11, /button_set)
   if re eq 1 then $
   Int=oimage->integrate_dll(oadetector, 2500.000, [double(m1),double(m2)], maskarr) else $
   Int=oimage->integrate_dll_chi(oadetector, 360., [double(-180.),double(180.)])
   zeroref=Int
   time1= SYSTIME(/SECONDS)
   print, 'DLL_integration: Computation time: ', (time1-time0)
   fnc=dialog_pickfile(/write,filter='*.chi', default_extension='chi', path=out_dir)
   n=n_elements(int)/2

    ;Int=oimage->integrate(oadetector, 1500., [double(m1),double(m2)])
    ;int=transpose(int)

   wset, wid_draw_6
   plot, int[0,0:n-1],int[1,0:n-1]
   write_data_to_chi, fnc, Int

 end

'Refine Pilatus':$
 begin


;---------------------
; Prepare X and Y arrays

   widget_control, wid_text_6, get_value=ni
   widget_control, wid_text_7, get_value=i0
   widget_control, wid_text_4, get_value=om0
   widget_control, wid_text_5, get_value=omD
   i0=fix(i0)
   ni=fix(ni)
   om0=float(om0)
   omD=float(omD)
   ds=which_calibrant(200., 1)
   tths=tth_from_en_and_d(A_to_keV(wv), ds)
   peaks_in_imagesImn=Intarr(500)
   peaks_in_imagesTTh=Fltarr(500)
   peaks_in_imagesNum=0L
   gonio=fltarr(6)
   x1=[0,0]
   x2=[0,arr2]
   x3=[arr1,0]
   x4=[arr1,arr2]

  for ih=0, ni[0]-1 do $ ;--- go through images
  begin
   gonio[1]=om0+ih*omD
   widget_control, wid_text_36b, set_value=string(gonio[1], format='(F10.2)')
   capture_calibration, oadetector, wv
   aa=    [oadetector->calculate_tth_from_pixels(x1,gonio),$
           oadetector->calculate_tth_from_pixels(x2,gonio),$
           oadetector->calculate_tth_from_pixels(x3,gonio),$
           oadetector->calculate_tth_from_pixels(x4,gonio)]
   m11=min(aa)
   m12=max(aa)
   w1=where(tths gt m11)
   w2=where(tths[w1] lt m12)
   if w2[0] ne -1 then w=w1[w2] else w=-1
   if w[0] ne -1 then $
   begin
    t1=tths[w]
    nt=n_elements(t1)
    peaks_in_imagesImn[peaks_in_imagesNum:peaks_in_imagesNum+nt-1]=ih
    peaks_in_imagesTTh[peaks_in_imagesNum:peaks_in_imagesNum+nt-1]=t1
    peaks_in_imagesNum=peaks_in_imagesNum+nt
   endif
  endfor

;---------------------

err=fltarr(peaks_in_imagesNum)
err[*]=1.0
peaks_in_imagesTTh=peaks_in_imagesTTh[0:peaks_in_imagesNum-1]
peaks_in_imagesImn=peaks_in_imagesImn[0:peaks_in_imagesNum-1]

ad=oadetector->get_object()
P0=fltarr(8)
  P0[0]   = ad.dist
  P0[1]   = ad.beamx
  P0[2]   = ad.beamy
  P0[3]   = ad.angle
  P0[4]   = ad.tiltom
  P0[5]   = ad.tiltch
  P0[6]   = wv
  P0[7]   = 10.0

b0=PILAT(P0, X=peaks_in_imagesImn, Y=peaks_in_imagesTTh, ERR=err)

  parinfo = replicate({value:0.D, fixed:0, limited:[0,0], $
                       limits:[0.D,0], tied:''}, 8)

  parinfo[*].value=P0

  parinfo[3].value=0.0
  parinfo[3].fixed=0
  parinfo[6].fixed=1
  parinfo[1].fixed=0

  fa = {X:peaks_in_imagesImn, Y:peaks_in_imagesTTh, ERR:err}

  p = mpfit('PILAT', p0, functargs=fa ,PERROR=PE, PARINFO=parinfo, BESTNORM=bestnorm)

  if n_elements(p) ne 0 then $
  begin
   DOF     = N_ELEMENTS(peaks_in_imagesImn) - N_ELEMENTS(P) ; deg of freedom
   PCERROR = PE * SQRT(BESTNORM / DOF)   ; scaled uncertainties
   print,P
   print,PCERROR
  endif


;---------------------------------------------------------------

end

 'Refine Pilatus1':$
 begin


;---------------------

   widget_control, wid_text_6, get_value=ni
   widget_control, wid_text_7, get_value=i0
   widget_control, wid_text_4, get_value=om0
   widget_control, wid_text_5, get_value=omD
   i0=fix(i0)
   ni=fix(ni)
   om0=float(om0)
   omD=float(omD)

;--- refine distance
   D0=400.0
   D1=600.0
   dD=D1-D0
   iD=(D1-D0)/100.0
   scores=fltarr(100,2)
   scoresT=fltarr(100,2)
   x1=[0,0]
   x2=[0,arr2]
   x3=[arr1,0]
   x4=[arr1,arr2]
   gonio=fltarr(6)
   an=read_kappa_and_ttheta()


  for ih=0, ni[0]-1 do $
  begin

   gonio[1]=om0+ih*omD
   widget_control, wid_text_36b, set_value=string(gonio[1], format='(F10.2)')
   ;---------------
   res.seq=i0+ih
   fn=generate_fname(res)
   res=analyse_fname(fn, dir, 3)
   widget_control, wid_text_9, set_value=res.name0
   oimage->load_image, fn, oadetector
   check_mask_file
   plot_image, oimage
   scale1=arr1/600.
   scale2=arr2/600.
   ds=which_calibrant(200., 1)
   tths=tth_from_en_and_d(A_to_keV(wv), ds)
   for i=0, n_elements(tths)-2 do $
   plot_ds_ring, tths[i], scale1, scale2, 0
   plot_ds_ring, tths[n_elements(tths)-1], scale1, scale2, 0

 for i=0, 99 do $
 begin
   dist=D0+iD*i
   widget_control, wid_text_33, set_value=string(dist)
   capture_calibration, oadetector, wv
   aa=    [oadetector->calculate_tth_from_pixels(x1,gonio),$
           oadetector->calculate_tth_from_pixels(x2,gonio),$
           oadetector->calculate_tth_from_pixels(x3,gonio),$
           oadetector->calculate_tth_from_pixels(x4,gonio)]

   m11=min(aa)
   m12=max(aa)
   w1=where(tths gt m11)
   w2=where(tths[w1] lt m12)
   if w2[0] ne -1 then w=w1[w2] else w=-1
   if w[0] ne -1 then $
   begin
   t1=tths[w]
   nt=n_elements(t1)
   l=intarr(nt)

   Int1=oimage->integrate_dll(oadetector, 500.000, [double(m11),double(m12)], maskarr)


   for j=0, nt-1 do $
   begin
     x=min(abs(int1[0,*]-t1[j]),a)
     l[j]=a
   endfor
   scores[i,0]=dist
   scores[i,1]=total(int1[1,l[*]])
  ; print, int1[0,l[*]]
   endif
 endfor
 scoresT[*,0]=scores[*,0]
 scoresT[*,1]=scoresT[*,1]+scores[*,1]

endfor ;ih

 plot, scoresT[*,0], scoresT[*,1]
 b=max(scoresT[*,1],kk)
 dist=scoresT[kk,0]
   scores=fltarr(100,2)
   scoresT=fltarr(100,2)
;---------------------------------------------------------------
;---------------------------------------------------------------
 D0=dist-iD
 D1=dist+iD
 dD=D1-D0
 iD=(D1-D0)/100.0


  for ih=0, ni[0]-1 do $
  begin

   gonio[1]=om0+ih*omD
   widget_control, wid_text_36b, set_value=string(gonio[1], format='(F10.2)')
   ;---------------
   res.seq=i0+ih
   fn=generate_fname(res)
   res=analyse_fname(fn, dir, 3)
   widget_control, wid_text_9, set_value=res.name0
   oimage->load_image, fn, oadetector
   check_mask_file
   plot_image, oimage
   scale1=arr1/600.
   scale2=arr2/600.
   ds=which_calibrant(200., 1)
   tths=tth_from_en_and_d(A_to_keV(wv), ds)
   for i=0, n_elements(tths)-2 do $
   plot_ds_ring, tths[i], scale1, scale2, 0
   plot_ds_ring, tths[n_elements(tths)-1], scale1, scale2, 0

 for i=0, 99 do $
 begin
   dist=D0+iD*i
   widget_control, wid_text_33, set_value=string(dist)
   capture_calibration, oadetector, wv
   aa=    [oadetector->calculate_tth_from_pixels(x1,gonio),$
           oadetector->calculate_tth_from_pixels(x2,gonio),$
           oadetector->calculate_tth_from_pixels(x3,gonio),$
           oadetector->calculate_tth_from_pixels(x4,gonio)]

   m11=min(aa)
   m12=max(aa)
   w1=where(tths gt m11)
   w2=where(tths[w1] lt m12)
   if w2[0] ne -1 then w=w1[w2] else w=-1
   if w[0] ne -1 then $
   begin
   t1=tths[w]
   nt=n_elements(t1)
   l=intarr(nt)

   Int1=oimage->integrate_dll(oadetector, 500.000, [double(m11),double(m12)], maskarr)


   for j=0, nt-1 do $
   begin
     x=min(abs(int1[0,*]-t1[j]),a)
     l[j]=a
   endfor
   scores[i,0]=dist
   scores[i,1]=total(int1[1,l[*]])
  ; print, int1[0,l[*]]
   endif
 endfor
 scoresT[*,0]=scores[*,0]
 scoresT[*,1]=scoresT[*,1]+scores[*,1]

endfor ;ih

 plot, scoresT[*,0], scoresT[*,1]
 b=max(scoresT[*,1],kk)
 dist=scoresT[kk,0]
 widget_control, wid_text_33, set_value=string(dist)
 capture_calibration, oadetector, wv


 end

 'Refine Pilatus1':$
 begin
   ; define table with detector angles
   angles=[14.4, 19.2, 24.0, 28.8]
   ; define table with image names
   nnames=['CeO2_007.tif',$
           'CeO2_008.tif',$
           'CeO2_009.tif',$
           'CeO2_010.tif']
   ;---- use just two images

   x1=[0,0]
   x2=[0,arr2]
   x3=[arr1,0]
   x4=[arr1,arr2]
   an=read_kappa_and_ttheta()
   gonio=fltarr(6)


   fn=dir+nnames[0]
   detangle=angles[0]
   gonio[1]=detangle
   widget_control, wid_text_36b, set_value=string(detangle)
   capture_calibration, oadetector, wv
   ;-------------------
   oimage->load_image, fn, oadetector

   aa=    [oadetector->calculate_tth_from_pixels(x1,gonio),$
           oadetector->calculate_tth_from_pixels(x2,gonio),$
           oadetector->calculate_tth_from_pixels(x3,gonio),$
           oadetector->calculate_tth_from_pixels(x4,gonio)]

   m11=0
   m12=max(aa)
   Int1=oimage->integrate_dll(oadetector, 500.000, [double(m11),double(m12)], maskarr)
   ;--------------------

   fn=dir+nnames[1]
   detangle=angles[1]
   gonio[1]=detangle
   widget_control, wid_text_36b, set_value=string(detangle)
   capture_calibration, oadetector, wv
   ;-------------------
   oimage->load_image, fn, oadetector
      aa=    [oadetector->calculate_tth_from_pixels(x1,gonio),$
           oadetector->calculate_tth_from_pixels(x2,gonio),$
           oadetector->calculate_tth_from_pixels(x3,gonio),$
           oadetector->calculate_tth_from_pixels(x4,gonio)]

   m21=0
   m22=max(aa)
   Int2=oimage->integrate_dll(oadetector, 500.000, [double(m21),double(m22)], maskarr)
   ;--------------------

   fn=dir+nnames[2]
   detangle=angles[2]
   gonio[1]=detangle
   widget_control, wid_text_36b, set_value=string(detangle)
   capture_calibration, oadetector, wv
   ;-------------------
   oimage->load_image, fn, oadetector
      aa=    [oadetector->calculate_tth_from_pixels(x1,gonio),$
           oadetector->calculate_tth_from_pixels(x2,gonio),$
           oadetector->calculate_tth_from_pixels(x3,gonio),$
           oadetector->calculate_tth_from_pixels(x4,gonio)]

   m31=0
   m32=max(aa)
   Int3=oimage->integrate_dll(oadetector, 500.000, [double(m31),double(m32)], maskarr)
   ;--------------------
   fn=dir+nnames[3]
   detangle=angles[3]
   gonio[1]=detangle
   widget_control, wid_text_36b, set_value=string(detangle)
   capture_calibration, oadetector, wv
   ;-------------------
   oimage->load_image, fn, oadetector
      aa=    [oadetector->calculate_tth_from_pixels(x1,gonio),$
           oadetector->calculate_tth_from_pixels(x2,gonio),$
           oadetector->calculate_tth_from_pixels(x3,gonio),$
           oadetector->calculate_tth_from_pixels(x4,gonio)]

   m41=0
   m42=max(aa)
   Int4=oimage->integrate_dll(oadetector, 500.000, [double(m41),double(m42)], maskarr)

   ;--------------------
   wset, draw0;wid_draw_6
   device, decomposed=1
   n=500


   ; resample and calculate difference between 14 and 20

   x0=m21
   x1=m12
   X=fltarr(1000)
   for i=0, 999 do x[i]=x0+i*(x1-x0)/1000.
   i1a=spline(int1[0,0:n-1],int1[1,0:n-1], X)
   i2a=spline(int2[0,0:n-1],int2[1,0:n-1], X)


   x0=m31
   x1=m22
   Xa=fltarr(1000)
   for i=0, 999 do xa[i]=x0+i*(x1-x0)/1000.
   i1b=spline(int2[0,0:n-1],int2[1,0:n-1], Xa)
   i2b=spline(int3[0,0:n-1],int3[1,0:n-1], Xa)

   x0=m41
   x1=m32
   Xb=fltarr(1000)
   for i=0, 999 do xb[i]=x0+i*(x1-x0)/1000.
   i1c=spline(int3[0,0:n-1],int3[1,0:n-1], Xb)
   i2c=spline(int4[0,0:n-1],int4[1,0:n-1], Xb)



   plot, [x,xa,xb],   [i1a,i1b,i1c], color='00ff00'xl
   oplot,[x,xa,xb],   [i2a,i2b,i1c], color='ff00ff'xl
   oplot,[x,xa,xb],   [i1a-i2a,i1b-i2b,i1c-i2c], color='f2002f'xl



 end

 'Close':$
 begin
   ;Class_adetector
   save_cal, 'last_calibration.cal', oadetector, wv
   obj_destroy, oadetector
   obj_destroy, opt
   obj_destroy, oimage
   obj_destroy, ops
   ;************************** NEW CODE ***********************
   if SIM_open eq 1 then wid_sim->destroy
   obj_destroy, wid_sim
   ;************************** NEW CODE ***********************
   WIDGET_CONTROL, ev.top, /destroy
   ;WIDGET_CONTROL, WID_Image_simulation, /destroy
   ;obj_destroy, WID_Image_simulation;
 end

'Draw3':$
 begin

 wset, draw3

 if  ev.release eq 1 or  ev.release eq 4 then $
 begin
  print, '===> mouse button pressed:'
  print, 'release=',ev.release
  print, 'sel.status=',selecting_status
  print, 'select=',select
 end

  if  ev.release eq 4 and selecting_status eq 0 then $  ; ------------ display context menu
  begin
    WIDGET_DISPLAYCONTEXTMENU, WID_DRAW_3, ev.X, ev.Y-300, contextBase3
    print, 'context menu'
  end else $

  if  ev.release eq 4 and (select eq 1 or unselect eq 1) then $  ; --- switch off selection
  begin
      draw_box, X1, Y1, ox, oy, draw3, 'FFFF00'XL
      selecting_status = 0
      select=0
      unselect=0
      Widget_Control, WID_DRAW_3, DRAW_MOTION_EVENTS=0
      print, '------> selections off'
      print, 'release=',ev.release
      print, 'sel.status=',selecting_status
      print, 'select=',select
  end else $

  if  ev.release eq 1 and selecting_status eq 0 and select eq 1 then $ ; --- start selection
  begin
       cursor, x, y, /device, /NOWAIT
       selecting_status=1
       DEVICE, SET_GRAPHICS_FUNCTION = 6
       Widget_Control, WID_DRAW_3, DRAW_MOTION_EVENTS=1
       Widget_Control, WID_DRAW_3, DRAW_BUTTON_EVENTS=1
       X1=X
       Y1=Y
       ox=x1
       oy=y1
       print, '-------> started selection'
       print, 'release=',ev.release
       print, 'sel.status=',selecting_status
       print, 'select=',select
       cursor, x, y, /device, /CHANGE

  end else $
  if  ev.release eq 1 and selecting_status eq 0 and unselect eq 1 then $ ; --- start unselection
  begin
       cursor, x, y, /device, /NOWAIT
       selecting_status=1
       DEVICE, SET_GRAPHICS_FUNCTION = 6
       Widget_Control, WID_DRAW_3, DRAW_MOTION_EVENTS=1
       Widget_Control, WID_DRAW_3, DRAW_BUTTON_EVENTS=1
       X1=X
       Y1=Y
       ox=x1
       oy=y1
       cursor, x, y, /device, /CHANGE
       print, '-------> started unselection'
       print, 'release=',ev.release
       print, 'sel.status=',selecting_status
       print, 'select=',select
  end else $
  if  ev.release eq 1 and selecting_status eq 0 and addpeak eq 1 then $ ; --- add peak zoom
  begin
       addpeak=0
       print, x,y
       Widget_Control, WID_DRAW_0, DRAW_MOTION_EVENTS=0
       scale1=2.0*rad/428.
       scale2=2.0*rad1/428.
       print, [cenx+(x-428/2)*scale1,ceny+(y-428/2)*scale2]
       ref_peak.detXY= [cenx+(x-428/2)*scale1,ceny+(y-428/2)*scale2]

       bx=read_box_size(wid_text_37,wid_text_37)
       ref_peak.intssd[0:1]=[bx]


       gonio=[0.0,0.0,0.0,0.0,0.0,0.0]
       widget_control, wid_text_16, get_value=o1
       gonio[3]=float(o1)
       ref_peak.gonio=gonio
       opt->appendpeak, ref_peak
       opt->calculate_all_xyz_from_pix, oadetector, wv
       print_peak_list, opt, wid_list_3
       update_peakno, opt->peakno()
       plot_peaks_zoom, draw3, opt
       plot_peaks, draw0, opt, arr1, arr2
       print, '-------> add peak'
       print, 'release=',ev.release
       print, 'sel.status=',selecting_status
       print, 'select=',select

  end else $
  if  ev.release eq 1 and selecting_status eq 1 and select eq 1 then $ ; --- end selection
  begin
       draw_box, X1, Y1, ox, oy, draw3, 'FFFF00'XL
       DEVICE, SET_GRAPHICS_FUNCTION = 3
       Widget_Control, WID_DRAW_3, DRAW_MOTION_EVENTS=0
       Widget_Control, WID_DRAW_3, DRAW_BUTTON_EVENTS=1
       X2=X
       Y2=Y
       selecting_status = 0
       scale1=2.0*rad/428.
       scale2=2.0*rad/428.

       ;----------- PD change --------------
       ;----------- 6/22/2010 --------------
       ;----------- fix problem with having to do selection only from bottom left to top right
       if x2 lt x1 then $
       begin
         a=x1
         x1=x2
         x2=a
       endif
       if y2 lt y1 then $
       begin
         a=y1
         y1=y2
         y2=a
       endif
       ;----------- PD change end ----------
       opt->select_image, cenx+(x1-428/2)*scale1,ceny+(y1-428/2)*scale1, cenx+(x2-428/2)*scale1,ceny+(y2-428/2)*scale1
       plot_peaks_zoom, draw3, opt
       plot_peaks, draw0, opt, arr1, arr2


       print, '-------> ended selection'
       print, 'release=',ev.release
       print, 'sel.status=',selecting_status
       print, 'select=',select

  endif else $
  if  ev.release eq 1 and selecting_status eq 1 and unselect eq 1 then $ ; --- end unselection
  begin
       draw_box, X1, Y1, ox, oy, draw3, 'FFFF00'XL
       DEVICE, SET_GRAPHICS_FUNCTION = 3
       Widget_Control, WID_DRAW_3, DRAW_MOTION_EVENTS=0
       X2=X
       Y2=Y
       selecting_status = 0
       print, 'selection box:', x1, y1, x2, y2
       scale1=2.0*rad/428.
       scale2=2.0*rad/428.
       ;----------- PD change --------------
       ;----------- 6/22/2010 --------------
       ;----------- fix problem with having to do unselection only from bottom left to top right
       if x2 lt x1 then $
       begin
         a=x1
         x1=x2
         x2=a
       endif
       if y2 lt y1 then $
       begin
         a=y1
         y1=y2
         y2=a
       endif
       ;----------- PD change end ----------
       opt->unselect_image, cenx+(x1-428/2)*scale1,ceny+(y1-428/2)*scale1, cenx+(x2-428/2)*scale1,ceny+(y2-428/2)*scale1
       plot_peaks_zoom, draw3, opt
       plot_peaks, draw0, opt, arr1, arr2
       print, '-------> ended unselection'
       print, 'release=',ev.release
       print, 'sel.status=',selecting_status
       print, 'select=',select
end
   if  selecting_status eq 1 then $
  begin
      draw_box, X1, Y1, ox, oy, draw3, 'FFFF00'XL
      ox=x
      oy=y
      draw_box, X1, Y1, x, y, draw3, 'FFFF00'XL
      cursor, x, y, /device, /CHANGE
      print, '-------> draw box'

  endif

end

 'Draw':$
 begin
  if  ev.release eq 4 and selecting_status eq 0 then $  ; --- switch on selection
  begin
    WIDGET_DISPLAYCONTEXTMENU, WID_DRAW_0, ev.X, ev.Y-500, contextBase
  end else $
  if  ev.release eq 4 and selecting_status eq 1 and (select eq 1 or unselect eq 1 or mask eq 1 or unmask eq 1) then $  ; --- switch off selection
  begin
      draw_box, X1, Y1, ox, oy, draw0, 'FFFF00'XL
      selecting_status = 0
      Widget_Control, WID_DRAW_0, DRAW_MOTION_EVENTS=0
  end else $
  if  ev.release eq 1 and selecting_status eq 0 and select eq 1 then $ ; --- start selection
  begin
       cursor, x, y, /device, /NOWAIT
       selecting_status=1
       DEVICE, SET_GRAPHICS_FUNCTION = 6
       Widget_Control, WID_DRAW_0, DRAW_MOTION_EVENTS=1
       X1=X
       Y1=Y
       ox=x1
       oy=y1
       cursor, x, y, /device, /CHANGE
  end else $
  if  ev.release eq 1 and selecting_status eq 0 and unselect eq 1 then $ ; --- start unselection
  begin
       cursor, x, y, /device, /NOWAIT
       selecting_status=1
       DEVICE, SET_GRAPHICS_FUNCTION = 6
       Widget_Control, WID_DRAW_0, DRAW_MOTION_EVENTS=1
       X1=X
       Y1=Y
       ox=x1
       oy=y1
       cursor, x, y, /device, /CHANGE
  end else $
  if  ev.release eq 1 and selecting_status eq 0 and mask eq 1 then $ ; --- start mask
  begin
       cursor, x, y, /device, /NOWAIT
       selecting_status=1
       DEVICE, SET_GRAPHICS_FUNCTION = 6
       Widget_Control, WID_DRAW_0, DRAW_MOTION_EVENTS=1
       X1=X
       Y1=Y
       ox=x1
       oy=y1
       cursor, x, y, /device, /CHANGE
  end else $
  if  ev.release eq 1 and selecting_status eq 0 and unmask eq 1 then $ ; --- start unmask
  begin
       cursor, x, y, /device, /NOWAIT
       selecting_status=1
       DEVICE, SET_GRAPHICS_FUNCTION = 6
       Widget_Control, WID_DRAW_0, DRAW_MOTION_EVENTS=1
       X1=X
       Y1=Y
       ox=x1
       oy=y1
       cursor, x, y, /device, /CHANGE
  end else $
  if  ev.release eq 1 and selecting_status eq 0 and zoom eq 1 then $ ; --- start zoom
  begin
       cursor, x, y, /device, /NOWAIT
       selecting_status=1
       DEVICE, SET_GRAPHICS_FUNCTION = 6
       Widget_Control, WID_DRAW_0, DRAW_MOTION_EVENTS=1
       X1=X
       Y1=Y
       ox=x1
       oy=y1
       cursor, x, y, /device, /CHANGE
  end else $
  if  ev.release eq 1 and selecting_status eq 1 and select eq 1 then $ ; --- end selection
  begin
       draw_box, X1, Y1, ox, oy, draw0, 'FFFF00'XL
       DEVICE, SET_GRAPHICS_FUNCTION = 3
       Widget_Control, WID_DRAW_0, DRAW_MOTION_EVENTS=0
       X2=X
       Y2=Y
       selecting_status = 0
       print, 'selection box:', x1, y1, x2, y2
       scale1=arr1/600.
       scale2=arr2/600.
       ;----------- PD change --------------
       ;----------- 6/22/2010 --------------
       ;----------- fix problem with having to do selection only from bottom left to top right
       if x2 lt x1 then $
       begin
         a=x1
         x1=x2
         x2=a
       endif
       if y2 lt y1 then $
       begin
         a=y1
         y1=y2
         y2=a
       endif
       ;----------- PD change end ----------

       opt->select_image, x1*scale1,y1*scale2, x2*scale1, y2*scale2
       plot_peaks, draw0, opt, arr1, arr2
  end else $
  if  ev.release eq 1 and selecting_status eq 1 and zoom eq 1 then $ ; --- end zoom
  begin
       draw_box, X1, Y1, ox, oy, draw0, 'FFFF00'XL
       DEVICE, SET_GRAPHICS_FUNCTION = 3
       Widget_Control, WID_DRAW_0, DRAW_MOTION_EVENTS=0
       X2=X
       Y2=Y
       selecting_status = 0
       zoom=0
       print, 'zoom box:', x1, y1, x2, y2
       scale1=arr1/600.
       scale2=arr2/600.
       x1=x1*scale1
       x2=x2*scale1
       y1=y1*scale2
       y2=y2*scale2
       cenx=(x1+x2)/2
       ceny=(y1+y2)/2
       ;rad=max(abs([cenx-x1,cenx-x2,ceny-y1,ceny-y2]))
       rad =abs(x2-x1)/2
       rad1=abs(y2-y1)/2
       plot_zoom, oimage
       plot_peaks_zoom, draw3, opt
  end else $
  if  ev.release eq 1 and selecting_status eq 1 and mask eq 1 then $ ; --- end mask
  begin
       draw_box, X1, Y1, ox, oy, draw0, 'FFFF00'XL
       DEVICE, SET_GRAPHICS_FUNCTION = 3
       Widget_Control, WID_DRAW_0, DRAW_MOTION_EVENTS=0
       X2=X
       Y2=Y
       selecting_status = 0
       print, 'selection box:', x1, y1, x2, y2
       scale1=arr1/600.
       scale2=arr2/600.
       ax0=fix(X1*scale1)
       ax1=fix(ox*scale1)
       ay0=fix(Y1*scale2)
       ay1=fix(oy*scale2)
       ;----------- PD change -----------------------
       ;----------- 6/22/2010
       ;----------- fixing a crash on selecting mask other than bottom left to top right
       if ax1 lt ax0 then $
       begin
        a=ax0
        ax0=ax1
        ax1=a
       endif
       if ay1 lt ay0 then $
       begin
        a=ay0
        ay0=ay1
        ay1=a
       endif
       ;----------- PD change end -------------------
       maskarr[ax0:ax1,ay0:ay1]=0
       plot_image, oimage
       ;draw_box, X1, Y1, ox, oy, draw0, 'FFFF00'XL
       ;opt->select_image, x1*scale1,y1*scale2, x2*scale1, y2*scale2
       ;plot_peaks, draw0, opt, arr1, arr2
  end else $
 if  ev.release eq 1 and selecting_status eq 1 and unmask eq 1 then $ ; --- end unmask
  begin
       draw_box, X1, Y1, ox, oy, draw0, 'FFFF00'XL
       DEVICE, SET_GRAPHICS_FUNCTION = 3
       Widget_Control, WID_DRAW_0, DRAW_MOTION_EVENTS=0
       X2=X
       Y2=Y
       selecting_status = 0
       print, 'selection box:', x1, y1, x2, y2
       scale1=arr1/600.
       scale2=arr2/600.
       ax0=fix(X1*scale1)
       ax1=fix(ox*scale1)
       ay0=fix(Y1*scale2)
       ay1=fix(oy*scale2)
       ;----------- PD change -----------------------
       ;----------- 6/22/2010
       ;----------- fixing a crash on selecting mask other than bottom left to top right
       if ax1 lt ax0 then $
       begin
        a=ax0
        ax0=ax1
        ax1=a
       endif
       if ay1 lt ay0 then $
       begin
        a=ay0
        ay0=ay1
        ay1=a
       endif
       ;----------- PD change end -------------------
       maskarr[ax0:ax1,ay0:ay1]=1
       plot_image, oimage
       ;draw_box, X1, Y1, ox, oy, draw0, 'FFFF00'XL
       ;opt->select_image, x1*scale1,y1*scale2, x2*scale1, y2*scale2
       plot_peaks, draw0, opt, arr1, arr2
  end else $

  if  ev.release eq 1 and selecting_status eq 1 and unselect eq 1 then $ ; --- end unselection
  begin
       draw_box, X1, Y1, ox, oy, draw0, 'FFFF00'XL
       DEVICE, SET_GRAPHICS_FUNCTION = 3
       Widget_Control, WID_DRAW_0, DRAW_MOTION_EVENTS=0
       X2=X
       Y2=Y
       selecting_status = 0
       print, 'selection box:', x1, y1, x2, y2
       scale1=arr1/600.
       scale2=arr2/600.
       ;----------- PD change --------------
       ;----------- 6/22/2010 --------------
       ;----------- fix problem with having to do unselection only from bottom left to top right
       if x2 lt x1 then $
       begin
         a=x1
         x1=x2
         x2=a
       endif
       if y2 lt y1 then $
       begin
         a=y1
         y1=y2
         y2=a
       endif
       ;----------- PD change end ----------

       opt->unselect_image, x1*scale1,y1*scale2, x2*scale1, y2*scale2
       plot_peaks, draw0, opt, arr1, arr2
  end else $
  if  ev.release eq 1 and addpeak eq 1 then $ ; --- add peak
  begin
       addpeak=0
       print, x,y
       Widget_Control, WID_DRAW_0, DRAW_MOTION_EVENTS=0
       scale1=arr1/600.
       scale2=arr2/600.
       print, [x*scale1,y*scale2]
       ref_peak.detXY=[x*scale1,y*scale2]

       bx=read_box_size(wid_text_37,wid_text_37)
       ref_peak.intssd[0:1]=[bx]

       gonio=[0.0,0.0,0.0,0.0,0.0,0.0]
       widget_control, wid_text_16, get_value=o1
       gonio[3]=float(o1)
       ref_peak.gonio=gonio
       opt->appendpeak, ref_peak
       opt->calculate_all_xyz_from_pix, oadetector, wv
       print_peak_list, opt, wid_list_3
       update_peakno, opt->peakno()
       plot_peaks, draw0, opt, arr1, arr2
  end else $
  if  selecting_status eq 1 then $
  begin
      draw_box, X1, Y1, ox, oy, draw0, 'FFFF00'XL
      ox=x
      oy=y
      draw_box, X1, Y1, x, y, draw0, 'FFFF00'XL
      cursor, x, y, /device, /CHANGE
  end else $
  ; else if excl eq 1 then $
  ;begin
  ;   scale1=arr1/600.
  ;   scale2=arr2/600.
  ;   pix=[x*scale1,y*scale2]
  ;   tth=oadetector->calculate_tth_from_pixels(pix, [0,0,0,0,0,0])
  ;   cursor, x, y, /device, /CHANGE
  ;end

  if ev.release eq 1 and excl eq 1 then $ ;-   draw exclusions
  begin
     Widget_Control, WID_DRAW_0, DRAW_MOTION_EVENTS=0
     scale1=arr1/600.
     scale2=arr2/600.
     pix=[x*scale1,y*scale2]
     an=read_kappa_and_ttheta()
     tth=oadetector->calculate_tth_from_pixels(pix, [0,an[1],0,0,an[0],0])
     SZ=SIZE(EXCLUSIONS)
     IF SZ[0] EQ 1 AND EXCLUSIONS[0] EQ 0 AND EXCLUSIONS[1] EQ 0 THEN EXCLUSIONS=[TTH, 0.3] ELSE $
     EXCLUSIONS=[[EXCLUSIONS],[TTH, 0.3]]
;     PRINT, '---- Exclusions', EXCLUSIONS
     Print_exclusions, EXCLUSIONS
     plot_ds_ring, tth+0.3, scale1, scale2, 1
     plot_ds_ring, tth-0.3, scale1, scale2, 0
     excl=0
  end


 end
'Add peak':$
  ; This code is executed if "Add peak" option is selected
  ; from the context menu in the main image window
begin
     wset, draw0
     Widget_Control, WID_DRAW_0, DRAW_MOTION_EVENTS=1
     cursor, x, y, /device, /DOWN
     addpeak=1
     select=0
     unselect=0
     zoom=0
     mask=0
end
'Add peak3':$
  ; This code is executed if "Add peak" option is selected
  ; from the context menu in the zoom window
begin
     wset, draw3
     Widget_Control, WID_DRAW_3, DRAW_MOTION_EVENTS=1
     cursor, x, y, /device, /DOWN
     addpeak=1
     select=0
     unselect=0
     zoom=0
     mask=0
end
'Save mask':$
begin
   ; chack if directory available for writing
       fn=generate_fname(res)
       res=analyse_fname(fn, dir, 3)
       write_tiff, out_dir+res.name0+'.msk', maskarr
end

'Open mask':$
begin
       re=dialog_pickfile(filter='*.msk', path=out_dir, /read)
       if re ne '' then $
       begin
        maskarr=read_tiff(re)
        plot_image, oimage
        plot_peaks, draw0, opt, arr1, arr2
       endif
end


'Define mask':$
begin
     wset, draw0
     cursor, x, y, /device, /CHANGE
     select=0
     unselect=0
     zoom=0
     mask=1
     unmask=0
end

'Define unmask':$
begin
     wset, draw0
     cursor, x, y, /device, /CHANGE
     select=0
     unselect=0
     zoom=0
     mask=0
     unmask=1
end


'Reset mask':$
begin
  mask=0
  maskarr[*,*]=1
  plot_image, oimage
  plot_peaks, draw0, opt, arr1, arr2
end
'CM Select':$
begin
     wset, draw0
     cursor, x, y, /device, /CHANGE
     select=1
     unselect=0
     zoom=0
     mask=0
end

'Select peak3':$
begin
     wset, draw3
     cursor, x, y, /device, /down
     select=1
     unselect=0
     zoom=0
     mask=0
     unmask=0
end

'CM Zoom':$
begin
     wset, draw0
     cursor, x, y, /device, /CHANGE
     select=0
     unselect=0
     zoom=1
     mask=0
     unmask=0
end
'CM Unselect':$
begin
     wset, draw0
     cursor, x, y, /device, /CHANGE
     select=0
     unselect=1
     mask=0
     unmask=0
     zoom=0
end
'Unselect peak3':$
begin
     wset, draw3
     cursor, x, y, /device, /CHANGE
     select=0
     unselect=1
     mask=0
     unmask=0
     zoom=0
end
'Refine omegas':$
begin
  if min(UB) eq 0 and max(UB) eq 0 then re=dialog_message('Load UB matrix first') else $
  begin
   opt->refine_ind_omega, UB
   lp=lp_from_ub(ub)
   print_UB_and_lp, ub,lp,wid_list_2, opt
   print_peak_list, opt, wid_list_3
  endelse
end
;----------------
'Refine UB':$
begin
  ub=opt->recomp_UB()
  lp=lp_from_ub(ub)
  print_UB_and_lp, ub,lp,wid_list_2, opt
end

'Mask selection off':$
begin
  mask=0
end
;----------------
'Selections off':$
begin
     selecting_status=0
     select=0
     unselect=0
     Widget_Control, WID_DRAW_0, DRAW_MOTION_EVENTS=0
     print, 'selections off'
end




'Selections off3':$
begin
     selecting_status=0
     select=0
     unselect=0
     Widget_Control, WID_DRAW_3, DRAW_MOTION_EVENTS=0
     print, 'selections off'
end
'Delete peaks':$
begin
       ; remember selection
       pn=read_peak_selected(wid_list_3)
       opt->delete_selected
       plot_image, oimage
       plot_peaks, draw0, opt, arr1, arr2
       print_peak_list, opt, wid_list_3
       update_peakno, opt->peakno()
       print_R_int, Rint(get_laue_class(), opt)
       if pn ne 0 then $
           if pn ne opt->peakno() then set_peak_selected,wid_list_3, pn else  set_peak_selected,wid_list_3, pn-1

 end
'Define exclusion':$
begin
     wset, draw0
     Widget_Control, WID_DRAW_0, DRAW_MOTION_EVENTS=1
     cursor, x, y, /device, /down
     excl=1
end

;-------
'Int. from series':$

begin
threeD:
   widget_control, wid_text_29, get_value=dira
   widget_control, wid_text_28, get_value=fila
   if dira eq '' then $
   begin
     re=dialog_message('Output directory not selected')
     goto, stoper11
   endif
   if fila eq '' then $
   begin
     re=dialog_message('Improper image file name')
     goto, stoper11
   endif

   widget_control, wid_text_6, get_value=nim	    ; number of images in the step scan
   widget_control, wid_text_7, get_value=i0
   widget_control, wid_text_4, get_value=rot_start  ; rotation angle at the start of step scan
   widget_control, wid_text_5, get_value= rot_delta ; step scan angular increment

   ;---- these two parameters have to be accessible in the gui

   rocking_curve = 1.5   ; rocking curve width in degrees
   box=[20,20]


 ;--------------- remove peaks that are close to the edge than box size
     pks=lindgen(opt->peakno())
     XY=opt->get_detXY(pks)
     w1=where(XY[0,*] lt box[0])
     if w1[0] ne -1 then opt->select_peaks, w1
     w1=where(XY[0,*] gt arr1-1-box[0])
     if w1[0] ne -1 then opt->select_peaks, w1
     w1=where(XY[1,*] lt box[1])
     if w1[0] ne -1 then opt->select_peaks, w1
     w1=where(XY[1,*] gt arr2-1-box[1])
     if w1[0] ne -1 then opt->select_peaks, w1
     opt->delete_selected
 ;------------- prepare array with rotation center values for each image in the series
     rot_centers=fltarr(nim)
     for i=0, nim[0]-1 do rot_centers[i]=rot_start+(i+0.5)*rot_delta
 ;------ prepare array with summation indices
     N=opt->peakno()
     indTAB=lonarr(nim,N+1) ; this array is too big. Have to resize once the max number of peaks in each image is known
     rot=opt->get_rotations(3)
     rot=rot[0:N-1]
     for i=0, nim[0]-1 do $
     begin
       w=where(abs(rot-rot_centers[i]) lt rocking_curve)
       if w[0] ne -1 then $
       begin
     	indTAB[i,0]=n_elements(w)
     	indTAB[i,1:n_elements(w)]=w
   	   endif
 	 endfor
 	 m=max(indTAB[*,0])
 	 indTAB=indTAB[*,0:m]
 	 print, 'Finished preparing index array'
 ;------ prepare 3d array for cumulative summation
     cumInt=fltarr(N, box[0]*2+1, box[1]*2+1)
 	 ; go through step scan and add intensities to cumInt
 	 cgProgressBar = Obj_New("CGPROGRESSBAR", /Cancel)
 	 cgProgressBar -> Start

 for i=0, nim[0]-1 do $ ; images
 begin
 ;--- open step image
    res.seq=i0[0]+i
    fn=generate_fname(res)
    res=analyse_fname(fn, dir, 3)
    widget_control, wid_text_9, set_value=res.name0
    oimage->load_image, fn, oadetector
    check_mask_file
    im=oimage->get_object()

   for j=1, indTAB[i,0] do $ ; peaks
   begin
     XY=opt->get_detXY(indTAB[i,j])
     pic=oimage->get_zoomin(XY, box, maskarr)
     cumInt[indTAB[i,j],0:2*box[0],0:2*box[1]]=cumInt[indTAB[i,j],0:2*box[0],0:2*box[1]]+pic
     ;print, max(pic), max(cumInt[indTAB[i,j],*,*])
   endfor
             IF cgProgressBar -> CheckCancel() THEN BEGIN
                ok = Dialog_Message('Operation canceled')
                cgProgressBar -> Destroy
                RETURN
             ENDIF
             cgProgressBar -> Update, (float(i)/nim[0])*100.0
 endfor
    cgProgressBar -> Destroy
 stoper11:
end

;------------------
'Fit all peaks':$
 begin
   			fit_all_peaks, prog=1
  			opt->delete_selected
     		plot_image, oimage
     		update_peakno, opt->peakno()
     		plot_peaks, draw0, opt, arr1, arr2

            ;---- filter observed
  			a=oimage->calculate_local_background(0)
  			widget_control, wid_text_48, get_value=obs
  			obs=float(obs)
  			opt->unselect_all
  			pt=opt->get_object()
  			for pn=0, opt->peakno()-1 do $
  			begin
  				bs=[long(pt.peaks[pn].intssd[0]),long(pt.peaks[pn].intssd[0])]
    			xy=pt.peaks[pn].detXY
 	 			bs=[2,2]
         		pic=oimage->get_zoomin(XY, bs, maskarr)
    			med=median(pic)
    			if (max(pic)-med)  lt obs then opt->select_peak, pn
  			endfor

   			opt->calculate_all_xyz_from_pix, oadetector, wv
     		plot_image, oimage
     		update_peakno, opt->peakno()
     		plot_peaks, draw0, opt, arr1, arr2
     		print_peak_list, opt, wid_list_3
  			opt->delete_selected
     		plot_image, oimage
     		update_peakno, opt->peakno()
     		plot_peaks, draw0, opt, arr1, arr2
     		print_peak_list, opt, wid_list_3
  			print_R_int, Rint(get_laue_class(), opt)
   		    re=dialog_message('Peak profile refinement complete')
 end
;-------


'Recalculate XYZ':$
   begin
       capture_calibration, oadetector, wv
       opt->calculate_all_xyz_from_pix, oadetector, wv
       print_peak_list, opt, wid_list_3
       re=dialog_message('Recalculation complete')
   end
;-------
'Recalculate DetXY':$
   begin
      capture_calibration, oadetector, wv
      opt->calculate_all_detXY_from_xyz, oadetector, wv
      print_peak_list, opt, wid_list_3
      plot_image, oimage
      plot_peaks, draw0, opt, arr1, arr2
      re=dialog_message('Recalculation complete')
   end
;-------
'Generate multiple peaks':$
   begin
     widget_control, wid_text_16, get_value=o1
     widget_control, wid_text_20, get_value=o2
     widget_control, wid_text_47, get_value=st
     if not(o1 eq '' or o2 eq '' or st eq '' ) then $
     begin
       o1=float(o1)
       o2=float(o2)
       st=float(st)
       if o2 lt o1 and st gt 0 then st=st*(-1.0)
       del=o2-o1
       nst=fix(abs(del/st))
       np=opt->peakno()
       for i=0, np-1 do $
       begin
        peak=opt->get_element(i)
        peak.gonio[3]=o1
        opt->replacepeak, i, peak
        for j=1, nst[0] do $
        begin
         peak.gonio[3]=o1+j*st
         opt->appendpeak, peak
        endfor
       endfor
     end
     opt->calculate_all_xyz_from_pix, oadetector, wv
     update_peakno, opt->peakno()
     print_peak_list, opt, wid_list_3
   end

;-------

'Integrate Pilatus':$
begin

   widget_control, wid_text_29, get_value=dira
   widget_control, wid_text_28, get_value=fila
   if dira eq '' then $
   begin
     re=dialog_message('Output directory not selected')
     goto, stoper1
   endif
   if fila eq '' then $
   begin
     re=dialog_message('Improper image file name')
     goto, stoper1
   endif
   widget_control, wid_text_6, get_value=ni
   widget_control, wid_text_7, get_value=i0
   widget_control, wid_text_4, get_value=om0
   widget_control, wid_text_5, get_value=omD
   i0=fix(i0)
   ni=fix(ni)
   om0=float(om0)
   omD=float(omD)
   ene0=float(om0)
   eneD=float(omD)
   gonio=fltarr(6)
  ;--- make array for profiles
  int=fltarr(ni[0],500)
  trr=fltarr(ni[0],500)
   widget_control, wid_text_8, set_value=string(0, format='(I3)')+'/'+string(ni[0], format='(I3)')
   for i=0, ni[0]-1 do $
   begin

    res.seq=i0[0]+i
    fn=generate_fname(res)
    res=analyse_fname(fn, dir, 3)
    widget_control, wid_text_9, set_value=res.name0
    oimage->load_image, fn, oadetector
    check_mask_file
    im=oimage->get_object()
    data1=congrid(im.img[0:arr1-1,0:arr2-1]*maskarr, 600, 600)
    widget_control, wid_text_24, get_value=imax
    widget_control, wid_text_25, get_value=imin
    imax=long(imax)
    imin=long(imin)
    imax=imax[0]
    imin=imin[0]
    data1=data1>imin
    data1=data1<imax
    wset, draw0
    tvscl, data1


    x1=[0,0]
    x2=[0,arr2]
    x3=[arr1,0]
    x4=[arr1,arr2]

    detangle=om0+i*omD
    gonio[1]=detangle
    widget_control, wid_text_36b, set_value=string(detangle)
    capture_calibration, oadetector, wv
   ;-------------------
   aa=    [oadetector->calculate_tth_from_pixels(x1,gonio),$
           oadetector->calculate_tth_from_pixels(x2,gonio),$
           oadetector->calculate_tth_from_pixels(x3,gonio),$
           oadetector->calculate_tth_from_pixels(x4,gonio)]

   m21=min(aa)
   m22=max(aa)
   Inti=oimage->integrate_dll(oadetector, 500.000, [double(m21),double(m22)], maskarr)
   int[i,*]=inti[1,*]
   trr[i,*]=inti[0,*]

   plot, trr[i,*],   int[i,*]

   f=strmid(res.name0, 0, strlen(res.name0)-4)
   write_data_to_chi, out_dir+f+'.chi', inti

   endfor

  ;--- now scale the data together

   print, min(trr), max(trr)
   x0=min(trr)
   x1=max(trr)
   N=500*ni[0]
   Xb=fltarr(500*ni[0])
   Nb=fltarr(500*ni[0])
   Ib=fltarr(500*ni[0])
   for i=0, N-1 do xb[i]=x0+i*(x1-x0)/N


   for i=0, ni[0]-1 do $
   begin
    a1=min(abs(trr[i,0]-Xb), l1)
    a2=min(abs(trr[i,499]-Xb), l2)
    ;print, l1, l2, xb[l1],xb[l2]
    l1=l1+5
    l2=l2-5
    iii=spline(trr[i,*],int[i,*], Xb[l1:l2], 10)
    Ib[l1:l2]=Ib[l1:l2]+iii
    Nb[l1:l2]=Nb[l1:l2]+1
    plot, Xb[l1:l2], iii
    plot, xb, ib
    print, 1


   endfor
   Ib=Ib/nb
   plot, xb, ib

   fnc=dialog_pickfile(/write,filter='*.chi', default_extension='chi', path=out_dir)
   write_data_to_chi, fnc, transpose([[xb],[ib]])

end
;---------------
 'Compute profiles':$
begin
   if n_elements(res) gt 0 then $
   begin

   axis=3
   kt=read_kappa_and_ttheta()
   ty=omega_or_energy()
   pt=opt->get_object()
   widget_control, wid_text_29, get_value=dira
   widget_control, wid_text_28, get_value=fila
   if dira eq '' then $
   begin
     re=dialog_message('Output directory not selected')
     goto, stoper1
   endif
   if fila eq '' then $
   begin
     re=dialog_message('Improper image file name')
     goto, stoper1
   endif
   widget_control, wid_text_6, get_value=ni
   widget_control, wid_text_7, get_value=i0
   widget_control, wid_text_4, get_value=om0
   widget_control, wid_text_5, get_value=omD
   i0=fix(i0)
   ni=fix(ni)
   om0=float(om0)
   omD=float(omD)
   ene0=float(om0)
   eneD=float(omD)

   ;bs=read_box_size(wid_text_37,wid_text_37)

  ;--- make array for profiles
   profiles=fltarr(pt.peakno, ni[0])

   cgProgressBar = Obj_New("CGPROGRESSBAR", /Cancel)
   cgProgressBar -> Start


   for i=0, ni[0]-1 do $
   begin

    res.seq=i0[0]+i
    fn=generate_fname(res)
    res=analyse_fname(fn, dir, 3)
    widget_control, wid_text_9, set_value=res.name0
    oimage->load_image, fn, oadetector
    check_mask_file
    im=oimage->get_object()
    data1=congrid(im.img[0:arr1-1,0:arr2-1]*maskarr, 600, 600)
    widget_control, wid_text_24, get_value=imax
    widget_control, wid_text_25, get_value=imin
    imax=long(imax)
    imin=long(imin)
    imax=imax[0]
    imin=imin[0]
    data1=data1>imin
    data1=data1<imax
    wset, draw0
    tvscl, data1
    for k=0, pt.peakno-1 do $
    begin
     ; print, i, k

      bs=[long(pt.peaks[k].intssd[0]),long(pt.peaks[k].intssd[0])]
      pic=oimage->get_zoomin(pt.peaks[k].detXY, bs, maskarr)
      profiles[k,i]=total(pic)
    end

     IF cgProgressBar -> CheckCancel() THEN BEGIN
        ok = Dialog_Message('Operation canceled')
        cgProgressBar -> Destroy
      RETURN
      ENDIF
      cgProgressBar -> Update, (float(i)/(ni[0]-1))*100.0

   endfor

   cgProgressBar -> Destroy

   omega=fltarr(ni[0])
   ene=fltarr(ni[0])
   for i=0, ni[0]-1 do omega[i]=om0+i*omD
   for i=0, ni[0]-1 do ene[i]=ene0+i*eneD
   for i=0, pt.peakno-1 do $
   begin
     re=max(profiles[i,0:ni[0]-1],l)
     if ty eq 1 then $
     begin
       pt.peaks[i].gonio[0]=kt[0] ; nu
       pt.peaks[i].gonio[1]=kt[1] ; del
       pt.peaks[i].gonio[axis]=omega[l]
     endif else $
     begin
       pt.peaks[i].energies[0]=ene[l]
       pt.peaks[i].gonio[5]=0.0
     end
   end

   opt->set_object, pt
   capture_calibration, oadetector, wv
  ; opt->calculate_all_xyz_from_pix, oadetector, wv


   if ty eq 1 then opt->calculate_all_xyz_from_pix, oadetector, wv else $
                   opt->calculate_all_xyz_from_pix_laue, oadetector
   print_peak_list, opt, wid_list_3
   re=dialog_message('Profile computation successfully completed')
   stoper1:
   endif
end
;-------
;---------------
 'Verify omegas1':$
 ;---- checks if the omega angles in peaktable (from prediction)
 ;---- are consistent with the intensity maximum in the rocking curve
 ;---- selects peaks that are not consistent
begin
   ty=omega_or_energy()
   pt=opt->get_object()
   widget_control, wid_text_29, get_value=dira
   widget_control, wid_text_28, get_value=fila
   if dira eq '' then $
   begin
     re=dialog_message('Output directory not selected')
     goto, stoper1a
   endif
   if fila eq '' then $
   begin
     re=dialog_message('Improper image file name')
     goto, stoper1a
   endif
   widget_control, wid_text_6, get_value=ni
   widget_control, wid_text_7, get_value=i0
   widget_control, wid_text_4, get_value=om0
   widget_control, wid_text_5, get_value=omD
   i0=fix(i0)
   ni=fix(ni)
   om0=float(om0)
   omD=float(omD)
   ene0=float(om0)
   eneD=float(omD)

   ;bs=read_box_size(wid_text_37,wid_text_37)

  ;--- make array for profiles
   profiles=fltarr(pt.peakno, ni[0])
   ;widget_control, wid_text_8, set_value=string(0, format='(I3)')+'/'+string(ni[0], format='(I3)')
   for i=0, ni[0]-1 do $
   begin


    res.seq=i0[0]+i
    fn=generate_fname(res)
    res=analyse_fname(fn, dir, 3)
    widget_control, wid_text_9, set_value=res.name0
    oimage->load_image, fn, oadetector
    check_mask_file
    im=oimage->get_object()
    data1=congrid(im.img[0:arr1-1,0:arr2-1]*maskarr, 600, 600)
    widget_control, wid_text_24, get_value=imax
    widget_control, wid_text_25, get_value=imin
    imax=long(imax)
    imin=long(imin)
    imax=imax[0]
    imin=imin[0]
    data1=data1>imin
    data1=data1<imax
    wset, draw0
    tvscl, data1
    for k=0, pt.peakno-1 do $
    begin
      bs=[long(pt.peaks[k].intssd[0]),long(pt.peaks[k].intssd[0])]
      pic=oimage->get_zoomin(pt.peaks[k].detXY, bs, maskarr)
      profiles[k,i]=total(pic)
    end
    widget_control, wid_text_8, set_value=string(i+1, format='(I2)')+'/'+string(ni[0], format='(I2)')
   endfor
   omega=fltarr(ni[0])
   ene=fltarr(ni[0])
   for i=0, ni[0]-1 do omega[i]=om0+i*omD
   for i=0, ni[0]-1 do ene[i]=ene0+i*eneD

   pt.peaks[*].selected[0]=0
   for i=0, pt.peakno-1 do $
   begin ;------ modifications here
     re=max(profiles[i,0:ni[0]-1],l)
     if ty eq 1 then $
     begin
       print, i, pt.peaks[i].gonio[3], omega[l]
       if abs(pt.peaks[i].gonio[3]-omega[l]) gt 2.0 then pt.peaks[i].selected[0]=1
     endif else $
     begin
       pt.peaks[i].energies[0]=ene[l]
       pt.peaks[i].gonio[3]=0.0
     end
   endfor

   opt->set_object, pt
   capture_calibration, oadetector, wv
   opt->calculate_all_xyz_from_pix, oadetector, wv


   if ty eq 1 then opt->calculate_all_xyz_from_pix, oadetector, wv else $
                   opt->calculate_all_xyz_from_pix_laue, oadetector
   print_peak_list, opt, wid_list_3
   plot_peaks, draw0, opt, arr1, arr2
   re=dialog_message('Angle verification successfully completed')
   stoper1a:

end

;---------------
 'Verify omegas':$
 ;---- checks if the omega angles in peaktable (from prediction)
 ;---- are consistent with the intensity maximum in the rocking curve
 ;---- selects peaks that are not consistent
begin
   ty=omega_or_energy()
   pt=opt->get_object()
   widget_control, wid_text_29, get_value=dira
   widget_control, wid_text_28, get_value=fila
   if dira eq '' then $
   begin
     re=dialog_message('Output directory not selected')
     goto, stoper1a
   endif
   if fila eq '' then $
   begin
     re=dialog_message('Improper image file name')
     goto, stoper1a
   endif
   widget_control, wid_text_6, get_value=ni
   widget_control, wid_text_7, get_value=i0
   widget_control, wid_text_4, get_value=om0
   widget_control, wid_text_5, get_value=omD
   i0=fix(i0)
   ni=fix(ni)
   om0=float(om0)
   omD=float(omD)
   ene0=float(om0)
   eneD=float(omD)

   ;bs=read_box_size(wid_text_37,wid_text_37)

  ;--- make array for profiles
   profiles=fltarr(pt.peakno, ni[0])
   widget_control, wid_text_8, set_value=string(0, format='(I3)')+'/'+string(ni[0], format='(I3)')
   for i=0, ni[0]-1 do $
   begin


    res.seq=i0[0]+i
    fn=generate_fname(res)
    res=analyse_fname(fn, dir, 3)
    widget_control, wid_text_9, set_value=res.name0
    oimage->load_image, fn, oadetector
    check_mask_file
    im=oimage->get_object()
    data1=congrid(im.img[0:arr1-1,0:arr2-1]*maskarr, 600, 600)
    widget_control, wid_text_24, get_value=imax
    widget_control, wid_text_25, get_value=imin
    imax=long(imax)
    imin=long(imin)
    imax=imax[0]
    imin=imin[0]
    data1=data1>imin
    data1=data1<imax
    wset, draw0
    tvscl, data1
    for k=0, pt.peakno-1 do $
    begin
      bs=[long(pt.peaks[k].intssd[0]),long(pt.peaks[k].intssd[0])]
      pic=oimage->get_zoomin(pt.peaks[k].detXY, bs, maskarr)
      profiles[k,i]=total(pic)
    end
    widget_control, wid_text_8, set_value=string(i+1, format='(I2)')+'/'+string(ni[0], format='(I2)')
   endfor
   omega=fltarr(ni[0])
   ene=fltarr(ni[0])
   for i=0, ni[0]-1 do omega[i]=om0+i*omD
   for i=0, ni[0]-1 do ene[i]=ene0+i*eneD

   pt.peaks[*].selected[0]=0
   for i=0, pt.peakno-1 do $
   begin ;------ modifications here
     re=max(profiles[i,0:ni[0]-1],l)
     if ty eq 1 then $
     begin
       print, i, pt.peaks[i].gonio[3], omega[l]
       if abs(pt.peaks[i].gonio[3]-omega[l]) gt 2.0 then pt.peaks[i].selected[0]=1
     endif else $
     begin
       pt.peaks[i].energies[0]=ene[l]
       pt.peaks[i].gonio[3]=0.0
     end
   endfor

   opt->set_object, pt
   capture_calibration, oadetector, wv
   opt->calculate_all_xyz_from_pix, oadetector, wv


   if ty eq 1 then opt->calculate_all_xyz_from_pix, oadetector, wv else $
                   opt->calculate_all_xyz_from_pix_laue, oadetector
   print_peak_list, opt, wid_list_3
   plot_peaks, draw0, opt, arr1, arr2
   re=dialog_message('Angle verification successfully completed')
   stoper2a:

end
;-------
'Integrate series':$
begin

;0000000000000000
   capture_calibration, oadetector, wv
   npoints=2000
   time0= SYSTIME(/SECONDS)
   ;Int=oimage->integrate(oadetector, 1500, [1.,30.])
   x1=[0,0]
   x2=[0,arr2]
   x3=[arr1,0]
   x4=[arr1,arr2]

   x5=[arr1/2,0]
   x6=[arr1/2,arr2]
   x7=[0,arr2/2]
   x8=[arr1,arr2/2]

   an=read_kappa_and_ttheta()
   gonio=fltarr(6)
   gonio[1]=an[1]

   aa=    [oadetector->calculate_tth_from_pixels(x1,gonio),$
           oadetector->calculate_tth_from_pixels(x2,gonio),$
           oadetector->calculate_tth_from_pixels(x3,gonio),$
           oadetector->calculate_tth_from_pixels(x4,gonio), $
           oadetector->calculate_tth_from_pixels(x5,gonio),$
           oadetector->calculate_tth_from_pixels(x6,gonio),$
           oadetector->calculate_tth_from_pixels(x7,gonio),$
           oadetector->calculate_tth_from_pixels(x8,gonio)]

   m1=min(aa)
   m2=max(aa)
   m1=0

;0000000000000000

  WIDGET_CONTROL, WID_TEXT_46a, GET_VALUE=a
  a=float(a)
  a=a[0]

  widget_control, wid_text_6, get_value=ni
    widget_control, wid_text_7, get_value=i0
    i0=reform(fix(i0))
    ni=reform(fix(ni))
    sum=fltarr(arr1,arr2)
    cnt=Intarr(arr1,arr2)
    for i=0, ni[0]-1 do $
    begin
      res.seq=i0[0]+i
      fn=generate_fname(res)
      res=analyse_fname(fn, dir, 3)
      widget_control, wid_text_9, set_value=res.name0
      oimage->load_image, fn, oadetector
      check_mask_file
      plot_image, oimage
 ;--------------
   im=oimage->get_object()
   w=where(im.img gt a)
   if w[0] ne -1 then maskarr[w]=0
   plot_image, oimage
   ys=long(w/arr1)
   xs=w-ys*arr1
   wset, draw0
   device, decomposed=1
   for iy=0L, n_elements(xs)-1 do $
   plots, xs[iy]/float(arr1), ys[iy]/float(arr2), color='FF0000'XL, /normal, psym=2, symsize=0.5
   device, decomposed=0
;--------------

   Int=oimage->integrate_dll(oadetector, 2500.000, [double(m1),double(m2)], maskarr)
   zeroref=Int
   fnc=out_dir+res.name0+'.chi'
   n=n_elements(int)/2
   wset, wid_draw_6
   plot, int[0,0:n-1],int[1,0:n-1]
   write_data_to_chi, fnc, Int
;--------------
      print, '--> ',i
    endfor
    im.img=sum;/cnt
    oimage->set_object, im
    maskarr[*,*]=1
    plot_image, oimage
    print, '--> done'
end
;-------

'Merge step images':$
begin
    if n_elements(res) gt 0 then $
    begin
    widget_control, wid_text_6, get_value=ni
    widget_control, wid_text_7, get_value=i0
    i0=reform(fix(i0))
    ni=reform(fix(ni))
    sum=fltarr(arr1,arr2)
    cnt=Intarr(arr1,arr2)

 	cgProgressBar = Obj_New("CGPROGRESSBAR", /Cancel)
 	cgProgressBar -> Start

    if not(whole_p_series()) then $
    begin

    for i=0, ni[0]-1 do $
    begin
      res.seq=i0[0]+i
      fn=generate_fname(res)
      res=analyse_fname(fn, dir, 3)
      widget_control, wid_text_9, set_value=res.name0
      oimage->load_image, fn, oadetector
      check_mask_file
      plot_image, oimage
      im=oimage->get_object()
      sum=sum+im.img*maskarr
      cnt=cnt+maskarr
      IF cgProgressBar -> CheckCancel() THEN BEGIN
        ok = Dialog_Message('Operation canceled')
        cgProgressBar -> Destroy
      RETURN
      ENDIF
      cgProgressBar -> Update, (float(i)/(ni[0]-1))*100.0
    endfor
    im.img=ni[0]*sum/cnt
    w=where(cnt eq 0)
    if w[0] ne -1 then im.img[w]=0
    oimage->set_object, im
    maskarr[*,*]=1
    plot_image, oimage
    cgProgressBar -> Destroy
    endif else $
    begin
;------------------------ merge whole series

  fn=generate_fname(res)
  b=strpos(fn, '_P0')
  l=strlen(fn)
  cc=strmid(fn, 0, b+2)
  dd=strmid(fn, b+6, l-(b+7-4))
  maskarr[*,*]=1

  for i=0, 300 do $
  begin
    t0=systime(/seconds)
    name=cc+string(i, format='(I04)')+dd
    re=file_info(name)
    res=analyse_fname(name, '', 3)
    f0=find_series_start(res)
    f1=find_series_end(res)
    print, name, re.exists, f0, f1
    if (re.exists eq 1) and (f0 eq 1) and (f1 eq 68)  then $
    begin; ----- processing individual pressure
      sum=fltarr(arr1,arr2)
      cnt=Intarr(arr1,arr2)
      for ij=0, ni[0]-1 do $
      begin
        res.seq=i0[0]+ij
        fn=generate_fname(res)
        res=analyse_fname(fn, dir, 3)
        widget_control, wid_text_9, set_value=res.name0
        oimage->load_image, fn, oadetector
        plot_image, oimage
        im=oimage->get_object()
        sum=sum+im.img*maskarr
        cnt=cnt+maskarr
        update_progress, float(ij+1)/ni
      endfor
      im.img=ni[0]*sum/cnt
      w=where(cnt eq 0)
      if w[0] ne -1 then im.img[w]=0
      oimage->set_object, im
      plot_image, oimage
      nn=cc+string(i, format='(I04)')+'.tif'
      write_tiff, nn, reverse(im.img,2), /long

      print, '--> done', nn

    endif
  endfor
 print, '------------------------- FINISHED ----------------------------'
 endelse
 endif
end
;-------end
 'Use exclusions':$
 begin
 end
;-------
 'Update exclusion':$
 begin
  scale1=arr1/600.
  scale2=arr2/600.
  re=widget_info(wid_list_1, /list_select)
  if re ne -1 then $
  begin
     widget_control, wid_text_18, get_value=ex0
     widget_control, wid_text_19, get_value=ex1
     if not (ex0 eq '' or ex1 eq '') then $
     begin
      EXCLUSIONS[0,re]=float(ex0)
      EXCLUSIONS[1,re]=float(ex1)
      plot_ds_ring, EXCLUSIONS[0,re]+EXCLUSIONS[1,re], scale1, scale2, 1
      plot_ds_ring, EXCLUSIONS[0,re]-EXCLUSIONS[1,re], scale1, scale2, 0
      Print_exclusions, EXCLUSIONS
      widget_control, wid_list_1, set_list_select=re
     endif
  end
 end
;-------
 'Remove exclusion':$
 begin
  sz=n_elements(EXCLUSIONS)/2
  re=widget_info(wid_list_1, /list_select)
  if re ne -1 then $
  begin
   if sz eq 1 then EXCLUSIONS=[0.,0.] else $
   if re eq 0 then EXCLUSIONS=EXCLUSIONS[0:1,1:sz-1] else $
   if re eq sz-1 then EXCLUSIONS=EXCLUSIONS[0:1, 0:re-1] else $
   EXCLUSIONS=[[EXCLUSIONS[0:1,0:re-1]],[EXCLUSIONS[0:1, re+1:sz-1]]]
   Print_exclusions, EXCLUSIONS

  endif

 end
 ;------
 'Clear exclusions':$
 begin
   exclusions=[0.,0.]
   Print_exclusions, EXCLUSIONS
 end
;-------
 'open exclusions':$
 begin
   re=dialog_pickfile(/read, filter='*.exc', DEFAULT_EXTENSION='.cal', path=out_dir)
   if re ne '' then  $
   begin
      exclusions=load_exclusions(re)
      Print_exclusions, EXCLUSIONS
   endif

 end
;-------
 'save exclusions':$
 begin
   re=dialog_pickfile(/read, filter='*.exc', DEFAULT_EXTENSION='.cal', path=out_dir)
   if re ne '' then  save_exclusions, re, exclusions
 end
;-------
'Exclusion list':$
begin
  scale1=arr1/600.
  scale2=arr2/600.
  re=widget_info(wid_list_1, /list_select)
  if re ne -1 then $
  begin
     plot_ds_ring, EXCLUSIONS[0,re]+EXCLUSIONS[1,re], scale1, scale2, 1
     plot_ds_ring, EXCLUSIONS[0,re]-EXCLUSIONS[1,re], scale1, scale2, 0
     widget_control, wid_text_18, set_value=string(EXCLUSIONS[0,re], format='(F10.3)')
     widget_control, wid_text_19, set_value=string(EXCLUSIONS[1,re], format='(F10.3)')
  end
end
;-------
'Save image':$
begin
  wset, draw0
  img=tvrd(0,0,600,600)
  ;tv, img, true=0
  fn=dialog_pickfile(/write, filter='*.jpg', default_extension='.jpg', path=out_dir)
  if fn ne '' then write_jpeg, fn, img, quality=100
end
'Print image':$
begin
     wset, draw0
     xyouts, 0,0,res.name0
     al=tvrd(0,0,600,600,/order, true=1)
     xs=18
     ys=18
     set_plot, 'Printer', /copy
     device, /true_color
     device, /landscape
     result=dialog_printersetup()
     tv, al, true=1, /centimeters, xsize=xs, ysize=ys, /order
     device, /close
     set_plot, 'Win'
end
;-------
'Export ASCII PT':$
begin
 ;re=dialog_message('Use long output format?', /question)

 ;if re eq 'Yes' then $
 opt->export_peak_list, wv, oadetector, out_dir
 ;else $
 ;fn=opt->save_hkl(out_dir)
end
;-------
'Simulate':$
begin
if SIM_open eq 0 then $
begin
 SIM_open=1
 if wid_sim->realized() eq 1 then wid_sim->show else   wid_sim->realize
end
end
;-------
'Filter observed':$

begin
  cgProgressBar = Obj_New("CGPROGRESSBAR", /Cancel)
  cgProgressBar -> Start
  bx0=read_box_size(wid_text_37,wid_text_37)
  a=oimage->calculate_local_background(0)
  widget_control, wid_text_48, get_value=obs
  obs=float(obs)


  opt->unselect_all
  pt=opt->get_object()
  for pn=0, opt->peakno()-1 do $
  begin

    IF cgProgressBar -> CheckCancel() THEN BEGIN
    	cgProgressBar -> Destroy
        ok = Dialog_Message('The user cancelled operation.')
        RETURN
    ENDIF

    cgProgressBar -> Update, float(pn)/(opt->peakno()-1)*100

  	bs=[long(pt.peaks[pn].intssd[0]),long(pt.peaks[pn].intssd[0])]
    xy=pt.peaks[pn].detXY
 	 bs=[2,2]
    if current_vs_series() eq  1 then $
         pic=oimage->get_zoomin(XY, bs, maskarr) else $
    begin
      	 ;bs=read_box_size(wid_text_37,wid_text_37)
     	 pic1=reform(cumInt[pn,*,*])
     	 pic=pic1[20-bs[0]:20+bs[0],20-bs[1]:20+bs[1]]
    endelse
    med=median(pic)
    if (max(pic)-med)  lt obs then opt->select_peak, pn
  endfor

  plot_peaks, draw0, opt, arr1, arr2
  cgProgressBar -> Destroy

end

;-------
'Display hkl labels':$
begin
 ;  widget_control, WID_DROPLIST_1, SET_VALUE=text1
   plot_image, oimage
   plot_peaks, draw0, opt, arr1, arr2
end
;-------
'Edit peak':$
begin

   pn=read_peak_selected(wid_list_3)
   if pn ne -1 then $
   begin
    common status, PE_open
     if  PE_open eq 0 then $
     begin

     pt=opt->get_object()
     if pn ge 0 and pn le opt->peakno()-1 then $
     PE_open=1
     wid_peditor->show
     wid_peditor->fillup , pn, pt

      print_peak_list, opt, wid_list_3
      widget_control, wid_list_3, set_list_select=pn
     end
   endif
end
;-------

'laue class':$
begin
  re=widget_info(WID_Droplist_brav, /droplist_select)
  widget_control, WID_Droplist_4aa, set_droplist_select=re
  if opt->peakno() ne 0 then print_R_int, Rint(get_laue_class(), opt)
end

'scale select':$
begin
if opt->peakno() ne 0 then $
begin
  opt->unselect_all
  Select_worst_Rint, get_laue_class(), opt, read_scale_select_th(), wid_draw_6
  plot_image, oimage
  update_peakno, opt->peakno()
  plot_peaks, draw0, opt, arr1, arr2
  print_peak_list, opt, wid_list_3
endif
end


'scale':$
begin
; calculate and plot the intensity difference
; fit polynomial
; display fit curve
if opt->peakno() ne 0 then $
begin
  if scale_spline() eq 0 then a=Scale_with_Rint(get_laue_class(), opt, wid_draw_6) else $
  a=Scale_with_Rint_spline(get_laue_class(), opt, wid_draw_6, scale_spline())
  print_R_int, Rint(get_laue_class(), opt)
endif
end

'apply scale':$
begin
; change intensities according to the scaling polynomial

if opt->peakno() ne 0 then $
begin

  if scale_spline() ne 0 then $
  begin
     apply_Scale_with_Rint_spline, get_laue_class(), opt, wid_draw_6, scale_spline()
  endif else $ ---- polynomial
  begin
   result=float(poly_text)
   pt=opt->get_object()
   for i=0, pt.peakno-1 do $
   begin
     x1=pt.peaks[i].gonio[3]
     m=poly(x1,result)+1.0
     pt.peaks[i].IntAD[0]=pt.peaks[i].IntAD[0]/m
     pt.peaks[i].IntAD[1]=pt.peaks[i].IntAD[1]/m
   endfor
   opt->set_object, pt
  endelse
 print_R_int, Rint(get_laue_class(), opt)
endif
end


'Laue Class':$
begin
  if opt->peakno() ne 0 then print_R_int, Rint(get_laue_class(), opt)
  widget_control, WID_Droplist_brav, set_droplist_select=get_laue_class()
end

'Change box size':$
begin
  a=read_box_change()
  bx=read_box_size(wid_text_37,wid_text_37)
  pn=read_peak_selected(wid_list_3)

  if a eq 1 then $; all peaks
  begin
    opt->set_peak_box_size, bx
  endif else $ ; just one peak
  begin
   if pn ne -1 then $
   begin
     opt->set_peak_box_size, bx, pn
   endif
  endelse

end
'AddIm2Task': $ ; add current image to task list...
begin
	myim = res.name0
	; now check for ub file
	; and check for
	calfile = res.base + '.cal'
	fileexists = FILE_TEST (calfile)
	if (fileexists eq 0) then begin
		ok= dialog_message (/Error, "Corresponding .cal file does not exist. Image is not added to task list")
		return
	endif
	ubfile = res.base + '.ub'
	fileexists = FILE_TEST (ubfile)
	if (fileexists eq 0) then begin
		ok= dialog_message (/Error, "Corresponding .ub file does not exist. Image is not added to task list")
		return
	endif

	; ok to add to the task list
	numims = widget_info (WID_LIST_TASK, /LIST_NUMBER)
	if numims gt 0 then begin
		widget_control, WID_LIST_TASK, get_uvalue=tasklist
		if (tasklist(0) eq 'EMPTY') then begin
			tasklist=strarr(1)
			tasklist(0)=res.path+res.name0
		endif else $
			tasklist=[tasklist,res.path+res.name0]
	endif else begin
		tasklist=strarr(1)
		tasklist(0)=res.path+res.name0
	endelse
	widget_control, WID_LIST_TASK, set_value=tasklist, set_uvalue=tasklist


end
'ClearTask' : $ ; clear all from task list widget
begin
	tasklist=strarr(1)
	tasklist(0)='EMPTY'
	widget_control, WID_LIST_TASK, set_value='', set_uvalue=tasklist
end
'SaveTask' : $ ; save to file
begin
	numims = widget_info (WID_LIST_TASK, /LIST_NUMBER)
	if (numims le 0) then return
	outfile = DIALOG_PICKFILE (title='Save Tasks To Output File',filter=['*.txt','*.*'])
	openw,lun, outfile,/get_lun
	widget_control, WID_LIST_TASK, get_uvalue=tasklist
	printf, lun, tasklist
	close,lun
	free_lun,lun
end
'ReadTask' : $ ; read tasks from file
begin


	tfile = DIALOG_PICKFILE (title='Load Tasks from  File',filter=['*.txt','*.*'])
	status = FILE_TEST(tfile)
	if (status lt 0) then return
	nlines = FILE_LINES(tfile)
	tasklist = strarr(nlines)
	openr,lun, tfile,/get_lun
	readf, lun, tasklist
	close,lun
	free_lun,lun
	widget_control, WID_LIST_TASK, set_uvalue=tasklist, set_value=tasklist
end


'DeleteTask': $ ; add current image to task list...
begin

	numims = widget_info (WID_LIST_TASK, /LIST_NUMBER)
	if numims le 0 then return
	widget_control, WID_LIST_TASK, get_uvalue=tasklist
	if numims eq 1 then begin
		tasklist=strarr(1)
		tasklist(0)='EMPTY'
		widget_control, WID_LIST_TASK, set_value='', set_uvalue=tasklist
		return
	endif

	selind = widget_info( WID_LIST_TASK, /LIST_SELECT)
	if selind lt 0 then return
	if selind eq 0 then begin
		tasklist = tasklist (1:*)
		widget_control, WID_LIST_TASK, set_value=tasklist, set_uvalue=tasklist
		return
	endif
	if selind eq numims -1 then begin
		tasklist = tasklist(0:selind -1)
		widget_control, WID_LIST_TASK, set_value=tasklist, set_uvalue=tasklist
		return
	endif
	tasklist = [tasklist(0:selind-1), tasklist(selind+1:*)]
	widget_control, WID_LIST_TASK, set_value=tasklist, set_uvalue=tasklist






end
'Max filter':$ ;--- calculate maximum threshold filter
begin
  re=WIDGET_INFO(WID_BUTTON_33a, /BUTTON_SET)
  if re eq 1 then $
  begin
   WIDGET_CONTROL, WID_TEXT_46a, GET_VALUE=a
   a=float(a)
   a=a[0]
   im=oimage->get_object()
   w=where(im.img gt a)
   if w[0] ne -1 then maskarr[w]=0
   plot_image, oimage
   ys=long(w/arr1)
   xs=w-ys*arr1
   wset, draw0
   device, decomposed=1
   for i=0L, n_elements(xs)-1 do $
   plots, xs[i]/float(arr1), ys[i]/float(arr2), color='FF0000'XL, /normal, psym=2, symsize=0.5
   device, decomposed=0

  endif else plot_image, oimage

end

;-------

'Region select':$

 begin
   print, 'Select 2theta range according to exclusion'
   print, exclusions
   pt=opt->get_object()
   for i=0, pt.peakno-1 do $
   begin
     tth=oadetector->calculate_tth_from_pixels(pt.peaks[i].detXY, pt.peaks[i].gonio)
     for j=0, n_elements(exclusions)/2-1 do $
     begin
       if tth gt exclusions[0,j]-exclusions[1,j] and tth lt exclusions[0,j]+exclusions[1,j] then pt.peaks[i].selected[0]=1
     endfor
   endfor
   opt->set_object, pt
   plot_image, oimage
   update_peakno, opt->peakno()
   plot_peaks, draw0, opt, arr1, arr2
 end

;-------
 'Move peaks':$
   begin
     if which_PT() eq 1 then $ ; move to PT2
     begin
      opt->move_sel_peaks_AtoB, opt2
      opt2->unselect_all
     endif else $ ; move to PT1
     begin
      opt->move_sel_peaks_AtoB, opt1
      opt1->unselect_all
     endelse
     plot_image, oimage
     update_peakno, opt->peakno()
     plot_peaks, draw0, opt, arr1, arr2
     print_peak_list, opt, wid_list_3
   end
 'PT1':$
   begin
    ; check if it is in PT1
     if which_PT() eq 1 then $
     begin
     opt2->replace_all_peaks_AbyB, opt
     opt->replace_all_peaks_AbyB, opt1
     plot_image, oimage
     update_peakno, opt->peakno()
     plot_peaks, draw0, opt, arr1, arr2
     print_peak_list, opt, wid_list_3
     endif
   end
 'PT2':$
   begin
    ; check if it is in PT2
     if which_PT() eq 0 then $
     begin
     opt1->replace_all_peaks_AbyB, opt
     opt->replace_all_peaks_AbyB, opt2
     plot_image, oimage
     update_peakno, opt->peakno()
     plot_peaks, draw0, opt, arr1, arr2
     print_peak_list, opt, wid_list_3
     endif
   end

'Both PT':$
begin
  	 opt->unselect_all
     plot_image, oimage
     plot_peaks, draw0, opt, arr1, arr2
  	 opt1->select_all
     plot_peaks, draw0, opt1, arr1, arr2
end
;-------

'Show rings':$
begin
   re=WIDGET_INFO(WID_but_36ac, /BUTTON_SET)
   if re eq 1 then $
   begin
    capture_calibration, oadetector, wv
    plot_image, oimage
    scale1=arr1/600.
    scale2=arr2/600.
    ds=which_calibrant(200., 1)
    tths=tth_from_en_and_d(A_to_keV(wv), ds)
    kath=read_kappa_and_ttheta()
    for i=0, n_elements(tths)-2 do $
    plot_ds_ring, tths[i], scale1, scale2, 0
    plot_ds_ring, tths[n_elements(tths)-1], scale1, scale2, 0
   endif else plot_image, oimage

end

'peak list':$
begin

;----------------- read intentisy scale
 if current_vs_series() eq 0 then $ ;-------------- intensity from series
 begin

 endif else $
 begin ;----------- individual image ----------------------

 pn=read_peak_selected(wid_list_3)
 if pn ge 0 and pn lt opt->peakno() then $
 begin


   pt=opt->get_object()
   widget_control, wid_text_37, SET_VALUE=strcompress(string(long(pt.peaks[pn].intssd[0])),/remove_all) ; display peak box size
   opt->unselect_all
   opt->select_peak, pn
   plot_peaks, draw0, opt, arr1, arr2
   bs=[long(pt.peaks[pn].intssd[0]),long(pt.peaks[pn].intssd[0])]

   b=opt->find_close_overlaps(pn, 10)
   if b[0] gt 0 then pic9=two_peaks_get_profile(b[1],b[2]) else $
   pic9=one_peak_get_profile(pn)

   if n_elements(pic9) eq 1 then pic9=fltarr((bs+1)*2)

   if min(pic9) eq 0 then $
   begin
     print, 'blind region'
   end

   sz=sqrt(n_elements(pic9))
   szi=(sz-1)/2
   bs=[szi,szi]

   pt=opt->get_object()
   XY=round(pt.peaks[pn].detxy)
   pic=oimage->get_zoomin(XY, bs, maskarr)

   ;---- if part of the box area is outside active circle, replace 0 with local background ------
  ; if exclude_corners() then $
  ; begin
  ;   cc=which_pixels_in_mtx_outside_circle(bs[0], xy, arr1/2-2)
  ;   c=where(cc eq 1)
  ;   if c[0] ne -1 then pic[c]=replicate(lbcgr[xy[0],xy[1]], n_elements(c))
  ; endif

   ;---------------------------------------------------------------------------------------------


       pic22=pic-pic9

       m1=max(pic22)   ; maximum difference
       m3=median(pic)
       m6=max(pic)    ; maximum in the box

       spic=pic[szi-3:szi+3,szi-3:szi+3]
       spic9=pic9[szi-3:szi+3,szi-3:szi+3]
       spic22=spic-spic9

       m7=total(pic[szi-2:szi+2,szi-2:szi+2])-25.*m3


 tf=total(pic9)-median(pic9)*n_elements(pic22)
       tp=total(pic)-median(pic)*n_elements(pic22)
       stf=total(spic9)-median(pic9)*n_elements(spic22)
       stp=total(spic)-median(pic)*n_elements(spic22)

          print, '------------------------ '
          print, '----- ', pn, '  max pic=           ', m6-median(pic)
          print, '----- ', pn, '  total fit=         ', tf
          print, '----- ', pn, '  total pic=         ', tp
          print, '----- ', pn, '  total sfit=         ', stf
          print, '----- ', pn, '  total spic=         ', stp
          print, '----- ', pn, '  median pic=        ', m3
          print, '----- ', pn, '  median fit=        ', median(pic9)
          print, '----- ', pn, '  max difference=    ', m1
          print, '----- ', pn, '  total difference=  ', long(total(abs(pic22)))
          print, '----- ', pn, '  total median=      ', m3*n_elements(pic22)
          print, '----- ', pn, '  abs(stp-stf)/stp=      ', abs(stp-stf)/stp
          print, '----- ', pn, '  max((spic-median(pic9))/median(pic9))=      ', max((spic-median(pic9))/median(pic9))
          print, '------------------------ '

    if total(pic9)-median(pic9)*n_elements(pic22) eq 0 then print, '========= fit failed'
    ;if abs(tp-tf)/tp gt 0.2 then print, '========= large differnce bix', abs(tp-tf)/tp
    if abs(stp-stf)/stp gt 0.25 then print, '========= large differnce small', abs(stp-stf)/stp


    pic1=congrid(pic, 210, 210)
    pic2=congrid(pic9, 210,210)

    pic3=pic1-pic2

    widget_control, wid_text_24, get_value=imax
    widget_control, wid_text_25, get_value=imin
    imax=long(imax)
    imin=long(imin)
    imax=imax[0]
    imin=imin[0]

    wset, wid_draw_1
	a1=pic1<imax
	a2=a1>imin
    tvscl, a2
    wset, wid_draw_2
	a1=pic2<imax
	a2=a1>imin
    tvscl, a2
    wset, wid_draw_5
	a1=pic3<imax
	a2=a1>imin
    tvscl, a2

    if PE_open eq 1 then $ ;--- Peak Editor only
    begin
       ;display_peak, pn, pt
       wid_peditor->fillup , pn, pt
       ;plot_peak, pn, pt, oimage
    endif

  endif else $ ;- pn gt 0
  begin
    wset, wid_draw_1
    tvscl, pic1
  endelse

 endelse ; individual image
 end

;************************  NEW CODE ***************************************
 'Help':$
 begin
 ;Check what the IDL working directory is and store it in homeDirectory.
 CD, Current = homeDirectory
 ;Display the dialog window for the user to open the help file.
 re=dialog_message(['Please make sure that you have a common windows ', $
 				   'path set for the Wordpad. If not sure cancel ', $
 				   'this window and consult your documentation installation. ', $
 				   'Help file is located in ' + homeDirectory], $
                   /CANCEL, /CENTER, TITLE = 'HELP FILE INFO')
 if re ne 'Cancel' then begin $
  ;Store the user selection from the dialog menu.
  fn=dialog_pickfile(/read, filter=['*.rtf'], path=dir, get_path=dir)
  ;If file is picked
  if fn ne '' then $
  begin
  ;Open Wordpad and display the help file
  spawn, ['write', fn], /noshell, /nowait ;, dialog_pickfile (filter=['*.txt'], path=dir, get_path=dir)
  endif
 endif

;////////////////////////////////////////////
  ;if fn ne '' then $
  ;begin
   ;save_last_directories
  ;endif
 ;///////////////////////////////////////////
 end

;***************************************  NEW CODE *************************

;-------
 else:
 endcase

end


;------

pro draw_box, box00x, box00y, x, y, draw, col
device, decomposed=1
                 wset, draw
                 PLOTS, box00x, box00y, /DEVICE, color=col
                 PLOTS, box00x, y,      /CONTINUE, /DEVICE, color=col, linestyle=2
                 PLOTS, x, y,           /CONTINUE, /DEVICE, color=col, linestyle=2
                 PLOTS, x, box00y,      /CONTINUE, /DEVICE, color=col, linestyle=2
                 PLOTS, box00x, box00y, /CONTINUE, /DEVICE, color=col, linestyle=2
device, decomposed=0
end

;------
pro plot_peaks, draw, opt, arr1,arr2
device, decomposed=1
   wset, draw
   pt=opt->get_object()
   for i=0, pt.peakno-1 do $
   begin
     if pt.peaks[i].selected[0] eq 0 then col='000000'XL else col='00FF10'XL
     x=(pt.peaks[i].detxy[0]/float(arr1))
     y=((pt.peaks[i].detxy[1])/float(arr2))
     if x-0.01 gt 0 and x+0.01 lt 1.0 and $
        y-0.01 gt 0 and y+0.01 lt 1.0 then $
     begin
     hkl=string(pt.peaks[i].hkl[0],format='(I3)')+string(pt.peaks[i].hkl[1],format='(I3)')+string(pt.peaks[i].hkl[2],format='(I3)')
      if hkl_labels_on() eq 1 then xyouts,x-0.05, y+0.015, hkl, color='0000FF'XL, /normal
      plots, x-0.010, y+0.010, color=col, /normal
      plots, x+0.010, y+0.010, /continue, color=col, /normal
      plots, x+0.010, y-0.010, /continue, color=col, /normal
      plots, x-0.010, y-0.010, /continue, color=col, /normal
      plots, x-0.010, y+0.010, /continue, color=col, /normal
     end
   end
   device, decomposed=0
end

;--------------------------------------
pro plot_peaks_zoom, draw, opt
COMMON image_type_and_arrays
device, decomposed=1
   wset, draw
   pt=opt->get_object()
   b=0.1*120.0/rad
   b1=0.1*120.0/rad1
   for i=0, pt.peakno-1 do $
   begin
     if pt.peaks[i].selected[0] eq 0 then col='000000'XL else col='00FF10'XL
     x=((pt.peaks[i].detxy[0]-cenx)/float(2.0*rad))+0.5
     y=((pt.peaks[i].detxy[1]-ceny)/float(2.0*rad1))+0.5
     if x-0.01 gt 0 and x+0.01 lt 1.0 and $
        y-0.01 gt 0 and y+0.01 lt 1.0 then $
     begin
     hkl=string(pt.peaks[i].hkl[0],format='(I3)')+string(pt.peaks[i].hkl[1],format='(I3)')+string(pt.peaks[i].hkl[2],format='(I3)')
      if hkl_labels_on() eq 1 then xyouts,x-b, y+b1, hkl, color='0000FF'XL, /normal
      plots, x-b, y+b1, color=col, /normal
      plots, x+b, y+b1, /continue, color=col, /normal
      plots, x+b, y-b1, /continue, color=col, /normal
      plots, x-b, y-b1, /continue, color=col, /normal
      plots, x-b, y+b1, /continue, color=col, /normal
     end
   end
   device, decomposed=0
end

;--------------------------------------

pro WID_MAR345_aux

COMMON WID_MAR345_elements
common datas
 COMMON draws,DRAWA,wid_list_3a

 WIDGET_CONTROL, WID_BUTTON_0, SET_UVALUE='Close'
 WIDGET_CONTROL, WID_BUTTON_1, SET_UVALUE='Open'
 WIDGET_CONTROL, WID_BUTTON_24, SET_UVALUE='Correlate'
 WIDGET_CONTROL, WID_BUTTON_25, SET_UVALUE='SaveImg'
 WIDGET_CONTROL,WID_BUTTON_20aa3, SET_UVALUE=''
 WIDGET_CONTROL,WID_BUTTON_412b, SET_UVALUE=''
 WIDGET_CONTROL,WID_BUTTON_413b, SET_UVALUE=''
 WIDGET_CONTROL,WID_BUTTON_412b, SET_BUTTON=1
 WIDGET_CONTROL,WID_BUTTON_47b, SET_UVALUE='Int. from series'
 WIDGET_CONTROL, WID_BUTTON_SAVEPROJ, SET_UVALUE='SaveProj'

; WIDGET_CONTROL, WID_BUTTON_1c, SET_UVALUE='SubtrImg'
; WIDGET_CONTROL, WID_BUTTON_1d, SET_UVALUE='AddImg'
 WIDGET_CONTROL, WID_BUTTON_2, SET_UVALUE='Colors'
 WIDGET_CONTROL, WID_BUTTON_3, SET_UVALUE='<-'
 WIDGET_CONTROL, WID_BUTTON_4, SET_UVALUE='->'
 WIDGET_CONTROL, WID_BUTTON_5, SET_UVALUE='PS'
 WIDGET_CONTROL, WID_BUTTON_5s, SET_UVALUE='PS Series'
 WIDGET_CONTROL, WID_BUTTON_51M, SET_UVALUE='PS Series Pilatus 1M'

 ;WIDGET_CONTROL, WID_BUTTON_7, SET_UVALUE=''
 ;WIDGET_CONTROL, WID_BUTTON_8, SET_UVALUE=''

WIDGET_CONTROL, WID_BUTTON_11, SET_UVALUE=''
WIDGET_CONTROL, WID_BUTTON_42, SET_UVALUE=''
WIDGET_CONTROL, WID_BUTTON_51, SET_UVALUE=''
WIDGET_CONTROL, WID_BUTTON_51a, SET_UVALUE='Dac absorption'
WIDGET_CONTROL, WID_BUTTON_52, SET_UVALUE=''

WIDGET_CONTROL,  WID_BUTTON_refine_cal_p, set_button=1
WIDGET_CONTROL, WID_BUTTON_51, set_button=1
WIDGET_CONTROL, WID_BUTTON_51a, set_button=1
WIDGET_CONTROL, WID_BUTTON_52, set_button=1


 WIDGET_CONTROL, WID_BUTTON_9, SET_UVALUE='Use exclusions'
 WIDGET_CONTROL, WID_BUTTON_12, SET_UVALUE='Update exclusion'
 WIDGET_CONTROL, WID_BUTTON_13, SET_UVALUE='Remove exclusion'
 WIDGET_CONTROL, WID_BUTTON_14, SET_UVALUE='open exclusions'
 WIDGET_CONTROL, WID_BUTTON_15, SET_UVALUE='save exclusions'
 WIDGET_CONTROL, WID_BUTTON_16, SET_UVALUE='Clear exclusions'

 WIDGET_CONTROL, WID_BUTTON_11, SET_BUTTON=1
 ;WIDGET_CONTROL, WID_BUTTON_7, SET_BUTTON=1


 WIDGET_CONTROL, WID_BUTTON_411, SET_UVALUE='Change box size'
 WIDGET_CONTROL, WID_BUTTON_412, SET_UVALUE=''
 WIDGET_CONTROL, WID_BUTTON_413, SET_UVALUE=''

 WIDGET_CONTROL, WID_BUTTON_413, SET_BUTTON=1


 WIDGET_CONTROL, WID_BUTTON_511, SET_UVALUE='Move peaks'
 WIDGET_CONTROL, WID_BUTTON_512, SET_UVALUE='PT1'
 WIDGET_CONTROL, WID_BUTTON_513, SET_UVALUE='PT2'

 WIDGET_CONTROL, WID_BUTTON_512, SET_BUTTON=1

 ;******************************* TAKEN OUT ***************
 ;WIDGET_CONTROL, WID_BUTTON_6, SET_UVALUE='Search series'
 ;WIDGET_CONTROL, WID_BUTTON_17, SET_UVALUE='Stop series search'
 ;WIDGET_CONTROL, WID_BUTTON_18, SET_UVALUE='Merge peaktables'
 ;******************************* TAKEN OUT ***************

  WIDGET_CONTROL,  WID_TEXT_83ad, EDITABLE=0
  WIDGET_CONTROL, WID_TEXT_83d,  EDITABLE=0
  WIDGET_CONTROL, WID_TEXT_82d,  EDITABLE=0
  WIDGET_CONTROL, WID_TEXT_81d,  EDITABLE=0
  WIDGET_CONTROL, WID_TEXT_80d,  EDITABLE=0
  WIDGET_CONTROL, WID_TEXT_32d,  EDITABLE=0
  WIDGET_CONTROL, WID_TEXT_33d,  EDITABLE=0
  WIDGET_CONTROL, WID_TEXT_35d,  EDITABLE=0
  WIDGET_CONTROL, WID_TEXT_36d,  EDITABLE=0

 WIDGET_CONTROL, WID_BUTTON_19, SET_UVALUE='Display hkl labels'
; WIDGET_CONTROL, WID_BUTTON_19a, SET_UVALUE='Fix tilt'
 ;WIDGET_CONTROL, WID_BUTTON_20, SET_UVALUE='Load peak tables'
 WIDGET_CONTROL, WID_BUTTON_21, SET_UVALUE='Pick image directory'
 WIDGET_CONTROL, WID_BUTTON_22, SET_UVALUE='Pick output directory'
 ;WIDGET_CONTROL, WID_BUTTON_23, SET_UVALUE='Read UB matrix'
 ;WIDGET_CONTROL, WID_BUTTON_24, SET_UVALUE=''
 ;WIDGET_CONTROL, WID_BUTTON_25, SET_UVALUE=''
 WIDGET_CONTROL, WID_BUTTON_26, SET_UVALUE='Open calibration'
 WIDGET_CONTROL, WID_BUTTON_27, SET_UVALUE='Save calibration'
 WIDGET_CONTROL, WID_BUTTON_28, SET_UVALUE='Open PT'
 WIDGET_CONTROL, WID_BUTTON_29, SET_UVALUE='Save PT'
 WIDGET_CONTROL, WID_BUTTON_30, SET_UVALUE='Clear peaktable'
 WIDGET_CONTROL, WID_BUTTON_31, SET_UVALUE='Integrate chi1'
 WIDGET_CONTROL, WID_BUTTON_33, SET_UVALUE='Output chi'
 WIDGET_CONTROL, WID_BUTTON_32, SET_UVALUE='Delete peaks'
 WIDGET_CONTROL, WID_BUTTON_34, SET_UVALUE='Recalculate XYZ'
 WIDGET_CONTROL, WID_BUTTON_35, SET_UVALUE='Update PT'
 WIDGET_CONTROL, WID_BUTTON_36, SET_UVALUE='Recalculate DetXY'
 ;WIDGET_CONTROL, WID_BUTTON_37, SET_UVALUE='Generate multiple peaks'
 WIDGET_CONTROL, WID_BUTTON_38, SET_UVALUE='Compute profiles'
 WIDGET_CONTROL, WID_BUTTON_39, SET_UVALUE='Reload PT'
 WIDGET_CONTROL, WID_BUTTON_40, SET_UVALUE='Export ASCII PT'
 WIDGET_CONTROL, WID_BUTTON_41, SET_UVALUE='Filter observed'
 WIDGET_CONTROL, WID_BUTTON_43, SET_UVALUE='Save image'
 WIDGET_CONTROL, WID_BUTTON_44, SET_UVALUE='Print image'
 WIDGET_CONTROL, WID_BUTTON_45, SET_UVALUE='Fit all peaks'
 WIDGET_CONTROL, WID_BUTTON_46, SET_UVALUE='Edit peak'
 WIDGET_CONTROL, WID_BUTTON_38a, SET_UVALUE='Merge step images'
 ;WIDGET_CONTROL, WID_BUTTON_47, SET_UVALUE='Refine UB'
 ;WIDGET_CONTROL, WID_BUTTON_48, SET_UVALUE='Save UB'
 WIDGET_CONTROL, WID_BUTTON_49, SET_UVALUE='Simulate'
 WIDGET_CONTROL, WID_BUTTON_50, SET_UVALUE='Cake'
 WIDGET_CONTROL, WID_BUTTON_IM2TASK, SET_UVALUE='AddIm2Task'
 WIDGET_CONTROL, WID_BUTTON_DELTASK, SET_UVALUE='DeleteTask'
 WIDGET_CONTROL, WID_BUTTON_CLEARTASK, SET_UVALUE='ClearTask'
 WIDGET_CONTROL, WID_BUTTON_SAVETASK, SET_UVALUE='SaveTask'
 WIDGET_CONTROL, WID_BUTTON_READTASK, SET_UVALUE='ReadTask'
 WIDGET_CONTROL, WID_TEXT_0, SET_UVALUE=''
 WIDGET_CONTROL, WID_TEXT_1, SET_UVALUE=''
 WIDGET_CONTROL, WID_TEXT_2, SET_UVALUE=''
 WIDGET_CONTROL, WID_TEXT_3, SET_UVALUE=''
 WIDGET_CONTROL, WID_TEXT_3a, SET_UVALUE=''
 WIDGET_CONTROL, WID_TEXT_3a, EDITABLE=1

 ;WIDGET_CONTROL, WID_TEXT_3a, SET_VALUE='10'

 WIDGET_CONTROL, WID_TEXT_4, SET_UVALUE=''
 WIDGET_CONTROL, WID_TEXT_5, SET_UVALUE=''
 WIDGET_CONTROL, WID_TEXT_6, SET_UVALUE=''
 WIDGET_CONTROL, WID_TEXT_7, SET_UVALUE=''

 WIDGET_CONTROL, WID_TEXT_37, SET_UVALUE=''
 ;WIDGET_CONTROL, WID_TEXT_45, SET_UVALUE=''

 WIDGET_CONTROL, WID_TEXT_37, SET_VALUE='8'
 ;WIDGET_CONTROL, WID_TEXT_45, SET_VALUE='20'

 WIDGET_CONTROL, WID_TEXT_36, SET_UVALUE=''
 WIDGET_CONTROL, WID_TEXT_35, SET_UVALUE=''
 WIDGET_CONTROL, WID_TEXT_33, SET_UVALUE=''
 WIDGET_CONTROL, WID_TEXT_83, SET_UVALUE=''
 WIDGET_CONTROL, WID_TEXT_82, SET_UVALUE=''
 WIDGET_CONTROL, WID_TEXT_81, SET_UVALUE=''
 WIDGET_CONTROL, WID_TEXT_80, SET_UVALUE=''


 WIDGET_CONTROL, WID_TEXT_14, SET_UVALUE=''
 WIDGET_CONTROL, WID_TEXT_14, SET_VALUE='0.058675'
 WIDGET_CONTROL, WID_TEXT_49, SET_UVALUE=''
 WIDGET_CONTROL, WID_TEXT_26, SET_UVALUE=''
 WIDGET_CONTROL, WID_TEXT_50, SET_UVALUE=''
; WIDGET_CONTROL, WID_TEXT_51, SET_UVALUE=''
 WIDGET_CONTROL, WID_TEXT_52, SET_UVALUE=''


 WIDGET_CONTROL, WID_TEXT_24, SET_UVALUE='Imax'
 WIDGET_CONTROL, WID_TEXT_25, SET_UVALUE='Imin'

 ;WIDGET_CONTROL, WID_TEXT_3a, EDITABLE=1
 WIDGET_CONTROL, WID_TEXT_24, EDITABLE=1
 WIDGET_CONTROL, WID_TEXT_25, EDITABLE=1

 WIDGET_CONTROL, WID_Droplist_4aa, SET_UVALUE='Laue Class'
 WIDGET_CONTROL, WID_DROPLIST_aaa, SET_UVALUE='Scan axis'

 ;WIDGET_CONTROL, WID_TEXT_37, EDITABLE=1


 WIDGET_CONTROL, WID_TEXT_36, EDITABLE=1
 WIDGET_CONTROL, WID_TEXT_35, EDITABLE=1
 WIDGET_CONTROL, WID_TEXT_33, EDITABLE=1
 WIDGET_CONTROL, WID_TEXT_83, EDITABLE=1
 WIDGET_CONTROL, WID_TEXT_82, EDITABLE=1
 WIDGET_CONTROL, WID_TEXT_81, EDITABLE=1
 WIDGET_CONTROL, WID_TEXT_80, EDITABLE=1

 WIDGET_CONTROL, WID_TEXT_0, SET_VALUE='2'      ; gradient additive
 WIDGET_CONTROL, WID_TEXT_1, SET_VALUE='40000'  ; max count
 WIDGET_CONTROL, WID_TEXT_2, SET_VALUE='2' 		; smooth window
 WIDGET_CONTROL, WID_TEXT_3, SET_VALUE='50'  	; min count
 WIDGET_CONTROL, WID_TEXT_3a, SET_VALUE='50' 	; local background segments


 ;WIDGET_CONTROL, WID_TEXT_8, SET_VALUE=''
 WIDGET_CONTROL, WID_TEXT_9, SET_VALUE=''
 ;WIDGET_CONTROL, WID_TEXT_10, SET_VALUE=''
 WIDGET_CONTROL, WID_TEXT_11, SET_VALUE=''
 WIDGET_CONTROL, WID_TEXT_12, SET_VALUE=''

 WIDGET_CONTROL, WID_TEXT_18, SET_UVALUE=''
 WIDGET_CONTROL, WID_TEXT_19, SET_UVALUE=''
 WIDGET_CONTROL, WID_TEXT_18, Editable=1
 WIDGET_CONTROL, WID_TEXT_19, Editable=1

 WIDGET_CONTROL, WID_TEXT_21, SET_UVALUE=''
 WIDGET_CONTROL, WID_TEXT_24, SET_VALUE='1000'
 WIDGET_CONTROL, WID_TEXT_25, SET_VALUE='0'
 WIDGET_CONTROL, WID_TEXT_0, EDITABLE=1
 WIDGET_CONTROL, WID_TEXT_1, EDITABLE=1
 WIDGET_CONTROL, WID_TEXT_2, EDITABLE=1
 WIDGET_CONTROL, WID_TEXT_3, EDITABLE=1
 WIDGET_CONTROL, WID_TEXT_4, EDITABLE=1
 WIDGET_CONTROL, WID_TEXT_5, EDITABLE=1
 WIDGET_CONTROL, WID_TEXT_6, EDITABLE=1
 WIDGET_CONTROL, WID_TEXT_7, EDITABLE=1

 WIDGET_CONTROL, WID_TEXT_30, EDITABLE=1
 WIDGET_CONTROL, WID_TEXT_31, EDITABLE=1
 ;WIDGET_CONTROL, WID_TEXT_34, EDITABLE=1
 ;WIDGET_CONTROL, WID_TEXT_39, EDITABLE=1
 WIDGET_CONTROL, WID_TEXT_38, EDITABLE=1
 WIDGET_CONTROL, WID_TEXT_40, EDITABLE=1
 WIDGET_CONTROL, WID_TEXT_42, EDITABLE=1
 WIDGET_CONTROL, WID_TEXT_41, EDITABLE=1
 WIDGET_CONTROL, WID_TEXT_44, EDITABLE=1
 WIDGET_CONTROL, WID_TEXT_43, EDITABLE=1


 WIDGET_CONTROL, WID_TEXT_39, SET_UVALUE=''
 WIDGET_CONTROL, WID_TEXT_39, Editable=1
 WIDGET_CONTROL, WID_TEXT_39, SET_VALUE='40.0'
 WIDGET_CONTROL, WID_BUTTON_37, SET_UVALUE='Use moving detector'
 WIDGET_CONTROL, WID_BUTTON_47, SET_UVALUE='Omega from Moving Detector'



 WIDGET_CONTROL, WID_TEXT_36ac, SET_UVALUE=''
 WIDGET_CONTROL, WID_but_36ac, SET_UVALUE='Show rings'

 WIDGET_CONTROL, WID_TEXT_30, SET_VALUE='-15.'
 WIDGET_CONTROL, WID_TEXT_31, SET_VALUE=' 30.'

 ;WIDGET_CONTROL, WID_TEXT_34, SET_VALUE='  0.'
 ;WIDGET_CONTROL, WID_TEXT_39, SET_VALUE='  0.5'
 WIDGET_CONTROL, WID_TEXT_38, SET_VALUE='-25'
 WIDGET_CONTROL, WID_TEXT_40, SET_VALUE='25'
 WIDGET_CONTROL, WID_TEXT_42, SET_VALUE='-25'
 WIDGET_CONTROL, WID_TEXT_41, SET_VALUE='25'
 WIDGET_CONTROL, WID_TEXT_44, SET_VALUE='-25'
 WIDGET_CONTROL, WID_TEXT_43, SET_VALUE='25'

 WIDGET_CONTROL, WID_BUTTON_36aa, SET_UVALUE='Refine calibration'
 WIDGET_CONTROL, WID_BUTTON_38ab, SET_UVALUE='Integrate Pilatus'


 WIDGET_CONTROL, WID_BUTTON_33a, SET_UVALUE='Max filter'
 WIDGET_CONTROL, WID_TEXT_46a, SET_UVALUE=''


; WIDGET_CONTROL, WID_TEXT_36a, SET_VALUE='0.0'
; WIDGET_CONTROL, WID_TEXT_36b, SET_UVALUE=''
; WIDGET_CONTROL, WID_TEXT_36b, SET_VALUE='0.0'

 ;********************* NEW CODE **************************
 WIDGET_CONTROL, WID_LIST_INFO, SET_UVALUE = 'Code info"
 WIDGET_CONTROL, WID_LIST_INFO, SET_VALUE= ['ATREX 1.0' ,'Hawaii Institute of Geophysics and Planetology','Przemek Dera' ,'Harold Garbeil','Comments/questions: pdera@hawaii.edu', 'Project supported by NSF grant EAR1440005']

 WIDGET_CONTROL, WID_BUTTON_HELP, SET_UVALUE='Help'
 WIDGET_CONTROL, WID_BUTTON_OMEGA_ROTATION, SET_UVALUE = ''
 WIDGET_CONTROL, WID_TEXT_30, SET_UVALUE = 'Omega Start Event'
 WIDGET_CONTROL, WID_TEXT_31, SET_UVALUE = 'Omega Range Event'
 WIDGET_CONTROL, WID_BUTTON_36ac, SET_UVALUE = 'Test calibration'
 WIDGET_CONTROL, WID_BUTTON_47a, SET_UVALUE = 'Integrate series'
 ;********************* NEW CODE **************************

 WIDGET_CONTROL, WID_TEXT_48, SET_UVALUE=''
 ;WIDGET_CONTROL, WID_TEXT_47, SET_VALUE='2.0'
 WIDGET_CONTROL, WID_TEXT_48, SET_VALUE='30'

 WIDGET_CONTROL, WID_TEXT_16, SET_UVALUE=''
 WIDGET_CONTROL, WID_TEXT_20, SET_UVALUE=''
 WIDGET_CONTROL, WID_TEXT_16, EDITABLE=1
 WIDGET_CONTROL, WID_TEXT_20, EDITABLE=1

 WIDGET_CONTROL, WID_DRAW_0, SET_UVALUE='Draw'
 WIDGET_CONTROL, WID_DRAW_3, SET_UVALUE='Draw3'
 WIDGET_CONTROL, WID_DRAW_6, SET_UVALUE='Draw'

 WIDGET_CONTROL, WID_BUTTON_20aa, SET_UVALUE='Rotate image'


COMMON cont, contextBase, contextBase3

contextBase = WIDGET_BASE(WID_DRAW_0, /CONTEXT_MENU)
button0 = WIDGET_BUTTON(contextBase, VALUE='Zoom', UVALUE='CM Zoom')
button1 = WIDGET_BUTTON(contextBase, VALUE='Select', UVALUE='CM Select')
button2 = WIDGET_BUTTON(contextBase, VALUE='Unselect', UVALUE='CM Unselect')
button3 = WIDGET_BUTTON(contextBase, VALUE='Selections off', UVALUE='Selections off')
button4 = WIDGET_BUTTON(contextBase, VALUE='Define exclusion', UVALUE='Define exclusion')
button5 = WIDGET_BUTTON(contextBase, VALUE='Add peak', UVALUE='Add peak')
button7 = WIDGET_BUTTON(contextBase, VALUE='Reset mask', UVALUE='Reset mask')
button6 = WIDGET_BUTTON(contextBase, VALUE='Mask', UVALUE='Define mask')
button7 = WIDGET_BUTTON(contextBase, VALUE='Unmask', UVALUE='Define unmask')
button8 = WIDGET_BUTTON(contextBase, VALUE='Mask selection off', UVALUE='Mask selection off')
button9 = WIDGET_BUTTON(contextBase, VALUE='Save mask', UVALUE='Save mask')
button10 = WIDGET_BUTTON(contextBase, VALUE='Open mask', UVALUE='Open mask')

contextBase3 = WIDGET_BASE(WID_DRAW_3, /CONTEXT_MENU)
button5 = WIDGET_BUTTON(contextBase3, VALUE='Add peak', UVALUE='Add peak3')
button6 = WIDGET_BUTTON(contextBase3, VALUE='Select peak', UVALUE='Select peak3')
button7 = WIDGET_BUTTON(contextBase3, VALUE='Unselect peak', UVALUE='Unselect peak3')
button8 = WIDGET_BUTTON(contextBase3, VALUE='Selections off', UVALUE='Selections off3')

WIDGET_CONTROL, WID_TEXT_opening,SET_UVALUE=''
WIDGET_CONTROL, WID_TEXT_opening,SET_VALUE='25.0'



;------ scaling

 WIDGET_CONTROL, WID_BUTTON_sc,SET_UVALUE='scale'
 WIDGET_CONTROL, WID_BUTTON_applsc, SET_UVALUE='apply scale'
 WIDGET_CONTROL, WID_droplist_poly, SET_UVALUE='scale polynomial'
 WIDGET_CONTROL, WID_list_poly, SET_UVALUE='list polynomial'
 WIDGET_CONTROL, WID_Droplist_brav, SET_UVALUE='laue class'
 WIDGET_CONTROL, WID_text_rinta, SET_UVALUE='rint display'
 WIDGET_CONTROL, WID_BUTTON_select, SET_UVALUE='scale select'
 WIDGET_CONTROL, WID_BUTTON_wholeseries, SET_UVALUE='Whole p-series'


 WIDGET_CONTROL, WID_text_sel1, SET_UVALUE=''
 WIDGET_CONTROL, WID_text_sel2, SET_UVALUE=''
 WIDGET_CONTROL, WID_text_sel1, SET_VALUE=' 0.5'
 WIDGET_CONTROL, WID_text_sel2, SET_VALUE='-0.5'

 WIDGET_CONTROL, WID_button_spline,  SET_UVALUE=''
 WIDGET_CONTROL, WID_droplist_spline,   SET_UVALUE=''

 WIDGET_CONTROL, WID_BUTTON_fcf_spline, SET_UVALUE=''
 WIDGET_CONTROL, WID_droplist_fcf_spline, SET_UVALUE=''

;-
;WIDGET_CONTROL,  WID_TABLE_pil, UVALUE='pilT'
  N=10
  vals=fltarr(N)
  vals=vals+1.0
  vals=string(vals)
;WIDGET_CONTROL,  WID_TABLE_pil, SET_VALUE=transpose(vals)


Widget_Control, WID_DRAW_0, DRAW_BUTTON_EVENTS=1
Widget_Control, WID_DRAW_3, DRAW_BUTTON_EVENTS=1

common selections
selecting_status=0


 WIDGET_CONTROL, WID_TAB_0, SET_UVALUE=''
 ;WIDGET_CONTROL, WID_DRAW_0, SET_UVALUE=''
 WIDGET_CONTROL, WID_DRAW_0, GET_VALUE=DRAW0
 DEVICE, SET_GRAPHICS_FUNCTION = 3
 WIDGET_CONTROL, WID_DRAW_3, GET_VALUE=DRAW3
 DRAWA=DRAW0
 WIDGET_CONTROL, WID_DRAW_1, GET_VALUE=WID_DRAW_1
 WIDGET_CONTROL, WID_DRAW_2, GET_VALUE=WID_DRAW_2
 WIDGET_CONTROL, WID_DRAW_5, GET_VALUE=WID_DRAW_5
 WIDGET_CONTROL, WID_DRAW_6, GET_VALUE=WID_DRAW_6
 ;WIDGET_CONTROL, WID_DRAW_1, SET_UVALUE=''
 ;WIDGET_CONTROL, WID_DRAW_2, SET_UVALUE=''
 ;WIDGET_CONTROL, WID_DRAW_5, SET_UVALUE=''
 WIDGET_CONTROL, WID_LIST_3, SET_UVALUE='peak list'
 WIDGET_CONTROL, WID_LIST_1, SET_UVALUE='Exclusion list'
 WIDGET_CONTROL,WID_BUTTON_36ab, SET_UVALUE='Refine Pilatus'
 WIDGET_CONTROL,WID_BUTTON_33b, SET_UVALUE='Use corners'


 widget_control, wid_button_20, set_button=1
 widget_control, wid_button_20aa3, set_button=1
 widget_control, WID_BUTTON_23c, set_button=1

 widget_control, wid_button_20aa4, set_button=1
 widget_control, wid_button_20aa5, set_button=1

 widget_control, wid_text_29, set_value=out_dir
 widget_control, wid_text_28, set_value=dir
 re=file_info('last_calibration.cal')
 if re.exists eq 1 then $
 begin
   load_cal, 'last_calibration.cal', oadetector, wv
   print_calibration, oadetector, wv
 end
 read_jpeg, 'start1.jpg', pic, true=3
 wset, draw0
 tvscl, congrid(pic[*,*,0:2],600,600,3), true=3
 WID_MAR345_ext


 ;WIDGET_CONTROL, WID_TEXT_36c, SET_UVALUE=''
 ;WIDGET_CONTROL, WID_BUTTON_38v, SET_UVALUE='Verify omegas'

 ;WIDGET_CONTROL, WID_TEXT_36c, SET_VALUE='0.000'
 WIDGET_CONTROL, WID_TEXT_14_da1, SET_UVALUE='2.100'
 WIDGET_CONTROL, WID_TEXT_14_da2, SET_UVALUE='5.800'
 WIDGET_CONTROL, WID_TEXT_14_da3, SET_UVALUE='4.000'
 WIDGET_CONTROL, WID_TEXT_14_da4, SET_UVALUE='0.705'
 WIDGET_CONTROL, WID_TEXT_14_da5, SET_UVALUE='0.1013460'
 WIDGET_CONTROL, WID_TEXT_14_da6, SET_UVALUE='0.0'

 WIDGET_CONTROL, WID_TEXT_14_da1, SET_VALUE='2.100'
 WIDGET_CONTROL, WID_TEXT_14_da2, SET_VALUE='5.800'
 WIDGET_CONTROL, WID_TEXT_14_da3, SET_VALUE='4.000'
 WIDGET_CONTROL, WID_TEXT_14_da4, SET_VALUE='0.705'
 WIDGET_CONTROL, WID_TEXT_14_da5, SET_VALUE='0.1013460'
 WIDGET_CONTROL, WID_TEXT_14_da6, SET_VALUE='0.0'

 WIDGET_CONTROL, WID_BUTTON_412a, SET_UVALUE=''
 WIDGET_CONTROL, WID_BUTTON_413a, SET_UVALUE=''
 WIDGET_CONTROL, WID_BUTTON_413a, SET_BUTTON=1
 WIDGET_CONTROL, WID_DROPLIST_aab, set_droplist_select=1

;peak filtering
 WIDGET_CONTROL, aWID_TEXT_0, SET_VALUE='100'; min I
 WIDGET_CONTROL, aWID_TEXT_1, SET_VALUE='400000'; max I
 WIDGET_CONTROL, aWID_TEXT_2, SET_VALUE='15.0'; Max width
 WIDGET_CONTROL, aWID_TEXT_3, SET_VALUE='0.13'; Max diff
 WIDGET_CONTROL, aWID_TEXT_4, SET_VALUE='0.25'; Total diff

 WIDGET_CONTROL,  aWID_BUTTON_0, set_button=0
 WIDGET_CONTROL,  aWID_BUTTON_1, set_button=1
 WIDGET_CONTROL,  aWID_BUTTON_2, set_button=1
 WIDGET_CONTROL,  aWID_BUTTON_3, set_button=1
 WIDGET_CONTROL,  aWID_BUTTON_4, set_button=1

 WIDGET_CONTROL, aWID_TEXT_0, editable=1
 WIDGET_CONTROL, aWID_TEXT_1, editable=1
 WIDGET_CONTROL, aWID_TEXT_2, editable=1
 WIDGET_CONTROL, aWID_TEXT_3, editable=1
 WIDGET_CONTROL, aWID_TEXT_4, editable=1



end

;----
pro refi_pila
    parinfo = replicate({value:0.D, fixed:0, limited:[0,0], $
                       limits:[0.D,0], tied:''}, 3)

    p0=[500.,0.,0.]
    parinfo[*].value=p0
    parinfo[0].fixed=0
    parinfo[1].fixed=0
    parinfo[2].fixed=0

    x=[1,2,3,4,5,6,7,8,9,10]
    y=[2,3,4,5,6,7,8,9,10,11]
    ERR=fltarr(10)
    N=10
    for i=0, N-1 do ERR[i]=1.0
    fa = {X:x, Y:y, ERR:err}
    p = mpfit('pil_opti', p0, functargs=fa,PERROR=PE, PARINFO=parinfo, BESTNORM=bestnorm)

    print, p
    DOF     = N_ELEMENTS(X) - N_ELEMENTS(P) ; deg of freedom
    PCERROR = PE * SQRT(BESTNORM / DOF)   ; scaled uncertainties

end

;----------

function pil_opti;, X, Y, P

common selections
common datas
COMMON image_type_and_arrays
  COMMON WID_MAR345_elements

;  dist   : 0.0,  $
;  beamx  : 0.0,  $
;  beamy  : 0.0,  $
;  psizex : 0.0,     $
;  psizey : 0.0,     $
;  nopixx : 0,       $
;  nopixY : 0,       $
;  angle  : 0.0,     $
;  alpha  : 0.0,     $
;  omega0 : 0.0,     $
;  ttheta0: 0.0,     $
;  tiltom : 0.0,       $
;  tiltch : 0.0}


;det=oadetector->get_object()
;det.dist=P[0]
;det.tiltom=P[1]
;det.tiltch=P[2]
; WIDGET_CONTROL, WID_TEXT_33, sET_VALUE=string(p[0])
; WIDGET_CONTROL, WID_TEXT_81, sET_VALUE=string(p[1])
; WIDGET_CONTROL, WID_TEXT_80, sET_VALUE=string(p[2])
;oadetector->set_object, det

 ; define table with detector angles
   angles=[4.8, 9.6, 14.4, 19.2, 24.0, 28.8, 33.6, 38.4, 43.2]
   ; define table with image names
   nnames=['CeO2_005.tif',$
           'CeO2_006.tif',$
           'CeO2_007.tif',$
           'CeO2_008.tif',$
           'CeO2_009.tif',$
           'CeO2_010.tif',$
           'CeO2_011.tif',$
           'CeO2_012.tif',$
           'CeO2_013.tif',$
           'CeO2_014.tif']
   ;---- use just two images

   x1=[0,0]
   x2=[0,arr2]
   x3=[arr1,0]
   x4=[arr1,arr2]
   an=read_kappa_and_ttheta()
   gonio=fltarr(6)

   fn=dir+nnames[3]
   detangle=angles[3]
   gonio[1]=detangle
   widget_control, wid_text_36b, set_value=string(detangle)
   capture_calibration, oadetector, wv
   ;-------------------
   oimage->load_image, fn, oadetector

   aa=    [oadetector->calculate_tth_from_pixels(x1,gonio),$
           oadetector->calculate_tth_from_pixels(x2,gonio),$
           oadetector->calculate_tth_from_pixels(x3,gonio),$
           oadetector->calculate_tth_from_pixels(x4,gonio)]

   m11=min(aa)
   m12=max(aa)
   Int1=oimage->integrate_dll(oadetector, 500.000, [double(m11),double(m12)], maskarr)
   ;--------------------

   fn=dir+nnames[4]
   detangle=angles[4]
   gonio[1]=detangle
   widget_control, wid_text_36b, set_value=string(detangle)
   capture_calibration, oadetector, wv
   ;-------------------
   oimage->load_image, fn, oadetector
      aa=    [oadetector->calculate_tth_from_pixels(x1,gonio),$
           oadetector->calculate_tth_from_pixels(x2,gonio),$
           oadetector->calculate_tth_from_pixels(x3,gonio),$
           oadetector->calculate_tth_from_pixels(x4,gonio)]

   m21=min(aa)
   m22=max(aa)
   Int2=oimage->integrate_dll(oadetector, 500.000, [double(m21),double(m22)], maskarr)
   ;--------------------

   fn=dir+nnames[5]
   detangle=angles[5]
   gonio[1]=detangle
   widget_control, wid_text_36b, set_value=string(detangle)
   capture_calibration, oadetector, wv
   ;-------------------
   oimage->load_image, fn, oadetector
      aa=    [oadetector->calculate_tth_from_pixels(x1,gonio),$
           oadetector->calculate_tth_from_pixels(x2,gonio),$
           oadetector->calculate_tth_from_pixels(x3,gonio),$
           oadetector->calculate_tth_from_pixels(x4,gonio)]

   m31=min(aa)
   m32=max(aa)
   Int3=oimage->integrate_dll(oadetector, 500.000, [double(m31),double(m32)], maskarr)
   ;--------------------
   fn=dir+nnames[6]
   detangle=angles[6]
   gonio[1]=detangle
   widget_control, wid_text_36b, set_value=string(detangle)
   capture_calibration, oadetector, wv
   ;-------------------
   oimage->load_image, fn, oadetector
      aa=    [oadetector->calculate_tth_from_pixels(x1,gonio),$
           oadetector->calculate_tth_from_pixels(x2,gonio),$
           oadetector->calculate_tth_from_pixels(x3,gonio),$
           oadetector->calculate_tth_from_pixels(x4,gonio)]

   m41=min(aa)
   m42=max(aa)
   Int4=oimage->integrate_dll(oadetector, 500.000, [double(m41),double(m42)], maskarr)

   ;--------------------
   wset, draw0;wid_draw_6
   device, decomposed=1
   n=500


   ; resample and calculate difference between 14 and 20

   x0=m21
   x1=m12
   X=fltarr(1000)
   for i=0, 999 do x[i]=x0+i*(x1-x0)/1000.
   i1a=spline(int1[0,0:n-1],int1[1,0:n-1], X)
   i2a=spline(int2[0,0:n-1],int2[1,0:n-1], X)


   x0=m31
   x1=m22
   Xa=fltarr(1000)
   for i=0, 999 do xa[i]=x0+i*(x1-x0)/1000.
   i1b=spline(int2[0,0:n-1],int2[1,0:n-1], Xa)
   i2b=spline(int3[0,0:n-1],int3[1,0:n-1], Xa)

   x0=m41
   x1=m32
   Xb=fltarr(1000)
   for i=0, 999 do xb[i]=x0+i*(x1-x0)/1000.
   i1c=spline(int3[0,0:n-1],int3[1,0:n-1], Xb)
   i2c=spline(int4[0,0:n-1],int4[1,0:n-1], Xb)



   plot, [x,xa,xb],   [i1a,i1b,i1c], color='00ff00'xl
   oplot,[x,xa,xb],   [i2a,i2b,i1c], color='ff00ff'xl
   oplot,[x,xa,xb],   [i1a-i2a,i1b-i2b,i1c-i2c], color='f2002f'xl

return, total([abs(i1a-i2a),abs(i1b-i2b),abs(i1c-i2c)])

end
