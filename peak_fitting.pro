;----------------------------------

function one2two, x
 sz=n_elements(x)
 sz1=long(sqrt(sz))
 if sz1*sz1 eq sz then $
 begin
   b=fltarr(sz1,sz1)
   for i=0,sz1-1 do b[0:sz1-1,i]=x[i*sz1:(i+1)*sz1-1]
   return, b
 endif else return, 0
end

;----------------------------------

function two2one,x
 sz=size(x)
 if n_elements(x) gt 0 then $
 begin
 b=fltarr(sz[1]*sz[1])
 b=x[0:sz[1]-1,0]
 for i=1,sz[1]-1 do b=[b,x[0:sz[1]-1,i]]
 return, b
 endif else return, 0
end

;----------------------------------
function Xinvec, siz
 XX=fltarr(siz[0],siz[1])
 for i=0, siz[1]-1 do $
 begin
  X=replicate(i-(siz[1]-1)/2.,siz[0])
  XX[*,i]=X
 endfor
 return, two2one(XX)
end
;----------------------------------
function Yinvec, siz
 XX=fltarr(siz[0],siz[1])
 for i=0, siz[1]-1 do $
 begin
  X=replicate(i-(siz[0]-1)/2.,siz[1])
  XX[i,*]=X
 endfor
 return, two2one(XX)
end
;--------------------------------------
function pixel_outside_circle, xy, rad
  n=n_elements(xy)/2
  if n gt 1 then $
  begin
    for i=0, n-1 do $
    begin
     r=lonarr(n)
     X1=xy[i,0]-(rad-1)
     Y1=xy[i,1]-(rad-1)
     r=sqrt(X1^2+Y1^2)
     if r ge rad-1 then r[i]=1
    endfor
  endif else $
  begin
     X1=xy[0]-(rad)
     Y1=xy[1]-(rad)
     r=sqrt(X1^2+Y1^2)
     if r ge rad then r=1 else r=0
  endelse
  return, r
end

;----------------------------------

function which_pixels_in_mtx_outside_circle, s1a, xy0, rad
; s1 is the size of square mtx
 ;s1a=(s1-1)/2
 res=lonarr(s1a*2+1,s1a*2+1)
 for i=-s1a, s1a do $
  for j=-s1a, s1a do $
    begin
      x=xy0[0]+i
      y=xy0[1]+j
      res[i+s1a,j+s1a]=pixel_outside_circle([x,y], rad)
    endfor
    return, res
end

;-------------------------------------------------------------

function recenter_to_max_intensity, pic
 n=size(pic)
 n1=n[1]
 n2=(n[1]-1)/2
 m=max(pic,i)
 y=long(i/n1)
 x=i-long(i/n1)*n1
 return, [x-n2,y-n2]
end

;----------------------

function peak_fit_error_codes, code
case code of
0:re='Fitting successful'
1:re='Position shift in first fitting moves the peak outside of the box'
2:re='After first shift position is too close to image edge'
3:re='Peak number is incorrect'
4:re='Initital position too close to image edge'
5:re='Final peak fitting failed'
else:re='Unknown error code'
endcase
return, re
end



;-----------------------------


function Two_Gaussians, p, X=x, Y=y, ERR=err

; X is X profile
; Y is Y profile

; parameters

;   P[0] - scale X
;   P[1] - shift X
;   P[2] - width X
;   P[3] - background const X
;   P[4] - background lin X

;   P[5] - scale Y
;   P[6] - shift Y
;   P[7] - width Y
;   P[8] - background const Y
;   P[9] - background lin Y
    sz=n_elements(X)
    XX=indgen(Sz)

    model1= Gauss(P[0:4],xx)
    model2= Gauss(P[5:9],xx)

    arr=[(model1-X),(model2-Y)]
    return,arr/err

end

;-----------------------------


function Gaussian2dwt, X, Y, P
 LYV=65535 ;top y value
; parameters
;   P[0] - background
;   P[1] - peak intensity
;   P[2] - x width
;   P[3] - y width
;   P[4] - tilting of the profile
;   P[5] - x shift
;   P[6] - y shift


 mtx=[[cos(p[4]),sin(p[4])],[-sin(p[4]),cos(p[4])]]
 XY=[[X],[Y]]
 XY1=mtx ## XY
 sz=n_elements(X)
 X1=XY1[0:sz-1,0]
 Y1=XY1[0:sz-1,1]
 sz=n_elements(p)
 if sz eq 8 then $
 begin
 U=((x1-p[5])/p[2])^2+((y1-p[6])/p[3])^2
 G=p[0]+p[1]*exp(-U/2.)
 return,G<LYV
 endif else return,0
end

;-----------------------------

function Voigt2dwt_0, X, Y, P

; parameters
;   P[0] - background
;   P[1] - peak intensity
;   P[2] - x width
;   P[3] - y width
;   P[4] - tilting of the profile
;   P[5] - x shift
;   P[6] - y shift
;   P[7] - Lorentz
 ;LYV=65535 ;top y value
 mtx=[[cos(p[4]),sin(p[4])],[-sin(p[4]),cos(p[4])]]
 XY=[[X],[Y]]
 XY1=mtx ## XY
;  XY1=[[X],[Y]]
 sz=n_elements(X)
 X1=XY1[0:sz-1,0]
 Y1=XY1[0:sz-1,1]
 sz=n_elements(p)
 if sz eq 8 then $
 begin
   Zx=((X1-P[5])/P[2])^2
   Zy=((Y1-P[6])/P[3])^2
   G=exp(-0.5*(Zx+Zy))
   L=1.0/((1.0+Zx)*(1.0+Zy))
   c=p[7]
   M=P[0]+P[1]*(c*L+(1.0-c)*G)
   return,M;<LYV
 endif else return,0
end

;-----------------------------

;-----------------------------

function Two_Voigt2dwt, X, Y, P

; only one flat background parameter is fitted
; parameters

;   P[0] - background
;   P[1] - peak 1 intensity
;   P[2] - x width 1
;   P[3] - y width 1
;   P[4] - tilting of the profile 1
;   P[5] - x shift 1
;   P[6] - y shift 1
;   P[7] - Lorentz 1

;   P[8] - peak intensity 2
;   P[9] - x width 2
;   P[10] - y width 2
;   P[11] - tilting of the profile 2
;   P[12] - x shift 2
;   P[13] - y shift 2
;   P[14] - Lorentz 2

 PV1= Voigt2dwt(X, Y, P[0:7])
 PV2= Voigt2dwt(X, Y, [0.0,P[8:14]])

 M=PV1+PV2
 return,M;<LYV
end

;-----------------------------

function Voigt2dwt, X, Y, P

; parameters
;   P[0] - background
;   P[1] - peak intensity
;   P[2] - x width
;   P[3] - y width
;   P[4] - tilting of the profile
;   P[5] - x shift
;   P[6] - y shift
;   P[7] - Lorentz
 ;LYV=65535 ;top y value
 mtx=[[cos(p[4]),sin(p[4])],[-sin(p[4]),cos(p[4])]]
 XY=[[X],[Y]]
 XY1=mtx ## XY
 ; XY1=[[X],[Y]]
 sz=n_elements(X)
 X1=XY1[0:sz-1,0]
 Y1=XY1[0:sz-1,1]
 sz=n_elements(p)
 if sz eq 8 then $
 begin
   Zx=((X1-P[5])/P[2])^2
   Zy=((Y1-P[6])/P[3])^2
   G=exp(-0.33*(Zx+Zy))
   ;-------------- Lorenzian
   L=1.0/(1.0+Zx+Zy)
   c=p[7]
   M=P[0]+P[1]*(c*L+(1.0-c)*G)
   return,M;<LYV
 endif else return,0
end

;-----------------------------
function profile_function, X, Y, P

COMMON WID_MAR345_elements
 s=widget_info(WID_button_413a, /button_set) ; pseudo-Voigt
 if s eq 1 then return, Voigt2dwt(X,Y,P) else return, Gaussian2dwt(X,Y,P)
end




;-----------------------

pro peak_intensity, pni, A, PCERROR, axis, pic, pic9

