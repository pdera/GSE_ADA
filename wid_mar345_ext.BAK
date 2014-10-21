;// Routines for interaction with the main GUI which are used outside of
;// the main GUI event handler file

pro WID_MAR345_ext_commons

;--- PD change 07/29/2010

 @WID_GSE_ADA_COMMON

;--- PD change end

end


;---------------------------

function read_cal_type
; 0 - fit2d style calibration
; 1 - Dera style calibration
COMMON WID_MAR345_elements
 rex=WIDGET_INFO(WID_BUTTON_refine_calt_s,/button_set)
return, rex
end
;---------------------------


function read_inversions
COMMON WID_MAR345_elements
 rex=WIDGET_INFO(WID_BUTTON_20aa,/button_set)
 rey=WIDGET_INFO(WID_BUTTON_20aa1,/button_set)
 tra=WIDGET_INFO(WID_BUTTON_20aa2,/button_set)
 res=0
 if rex eq 1 and rey eq 1 and tra eq 0 then res = 2 else $
 if rex eq 1 and rey eq 0 and tra eq 0 then res = 5 else $
 if rex eq 0 and rey eq 1 and tra eq 0 then res = 7 else $
 if rex eq 0 and rey eq 0 and tra eq 1 then res = 4 else $
 if rex eq 1 and rey eq 0 and tra eq 1 then res = 3 else $
 if rex eq 0 and rey eq 1 and tra eq 1 then res = 1 else $
 if rex eq 1 and rey eq 1 and tra eq 1 then res = 6
 return, res
end



;---------------------------



function get_dac_opening
COMMON WID_MAR345_elements
  WIDGET_CONTROL, WID_TEXT_opening,gET_VALUE=aa
  return, float(aa)
end


;------------------------------

function read_fcf_select_th

COMMON WID_MAR345_elements

 WIDGET_CONTROL, WID_text_fcf_1, GET_VALUE=a1
 WIDGET_CONTROL, WID_text_fcf_2, GET_VALUE=a2

 return, [float(a1),float(a2)]

end

function read_scale_select_th

COMMON WID_MAR345_elements

 WIDGET_CONTROL, WID_text_sel1, GET_VALUE=a1
 WIDGET_CONTROL, WID_text_sel2, GET_VALUE=a2

 return, [float(a1),float(a2)]

end
;---------------------------
function scale_spline

COMMON WID_MAR345_elements

 re=widget_info(WID_button_spline, /button_set)
 s=widget_info(WID_droplist_spline, /DROPLIST_SELECT) ;
 return, re*(s+5)
end

;----------------------

function fcf_spline

COMMON WID_MAR345_elements

 re=widget_info(WID_BUTTON_fcf_spline, /button_set)
 s=widget_info(WID_droplist_fcf_spline, /DROPLIST_SELECT) ;
 return, re*(s+5)
end

;---------------------------


function scale_poly
; reads a degree of polynomial to be used for scaling from the droplist in the scale tab
; available values are 2, 3, 4
COMMON WID_MAR345_elements
  s=widget_info(WID_droplist_poly, /DROPLIST_SELECT) ;
 return, s+2
end


pro print_scale_poly, coeff
@common_datas
 n=n_elements(coeff)
 poly_text=strarr(n)
 COMMON WID_MAR345_elements
 for i=0, n-1 do poly_text[i]=string(coeff[i], format='(F12.8)')
 widget_control, WID_list_poly, set_value=poly_text
end

function Lab6, dst, wh
@COMMON_DATAS

N=48
la=wv
;dst=200
d=fltarr(N)
tth=fltarr(N)
rad=fltarr(25)

