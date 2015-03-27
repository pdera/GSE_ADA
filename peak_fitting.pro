
;--------------
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


function fit_one_peak_PD_from_Pic, pn, pica
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
      XX=Xinvec([bs[0]*2+1,bs[1]*2+1])
      yy=yinvec([bs[0]*2+1,bs[1]*2+1])
retry: pic=oimage->get_zoomin(XY, bs, maskarr)
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
        XY=[XY[0]+A[5],XY[1]+A[6]]
        pt.peaks[pn].detXY=XY
        opt->set_object, pt
        parinfo[*].value  = A
        pic=oimage->get_zoomin(xy, bs, maskarr)
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
              XY=[XY[0]+A[5],XY[1]+A[6]]
               pt.peaks[pn].intssd[0]=6
              pt.peaks[pn].detXY=XY
              opt->set_object, pt
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
;  XY1=[[X],[Y]]
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
;-----------------------------
function profile_function, X, Y, P

COMMON WID_MAR345_elements
 s=widget_info(WID_button_413a, /button_set) ; pseudo-Voigt
 if s eq 1 then return, Voigt2dwt(X,Y,P) else return, Gaussian2dwt(X,Y,P)
end



pro peak_fitting
end