@COMMON_DATAS
@COMMON_DATAS2

       opt->unselect_all
       re=peak_filtering_settings()

       MaxI    		   = re[1]
       maxFWHM 		   = re[2]
       minI			   = re[3]
       maxTotDiffRatio = re[4]

       pic2=pic-pic9
       m1=max(pic2)   ; maximum difference
       m2=min(pic2)   ; minimum difference
       m3=median(pic) ; background level
       m4=a[1]        ; fitted intensity
       m5=total(pic2) ; summ of difference intensity
       m6=max(pic)    ; maximum in the box
       sz=sqrt(n_elements(pic))
       szi=(sz-1)/2

       m7=total(pic[szi-2:szi+2,szi-2:szi+2])-25.*m3
       if n_elements (pic) ge 25 then $
	   begin
       		spic=pic[szi-3:szi+3,szi-3:szi+3]
       		spic9=pic9[szi-3:szi+3,szi-3:szi+3]
       		spic22=spic-spic9

       		tf=total(pic9)-median(pic9)*n_elements(pic22)
       		tp=total(pic)-median(pic)*n_elements(pic22)
       		stf=total(spic9)-median(pic9)*n_elements(spic22) ; total intensity above bcgr in fitted profile [7x7]
       		stp=total(spic)-median(pic)*n_elements(spic22)   ; total intensity above bcgr in image [7x7]
       		str=total(spic22)   							 ; total residual intensity [7x7]

       		if abs(stp-stf)/stp gt maxTotDiffRatio then print, '========= large differnce in total intensity between fit and image', abs(stp-stf)/stp
	   	endif else $
		begin ;- box set too small
 			stp=1
 			stf=100
 			tf=0
		endelse
       if tf eq 0 or abs(stp-stf)/stp gt maxTotDiffRatio or (a[2] gt maxFWHM) or (a[3] gt maxFWHM) or stf gt MaxI or max((spic-median(pic9))/median(pic9)) lt minI then $
       begin
        print, '----- peak ', pni, ' removed'
        pt.peaks[pni].selected[0]=1
       endif else  pt.peaks[pni].selected[0]=0

 	   gonio=pt.peaks[pni].gonio
       kt=read_kappa_and_ttheta()
       gonio[1]=kt[1]
       xyz=oadetector->calculate_XYZ_from_pixels_mono(pt.peaks[pni].DetXY, gonio, wv)

     ;------------

       sd=oadetector->calculate_sd_from_pixels(pt.peaks[pni].DetXY, gonio)
       nu=ang_between_vecs([0.0,sd[1],sd[2]],[0.,-1.,0.])
       nu1=oadetector->get_nu_from_pix(pt.peaks[pni].DetXY)
       ;print, nu, nu1
       tth=get_tth_from_xyz(pt.peaks[pni].xyz)
       II=(A[1]*A[2]*A[3])*2.*!pi
       si=2.*!pi*(A[2]*A[3]*PCERROR[1]+A[1]*A[2]*PCERROR[3]+A[1]*A[3]*PCERROR[2])
       ty=I_corrections()

      ;-- Lorenz correction
      if ty[1] eq 1 then $
      begin
       ii=II/lorenz(xyz, gonio, wv)
       si=sI/lorenz(xyz, gonio, wv)
      endif

     ;-- polarization correction
      if ty[2] eq 1 then $
      begin
       P1=0.9
       mu=20.41
       h=0.005
       v=vert_polariz()*90.0+nu
       ii=II/(1.0-read_polar()*cos(2.0*v/!radeg));*cos(gonio[3]/!radeg)
       si=sI/(1.0-read_polar()*cos(2.0*v/!radeg));*cos(gonio[3]/!radeg)
      endif
      ;-- CBN absorption correction
      if ty[0] eq 1 then $
      begin
       om0= 0.0
       ii=II/dac_profile(pt.peaks[pni].gonio[axis]+om0,1)
       si=sI/dac_profile(pt.peaks[pni].gonio[axis]+om0,1)
      end

    ;-- omega polynomial correction
       aom=omega_correction(pt.peaks[pni].gonio[axis])
       ii=II*aom
       si=sI*aom

       pt.peaks[pni].energies[2]=A[2] ; width 2th
       pt.peaks[pni].energies[3]=A[3] ; width chi
       pt.peaks[pni].energies[4]=A[4] ; tilt
       pt.peaks[pni].energies[5]=A[0] ; background

       pt.peaks[pni].intAD[0]=ii
       pt.peaks[pni].intAD[1]=si
       opt->set_object, pt

end
;----------------------------------


pro merge_peak_tables_in_series

@COMMON_DATAS
@COMMON_DATAS2
@WID_GSE_ADA_COMMON
   ex=res.extno
   if n_elements(res) gt 0 then $
   begin
   if res.name0 ne '' then $
   begin
   widget_control, wid_text_7, get_value=i0
   widget_control, wid_text_6, get_value=ni
   ni=fix(ni)
   i0=fix(i0)

    res.seq=i0[0]
    fn=generate_fname(res,ex)
    res=analyse_fname(fn, dir, ex)
    opt->read_object_from_file, dir+res.name0+'.pks'
    update_peakno, opt->peakno()
    plot_peaks, draw0, opt, arr1, arr2
   for i=1, ni[0]-1 do $
   begin
    res.seq=i0[0]+i
    fn=generate_fname(res,ex)
    res=analyse_fname(fn, dir, ex)
    opt->APPEND_object_from_file, dir+res.name0+'.pks'
    update_peakno, opt->peakno()
    plot_peaks, draw0, opt, arr1, arr2
   endfor
   opt->write_object_to_file, out_dir+res.base0+'_merge.pks', 1
   print_peak_list, opt, wid_list_3
   peaktable_file=out_dir+res.base0+'_merge.pks'
  endif
  endif
end


;--------------------------------------------------------------

pro peak_intensity_evaluation, pni, A, PCERROR, XY, axis, lbcgr

@COMMON_DATAS
@COMMON_DATAS2
;COMMON WID_MAR345_elements
;COMMON image_type_and_arrays
;common selections, selecting_status, select, excl, unselect, addpeak, mask, maskarr, zoom, unmask


       pt=opt->get_object()
       pt.peaks[pni].DetXY[0]= XY[0]+a[5]
       pt.peaks[pni].DetXY[1]= XY[1]+a[6]

       bs=[long(pt.peaks[pni].intssd[0]),long(pt.peaks[pni].intssd[0])]
       XX=Xinvec([bs[0]*2+1,bs[1]*2+1])
       yy=yinvec([bs[0]*2+1,bs[1]*2+1])
       p2=long(one2two(profile_function(XX, YY, A)))


       pic=oimage->get_zoomin(XY, bs, maskarr)

       ;---- if part of the box area is outside active circle, replace 0 with local background ------
       cc=which_pixels_in_mtx_outside_circle(bs[0], xy, arr1/2-2)
       c=where(cc eq 1)
       if c[0] ne -1 then pic[c]=replicate(lbcgr[xy[0],xy[1]], n_elements(c))

       ;---------------------------------------------------------------------------------------------


       attt=evaluate_fit_quality(pic, p2)
       if attt[0] gt 0 then $
       begin
          opt->select_peak, pni
       endif else $
       begin

       gonio=pt.peaks[pni].gonio
       kt=read_kappa_and_ttheta()
       gonio[1]=kt[1]
       xyz=oadetector->calculate_XYZ_from_pixels_mono(pt.peaks[pni].DetXY, gonio, wv)

     ;------------
       sd=oadetector->calculate_sd_from_pixels(pt.peaks[pni].DetXY, gonio)
       nu=ang_between_vecs([0.0,sd[1],sd[2]],[0.,-1.,0.])
       nu1=oadetector->get_nu_from_pix(pt.peaks[pni].DetXY)
       ;print, nu, nu1
       tth=get_tth_from_xyz(pt.peaks[pni].xyz)
       II=(A[1]*A[2]*A[3])*2.*!pi
       si=2.*!pi*(A[2]*A[3]*PCERROR[1]+A[1]*A[2]*PCERROR[3]+A[1]*A[3]*PCERROR[2])
       ty=I_corrections()

      ;-- Lorenz correction
      if ty[1] eq 1 then $
      begin
       ii=II/lorenz(xyz, gonio, wv)
       si=sI/lorenz(xyz, gonio, wv)
      endif

     ;-- polarization correction
      if ty[2] eq 1 then $
      begin
       P1=0.9
       mu=20.41
       h=0.005
       v=vert_polariz()*90.0+nu
       ii=II/(1.0-read_polar()*cos(2.0*v/!radeg));*cos(gonio[3]/!radeg)
       si=sI/(1.0-read_polar()*cos(2.0*v/!radeg));*cos(gonio[3]/!radeg)
      endif
      ;-- CBN absorption correction
      if ty[0] eq 1 then $
      begin
       om0= 0.0
       ii=II/dac_profile(pt.peaks[pni].gonio[axis]+om0,1)
       si=sI/dac_profile(pt.peaks[pni].gonio[axis]+om0,1)
      end

    ;-- omega polynomial correction
       aom=omega_correction(pt.peaks[pni].gonio[axis])
       ii=II*aom
       si=sI*aom

       pt.peaks[pni].energies[2]=A[2] ; width 2th
       pt.peaks[pni].energies[3]=A[3] ; width chi
       pt.peaks[pni].energies[4]=A[4] ; tilt
       pt.peaks[pni].energies[5]=A[0] ; background

       pt.peaks[pni].intAD[0]=ii
       pt.peaks[pni].intAD[1]=si
       opt->set_object, pt
       end

end
;----------------------------------

function opt_vertical_subtraction, P, X=x, Y=y, ERR=err

; p[0] - rotation angle
; p[1] - shift x
; p[2] - shift y

    im=one2two(x); convert image from vector to array

    sz=sqrt(n_elements(im))
    szi=(sz-1)/2

    image1=rot(im, P[0], 1.0, szi+P[1], szi+P[2], /interp)
    image2=rotate(image1, 7)
    sub=(image1-image2)

    sub1=sub[szi-2:szi+2,szi-2:szi+2]
    sub2=fltarr(sz,sz)
    sub2[szi-2:szi+2,szi-2:szi+2]=sub1

;    g1=congrid(image1, 200,200)
;    g2=congrid(image2, 200,200)
;    g3=congrid(sub>0, 200,200)
;    g4=g1-g3

;    window, 1, xpos=0, ypos=0, xsize=200, ysize=200
;    tvscl, g1
;    window, 2, xpos=210, ypos=0, xsize=200, ysize=200
;    tvscl, g2
;    window, 3, xpos=420, ypos=0, xsize=200, ysize=200
;    tvscl, g3
;    window, 4, xpos=630, ypos=0, xsize=200, ysize=200
;    tvscl, g4

    sub3=two2one(sub2) ; convert image from array to vector
    return,sub3/err

