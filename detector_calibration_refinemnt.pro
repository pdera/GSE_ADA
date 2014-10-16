 FUNCTION PILAT, p, X=x, Y=y, ERR=err
    @COMMON_DATAS
    @WID_GSE_ADA_COMMON
    COMMON image_type_and_arrays, imt, arr1, arr2,cenx, ceny, rad, rad1
    common selections, selecting_status, select, excl, unselect, addpeak, mask, maskarr, zoom, unmask

;   ds=which_calibrant(200., 1)
;   tths=tth_from_en_and_d(A_to_keV(wv), ds)

; X is image number gor peaks
; Y is calculated tth
   F=fltarr(n_elements(Y))

   widget_control, wid_text_6, get_value=ni
   widget_control, wid_text_7, get_value=i0
   widget_control, wid_text_4, get_value=om0
   widget_control, wid_text_5, get_value=omD
   i0=fix(i0)
   ni=fix(ni)
   om0=float(om0)
   omD=float(omD)


   x1=[0,0]
   x2=[0,arr2]
   x3=[arr1,0]
   x4=[arr1,arr2]
   gonio=fltarr(6)
   an=read_kappa_and_ttheta()

  ad=oadetector->get_object()
  ad.dist   = P[0]
  ad.beamx  = P[1]
  ad.beamy  = P[2]
  ad.angle  = P[3]
  ad.tiltom = P[4]
  ad.tiltch = P[5]
  wv        = P[6]
  om0       = P[7]

  oadetector->set_object, ad
  print_calibration, oadetector, wv

   ints=0 ; sum of intensities at CeO2 peak positions

   time0=systime(/seconds)
  np=0 ;- numbers peaks from X
  for ih=0, ni[0]-1 do $ ;--- go through images
  begin
   ;-- set new 2theta
   gonio[1]=om0+ih*omD
   widget_control, wid_text_36b, set_value=string(gonio[1], format='(F10.2)')
   ;-- read new image file
   res.seq=i0+ih
   fn=generate_fname(res)
   res=analyse_fname(fn, dir, 3)
   widget_control, wid_text_9, set_value=res.name0
   oimage->load_image, fn, oadetector
;   check_mask_file

   ; calculated peaks
   ss=where(X eq ih)
   if ss[0] ne -1 then $
   begin
    t1=Y[ss]
    nt=n_elements(ss)

    capture_calibration, oadetector, wv
    aa=    [oadetector->calculate_tth_from_pixels(x1,gonio),$
           oadetector->calculate_tth_from_pixels(x2,gonio),$
           oadetector->calculate_tth_from_pixels(x3,gonio),$
           oadetector->calculate_tth_from_pixels(x4,gonio)]

   m11=min(aa)
   m12=max(aa)

   Int1=oimage->integrate_dll(oadetector, 500.000, [double(m11),double(m12)], maskarr)
   ;plot, int1[0,*], int1[1,*]

   for j=0, nt-1 do $ ;- go though all the rings and find local maxima around calculated positions
   begin
     xx=min(abs(int1[0,*]-t1[j]),a) ; a is a bin with theoretical position
     plot, int1[0,*], int1[1,*]
     r0=max([a-20,0])
     r1=min([a+20,n_elements(int1)/2-1])
     b=max(int1[1,r0:r1], c)
     pos=int1[0,r0+c]
     F[np]=(t1[j]-pos)
     ;F[np]=total(int1[1,r0:r1])-int1[1,a]
     ;print,'--> ', t1[j], pos
     np=np+1
   endfor
   endif
 endfor
time1=systime(/seconds)
;print, 'computation time:', time1-time0
;print, F
return, F/err

;---------------------------------------------------------------

end

 FUNCTION MYFUN_CAL_OPT, p, X=x, Y=y, ERR=err


   @COMMON_DATAS

   N=opt->peakno() ; dimension of X, Y and ERR

   f=fltarr(N)
   oadn=obj_new('adetector_class')

   ad=oadetector->get_object()

   ad.dist   = p[0]
   ad.beamx  = p[1]
   ad.beamy  = p[2]
   ad.angle  = p[3]
   ad.tiltom = p[4]
   ad.tiltch = p[5]

   ad.alpha  = p[9]


   ;opt->set_alpha, p[9]

    U=U_from_UB(ub)
    lp=lp_from_ub(ub)
    B=b_from_lp(lp)

    if determ(u) lt 0.0 then $
    begin
     inv=[[-1,0,0],[0,-1,0],[0,0,-1]]
    endif else $
    begin
      inv=[[1,0,0],[0,1,0],[0,0,1]]
    endelse

    ;u2=generate_rotation(p[6],p[7],p[8])
    ;u=inv # u2
    uba=inv # euler_composition([p[6],p[7],p[8]]) ## b