d[0]=		4.1565	;	0	0	1
d[1]=		2.9391	;	0	1	1
d[2]=		2.3997	;	1	1	1
d[3]=		2.0782	;	0	0	2
d[4]=		1.8588	;	0	1	2
d[5]=		1.6969	;	1	1	2
d[6]=		1.4695	;	0	2	2
d[7]=		1.3855	;	0	0	3
d[8]=		1.3855	;	1	2	2
d[9]=		1.3144	;	0	1	3
d[10]=		1.2532	;	1	1	3
d[11]=		1.1999	;	2	2	2
d[12]=		1.1528	;	0	2	3
d[13]=		1.1109	;	1	2	3
d[14]=		1.0391	;	0	0	4
d[15]=		1.0081	;	0	1	4
d[16]=		1.0081	;	2	2	3
d[17]=		0.9797	;	1	1	4
d[18]=		0.9797	;	0	3	3
d[19]=		0.9536	;	1	3	3
d[20]=		0.9294	;	0	2	4
d[21]=		0.9070	;	1	2	4
d[22]=		0.8862	;	2	3	3
d[23]=		0.8484	;	2	2	4
d[24]=		0.8313	;	0	0	5
d[25]=		0.8313	;	0	3	4
d[26]=		0.8152	;	0	1	5
d[27]=		0.8152	;	1	3	4
d[28]=		0.7999	;	1	1	5
d[29]=		0.7999	;	3	3	3
d[30]=		0.7718	;	0	2	5
d[31]=		0.7718	;	2	3	4
d[32]=		0.7589	;	1	2	5
d[33]=		0.7348	;	0	4	4
d[34]=		0.7235	;	2	2	5
d[35]=		0.7235	;	1	4	4
d[36]=		0.7128	;	0	3	5
d[37]=		0.7128	;	3	3	4
d[38]=		0.7026	;	1	3	5
d[39]=		0.6927	;	0	0	6
d[40]=		0.6927	;	2	4	4
d[41]=		0.6833	;	0	1	6
d[42]=		0.6743	;	1	1	6
d[43]=		0.6743	;	2	3	5
d[44]=		0.6572	;	0	2	6
d[45]=		0.6491	;	1	2	6
d[46]=		0.6491	;	0	4	5
d[47]=		0.6491	;	3	4	4
;
for i=0, 47 do $
tth[i]=2.0*asin(la/(2.0*d[i]))*!radeg
rad=dst*tan(tth/!radeg)
if wh eq 0 then return, rad else return, d
end

function Neon, dst, wh
@COMMON_DATAS

N=11
la=wv
;dst=200
d=fltarr(11)
tth=fltarr(11)
rad=fltarr(11)



d[0] =	2.10560
d[1] =  1.82350
d[2] =  1.28941
d[3] = 	1.09961
d[4] =	1.05280
d[5] =	0.91175
d[6] =	0.83668
d[7] =	0.81549
d[8] =	0.74444
d[9] =	0.70187
d[10] =	0.64470

for i=0, 10 do $
tth[i]=2.0*asin(la/(2.0*d[i]))*!radeg
rad=dst*tan(tth/!radeg)
if wh eq 0 then return, rad else return, d
end

function CeO2, dst, wh
@COMMON_DATAS

N=25
la=wv
;dst=200
d=fltarr(25)
tth=fltarr(25)
rad=fltarr(25)

d[0] =3.12442
d[1] =2.70583
d[2] =1.91331
d[3] =1.63167
d[4] =1.56221
d[5] =1.35291
d[6] =1.24152
d[7] =1.21008
d[8] =1.10465
d[9] =1.04147
d[10]=0.95665
d[11]=0.91474
d[12]=0.90194
d[13]=0.85566
d[14]=0.82527
d[15]=0.81584
d[16]=0.78110
d[17]=0.75778
d[18]=0.75046
d[19]=0.72316
d[20]=0.70454
d[21]=0.67646
d[22]=0.66114
d[23]=0.65626
d[24]=0.63777
for i=0, 23 do $
tth[i]=2.0*asin(la/(2.0*d[i]))*!radeg
rad=dst*tan(tth/!radeg)
if wh eq 0 then return, rad else return, d
end

function CO2, dst, wh
@COMMON_DATAS

N=21
la=wv
;dst=200
d=fltarr(N)
tth=fltarr(N)
rad=fltarr(N)

d[0]=2.87261
d[1]=2.48775
d[2]=2.22511
d[3]=2.03124
d[4]=1.7591
d[5]=1.6585
d[6]=1.4363
d[7]=1.37996
d[8]=1.32976
d[9]=1.24388
d[10]=1.20674
d[11]=1.14146
d[12]=1.08574
d[13]=1.06078
d[14]=1.01562
d[15]=0.92393
d[16]=0.9084
d[17]=0.87955
d[18]=0.84101
d[19]=0.82925
d[20]=0.80713

for i=0, N-1 do $
tth[i]=2.0*asin(la/(2.0*d[i]))*!radeg
rad=dst*tan(tth/!radeg)
if wh eq 0 then return, rad else return, d
end

function which_calibrant, dst, no; choice of calibrant for powder based refinement of detector geometry
COMMON WID_MAR345_elements
  s=widget_info(WID_Droplist_36aa, /DROPLIST_SELECT) ;
  case s of
  0:a=ceo2(dst,no) ; CeO2
  1:a=LaB6(dst,no) ; LaB6
  2:a=Neon(dst,no) ; LaB6
  3:a=CO2(dst,no) ; LaB6
  endcase
 return, a
end

;WID_Droplist_36aa
function which_calibration
COMMON WID_MAR345_elements
  s=widget_info(WID_BUTTON_refine_cal_p, /button_set) ;
 return, s
end


function use_corners
COMMON WID_MAR345_elements
  s=widget_info(WID_BUTTON_33b, /button_set) ;
 return, s