end

;===============================================================
function vertical_subtraction, P, im


; p[0] - rotation angle
; p[1] - shift x
; p[2] - shift y

    sz=sqrt(n_elements(im))
    szi=(sz-1)/2

    image1=rot(im, P[0], 1.0, szi+P[1], szi+P[2], /interp)
    image2=rotate(image1, 7)
    sub=(image1-image2)
    sub1=sub>0

    g4=image1-sub1

    g5=rot(g4, -P[0], 1.0, szi-P[1], szi-P[2], /interp)

    return,g5

end

;===============================================================

function center_intensity, im

	  sz=sqrt(n_elements(im))
      szi=(sz-1)/2


      parinfo = replicate({value:0.D, fixed:0, limited:[0,0], $
                       limits:[0.D,0]}, 3)

      parinfo[0].value = -20.0
      parinfo[1].value = 0.0
      parinfo[2].value = 0.0

      parinfo[1].limited(0) = 1
      parinfo[1].limited(1) = 1
      parinfo[2].limited(0) = 1
      parinfo[2].limited(1) = 1

      parinfo[1].limits(0) = -1.0
      parinfo[1].limits(1) =  1.0
      parinfo[2].limits(0) = -1.0
      parinfo[2].limits(1) =  1.0


      XX=two2one(im)
      YY=two2one(im)

      err=REPLICATE(1.,sz*sz)

      fa = {X:XX, Y:YY, ERR:err}

      A = mpfit('opt_vertical_subtraction', functargs=fa, parinfo=parinfo, PERROR=pe, BESTNORM=bestnorm, quiet=1)
	  if n_elements(PE) gt 0 then $
	  begin
	    print, '--- Orientation optimization successful!'
	    print, a
	    print, pe
	  endif else print, 'fitting failed'
	  return, A

end

;===============================================================

function find_overlap, image
; finds orgin shift and rotation that optimize vertical overlap
; convergece criterium is maximum intensity in the original image center (5x5 central pixels)
; and minimum intensity in vertical difference center (5x5 central pixels)

sz=sqrt(n_elements(image))
szi=(sz-1)/2

dd=symmetric_corrlation(ff)
lr=congrid(dd, sz, sz)
print, center_intensity(dd)

end

;-------------------------------------------

function symmetric_corrlation, im
; uses symmetric correlation of each half (top + bottom, left + right) to filter peak
; surrounding and leave only central symmetric peak
; peak elongation + tilt will be a problem, unless a rotation is included


  if n_elements(im) ne 0 then $
  begin

    shif=0

    sz=sqrt(n_elements(im))
    szi=(sz-1)/2-shif

;    window,1, xsize=200, ysize=200, xpos=0, ypos=0
;    tvscl, congrid(im, 200,200)


    P=center_intensity(im)
    image=vertical_subtraction(P, im)


 ;   window,2, xsize=200, ysize=200, xpos=210, ypos=0
 ;   tvscl, congrid(image, 200,200)

    return, image


  endif

 end


;===============================================================

pro peak_intensity_evaluation_2d, pni, A, PCERROR, XY, axis, lbcgr

@COMMON_DATAS
@COMMON_DATAS2
;COMMON WID_MAR345_elements
;COMMON image_type_and_arrays
;common selections, selecting_status, select, excl, unselect, addpeak, mask, maskarr, zoom, unmask


       pt=opt->get_object()
       pt.peaks[pni].DetXY[0]= XY[0]+a[5]
       pt.peaks[pni].DetXY[1]= XY[1]+a[6]

       bs=[long(pt.peaks[pni].intssd[0]),long(pt.peaks[pni].intssd[0])]
       XX=Xinvec([bs[0]*2+1,bs[1]*2+1])
       yy=yinvec([bs[0]*2+1,bs[1]*2+1])
       p2=long(one2two(profile_function(XX, YY, A)))


       pic=oimage->get_zoomin(XY, bs, maskarr)

       ;---- if part of the box area is outside active circle, replace 0 with local background ------
       cc=which_pixels_in_mtx_outside_circle(bs[0], xy, arr1/2-2)
       c=where(cc eq 1)
       if c[0] ne -1 then pic[c]=replicate(lbcgr[xy[0],xy[1]], n_elements(c))

       ;---------------------------------------------------------------------------------------------


       attt=evaluate_fit_quality(pic, p2)
       if attt[0] gt 0 then $
       begin
          opt->select_peak, pni
       endif else $
       begin

       gonio=pt.peaks[pni].gonio
       kt=read_kappa_and_ttheta()
       gonio[1]=kt[1]
       xyz=oadetector->calculate_XYZ_from_pixels_mono(pt.peaks[pni].DetXY, gonio, wv)

     ;------------
       sd=oadetector->calculate_sd_from_pixels(pt.peaks[pni].DetXY, gonio)
       nu=ang_between_vecs([0.0,sd[1],sd[2]],[0.,-1.,0.])
       nu1=oadetector->get_nu_from_pix(pt.peaks[pni].DetXY)
       ;print, nu, nu1
       tth=get_tth_from_xyz(pt.peaks[pni].xyz)
       II=(A[1]*A[2]*A[3])*2.*!pi
       si=2.*!pi*(A[2]*A[3]*PCERROR[1]+A[1]*A[2]*PCERROR[3]+A[1]*A[3]*PCERROR[2])
       ty=I_corrections()

      ;-- Lorenz correction
      if ty[1] eq 1 then $
      begin
       ii=II/lorenz(xyz, gonio, wv)
       si=sI/lorenz(xyz, gonio, wv)
      endif

     ;-- polarization correction
      if ty[2] eq 1 then $
      begin
       P1=0.9
       mu=20.41
       h=0.005
       v=vert_polariz()*90.0+nu
       ii=II/(1.0-read_polar()*cos(2.0*v/!radeg));*cos(gonio[3]/!radeg)
       si=sI/(1.0-read_polar()*cos(2.0*v/!radeg));*cos(gonio[3]/!radeg)
      endif
      ;-- CBN absorption correction
      if ty[0] eq 1 then $
      begin
       om0= 0.0
       ii=II/dac_profile(pt.peaks[pni].gonio[axis]+om0,1)
       si=sI/dac_profile(pt.peaks[pni].gonio[axis]+om0,1)
      end

    ;-- omega polynomial correction
       aom=omega_correction(pt.peaks[pni].gonio[axis])
       ii=II*aom
       si=sI*aom

       pt.peaks[pni].energies[2]=A[2] ; width 2th
       pt.peaks[pni].energies[3]=A[3] ; width chi
       pt.peaks[pni].energies[4]=A[4] ; tilt
       pt.peaks[pni].energies[5]=A[0] ; background

       pt.peaks[pni].intAD[0]=ii
       pt.peaks[pni].intAD[1]=si
       opt->set_object, pt
       end

end

;----------------------------------



function two2DGaussians, image, loc1, loc2

; fits two 2d gaussian profiles simultaneously in the same fitting box
; location of peak 1 is passed as parameter of pixel coordinates relative to center
; location of peak 2 is passed as parameter of pixel coordinates relative to center

  if n_elements(image) ne 0 then $
  begin

    sz=sqrt(n_elements(image))
    szi=(sz-1)/2


    XX=Xinvec([sz,sz]) ; x-coordinates as vector. Center is at 0,0
    yy=yinvec([sz,sz]) ; y-coordinates as vector. Center is at 0,0
    zz=TWO2ONE(image)



    location1=loc1
    location2=loc2

; 15 fitting parameters is for two pseudo Voigt on one flat background
      parinfo = replicate({value:0.D, fixed:0, limited:[0,0], $
                       limits:[0.D,0]}, 15)

;   P[0] - background
;   P[1] - peak 1 intensity
;   P[2] - x width 1
;   P[3] - y width 1
;   P[4] - tilting of the profile 1
;   P[5] - x shift 1
;   P[6] - y shift 1
;   P[7] - Lorentz 1