;-----------------------------------

   oadn->set_object, ad

   for i=0, N-1 do $
   begin
      F[i]=opt->peak_pos_diff_one(uba, oadn, pred, wv, i);/100.0
      ;print,i,F[i]
   endfor

   obj_destroy, oadn

   return, F/ERR
 END



function xy_from_ind, nx,ny,ind
 y=long(ind/ny)
 x=ind-y*ny
 return, [[x],[y]]
end

;-----------------

function compdist, ff,pos
 n=n_elements(ff)
 b=fltarr(n)
 p0=replicate(pos[0],n)
 p1=replicate(pos[1],n)
 p=[[p0],[p1]]
 ;for i=0, n-1 do $
 ;begin
   xy=xy_from_ind(500,500,ff)
   c=(xy-p)^2
   b=sqrt(c[*,0]+c[*,1])
 ;end
 return, b
end




function closest_ref, rad, dst
 ref=which_calibrant(dst,0)
 ;ref=ceo2(dst,0)
 dr=min(abs(ref-rad), kk)
 return, dr
end

function closest_ref_d, rad, dst
 ref=which_calibrant(dst,0)
 ds=which_calibrant(dst,1)
 dr=min(abs(ref-rad), kk)
 return, ds[kk]
end


function sum_closest_refs, rads, dst
 n=n_elements(rads)
 sum=0.0
 for i=0, n-1 do sum=sum+closest_ref(rads[i], dst)
 return, sum
end

;---------------------------------
function radius_at_tth_and_nu, tt, nu
  @COMMON_DATAS
  common Rota, Mtx
  N=n_elements(tt)
  rad=fltarr(N)
  s0=[1,0,0]
  gonio=fltarr(6)
  for i=0, N-1 do $
  begin
    GenerateR, 3, tt[i]
    sd=mtx # s0
    GenerateR, 1, nu[i]
    sd=mtx # sd
    pix=oadetector->calculate_pixels_from_sd(sd, gonio)
    ad=oadetector->get_object()
    rad[i]=sqrt((pix[0]-ad.beamx)^2+(pix[1]-ad.beamy)^2)*ad.psizex
  endfor
  return, rad
end




;---------------------------------------

function radius_differences, X, Y, P
; x  - x pixel coordinates
; y  - y pixel coordinates
; P  - area detector parameters
@COMMON_DATAS
COMMON CAL_ref, tths, nus ; calculated d for each position
  ad=oadetector->get_object()
  ad.dist   = p[0]
  ad.beamx  = p[1]
  ad.beamy  = p[2]
  ad.angle  = p[3]
  ad.tiltom = p[4]
  ad.tiltch = p[5]
  oadetector->set_object, ad
  n=n_elements(X)
  rado=sqrt(((X-ad.beamx))^2+((Y-ad.beamy))^2)*ad.psizex ; observed radiuses
  pix=fltarr(2,N)
  pix[0,*]=X
  pix[1,*]=Y
  nus=oadetector->get_nu_from_pix(pix) ; observed nu
  radc=radius_at_tth_and_nu(tths, nus)
  return, rado-radc
end

;----------------------------------
function local_background, img
 n=fix(sqrt(n_elements(img)))
 ii=congrid(img, 1000,1000)
 out=lonarr(1000,1000)
 for i=0,99 do $
   for j=0,99 do $
   begin
     box=ii[i*10:(i+1)*10-1,j*10:(j+1)*10-1]
     nz=where(box ne 0)
     if nz[0] ne -1 then m=median(box[nz]) else m=1
     out[i*10:(i+1)*10-1,j*10:(j+1)*10-1]=m
   endfor
   return, congrid(out, n,n)
end
;=====================================================================
;=====================================================================
;=====================================================================
; written on 1/3/2012