end


function refine_twist
COMMON WID_MAR345_elements
  s=widget_info(WID_BUTTON_refine_twist, /button_set) ;
 return, s
end

function cal_IovS
COMMON WID_MAR345_elements
  WIDGET_CONTROL, WID_TEXT_36ac, Get_value=re
 return, float(re)
end



;--------------------------------
function dynamic_mask_on
COMMON WID_MAR345_elements
 s=widget_info(WID_BUTTON_dynamic_mask, /button_set) ;
 return, s
end

function prefitting
COMMON WID_MAR345_elements
 s=widget_info(WID_BUTTON_23a, /button_set) ;
 return, s
end



;--------------------------------
function vert_polariz
COMMON WID_MAR345_elements
 s=widget_info(WID_BUTTON_52ab, /button_set) ;
 return, s
end

function profile_function_name
COMMON WID_MAR345_elements
 s=widget_info(WID_button_413a, /button_set) ; pseudo-Voigt
 if s eq 1 then return, 'Voigt2dwt' else return, 'Gaussian2dwt'
end


;-----------------------------
function profile_function, X, Y, P

COMMON WID_MAR345_elements
 s=widget_info(WID_button_413a, /button_set) ; pseudo-Voigt
 if s eq 1 then return, Voigt2dwt(X,Y,P) else return, Gaussian2dwt(X,Y,P)
end




;--------------------------------

function read_fcf_var
COMMON WID_MAR345_elements

 re=widget_info(WID_droplist_var1, /droplist_select)
 return, re+1
end

;--------------------------------
function get_laue_class


COMMON WID_MAR345_elements

 re=widget_info(WID_Droplist_4aa, /droplist_select)
 return, re
end

function which_PT
COMMON WID_MAR345_elements

 re=widget_info(WID_button_512, /button_set)
 return, re ; 1 for PT1 0 for PT2
end

function omega_correction, om
COMMON WID_MAR345_elements
;  re=widget_info(WID_BUTTON_51aomg,/button_set)
;  if re eq 0 then ret=[0,0,0] else $
;  begin
;   widget_control, WID_TEXT_14_da1om, get_value=a1
;   widget_control, WID_TEXT_14_da2om, get_value=a2
;   widget_control, WID_TEXT_14_da3om, get_value=a3
;   ret=[float(a1),float(a2),float(a3)]
;  endelse
;  b=ret[0]*om*om+ret[1]*om+ret[2]
  return, 1.0
end
;--------------------------------

pro print_R_int, text
COMMON WID_MAR345_elements

widget_control, WID_TEXT_37aa, set_value=string(text, format='(F7.4)')
widget_control, WID_text_rinta, set_value=string(text, format='(F7.4)')

end




function read_abs
COMMON WID_MAR345_elements
        widget_control, WID_TEXT_14_da1, get_value=va1
        widget_control, WID_TEXT_14_da2, get_value=va2
        widget_control, WID_TEXT_14_da3, get_value=va3
        widget_control, WID_TEXT_14_da4, get_value=va4
        widget_control, WID_TEXT_14_da5, get_value=va5
        widget_control, WID_TEXT_14_da6, get_value=va6
  return, [float(va1),float(va2),float(va3),float(va4),float(va5),float(va6)]
end
;--------------------------------
pro plot_image, oimage
COMMON WID_MAR345_elements
COMMON image_type_and_arrays, imt, arr1, arr2,cenx, ceny, rad, rad1
common selections, selecting_status, select, excl, unselect, addpeak, mask, maskarr, zoom, unmask

   im=oimage->get_object()
   data1=congrid(im.img[0:arr1-1,0:arr2-1]*maskarr, 600,600)
   widget_control, wid_text_24, get_value=imax
   widget_control, wid_text_25, get_value=imin
   imax=long(imax)
   imin=long(imin)
   imax=imax[0]
   imin=imin[0]
   data1=data1<imax
   data1=data1>imin

   wset, draw0
   device, decomposed=0
   tvscl, data1, true=0

        ;thisPostion = [0.1, 0.1, 0.9, 0.9]
        ;cgIMAGE, data1, POSITION=thisPosition, /KEEP_ASPECT_RATIO
        ;cgZImage, data1
  end
;--------------------------------
function get_md
COMMON WID_MAR345_elements
 widget_control, wid_text_39, get_value=mov
 return, reform(float(mov))
end
;--------------------------------
function get_alpha
COMMON WID_MAR345_elements
 widget_control, wid_text_36c, get_value=al
 return, reform(float(al))
end
;--------------------------------


function rotate_image
COMMON WID_MAR345_elements
 re=widget_info(WID_BUTTON_20aa,/button_set)
 return, re
end

function det_move
COMMON WID_MAR345_elements
 re=widget_info(wid_button_37,/button_set)
 return, re