;   P[8] - peak intensity 2
;   P[9] - x width 2
;   P[10] - y width 2
;   P[11] - tilting of the profile 2
;   P[12] - x shift 2
;   P[13] - y shift 2
;   P[14] - Lorentz 2


      parinfo[0].value = median(image); background
      parinfo[1].value = image[szi+loc1[0],szi+loc1[1]]-median(image); intensity
      parinfo[2].value = 0.5; width
      parinfo[3].value = 0.5; width
      parinfo[4].value = 0.0; tilt
      parinfo[5].value = loc1[1]; shift
      parinfo[6].value = loc1[0]; shift
      parinfo[7].value = 0.0; lorenz

      parinfo[8].value = image[szi+loc2[0],szi+loc2[1]]-median(image)	; intensity
      parinfo[9].value = 0.5		; width
      parinfo[10].value = 0.5		; width
      parinfo[11].value = 0.0		; tilt
      parinfo[12].value = loc2[1]	; shift
      parinfo[13].value = loc2[0]	; shift
      parinfo[14].value = 0.0		; lorenz

      parinfo[0].limited(0) = 1
      parinfo[0].limits(0)  = 0.D
      parinfo[1].limited(0) = 1
      parinfo[1].limits(0)  = 0.D
      parinfo[2].limited(0) = 1
      parinfo[2].limits(0)  = 0.D
      parinfo[3].limited(0) = 1
      parinfo[3].limits(0)  = 0.D
      parinfo[4].limited(0) = 1
      parinfo[4].limited(1) = 1
      parinfo[4].limits(0)  = -!pi;!pi/2.
      parinfo[4].limits(1)  =  !pi;*3./2.
      parinfo[5].limited(0) = 1
      parinfo[5].limited(1) = 1
      parinfo[5].limits(0)  = -szi
      parinfo[5].limits(1)  = szi
      parinfo[6].limited(0) = 1
      parinfo[6].limited(1) = 1
      parinfo[6].limits(0)  = -szi
      parinfo[6].limits(1)  = szi
      parinfo[7].limited(0) = 1
      parinfo[7].limited(1) = 1
      parinfo[7].limits(0)  = 0.
      parinfo[7].limits(1)  = 1.


      parinfo[8].limited(0) = 1
      parinfo[8].limits(0)  = 0.D
      parinfo[9].limited(0) = 1
      parinfo[9].limits(0)  = 0.D
      parinfo[10].limited(0) = 1
      parinfo[10].limits(0)  = 0.D
      parinfo[11].limited(0) = 1
      parinfo[11].limited(1) = 1
      parinfo[11].limits(0)  = -!pi;!pi/2.
      parinfo[11].limits(1)  =  !pi;*3./2.
      parinfo[12].limited(0) = 1
      parinfo[12].limited(1) = 1
      parinfo[12].limits(0)  = -szi
      parinfo[12].limits(1)  = szi
      parinfo[13].limited(0) = 1
      parinfo[13].limited(1) = 1
      parinfo[13].limits(0)  = -szi
      parinfo[13].limits(1)  = szi
      parinfo[14].limited(0) = 1
      parinfo[14].limited(1) = 1
      parinfo[14].limits(0)  = 0.
      parinfo[14].limits(1)  = 1.

      er=REPLICATE(1.,sz*sz)


      A = MPFIT2DFUN('Two_Voigt2dwt', XX, YY, ZZ, ER, PERROR=PE, BESTNORM=BN,parinfo=parinfo, ERRMSG=msg, quiet=1)
	  if n_elements(PE) gt 0 then $
	  begin
	    ;print, '--- Two profile fitting successful!'
	    ;print, a
	    ;print, pe
	    b=Two_Voigt2dwt(XX, YY, A)
	  endif

 ; window, 1, xsize=200, ysize=200, xpos=0,ypos=0
 ; tvscl, congrid(image, 200, 200)

 ; window, 2, xsize=200, ysize=200, xpos=210,ypos=0
 ; tvscl, congrid(one2two(b), 200, 200)


 ; window, 4, xsize=200, ysize=200, xpos=630,ypos=0
 ; tvscl, congrid(image-one2two(b), 200, 200)
  if n_elements(pe) eq 0 then return, 0
  return, [a, pe]

  endif else return, 0


end

;----------------------------------

function two_peaks_get_profile, i1, i2

; i1 is the number of the peak to be fit
; returns fitted profile parameters with uncertainties