pro detector_calibration_test_points

@COMMON_DATAS
@WID_GSE_ADA_COMMON
COMMON image_type_and_arrays, imt, arr1, arr2,cenx, ceny, rad, rad1
common selections, selecting_status, select, excl, unselect, addpeak, mask, maskarr, zoom, unmask
COMMON CAL_ref, tths, nus ; calculated d for each position

; compress image for fast search to 500x500 pixels
ad=oadetector->get_object()
a0=systime(/seconds)
;---- parametrs -----
en=37.077
cut=30       ; minimum number of points along a ring required
dist_tol=1.8 ; toerance for difference in radius between the given point and ring mean
IovS=cal_IovS()

;---- from detector calibration
npixx=arr1
npixy=arr2
psize=ad.psizex
start_dist=ad.dist-ad.dist*0.5
end_dist  =ad.dist+ad.dist*0.5

im=oimage->get_object()
ii=congrid(im.img[0:arr1-1,0:arr2-1]*maskarr, 500,500)
bg=local_background(ii)
;;--------------- ring analysis ------------------
;;-------- select points above 5 sigma

;**** it would be much better to use local background than global median

;median1=median(ii[where(ii gt 0)])
;ff=where(ii gt median1*3.)
ff=where(ii/bg gt IovS[0] and ii gt 20.)
nn=n_elements(ff)


;;-------- plot selected points
wset, draw0
device, decomposed=1
for i=0L, nn-1 do $
begin
  xy=xy_from_ind(500,500,ff[i])
  plots, xy[0]/500., xy[1]/500., color='ff00FF'xl, /normal, psym=1
end


; xy are normal coordinates of the selected points
; ff[i] are sequence coordinates of the selected points in 500x500 mtx
;

;;-------- equal proximity search coarse

; goes in 5 pixel steps
h=fltarr(100,100)
for i=0, 499, 5 do $
begin
  for j=0, 499,5 do $
   begin
     dist=compdist(ff,[i,j])
     h[i/5,j/5]=max(histogram(dist))
   endfor
 endfor
 a=max(h,i)

 xy=xy_from_ind(100,100,i)
 plots, xy[0]/100., xy[1]/100., color='00ff00'xl, /normal, psym=2
 dist=compdist(ff,xy*5.)
 h=histogram(dist, LOCATIONS=hl, binsize=1.)

;;-------- equal proximity search fine
;
h=fltarr(11,11)
for i=-5, 5 do $
begin
print, i
  for j=-5, 5 do $
   begin
     dist=compdist(ff,[5.*xy[0]+i,5.*xy[1]+j])
     h[i+5,j+5]=max(histogram(dist))
   endfor
 endfor
 a=max(h,i)
 xy0=xy+([-5.,-5]+xy_from_ind(11,11,i))/5.
 plots, xy0[0]/100., xy0[1]/100., color='ff0000'xl, /normal, psym=2


  ad=oadetector->get_object()
  ad.beamx=xy0[0]/100.*npixx
  ad.beamy=xy0[1]/100.*npixy
  oadetector->set_object, ad



;;                  beam center is x0 in normal coordinates

;;--------  classify selected points into individual rings


   dist=compdist(ff,xy0*5.)
   h=histogram(dist, LOCATIONS=hl, binsize=1.)