end

;--------------------------------
pro plot_zoom, oimage
COMMON WID_MAR345_elements
COMMON image_type_and_arrays, imt, arr1, arr2,cenx, ceny, rad, rad1
common selections, selecting_status, select, excl, unselect, addpeak, mask, maskarr, zoom
   if cenx-rad le 0 then rad=cenx-1
   if ceny-rad1 le 0 then rad1=ceny-1
   if cenx+rad ge arr1 then rad=arr1-cenx-1
   if ceny+rad1 ge arr2 then rad1=arr2-ceny-1

   im=oimage->get_object()
   data1=congrid(im.img[cenx-rad:cenx+rad,ceny-rad1:ceny+rad1]*maskarr, 428,428)
   widget_control, wid_text_24, get_value=imax
   widget_control, wid_text_25, get_value=imin
   imax=long(imax)
   imin=long(imin)
   imax=imax[0]
   imin=imin[0]
   data1=data1<imax
   data1=data1>imin

   wset, draw3
   tvscl, data1, true=0
  end
;--------------------------------
function read_polar
COMMON WID_MAR345_elements
 widget_control, wid_text_14, get_value=uv
 return, float(uv)
end


pro update_progress, prog
COMMON WID_MAR345_elements
 widget_control, wid_text_8, set_value=string(prog*100.0, format='(I4)')+'%'
end

function read_kappa_and_ttheta
COMMON WID_MAR345_elements
 widget_control, wid_text_36a, get_value=ka
 widget_control, wid_text_36b, get_value=tth
 return, [float(ka),float(tth)]
end

;--------------------------------

function read_box_size, text1, text2
COMMON WID_MAR345_elements
 text1=wid_text_37
 text2=wid_text_37
 widget_control, text1, get_value=px
 widget_control, text2, get_value=py
 px=long(px)
 py=long(py)
 px=px[0]
 py=py[0]
 return, [px,py]
end

;--------------------------------
function read_box_change

; 0 is one peak
; 1 is all peaks

COMMON WID_MAR345_elements
 re=widget_info(wid_button_412, /button_set)
 if re eq 1 then return, 0 else return, 1
end

;--------------------------------

function read_color_scale
COMMON WID_MAR345_elements

   widget_control, wid_text_24, get_value=imax
   widget_control, wid_text_25, get_value=imin
   imax=long(imax)
   imin=long(imin)
   imax=imax[0]
   imin=imin[0]

   return, [imin, imax]
end

;--------------------------------

function hkl_labels_on
COMMON WID_MAR345_elements
 return, widget_info(wid_button_19, /button_set)
end

;-------------------------------

function omega_or_energy
COMMON WID_MAR345_elements
re=widget_info(wid_button_7, /button_set)
return, re ; 1=om, 0=en
end

;-------------------------------

function I_corrections
COMMON WID_MAR345_elements
re1=widget_info(wid_button_51a, /button_set) ; dac abs
re2=widget_info(wid_button_51, /button_set) ; Lorenz
re3=widget_info(wid_button_52, /button_set) ; Polariz
return, [re1,re2, re3] ; 1=apply, 0=don't apply
end

;-------------------------------
pro update_peakno, pn
COMMON WID_MAR345_elements
 widget_control, wid_text_10, set_value=string(pn, format='(I4)')
end
;-------------------------------
function omega_from_scan, filno
COMMON WID_MAR345_elements
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
   pos=filno-i0
   om=om0+pos*omD+omD/2.
   return, om
end

;-------------------------------

function im_seq_0
COMMON WID_MAR345_elements
   widget_control, wid_text_6, get_value=ni
   widget_control, wid_text_7, get_value=i0
   a=long(i0)
   return, a[0]
end

;-------------------------------

function im_seq_n
COMMON WID_MAR345_elements
   widget_control, wid_text_6, get_value=ni
   widget_control, wid_text_7, get_value=i0
   a=long(ni)
   return, a[0]
end

;********************************** NEW CODE ****************
function read_om_rotation_dir
COMMON WID_MAR345_elements
   re=widget_info(WID_BUTTON_OMEGA_ROTATION, /button_set)
   ;---- PD change
   ;---- 6/23/2010
   ;---- changed default setting to GSECARS
   if re eq 1 then return, -1 else return, 1
   ;---- PD change end
end

;********************************** NEW CODE ****************

;********************************** NEW CODE ****************
pro WID_MAR345_Cleanup, WID_MAR345
@COMMON_DATAS
common closing, Wid_Image_simulation
common status, PE_open, SIM_open

if SIM_open eq 1 then wid_sim->destroy

end
;********************************** NEW CODE ****************
;-------------------------------
pro WID_MAR345_ext
end
;-------------------------------