@COMMON_DATAS
@COMMON_DATAS2

 pt=opt->get_object()
 x1=pt.peaks[i1].detXY
 x2=pt.peaks[i2].detXY




 ;determine box size and location
 middle=round((x1+x2)/2.0)
 d=x1-middle
 d=round(sqrt(d[0]*d[0]+d[1]*d[1])+6)
 xr1=x1-middle
 xr2=x2-middle
 ;print, xr1, xr2
 pic=oimage->get_zoomin(middle, [d,d], maskarr)
 aaa=two2DGaussians(pic, xr1,xr2)

 if  n_elements(aaa) gt 1 then $
 begin

 sz=sqrt(n_elements(pic))

 XX=Xinvec([sz,sz]) ; x-coordinates as vector. Center is at 0,0
 yy=yinvec([sz,sz]) ; y-coordinates as vector. Center is at 0,0
 b=one2two(Two_Voigt2dwt(XX, YY, Aaa))

 t=-aaa[11]
 mtx=[[cos(t),sin(t)],[-sin(t),cos(t)]]
 XYa=[aaa[12],aaa[13]]
 ea=transpose(mtx ## XYa)
 xr1a=[-ea[1],-ea[0]]


 cen=[d,d]+round(xr1)

 ra=(min(cen))
 if cen[0]-ra lt 0 then ra=cen[0]
 if cen[1]-ra lt 0 then ra=cen[1]
 if cen[0]+ra gt sz-1 then ra=sz-1-cen[0]
 if cen[1]+ra gt sz-1 then ra=sz-1-cen[1]

 a=oimage->get_zoomin(round(middle+round(xr1)), [ra,ra], maskarr)


 ;a=pic[cen[0]-ra:cen[0]+ra, cen[1]-ra:cen[1]+ra]
 b=b[cen[0]-ra:cen[0]+ra, cen[1]-ra:cen[1]+ra]


;window, 1, xsize=200, ysize=200, xpos=0,ypos=0
;tvscl, congrid(a,200,200)

;window, 2, xsize=200, ysize=200, xpos=220,ypos=0
;tvscl, congrid(b,200,200)

;window, 3, xsize=200, ysize=200, xpos=440,ypos=0
;tvscl, congrid(a-b,200,200)

 return, b

 endif else return, 0


end



;----------------------------------



function one2DGaussian, image

; fits one 2d gaussian profile in the fitting box

  if n_elements(image) ne 0 then $
  begin

    sz=sqrt(n_elements(image))
    szi=(sz-1)/2


    XX=Xinvec([sz,sz]) ; x-coordinates as vector. Center is at 0,0
    yy=yinvec([sz,sz]) ; y-coordinates as vector. Center is at 0,0
    zz=TWO2ONE(image)


; 8 fitting parameters is for two pseudo Voigt on one flat background
      parinfo = replicate({value:0.D, fixed:0, limited:[0,0], $
                       limits:[0.D,0]}, 8)

;   P[0] - background
;   P[1] - peak 1 intensity
;   P[2] - x width 1
;   P[3] - y width 1
;   P[4] - tilting of the profile 1
;   P[5] - x shift 1
;   P[6] - y shift 1
;   P[7] - Lorentz 1


      parinfo[0].value = median(image); background
      parinfo[1].value = image[szi,szi]-median(image); intensity
      parinfo[2].value = 0.5; width
      parinfo[3].value = 0.5; width
      parinfo[4].value = 0.0; tilt
      parinfo[5].value = 0.0; shift
      parinfo[6].value = 0.0; shift
      parinfo[7].value = 0.0; lorenz


      parinfo[0].limited(0) = 1
      parinfo[0].limits(0)  = 0.D
      parinfo[1].limited(0) = 1
      parinfo[1].limits(0)  = 0.D
      parinfo[2].limited(0) = 1
      parinfo[2].limits(0)  = 0.D
      parinfo[3].limited(0) = 1
      parinfo[3].limits(0)  = 0.D
      parinfo[4].limited(0) = 1
      parinfo[4].limited(1) = 1
      parinfo[4].limits(0)  = -!pi;!pi/2.
      parinfo[4].limits(1)  =  !pi;*3./2.
      parinfo[5].limited(0) = 1
      parinfo[5].limited(1) = 1
      parinfo[5].limits(0)  = -szi
      parinfo[5].limits(1)  = szi
      parinfo[6].limited(0) = 1
      parinfo[6].limited(1) = 1
      parinfo[6].limits(0)  = -szi
      parinfo[6].limits(1)  = szi
      parinfo[7].limited(0) = 1
      parinfo[7].limited(1) = 1
      parinfo[7].limits(0)  = 0.
      parinfo[7].limits(1)  = 1.

      er=REPLICATE(1.,sz*sz)

      A = MPFIT2DFUN('Voigt2dwt', XX, YY, ZZ, ER, PERROR=PE, BESTNORM=BN,parinfo=parinfo, ERRMSG=msg, quiet=1)
	  if n_elements(PE) gt 0 then $
	  begin
	    b=Voigt2dwt(XX, YY, A)
	  endif

 ; window, 1, xsize=200, ysize=200, xpos=0,ypos=0
 ; tvscl, congrid(image, 200, 200)

;  window, 2, xsize=200, ysize=200, xpos=210,ypos=0
;  tvscl, congrid(one2two(b), 200, 200)


;  window, 4, xsize=200, ysize=200, xpos=630,ypos=0
;  tvscl, congrid(image-one2two(b), 200, 200)
  if n_elements(pe) ne 0 then $
  return, [a, pe] else return, 0

  endif else return, -1


end


;----------------------------------

;----------------------------------

function one_peak_get_profile, i1

; i1 is the number of the peak to be fit
; returns fitted profile parameters with uncertainties

@COMMON_DATAS
@COMMON_DATAS2

 pt=opt->get_object()
 x1=pt.peaks[i1].detXY

 ;determine box size and location
 bx=read_box_size(wid_text_37,wid_text_37)
 pic=oimage->get_zoomin(round(x1), bx, maskarr)
 aaa=one2DGaussian(pic)

 sz=sqrt(n_elements(pic))

 XX=Xinvec([sz,sz]) ; x-coordinates as vector. Center is at 0,0
 yy=yinvec([sz,sz]) ; y-coordinates as vector. Center is at 0,0
 if n_elements(aaa) ne 1 then baa=one2two(Voigt2dwt(XX, YY, Aaa[0:7])) else baa=fltarr(sz,sz)

 return, baa

end

;--------------------------------------


function simple_sum, image
; assumes, that the flat background is well estimated by median
  if n_elements(image) ne 0 then $
  begin
    sz=sqrt(n_elements(image))
    b=median(image)
    sum=total(image)
    background=b*sz*sz
    print, 'max', max(image)
    print, 'min', min(image)
    print, 'total', sum
    print, 'median', b
    print, 'integral', sum-background
    return, sum-background
  endif else return, -1
end
;--------------

function simple_sum_locate_peak, image
; assumes, that the flat background is well estimated by median
  if n_elements(image) ne 0 then $
  begin
    sz=sqrt(n_elements(image))
    sza=n_elements(image)
    center=(sz-1)/2
    b=median(image)
    sum=total(image)
    for i=0,center-1 do $
    begin
     pic_zoom=image[center-i:center+i,center-i:center+i]
     szi=n_elements(pic_zoom)
     total_zoom=total(pic_zoom)
     aa=float((sum-total_zoom))/(sza-szi)
     ab=total_zoom/szi
     ;print, i,ab/aa,ab,aa, b.
     print, i, ab/aa,ab,aa, b, median(pic_zoom), total_zoom-b*szi

    endfor
    background=b*sz*sz
    print, 'max', max(image)
    print, 'min', min(image)
    print, 'total', sum
    print, 'median', b
    print, 'integral', sum-background
    return, sum-background
  endif else return, -1
end
;--------------

function gauss, A, x
  Z=(x-A[1])/A[2]
  g=A[0]*exp(-0.5*Z^2)+A[3]+A[4]*x
  return, g
end


function twoDfit, image
  if n_elements(image) ne 0 then $
  begin
    sz=sqrt(n_elements(image))
    xprofile=fltarr(sz)
    yprofile=fltarr(sz)
    x=indgen(sz)
    xx=indgen(sz*10)/10.
    for i=0, sz-1 do xprofile[i]=total(image[*,i])
    for i=0, sz-1 do yprofile[i]=total(image[i,*])
    window, 1
    plot, xprofile, yrange=[min(xprofile), max(xprofile)], psym=2
    b=gaussfit(x, xprofile,a, nterms=5)
    yy=gauss(A, xx)
    print, 'gaussian integral=', a[0]*sqrt(!pi*a[2]*2.0), a[3]/sz
    oplot, xx,yy
    window, 2
    plot, yprofile, yrange=[min(yprofile), max(yprofile)], psym=2
    b=gaussfit(x, yprofile, a, nterms=5)
    yy=gauss(A, xx)
    print, 'gaussian integral=', a[0]*sqrt(!pi*a[2]*2.0), a[3]/sz
    oplot, xx, yy
  endif else return, -1
end

;--------------

function twoDfit_mpfit, image, diagnostic
  if n_elements(image) ne 0 then $
  begin
    sz=sqrt(n_elements(image))
    szi=(sz-1)/2
    xprofile=fltarr(sz)
    yprofile=fltarr(sz)
    x=indgen(sz)
    xx=indgen(sz*10)/10.
    for i=0, sz-1 do xprofile[i]=total(image[*,i])
    for i=0, sz-1 do yprofile[i]=total(image[i,*])

    parinfo = replicate({value:0.D, fixed:0, limited:[0,0], $
                        limits:[0.D,0], tied:''}, 10)
    bx=gaussfit(x, xprofile, ax, nterms=5)
    by=gaussfit(x, yprofile, ay, nterms=5)

    parinfo[*].value = [ax, ay]
    parinfo[5].tied = 'P[0]*sqrt(2.0*!pi*P[2])/sqrt(2.0*!pi*P[7])'
    p0=parinfo[*].value


    err=fltarr(sz*2)
    err[*]=1.0

    fa = {X:xprofile, Y:yprofile, ERR:err}
    p = mpfit('Two_Gaussians', functargs=fa, parinfo=parinfo, PERROR=perror, BESTNORM=bestnorm, quiet=1)
    ;DOF     = N_ELEMENTS(fa.X)+N_ELEMENTS(fa.Y) - N_ELEMENTS(P) ; deg of freedom
    ;PCERROR = perror * SQRT(BESTNORM / DOF)   ; scaled uncertainties
    print, p
    if n_elements(PERROR) gt 0 then print, PERROR

    if diagnostic eq 1 then $
    begin

    window, 1
    plot, xprofile, yrange=[min(xprofile), max(xprofile)], psym=2
    yy=gauss(P[0:4], xx)
    oplot, xx,yy

    window, 2
    plot, yprofile, yrange=[min(yprofile), max(yprofile)], psym=2
    yy=gauss(P[5:9], xx)
    oplot, xx, yy

    print, 'gaussian integral X=', p[0]*sqrt(!pi*p[2]*2.0)
    print, 'gaussian shifts =', p[1]-szi, p[6]-szi

    endif

    return, [p[0]*sqrt(!pi*p[2]*2.0), p[1]-szi, p[6]-szi]

  endif else return, -1
end

;--------------

function one_profile_fitting, i1

; i1 is the number of the peak to be fit
; returns fitted profile parameters with uncertainties

@COMMON_DATAS
@COMMON_DATAS2

 pt=opt->get_object()
 x1=pt.peaks[i1].detXY

; check if selected pixels are the maxima. If not, then update
 pic1=oimage->get_zoomin(x1, [2,2], maskarr)
 b1=max(pic1,j1)
 ind1=ARRAY_INDICES(pic1, j1)
 x1=x1+ind1-[2,2]

;recenter one more time
 pic1=oimage->get_zoomin(x1, [2,2], maskarr)
 b1=max(pic1,j1)
 ind1=ARRAY_INDICES(pic1, j1)
 x1=x1+ind1-[2,2]

 pt.peaks[i1].detXY=x1
 opt->set_object, pt

 ;determine box size and location
 bx=read_box_size(wid_text_37,wid_text_37)
 pic=oimage->get_zoomin(x1, bx, maskarr)
 aaa=one2DGaussian(pic)

 if n_elements(aaa) ne 1 then $
 begin

 t=-aaa[4]
 mtx=[[cos(t),sin(t)],[-sin(t),cos(t)]]
 XYa=[aaa[5],aaa[6]]
 ea=transpose(mtx ## XYa)
 pt.peaks[i1].detXY=x1+[ea[1],ea[0]]
 opt->set_object, pt
 return, aaa

endif else return, 0

end


;----------------------------------
function two_profile_fitting, i1,i2

; i1 and i2 and numbers of the two peaks to be fit together
; returns fitted profile parameters with uncertainties

@COMMON_DATAS
@COMMON_DATAS2

 pt=opt->get_object()
 x1=pt.peaks[i1].detXY
 x2=pt.peaks[i2].detXY
 dx2=x2-x1

; check if selected pixels are the maxima. If not, then update
 pic1=oimage->get_zoomin(x1, [2,2], maskarr)
 pic2=oimage->get_zoomin(x2, [2,2], maskarr)
 b1=max(pic1,j1)
 b2=max(pic2,j2)
 ind1=ARRAY_INDICES(pic1, j1)
 ind2=ARRAY_INDICES(pic2, j2)
 x1=x1+ind1-[2,2]
 x2=x2+ind2-[2,2]

;recenter one more time
 pic1=oimage->get_zoomin(x1, [2,2], maskarr)
 pic2=oimage->get_zoomin(x2, [2,2], maskarr)
 b1=max(pic1,j1)
 b2=max(pic2,j2)
 ind1=ARRAY_INDICES(pic1, j1)
 ind2=ARRAY_INDICES(pic2, j2)
 x1=x1+ind1-[2,2]
 x2=x2+ind2-[2,2]


 pt.peaks[i1].detXY=x1
 pt.peaks[i2].detXY=x2
 opt->set_object, pt


 dx2=x2-x1

 ;determine box size and location
 middle=(x1+x2)/2.0
 d=x1-middle
 d=round(sqrt(d[0]*d[0]+d[1]*d[1])+6)
 xr1=x1-middle
 xr2=x2-middle
 ;print, xr1, xr2
 pic=oimage->get_zoomin(middle, [d,d], maskarr)
 aaa=two2DGaussians(pic, xr1,xr2)

 if N_elements(aaa) ne 1 then $
 begin


 t=-aaa[4]
 mtx=[[cos(t),sin(t)],[-sin(t),cos(t)]]
 XYa=[aaa[5],aaa[6]]
 ;print, 'Unrotation'
 ea=transpose(mtx ## XYa)
 pt.peaks[i2].detXY=middle+[-ea[1],-ea[0]]

 t=-aaa[11]
 mtx=[[cos(t),sin(t)],[-sin(t),cos(t)]]
 XYa=[aaa[12],aaa[13]]
 ;print, 'Unrotation'
 ea=transpose(mtx ## XYa)
 pt.peaks[i1].detXY=middle+[-ea[1],-ea[0]]



 ;pt.peaks[i2].detXY=middle+[aaa[13],aaa[12]]
 opt->set_object, pt


 return, [aaa[0:7],aaa[15:22]]
 endif else $
 return, 0

end

;----------------------------------


function grow_peak, arr, bkg, x,y, mins, xmax, ymax
;-- up
if y lt ymax-1 then $
begin
yu=y+1
while (arr[x,yu] gt bkg[x,y]+mins) and (yu lt ymax-1) do yu=yu+1
endif else yu=y
;-- down
if y gt 0 then $
begin
yd=y-1
while (arr[x,yd] gt bkg[x,y]+mins) and (yd gt 0) do yd=yd-1
endif else yd=y
;-- left
if x gt 0 then $
begin
xl=x-1
while (max(arr[xl,yd:yu]) gt bkg[x,y]+mins) and (xl gt 0) do xl=xl-1
endif else xl=x
;-- right
if x lt xmax-1 then $
begin
xr=x+1
while (max(arr[xr,yd:yu]) gt bkg[x,y]+mins) and (xr lt xmax-1) do xr=xr+1
endif else xr=x
;print, 'peak: ', x,y
;print, 'grow results:', xl,xr, yd,yu
;----------- max intensity
bb=arr[xl:xr,yd:yu]
m=max(bb,ll)
XY=ARRAY_INDICES([xr-xl+1,yu-yd+1], ll, /DIMENSIONS)
return, [xl,xr, yd,yu, xl+xy[0],yd+xy[1]]
;----------- geometric center
;XY=[(xr+xl)/2.,(yu+yd)/2.]
;return, [xl,xr, yd,yu, xy[0],xy[1]]
end
;--------------



function fit_one_peak_PD_from_Pic, pni, pica
@COMMON_DATAS
COMMON image_type_and_arrays, imt, arr1, arr2,cenx, ceny, rad, rad1
common selections, selecting_status, select, excl, unselect, addpeak, mask, maskarr, zoom, unmask

   try=0
   if pn ge 0 and pn lt opt->peakno() then $
   begin
     pt=opt->get_object()
     bs=[long(pt.peaks[pn].intssd[0]),long(pt.peaks[pn].intssd[0])]
     XY=pt.peaks[pn].detxy
     if not(XY[0]-bs[0] le 0 or $
           arr1 - XY[0] le bs[0] or $
           XY[1]-bs[1] le 0 or $
           arr2 - XY[1] le bs[1]) then $
     begin
      parinfo = replicate({value:0.D, fixed:0, limited:[0,0], $
                       limits:[0.D,0]}, 8)
      parinfo[0].limited(0) = 1
      parinfo[0].limits(0)  = 0.D
      parinfo[1].limited(0) = 1
      parinfo[1].limits(0)  = 0.D
      parinfo[2].limited(0) = 1
      parinfo[2].limits(0)  = 0.D
      parinfo[3].limited(0) = 1
      parinfo[3].limits(0)  = 0.D
      parinfo[4].limited(0) = 1
      parinfo[4].limited(1) = 1
      parinfo[4].limits(0)  = -!pi;!pi/2.
      parinfo[4].limits(1)  =  !pi;*3./2.
      parinfo[5].limited(0) = 1
      parinfo[5].limited(1) = 1
      parinfo[5].limits(0)  = -bs[0]
      parinfo[5].limits(1)  = bs[0]
      parinfo[6].limited(0) = 1
      parinfo[6].limited(1) = 1
      parinfo[6].limits(0)  = -bs[1]
      parinfo[6].limits(1)  = bs[1]
      parinfo[7].limited(0) = 1
      parinfo[7].limited(1) = 1
      parinfo[7].limits(0)  = 0.
      parinfo[7].limits(1)  = 1.
      XX=Xinvec([bs[0]*2+1,bs[1]*2+1])
      yy=yinvec([bs[0]*2+1,bs[1]*2+1])

retry:
      ; pica array is larger than the fitting region to allow re-centering and box size change within this routne
      ; for now the size of pica is fixed to 41x41. It is unlikely the fitting box will require larger array.
      ; XYBC are the initial coordinates of the center of firring box within pica
       XYBC=[20,20]
	  ;pic=oimage->get_zoomin(XY, bs, maskarr)

      ; pic is the fitting box
	   pic= pica[XYBC[0]-bs[0]:XYBC[0]+bs[0], XYBC[1]-bs[1]:XYBC[0]+bs[1]]

       ;cc=which_pixels_in_mtx_outside_circle(bs[0], xy, arr1/2-2)
       ;c=where(cc eq 1)
       ;if c[0] ne -1 then pic[c]=replicate(lbcgr[xy[0],xy[1]], n_elements(c))

       if prefitting() eq 1 then $
       begin
         p0=fltarr(7)
         p0[1]=max(pic)
         p0[2]=1
         p0[3]=1
         Gauss = GAUSS2DFIT( pic, P0, /TILT)
         ; aply position shift only if new center is still within the box
         if p0[4] gt 0 and p0[4] lt bs[0]*2. and  $
         p0[5] gt 0 and p0[5] lt bs[0]*2. then $
         begin
            xy[0]= (P0[4]-bs[0])+XY[0]
            xy[1]= (P0[5]-bs[1])+XY[1]
            if xy[0]-bs[0] lt 0 or $
            xy[0]+bs[0] gt arr1-1 or $
            xy[1]-bs[1] lt 0 or $
            xy[1]+bs[1] gt arr2-1 then return, 2; Peak too close to the edge of the image after shift'
            pic=oimage->get_zoomin(XY, bs, maskarr)
         endif else $
         begin
           if try eq 1 then return, 1 $; position shift larger then the box
           else $
           begin
             dXY=recenter_to_max_intensity(pic)
             XY=XY+dXY
             try=1
             goto, retry
           endelse
         endelse

         ;if shift is not too large recenter the zoomin
         pic=oimage->get_zoomin(XY, bs, maskarr)
         Gauss = GAUSS2DFIT( pic, P0, /TILT)
         p1=p0
         p1[5]=p0[5]-BS[0]
         p1[6]=p0[4]-bs[1]
         p1[4]=p0[6]

      endif else $
      begin
       P1=fltarr(7)
       P1[0]=median(pic); lbcgr[XY[0],XY[1]]
       P1[1]=max(pic)
       P1[2]=0.5 ; profile width
       P1[3]=0.5 ; profile width
 	   P1[5]=0.0 ; profile width
       P1[6]=0.0 ; profile width

     ;--------------- temporarily disabled --------------------------------
     ;  dXY=recenter_to_max_intensity(pic)
     ;  XY=XY+dXY

     ;  XYBC=XYBC+dXY
	 ;  pic= pica[XYBC[0]-bs[0]:XYBC[0]+bs[0], XYBC[1]-bs[1]:XYBC[0]+bs[1]]

     ;  pic=oimage->get_zoomin(XY, bs, maskarr)
     ;  cc=which_pixels_in_mtx_outside_circle(bs[0], xy, arr1/2-2)
     ;  c=where(cc eq 1)
     ;  if c[0] ne -1 then pic[c]=replicate(lbcgr[xy[0],xy[1]], n_elements(c))
     ;---------------------------------------------------------------------

      endelse

      p1=[p1,0.0]
      parinfo[*].value  = p1
      zz=TWO2ONE(PIC)
      er=REPLICATE(1.,(bs[0]*2+1)*(bs[1]*2+1))
      A = MPFIT2DFUN(profile_function_name(), XX, YY, ZZ, ER, PERROR=PE, BESTNORM=BN,parinfo=parinfo, ERRMSG=msg, QUIET=1)
	  if n_elements(PE) gt 0 then $
      if not((A[0] eq 0) or (pe[1] eq 0)  or (A[1] gt 170000) or (abs(A[5]) ge bs[0]) or $
            (abs(A[6]) ge bs[0]) or (abs(A[2]) ge bs[0]) or (abs(A[3]) ge bs[0])) then $
      begin
        XY=[XY[0]+A[5],XY[1]+A[6]]
        pt.peaks[pn].detXY=XY
        opt->set_object, pt
        parinfo[*].value  = A

      ;  pic=oimage->get_zoomin(xy, bs, maskarr)
      ;  cc=which_pixels_in_mtx_outside_circle(bs[0], xy, arr1/2-2)
      ;  c=where(cc eq 1)
      ;  if c[0] ne -1 then pic[c]=replicate(lbcgr[xy[0],xy[1]], n_elements(c))
      ;  zz=TWO2ONE(PIC)
      ;  A = MPFIT2DFUN(profile_function_name(), XX, YY, ZZ, ER, PERROR=PE, BESTNORM=BN,parinfo=parinfo, ERRMSG=msg, QUIET=1)

      end else $
      begin
        goto, do_nothing
        ;try fitting in a smaller box
        pic=oimage->get_zoomin(xy, [6,6], maskarr)
        cc=which_pixels_in_mtx_outside_circle(6, xy, arr1/2-2)
        c=where(cc eq 1)
        if c[0] ne -1 then pic[c]=replicate(lbcgr[xy[0],xy[1]], n_elements(c))
        zz=TWO2ONE(PIC)
      	parinfo[5].limits(0)  = -6
      	parinfo[5].limits(1)  =  6
      	parinfo[6].limits(0)  = -6
      	parinfo[6].limits(1)  =  6
      	XX=Xinvec([6*2+1,6*2+1])
      	yy=yinvec([6*2+1,6*2+1])

        A = MPFIT2DFUN(profile_function_name(), XX, YY, ZZ, ER, PERROR=PE, BESTNORM=BN,parinfo=parinfo, ERRMSG=msg, QUIET=1)
        if not((A[0] eq 0) or (pe[1] eq 0)  or (A[1] gt 50000) or (abs(A[5]) ge 6) or $
            (abs(A[6]) ge 6) or (abs(A[2]) ge 6) or (abs(A[3]) ge 6)) then $
            begin
              XY=[XY[0]+A[5],XY[1]+A[6]]
              pt.peaks[pn].intssd[0]=6
              pt.peaks[pn].detXY=XY
              opt->set_object, pt
              return, [0,A, PE]
            endif else return, 5; 'Peak fitting failed
 do_nothing:
      endelse
    end else return, 4; 'Peak too close to the edge of the image'
   endif else return, 3; peak number incorrect
   if n_elements(PE) eq 0 then PE=fltarr(8)
   return, [0,A, PE]
 end


;----------------------

function fit_one_peak_PD, pn, lbcgr
@COMMON_DATAS
COMMON image_type_and_arrays, imt, arr1, arr2,cenx, ceny, rad, rad1
common selections, selecting_status, select, excl, unselect, addpeak, mask, maskarr, zoom, unmask
   try=0
   if pn ge 0 and pn lt opt->peakno() then $
   begin
     pt=opt->get_object()
     bs=[long(pt.peaks[pn].intssd[0]),long(pt.peaks[pn].intssd[0])]
     XY=pt.peaks[pn].detxy
     if not(XY[0]-bs[0] le 0 or $
           arr1 - XY[0] le bs[0] or $
           XY[1]-bs[1] le 0 or $
           arr2 - XY[1] le bs[1]) then $
     begin
     ;print, pn
      parinfo = replicate({value:0.D, fixed:0, limited:[0,0], $
                       limits:[0.D,0]}, 8)
      parinfo[0].limited(0) = 1
      parinfo[0].limits(0)  = 0.D
      parinfo[1].limited(0) = 1
      parinfo[1].limits(0)  = 0.D
      parinfo[2].limited(0) = 1
      parinfo[2].limits(0)  = 0.D
      parinfo[3].limited(0) = 1
      parinfo[3].limits(0)  = 0.D
      parinfo[4].limited(0) = 1
      parinfo[4].limited(1) = 1
      parinfo[4].limits(0)  = -!pi;!pi/2.
      parinfo[4].limits(1)  =  !pi;*3./2.
      parinfo[5].limited(0) = 1
      parinfo[5].limited(1) = 1
      parinfo[5].limits(0)  = -bs[0]
      parinfo[5].limits(1)  = bs[0]
      parinfo[6].limited(0) = 1
      parinfo[6].limited(1) = 1
      parinfo[6].limits(0)  = -bs[1]
      parinfo[6].limits(1)  = bs[1]
      parinfo[7].limited(0) = 1
      parinfo[7].limited(1) = 1
      parinfo[7].limits(0)  = 0.
      parinfo[7].limits(1)  = 1.
      XX=Xinvec([bs[0]*2+1,bs[1]*2+1]) ; x-coordinates as vector. Center is at 0,0
      yy=yinvec([bs[0]*2+1,bs[1]*2+1]) ; y-coordinates as vector. Center is at 0,0

retry: pic=oimage->get_zoomin(XY, bs, maskarr)

       if do_symmetric_correlation() then $
       pic=symmetric_corrlation(pic)


       cc=which_pixels_in_mtx_outside_circle(bs[0], xy, arr1/2-2)
       c=where(cc eq 1)
       if c[0] ne -1 then pic[c]=replicate(lbcgr[xy[0],xy[1]], n_elements(c))
       if prefitting() eq 1 then $
       begin
         p0=fltarr(7)
         p0[1]=max(pic)
         p0[2]=1
         p0[3]=1
         Gauss = GAUSS2DFIT( pic, P0, /TILT)
         ; aply position shift only if new center is still within the box
         if p0[4] gt 0 and p0[4] lt bs[0]*2. and  $
         p0[5] gt 0 and p0[5] lt bs[0]*2. then $
         begin
            xy[0]= (P0[4]-bs[0])+XY[0]
            xy[1]= (P0[5]-bs[1])+XY[1]
            if xy[0]-bs[0] lt 0 or $
            xy[0]+bs[0] gt arr1-1 or $
            xy[1]-bs[1] lt 0 or $
            xy[1]+bs[1] gt arr2-1 then return, 2; Peak too close to the edge of the image after shift'
            pic=oimage->get_zoomin(XY, bs, maskarr)
         endif else $
         begin
           if try eq 1 then return, 1 $; position shift larger then the box
           else $
           begin
             dXY=recenter_to_max_intensity(pic)
             XY=XY+dXY
             try=1
             goto, retry
           endelse
         endelse

         ;if shift is not too large recenter the zoomin
         pic=oimage->get_zoomin(XY, bs, maskarr)

         if do_symmetric_correlation() then $
         pic=symmetric_corrlation(pic)

         Gauss = GAUSS2DFIT( pic, P0, /TILT)
         p1=p0
         p1[5]=p0[5]-BS[0]
         p1[6]=p0[4]-bs[1]
         p1[4]=p0[6]

      endif else $
      begin
       P1=fltarr(7)
       P1[0]=lbcgr[XY[0],XY[1]]
       P1[1]=max(pic)
       P1[2]=5.0
       P1[3]=5.0
       dXY=recenter_to_max_intensity(pic)
       XY=XY+dXY
       pic=oimage->get_zoomin(XY, bs, maskarr)
       cc=which_pixels_in_mtx_outside_circle(bs[0], xy, arr1/2-2)
       c=where(cc eq 1)
       if c[0] ne -1 then pic[c]=replicate(lbcgr[xy[0],xy[1]], n_elements(c))


      endelse

      p1=[p1,0.0]
      parinfo[*].value  = p1
      zz=TWO2ONE(PIC)
      er=REPLICATE(1.,(bs[0]*2+1)*(bs[1]*2+1))
      A = MPFIT2DFUN(profile_function_name(), XX, YY, ZZ, ER, PERROR=PE, BESTNORM=BN,parinfo=parinfo, ERRMSG=msg, QUIET=1)
	  if n_elements(PE) gt 0 then $
      if not((A[0] eq 0) or (pe[1] eq 0)  or (A[1] gt 170000) or (abs(A[5]) ge bs[0]) or $
            (abs(A[6]) ge bs[0]) or (abs(A[2]) ge bs[0]) or (abs(A[3]) ge bs[0])) then $
      begin
        if update_on_browse() then $
        begin

         dxy=[A[5],A[6]]

         t=-a[4]
 		 mtx=[[cos(t),sin(t)],[-sin(t),cos(t)]]
 		 XYa=[a[5],a[6]]
 		 ea=transpose(mtx ## XYa)
         XY=XY+[-ea[1],-ea[0]]

         pt.peaks[pn].detXY=XY
         opt->set_object, pt
        endif
        parinfo[*].value  = A
        pic=oimage->get_zoomin(xy, bs, maskarr)

        if do_symmetric_correlation() then $
        pic=symmetric_corrlation(pic)

        cc=which_pixels_in_mtx_outside_circle(bs[0], xy, arr1/2-2)
        c=where(cc eq 1)
        if c[0] ne -1 then pic[c]=replicate(lbcgr[xy[0],xy[1]], n_elements(c))
        zz=TWO2ONE(PIC)
        A = MPFIT2DFUN(profile_function_name(), XX, YY, ZZ, ER, PERROR=PE, BESTNORM=BN,parinfo=parinfo, ERRMSG=msg, QUIET=1)
      end else $
      begin

        ;try fitting in a smaller box
        pic=oimage->get_zoomin(xy, [6,6], maskarr)
        cc=which_pixels_in_mtx_outside_circle(6, xy, arr1/2-2)
        c=where(cc eq 1)
        if c[0] ne -1 then pic[c]=replicate(lbcgr[xy[0],xy[1]], n_elements(c))
        zz=TWO2ONE(PIC)
      	parinfo[5].limits(0)  = -6
      	parinfo[5].limits(1)  =  6
      	parinfo[6].limits(0)  = -6
      	parinfo[6].limits(1)  =  6
      	XX=Xinvec([6*2+1,6*2+1])
      	yy=yinvec([6*2+1,6*2+1])

        A = MPFIT2DFUN(profile_function_name(), XX, YY, ZZ, ER, PERROR=PE, BESTNORM=BN,parinfo=parinfo, ERRMSG=msg, QUIET=1)
    ;    if not((A[0] eq 0) or (pe[1] eq 0)  or (A[1] gt 50000) or (abs(A[5]) ge 6) or $
    ;        (abs(A[6]) ge 6) or (abs(A[2]) ge 6) or (abs(A[3]) ge 6)) then $
    ;        begin


         if update_on_browse() then $
         begin

              XY=[XY[0]+A[5],XY[1]+A[6]]
              pt.peaks[pn].intssd[0]=6
              pt.peaks[pn].detXY=XY
              opt->set_object, pt
         endif
              return, [0,A, PE]
    ;        endif else return, 5; 'Peak fitting failed
      endelse
    end else return, 4; 'Peak too close to the edge of the image'
   endif else return, 3; peak number incorrect
   if n_elements(PE) eq 0 then PE=fltarr(8)
   return, [0,A, PE]
 end




;----------------------------------

pro fit_all_peak_PD1, lbcgr, pt
@COMMON_DATAS
COMMON image_type_and_arrays, imt, arr1, arr2,cenx, ceny, rad, rad1
common selections, selecting_status, select, excl, unselect, addpeak, mask, maskarr, zoom, unmask

     for pn=0, pt.peakno-1 do $
     begin

     bs=[long(pt.peaks[pn].intssd[0]),long(pt.peaks[pn].intssd[0])]
     XY=pt.peaks[pn].detxy
     if not(XY[0]-bs[0] le 0 or $
           arr1 - XY[0] le bs[0] or $
           XY[1]-bs[1] le 0 or $
           arr2 - XY[1] le bs[1]) then $
     begin
      ;XX=Xinvec([bs[0]*2+1,bs[1]*2+1])
      ;yy=yinvec([bs[0]*2+1,bs[1]*2+1])


         pic=oimage->get_zoomin(XY, bs, maskarr)
         m=max(pic, jj)
         aaa=ARRAY_INDICES(pic,jj)

         XY=XY+AAA-[bs[0],bs[1]]

         pic=oimage->get_zoomin(XY, bs, maskarr)

        ; window, 9, xsize=400, ysize=400, title='image'
        ; b=congrid(pic, 400, 400)
        ; tvscl, b

         p0=fltarr(7)
         p0[1]=max(pic)
         p0[2]=1
         p0[3]=1
		 ;p0[4]=bs[0]
         ;p0[5]=bs[1]
    	 p0[4]=aaa[0]
         p0[5]=aaa[1]

         Gauss = GAUSS2DFIT( pic, P0, /TILT)
    ;     print, p0

         ; aply position shift only if new center is still within the box
         xy[0]= (P0[4]-bs[0])+XY[0]
         xy[1]= (P0[5]-bs[1])+XY[1]
         pt.peaks[pn].detXY=XY

         pic=oimage->get_zoomin(XY, bs, maskarr)

     ;    b2=congrid(gauss, 400, 400)
     ;    window, 10, xsize=400, ysize=400, title='fitted'
     ;    tvscl, b2

      ;   b1=congrid(pic, 400, 400)
      ;   window, 11, xsize=400, ysize=400, title='recentered'
      ;   tvscl, b1
      ;   print, ''
       endif
   endfor

 end



;----------------------------------
function determine_optimal_profile, pic, pic2, minsiz

; PARAMETERS:
;   pic  - zoom of diffraction image around the peak
;   pic2 - calculated peak profile in the same zoom window
; RETURNS:
;   0 - fitting is satisfactory
;   1 - significant intensity outside peak area
;   2 - unacceptable intensity outside peak area
;   3 - poor profile match within peak area
;   4 - improper fitting - only background detected

    pic3=pic-pic2
    w=where(pic2 gt median(pic2)*1.5,COMPLEMENT=w1)
    wp=where(pic gt median(pic)*1.5,COMPLEMENT=wp1)
    N=fix(sqrt(n_elements(pic)))

    if w[0] ne -1 and wp[0] ne -1 and w1[0] ne -1 and wp1[0] ne -1 then $
    begin
     bkg=fltarr(N, N)
     bkg[*,*]=median(pic)
     bbd=grow_peak(pic, bkg, (N-1)/2,(N-1)/2, median(pic)*1.0, N, N)
     siz=max([sqrt(n_elements(w))*1.5, minsiz])
     if max(pic3[w1]) gt 3.0*median(pic) then siz=minsiz
     return,fix(siz)
    endif else return, fix((N-1)/2.)
end

;----------------------------------

function evaluate_fit_quality, pic, pic2

; PARAMETERS:
;   pic  - zoom of diffraction image around the peak
;   pic2 - calculated peak profile in the same zoom window
; RETURNS (two element vector).
; First element:
;   0 - fitting is satisfactory
;   1 - significant intensity outside peak area
;   2 - unacceptable intensity outside peak area
;   3 - poor profile match within peak area
;   4 - improper fitting - only background detected
;   5 - residual exceeds 10% of I

; Second element:
;   peak fit quality (difference total to peak total ratio)
    res=fltarr(2)
    N=fix(sqrt(n_elements(pic)))
    pic3=pic-pic2
    w=where(pic2 gt median(pic2)*1.5,COMPLEMENT=w1)
    wp=where(pic gt median(pic)*1.5,COMPLEMENT=wp1)
    if w1[0] ne -1 then $ ; strong pixels outside profile
    w_out=where(pic[w1] gt median(pic)*1.5,COMPLEMENT=w_out1) else w_out=-1

    if w[0] ne -1 and wp[0] ne -1 and w1[0] ne -1 and wp1[0] ne -1 then $
    begin

     ;---- find location of the center of fitted profile
      m=max(pic2, gg)
      center=float(ARRAY_INDICES(pic2, gg))/float(n-1)
      if min(center) lt 0.4 or max(center) gt 0.6 then $
      begin
       print, '---> center = ', center
       print, '---> significant position shift'
      endif

     ;---- find average and maximum intensity in the image outside fitted peak profile
       if w_out[0] ne -1 then $
       begin
        max_out=max(pic[w1[w_out]])/median(pic)
        avg_out=total(pic[w1[w_out]])/median(pic)/N_elements(w_out)
        print, '---> agv_out = ', avg_out
        print, '---> agv_Npoint = ', N_elements(w_out)
        print, '---> max_out = ', max_out
       endif else print, '---> no significant intensity outside profile'


      residual=max(pic3)/max(pic)
	;  if residual gt 0.1 and max(pic3) gt median (pic) then res[0]=5.

      avg_in=mean(pic[wp])
      max_outside=max(pic3[w1])
      med_pic=median(pic)

      if max_outside gt 2.0*median(pic) then res[0]=1. else $
      if max_outside gt 3.0*median(pic) then res[0]=2.

      ii=total(pic2[w])-n_elements(w)*median(pic2)
      id=total(pic3[w])

      res[1]=float(id)/float(ii)
      if abs(res[1]) gt 0.02 then res[0]=3


     ; print, 'm3/m1', max(pic3)/max(pic), min(pic3)/max(pic)

    endif else $
      begin
         res[0]=4. ; improper fitting
         if w[0] eq -1 then print, '---> no intensity above 150% background' else $
         if wp[0] eq -1 then print, '---> fitted profile has no intensity above 150% background'
      endelse
    return, res
end


;--------------------------------------



pro fit_all_peaks, prog=prog

@COMMON_DATAS
@COMMON_DATAS2

   axis=3 ;was 5 for phi
   if prog then $
   begin
    cgProgressBar = Obj_New("CGPROGRESSBAR", /Cancel)
    cgProgressBar -> Start
   endif

   nnn=opt->peakno()-1
   lbcgr=oimage->calculate_local_background(0)

   for pn=nnn, 0, -1 do $
   begin

   if prog then $
   begin
     IF cgProgressBar -> CheckCancel() THEN $
     BEGIN
     	ok = Dialog_Message('Operation canceled')
     	cgProgressBar -> Destroy
     	RETURN
     ENDIF
     cgProgressBar -> Update, (float(nnn-pn)/nnn)*100.0
    endif



     if current_vs_series() eq 1 then $
     begin ; ----- from one image
       ; print, 'fitting peak', pn
        b=opt->find_close_overlaps(pn, 10)
        if b[0] gt 0 then re=two_profile_fitting(b[1],b[2]) else $
        re=one_profile_fitting(pn)
        ;re=fit_one_peak_PD(pn, lbcgr) ; does not update intensity, but updates peak position
;        if n_elements(re) ne 1 then print, 'intensity', re[1]

     endif else $
     begin ; ---- from series
     	bs=read_box_size(wid_text_37,wid_text_37)
     	pic=reform(cumInt[pn,*,*])
     	pic1=pic[20-bs[0]:20+bs[0],20-bs[1]:20+bs[1]]
     	re=fit_one_peak_PD_from_Pic(pn, pic)
 	 endelse

     pt=opt->get_object()
     XY=pt.peaks[pn].DetXY

     if n_elements(re) eq 1 then $
     begin
       opt->select_peak, pn
     endif else $
     begin ;--- successful fit
       n=n_elements(re)-1
       A=re[0:7]
       PCERROR=re[8:15]

       ;------------------------------
       ; get images for comparison
       ;------------------------------

       bs=[long(pt.peaks[pn].intssd[0]),long(pt.peaks[pn].intssd[0])]
       b=opt->find_close_overlaps(pn, 10)
       if b[0] gt 0 then pic9=two_peaks_get_profile(b[1],b[2]) else $
       pic9=one_peak_get_profile(pn)
       if n_elements(pic9) eq 1 then pic9=fltarr((bs+1)*2)

   	   sz=sqrt(n_elements(pic9))
       szi=(sz-1)/2
       bs=[szi,szi]

       pt=opt->get_object()
       XY=round(pt.peaks[pn].detxy)
       pic=oimage->get_zoomin(XY, bs, maskarr)

       ;--------------------------------
       peak_intensity, pn, A, PCERROR, axis, pic, pic9

     endelse
   endfor
   opt->calculate_all_xyz_from_pix, oadetector, wv

goto, hhh

   ; check for improper peak
   for i=pt.peakno[0]-1, 0, -1 do if pt.peaks[i].intAD[1] le 0 or $
                                  pt.peaks[i].DetXY[0] lt 0 or $
                                  pt.peaks[i].DetXY[0] gt arr1 or $
                                  pt.peaks[i].DetXY[1] lt 0 or $
                                  pt.peaks[i].DetXY[1] gt arr2 then $
   begin
     opt->delete_peak, i[0]
   endif
hhh:
      if prog then $
     cgProgressBar -> Destroy
   end




pro peak_fitting
end