;--- shappening the histogram above the cut

   h1=h
   nh=n_elements(h)


   while max(h1) gt cut do $
   begin
     m=max(h1,i)
     h1[i]=0
     if i gt 0 and i lt nh-1 then $
     begin
      j=i-1
      while j ge 0 do $
      begin
      if h1[j] gt cut/2. then $
      begin
         h[i]=h[i]+h[j]
         h[j] =0
         h1[j] =0
      endif else j=0
      j=j-1
      endwhile
      j=i+1
      while j le nh-1 do $
      begin
      if h1[j] gt cut/2. then $
        begin
         h[i]=h[i]+h[j]
         h[j] =0
         h1[j] =0
        endif else j=nh-1
        j=j+1
      endwhile
     endif
   endwhile

   fh=where(h gt cut) ; select rings with # ponits gt 50
   ; hl[fh] is a list of distances (radiuses) corresponding to each ring

   nb=n_elements(fh) ; number of different rings with sufficient number of points
   rings=lonarr(nn)

   for i=0, nn-1 do $ ; numbers all points selected
   begin
     c=abs(dist[i]-hl[fh])
     ri=min(c,kk)
     if ri lt dist_tol then rings[i]=kk else rings[i]=-1 ; rings is a table that tells which ring each point belongs to
   end


   nr=lonarr(nb)
   ds=fltarr(nb)
   for k=0, nb-1 do $
   begin
     r=where(rings eq k) ; select points belonging to ring ll
     nr[k]=n_elements(r)     ; number of point currently in this ring
   endfor

   print, 'Classes done'
   print, ''


   wset, draw0
   device, decomposed=1

   m=max(nr)
   rgx=fltarr(nb,m) ; x normal coordinates of points
   rgy=fltarr(nb,m); y normal coordinates of points


   for k=0, nb-1 do $
   begin
     r=where(rings eq k)
     ds[k]=mean(dist[r])*npixx/500*psize ; these are ring mean radiuses
     ;>>>>>>>>>>>>>> this may need to be modified for nonsquare detectors
     xya=xy_from_ind(500,500,ff[r])
     rgx[k,0:nr[k]-1]=xya[*,0]
     rgy[k,0:nr[k]-1]=xya[*,1]
     plots, rgx[k,0:nr[k]-1]/500., rgy[k,0:nr[k]-1]/500., color='f0000F'xl, /normal, psym=1
   endfor






;------ refine detector distance alone


  step=(end_dist-start_dist)/1000.

  ddists=fltarr(1000,2)
  for i=0, 999 do $
  begin
    ddists[i,0]=start_dist+i*step
    ddists[i,1]=sum_closest_refs(ds, start_dist+i*step)
  end
  aa=min(ddists[*,1], ll)
  dst=ddists[ll,0]
  print, 'Estimated detector distance: ', dst

  start_dist=dst-step*5.
  end_dist  =dst+step*5.
  step=(end_dist-start_dist)/1000.

  for i=0, 999 do $
  begin
    ddists[i,0]=start_dist+i*step
    ddists[i,1]=sum_closest_refs(ds, start_dist+i*step)
  end
  aa=min(ddists[*,1], ll)
  dst=ddists[ll,0]
  print, 'Estimated detector distance: ', dst


  ad=oadetector->get_object()
  ad.dist=dst
  oadetector->set_object, ad


  ;-- use only peaks that match standard and are unique
  cr=fltarr(nb,2)
  for i=0,nb-1 do $
  begin
    cr[i,0]=closest_ref(ds[i], dst)
    cr[i,1]=closest_ref_d(ds[i], dst)
  endfor

  rrr=0
  X=rgx[rrr,0:nr[rrr]-1]*npixx/500.
  Y=rgy[rrr,0:nr[rrr]-1]*npixy/500.

  Z=fltarr(nr[rrr])
  dspcc=replicate(cr[rrr,1],nr[rrr])
  tths=fltarr(nr[rrr])
  nus=fltarr(nr[rrr])
  for i=0, nr[rrr]-1 do tths[i]=tth_from_en_and_d(en, dspcc[i])
  device, decomposed=0
end

;=====================================================================

pro detector_calibration_refinemnt,esd
esd=fltarr(9)
@COMMON_DATAS
@WID_GSE_ADA_COMMON
COMMON image_type_and_arrays, imt, arr1, arr2,cenx, ceny, rad, rad1
common selections, selecting_status, select, excl, unselect, addpeak, mask, maskarr, zoom, unmask
COMMON CAL_ref, tths, nus ; calculated d for each position

; compress image for fast search to 500x500 pixels

a0=systime(/seconds)
;---- parametrs -----
en=a_to_kev(wv)
cut=50       ; minimum number of points along a ring required
dist_tol=1.2 ; toerance for difference in radius between the given point and ring mean
Sig_to_noise=cal_IovS()

ad=oadetector->get_object()
;---- from detector calibration
npixx=arr1
npixy=arr2
psize=ad.psizex
start_dist=ad.dist-ad.dist*0.1
end_dist  =ad.dist+ad.dist*0.1

im=oimage->get_object()
ii=congrid(im.img[0:arr1-1,0:arr2-1]*maskarr, 500,500)
bg=local_background(ii)
;;--------------- ring analysis ------------------
;;-------- select points above 5 sigma

;**** it would be much better to use local background than global median

;median1=median(ii[where(ii gt 0)])
;ff=where(ii gt median1*3.)
ff=where(ii/bg gt Sig_to_noise[0] and ii gt 20.)
nn=n_elements(ff)


;;-------- plot selected points
wset, draw0
device, decomposed=1

for i=0L, nn-1 do $
begin
  xy=xy_from_ind(500,500,ff[i])
  plots, xy[0]/500., xy[1]/500., color='ff00FF'xl, /normal, psym=1
end


; xy are normal coordinates of the selected points
; ff[i] are sequence coordinates of the selected points in 500x500 mtx
;

;;-------- equal proximity search coarse

; goes in 5 pixel steps
h=fltarr(100,100)
for i=0, 499, 5 do $
begin
  for j=0, 499,5 do $
   begin
     dist=compdist(ff,[i,j])
     h[i/5,j/5]=max(histogram(dist))
   endfor
 endfor
 a=max(h,i)

 xy=xy_from_ind(100,100,i)
 plots, xy[0]/100., xy[1]/100., color='00ff00'xl, /normal, psym=2
 dist=compdist(ff,xy*5.)
 h=histogram(dist, LOCATIONS=hl, binsize=1.)

;;-------- equal proximity search fine
;
h=fltarr(11,11)
for i=-5, 5 do $
begin
print, i
  for j=-5, 5 do $
   begin
     dist=compdist(ff,[5.*xy[0]+i,5.*xy[1]+j])
     h[i+5,j+5]=max(histogram(dist))
   endfor
 endfor
 a=max(h,i)
 xy0=xy+([-5.,-5]+xy_from_ind(11,11,i))/5.
 plots, xy0[0]/100., xy0[1]/100., color='ff0000'xl, /normal, psym=2


  ad=oadetector->get_object()
  ad.beamx=xy0[0]/100.*npixx
  ad.beamy=xy0[1]/100.*npixy
  oadetector->set_object, ad



;;                  beam center is x0 in normal coordinates

;;--------  classify selected points into individual rings


   dist=compdist(ff,xy0*5.)
   h=histogram(dist, LOCATIONS=hl, binsize=1.)

;--- shappening the histogram above the cut

   h1=h
   nh=n_elements(h)


   while max(h1) gt cut do $
   begin
     m=max(h1,i)
     h1[i]=0
     if i gt 0 and i lt nh-1 then $
     begin
      j=i-1
      while j ge 0 do $
      begin
      if h1[j] gt cut/2. then $
      begin
         h[i]=h[i]+h[j]
         h[j] =0
         h1[j] =0
      endif else j=0
      j=j-1
      endwhile
      j=i+1
      while j le nh-1 do $
      begin
      if h1[j] gt cut/2. then $
        begin
         h[i]=h[i]+h[j]
         h[j] =0
         h1[j] =0
        endif else j=nh-1
        j=j+1
      endwhile
     endif
   endwhile

   fh=where(h gt cut) ; select rings with # ponits gt 50
   ; hl[fh] is a list of distances (radiuses) corresponding to each ring

   nb=n_elements(fh) ; number of different rings with sufficient number of points
   rings=lonarr(nn)

   for i=0, nn-1 do $ ; numbers all points selected
   begin
     c=abs(dist[i]-hl[fh])
     ri=min(c,kk)
     if ri lt dist_tol then rings[i]=kk else rings[i]=-1 ; rings is a table that tells which ring each point belongs to
   end


   nr=lonarr(nb)
   ds=fltarr(nb)
   for k=0, nb-1 do $
   begin
     r=where(rings eq k) ; select points belonging to ring ll
     nr[k]=n_elements(r)     ; number of point currently in this ring
   endfor

   print, 'Classes done'
   print, ''


   wset, draw0
   device, decomposed=1

   m=max(nr)
   rgx=fltarr(nb,m) ; x normal coordinates of points
   rgy=fltarr(nb,m); y normal coordinates of points


   for k=0, nb-1 do $
   begin
     r=where(rings eq k)
     ds[k]=mean(dist[r])*npixx/500*psize ; these are ring mean radiuses
     ;>>>>>>>>>>>>>> this may need to be modified for nonsquare detectors
     xya=xy_from_ind(500,500,ff[r])
     rgx[k,0:nr[k]-1]=xya[*,0]
     rgy[k,0:nr[k]-1]=xya[*,1]
     plots, rgx[k,0:nr[k]-1]/500., rgy[k,0:nr[k]-1]/500., color='f0000F'xl, /normal, psym=1
   endfor






;------ refine detector distance alone


  step=(end_dist-start_dist)/1000.

  ddists=fltarr(1000,2)
  for i=0, 999 do $
  begin
    ddists[i,0]=start_dist+i*step
    ddists[i,1]=sum_closest_refs(ds, start_dist+i*step)
  end
  plot, ddists[*,0] , ddists[*,1]
  aa=min(ddists[*,1], ll)
  dst=ddists[ll,0]
  print, 'Estimated detector distance: ', dst

  start_dist=dst-step*5.
  end_dist  =dst+step*5.
  step=(end_dist-start_dist)/1000.

  for i=0, 999 do $
  begin
    ddists[i,0]=start_dist+i*step
    ddists[i,1]=sum_closest_refs(ds, start_dist+i*step)
  end
  plot, ddists[*,0] , ddists[*,1]
  aa=min(ddists[*,1], ll)
  dst=ddists[ll,0]
  print, 'Estimated detector distance: ', dst


  ad=oadetector->get_object()
  ad.dist=dst
  oadetector->set_object, ad

  omissions=intarr(nb)
  ;-- use only peaks that match standard and are unique
  cr=fltarr(nb,2)
  for i=0,nb-1 do $
  begin
    cr[i,0]=closest_ref(ds[i], dst)
    cr[i,1]=closest_ref_d(ds[i], dst)
    if cr[i,0] gt 0.2 then omissions[i]=1
  endfor
  print, 'individual ring radius errors:'
  print, cr[*,0]

  ;-------- have to protect from first ring being faulty

  rrr=0
  X=rgx[rrr,0:nr[rrr]-1]*npixx/500.
  Y=rgy[rrr,0:nr[rrr]-1]*npixy/500.

  Z=fltarr(nr[rrr])
  dspcc=replicate(cr[rrr,1],nr[rrr])
  tths=fltarr(nr[rrr])
  nus=fltarr(nr[rrr])
  for i=0, nr[rrr]-1 do tths[i]=tth_from_en_and_d(en, dspcc[i])

  for rrr=1, nb-1 do $
  begin
    if omissions[rrr] eq 0 then $
    begin
      pos=n_elements(X)
      X=[[X],[rgx[rrr,0:nr[rrr]-1]*npixx/500.]]
      Y=[[Y],[rgy[rrr,0:nr[rrr]-1]*npixx/500.]]
      dspcc=[[dspcc], replicate(cr[rrr,1],nr[rrr])]
      tt=fltarr(nr[rrr])
      nu=fltarr(nr[rrr])
      tths=[[tths],tt]
      nus=[[nus],nu]
  ;    pos=total(nr[0:rrr-1])
      for i=pos, pos+nr[rrr]-1 do $
      begin
        tths[i]=tth_from_en_and_d(en, dspcc[i])
        nus[i]=oadetector->get_nu_from_pix([X[i],Y[i]]) ; observed nu
      endfor
    endif
  endfor

 ;-- use hr coordinates for all peaks



  p=fltarr(6)
  p[0]=ad.dist
  p[1]=ad.beamx
  p[2]=ad.beamy
  p[3]=0.
  p[4]=0.
  p[5]=0.

  print, 'starting calibration refinement'
  parinfo = replicate({value:0.D, fixed:0, limited:[0,0], $
                       limits:[0.D,0]}, 6)
  NNN=n_elements(X)

  for i=0, NNN-1 do $
  begin

  if not(x[i] lt 5 or x[i] gt arr1-6 or $
         y[i] lt 5 or x[i] gt arr2-6) then  $
     begin
    if im.img[X[i],Y[i]] lt im.img[X[i]-1,Y[i]] then X[i]=X[i]-1
    if im.img[X[i],Y[i]] lt im.img[X[i]+1,Y[i]] then X[i]=X[i]+1
    if im.img[X[i],Y[i]] lt im.img[X[i],Y[i]-1] then Y[i]=Y[i]-1
    if im.img[X[i],Y[i]] lt im.img[X[i],Y[i]+1] then Y[i]=Y[i]+1

    if im.img[X[i],Y[i]] lt im.img[X[i]-1,Y[i]] then X[i]=X[i]-1
    if im.img[X[i],Y[i]] lt im.img[X[i]+1,Y[i]] then X[i]=X[i]+1
    if im.img[X[i],Y[i]] lt im.img[X[i],Y[i]-1] then Y[i]=Y[i]-1
    if im.img[X[i],Y[i]] lt im.img[X[i],Y[i]+1] then Y[i]=Y[i]+1

    if im.img[X[i],Y[i]] lt im.img[X[i]-1,Y[i]] then X[i]=X[i]-1
    if im.img[X[i],Y[i]] lt im.img[X[i]+1,Y[i]] then X[i]=X[i]+1
    if im.img[X[i],Y[i]] lt im.img[X[i],Y[i]-1] then Y[i]=Y[i]-1
    if im.img[X[i],Y[i]] lt im.img[X[i],Y[i]+1] then Y[i]=Y[i]+1
   endif

   if not(x[i] lt 5 or x[i] gt arr1-6 or $
         y[i] lt 5 or x[i] gt arr2-6) then  $
     begin

    ;m=max(im.img[X[i]-1:X[i]-1,Y[i]],ppp)
    ;X[i]=X[i]+ppp-1
    ;m=max(im.img[X[i],Y[i]-1:Y[i]+1],ppp)
    ;Y[i]=Y[i]+ppp-1
    xxx=indgen(11)-5
    a=fltarr(4)
    nus[i]=oadetector->get_nu_from_pix([X[i],Y[i]])
    if nus[i] gt 45. and nus[i] lt 135 then $ ;--- horizontal section
    begin
      sec=im.img[round(X[i]):round(X[i]),round(Y[i])-5:round(Y[i])+5]
      a[0]=max(sec)-min(sec)
      a[3]=min(sec)
      Result = GAUSSFIT(xxx , sec, a, nterms=4)
      if abs(a[1]) lt 2.0 then Y[i]=Y[i]+a[1]
    endif else $ ;----- vertical section
    begin
      sec=im.img[round(X[i])-5:round(X[i])+5,round(Y[i])]
      a[0]=max(sec)-min(sec)
      a[3]=min(sec)
      Result = GAUSSFIT(xxx , sec, a, nterms=4)
      if abs(a[1]) lt 2.0 then X[i]=X[i]+a[1]
    endelse

    ;if nus[i]

    endif
  end




  er=1.0/dspcc;REPLICATE(1.,NNN)
  Z =REPLICATE(0.,NNN)
  parinfo[*].value  = [P]
  if refine_twist() eq 0 then $
  begin
    p[3]=0
    parinfo[3].value=0
    parinfo[3].fixed  = 1
  endif else parinfo[3].fixed  = 0

  a1=systime(/seconds)
  A = MPFIT2DFUN('radius_differences', X, Y, Z, ER, PERROR=PE, BESTNORM=BN,parinfo=parinfo, ERRMSG=msg, QUIET=1)
  a2=systime(/seconds)
  Print, 'refinement time = ',a2-a1
  Print, 'total time = ',a2-a0
  if n_elements(pe) gt 0 then $
  begin
     DOF     = N_ELEMENTS(Z) - N_ELEMENTS(A) ; deg of freedom
     PCERROR = PE * SQRT(BN / DOF)*1.   ; scaled uncertainties
     print, A
     print, PCERROR
   endif
  esd=PCERROR
  print_calibration, oadetector, wv

  device, decomposed=0
  plot_image, oimage

  re=dialog_message('Calibration refinement complete')

  ;print, radius_differences(X, Y, P)
  ; only rings with at least cut number of points
  ; tolerance controlled by dist_tol
  ; rgx[i,*] - x normal coordinates of points along ring i
  ; rgy[i,*] - y normal coordinates of points along ring i
  ; nr[i]    - number of points along ring i


  ;**** need to do local integration and peak fitting to get best positions

  ;**** use azimuth angle - for nonorthog. detector the radius can be calculated from nu

  ;-- use only peaks that match standard and are unique


end

pro refine_whole_calibration
end