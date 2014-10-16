

;-------
; version 08/06/2014
'Fit all peaks':$
 begin
; added axis to distinguish between omega and phi scans
   axis=5
   cgProgressBar = Obj_New("CGPROGRESSBAR", /Cancel)
   cgProgressBar -> Start

   pt=opt->get_object()
   ad=oadetector->get_object()
   nnn=opt->peakno()-1
   lbcgr=oimage->calculate_local_background(0)

   for pn=nnn, 0, -1 do $
   begin

             IF cgProgressBar -> CheckCancel() THEN BEGIN
                ok = Dialog_Message('Operation canceled')
                cgProgressBar -> Destroy
                RETURN
             ENDIF
             cgProgressBar -> Update, (float(nnn-pn)/nnn)*100.0


     re=fit_one_peak_PD(pn, lbcgr)
     pt=opt->get_object()
     XY=pt.peaks[pn].DetXY
     if re[0] ne 0 then $
     begin
       opt->select_peak, pn
     endif else $
     begin
       n=n_elements(re)-1
       A=re[1:n/2]
       PCERROR=re[n/2+1:n]
       pt.peaks[pn].DetXY[0]= XY[0]+a[5]
       pt.peaks[pn].DetXY[1]= XY[1]+a[6]
       gonio=pt.peaks[pn].gonio
       kt=read_kappa_and_ttheta()
       gonio[1]=kt[1]
       xyz=oadetector->calculate_XYZ_from_pixels_mono(pt.peaks[pn].DetXY, gonio, wv)
     ;------------
       sd=oadetector->calculate_sd_from_pixels(pt.peaks[pn].DetXY, gonio)
       nu=ang_between_vecs([0.0,sd[1],sd[2]],[0.,-1.,0.])
       nu1=oadetector->get_nu_from_pix(pt.peaks[pn].DetXY)
       ;print, nu, nu1
       tth=get_tth_from_xyz(pt.peaks[pn].xyz)
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
       ii=II/dac_profile(pt.peaks[pn].gonio[axis]+om0,1)
       si=sI/dac_profile(pt.peaks[pn].gonio[axis]+om0,1)
      end

    ;-- omega polynomial correction
       aom=omega_correction(pt.peaks[pn].gonio[axis])
       ii=II*aom
       si=sI*aom

       pt.peaks[pn].energies[2]=A[2] ; width 2th
       pt.peaks[pn].energies[3]=A[3] ; width chi
       pt.peaks[pn].energies[4]=A[4] ; tilt
       pt.peaks[pn].energies[5]=A[0] ; background

       pt.peaks[pn].intAD[0]=ii
       pt.peaks[pn].intAD[1]=si
       opt->set_object, pt
   endelse
  nex:
   endfor
   ; check for improper peak
   for i=pt.peakno[0]-1, 0, -1 do if pt.peaks[i].intAD[1] lt 0 or $
                                  pt.peaks[i].DetXY[0] lt 0 or $
                                  pt.peaks[i].DetXY[0] gt arr1 or $
                                  pt.peaks[i].DetXY[1] lt 0 or $
                                  pt.peaks[i].DetXY[1] gt arr2 then $
   begin
     opt->delete_peak, i[0]
   endif
   pt=opt->get_object()
   opt->calculate_all_xyz_from_pix, oadetector, wv
   print_peak_list, opt, wid_list_3
   plot_image, oimage
   plot_peaks, draw0, opt, arr1, arr2
   update_peakno, opt->peakno()
   print_R_int, Rint(get_laue_class(), opt)
   cgProgressBar -> Destroy
   re=dialog_message('Peak profile refinement complete')
 end
;-------


pro peaksearch_CLASS::execute1, oimage, oad, excl, butt

  COMMON Widget_Image_elements, $
    WID_DRAW_0, $
    WID_BASE_1, $
    WID_BASE_2, $
    WID_BASE_3, $
    WID_BUTTON_F_Open, $
    WID_BUTTON_F_previous, $
    WID_BUTTON_f_next, $
    WID_BUTTON_F_scans, $
    WID_BUTTON_f_close  , $
    WID_BUTTON_s_colors, $
    WID_BUTTON_s_ccd, $
    WID_TEXT_peak_sp1, $
    WID_TEXT_peak_sp2, $
    WID_TEXT_peak_sp3, $
    WID_TEXT_peak_sp4, $
    WID_TEXT_peak_peakno, $
    WID_BUTTON_peak_search, $
    WID_BUTTON_peaks_plotpeaks, $
    WID_BUTTON_peaks_OLAcurves, $
    WID_BUTTON_peaks_selectpeak, $
    WID_TAB_s_colors, $
    WID_BUTTON_peaksloadpt, $
    WID_BUTTON_peakssavept, $
    WID_BUTTON_peaksclearpt, $
    WID_TEXT_output


thresh = self.threshold
x1     = self.bbox
x2     = self.pbox
x3     = self.mindist

COMMON CLASS_peaktable_reference, ref_peaktable, ref_peak

COMMON ad_image_CLASS_Reference, adimage
COMMON EX, EXCLUSIONS

adimage=oimage->get_object()
topX=long(oimage.sts.adet.nopixx/oimage.sts.binning)-1
topY=long(oimage.sts.adet.nopixy/oimage.sts.binning)-1
image1=adimage.img[0:topX,0:topY]
image=congrid(image1, 1000,1000)
px=float(topX/1000.0)
py=float(topy/1000.0)

pt=obj_new('CLASS_peaktable')
pt->set_object, self.peaktable
pt->initialize
ptc=pt->get_object()

box=intarr(x1*2+1,x1*2+1)
bcgU=intarr(2*x1+1)
bcgD=intarr(2*x1+1)
bcgL=intarr(2*x1+1)
bcgR=intarr(2*x1+1)

imsize=size(image)


          cgProgressBar = Obj_New("CGPROGRESSBAR", /Cancel)
          cgProgressBar -> Start

COMMON progress_edit, progs

   grad=1.5
   non0=where(image[*,*] ne 0)
   med=median(image[non0])
   print, med
   maxint=80000
   minint=med-20

for i=x1, imsize[1]-x1-1 do begin
  ;widget_control, progs, set_value=string(long(100.0*i/(imsize[1]-20.0)))+' %'
  ;print, string(float(i/(imsize[1]-20.0))*100.0)+'.0 %'

             IF cgProgressBar -> CheckCancel() THEN BEGIN
                ok = Dialog_Message('The user cancelled operation.')
                cgProgressBar -> Destroy
                RETURN
             ENDIF
;             cgProgressBar -> Update, float(i/imsize[1]-x1-1)*100.0
  for j=x1, imsize[2]-x1-1 do BEGIN
   if use_exclusions(butt) eq 1 then $
   IF  EXCLUS(I*PX,J*PY, OAD) EQ 1  THEN $
   BEGIN
     goto, end2
   ENDIF
   if (ptc.peakno ge 1000) then goto, end3
   box=image[i-x2:i+x2,j-x2:j+x2]
   inten=total(box)/((2*x2+1)*(2*x2+1))
   box2=image[i-x1:i+x1,j-x1:j+x1]
   bcg=(total(box2)-total(box))/((2*x1+1)*(2*x1+1)-((2*x2+1)*(2*x2+1)))
   if image[i,j] gt minint and inten gt bcg*thresh  and inten lt maxint and $
      image[i,j] gt grad*image[i-x2,j] and $
      image[i,j] gt grad*image[i+x2,j] and $
      image[i,j] gt grad*image[i,j-x2] and $
      image[i,j] gt grad*image[i,j+x2] $
       then begin ; peak found
                ; Check if peak already in peaktable
                found=0
                index=0
                while (found eq 0) and (index le ptc.peakno-1) do $
                begin
                   index=index+1
                   if (abs(ptc.peaks[index].DetXY[0]-px*FIX(i)) lt x3) and (abs(ptc.peaks[index].DetXY[1]-py*FIX(j)) lt x3) then $
                   begin
                      found=1
                      ; Check if the new one is stronger
                      if (ptc.peaks[index].IntAD[0] lt image[i,j]) then $
                      begin
                        ; stronger
                        ref_peak.DetXY=[px*FIX(i),py*FIX(j)]
                        ref_peak.IntAD[0]=inten
                        ref_peak.gonio=adimage.sts.gonio
                        ref_peak.Selected[1]=1
                        ref_peak.Selected[0]=0
                        pt->Replacepeak,index,ref_peak
                        ptc=pt->get_object()
                      endif
                   endif
                endwhile
                if found eq 0 then $
                begin

                   npx=1000
                   npy=1000

                   ; need to check the radius here
                   x=FIX(i)-npx/2.0
                   y=FIX(j)-npy/2.0
                   r=sqrt(x*x+y*y)
                   if r lt npx/2.0-10.0 then $
                   begin
                   ref_peak.DetXY=[px*FIX(i),py*FIX(j)]
                   ref_peak.IntAD[0]=inten
                   ref_peak.gonio=adimage.sts.gonio
                   ref_peak.Selected[1]=1
                   ref_peak.Selected[0]=0
                   pt->Appendpeak, ref_peak
                   ptc=pt->get_object()
        ;           print, ref_peak.DetXY
                   endif
                endif
      endif
      end2:
  endfor
  cgProgressBar -> Update, float(i-x1)/float(imsize[1]-2.*x1-1)*100.0
  ;update_progress, float(i-x1)/float(imsize[1]-2.*x1-1)
endfor
end3:
pt->set_object, ptc
self.peaktable=ptc
cgProgressBar -> Destroy
obj_destroy, pt

end



;---------------------------------------------------------------
;---------------------------------------------------------

pro peaksearch_CLASS::execute1, oimage, oad, excl, butt

  COMMON Widget_Image_elements, $
    WID_DRAW_0, $
    WID_BASE_1, $
    WID_BASE_2, $
    WID_BASE_3, $
    WID_BUTTON_F_Open, $
    WID_BUTTON_F_previous, $
    WID_BUTTON_f_next, $
    WID_BUTTON_F_scans, $
    WID_BUTTON_f_close  , $
    WID_BUTTON_s_colors, $
    WID_BUTTON_s_ccd, $
    WID_TEXT_peak_sp1, $
    WID_TEXT_peak_sp2, $
    WID_TEXT_peak_sp3, $
    WID_TEXT_peak_sp4, $
    WID_TEXT_peak_peakno, $
    WID_BUTTON_peak_search, $
    WID_BUTTON_peaks_plotpeaks, $
    WID_BUTTON_peaks_OLAcurves, $
    WID_BUTTON_peaks_selectpeak, $
    WID_TAB_s_colors, $
    WID_BUTTON_peaksloadpt, $
    WID_BUTTON_peakssavept, $
    WID_BUTTON_peaksclearpt, $
    WID_TEXT_output


thresh = self.threshold
x1     = self.bbox
x2     = self.pbox
x3     = self.mindist

COMMON CLASS_peaktable_reference, ref_peaktable, ref_peak

COMMON ad_image_CLASS_Reference, adimage
COMMON EX, EXCLUSIONS
COMMON image_type_and_arrays, imt, arr1, arr2,cenx, ceny, rad, rad1

adimage=oimage->get_object()
lbcg=oimage->calculate_local_background(0)
image1=congrid(adimage.img, 1000,1000)
lbcg1=congrid(lbcg, 1000,1000)

t0=systime(/seconds)

i0=image1[1:999-1,1:999-1]
i1=image1[0:999-2,1:999-1]
i2=image1[2:999-0,1:999-1]
i3=image1[1:999-1,0:999-2]
i4=image1[0:999-2,0:999-2]
i5=image1[2:999-0,0:999-2]
i6=image1[1:999-1,2:999-0]
i7=image1[0:999-2,2:999-0]
i8=image1[2:999-0,2:999-0]

w=where(i0-lbcg1[1:999-1,1:999-1] gt 100 and i0 lt 50000)

print, n_elements(w), ' peaks found'
if w[0] ne -1 then $
begin
a1=(i0[w]-i1[w])
a2=(i0[w]-i2[w])
a3=(i0[w]-i3[w])
a4=(i0[w]-i4[w])
a5=(i0[w]-i5[w])
a6=(i0[w]-i6[w])
a7=(i0[w]-i7[w])
a8=(i0[w]-i8[w])
b=a1<a2<a3<a6<a5<a4<a7<a8
w1=where(b gt i0[w]*0.05)



t1=systime(/seconds)
print, 'time = ', t1-t0
print, n_elements(w1), ' peaks found'


pt=obj_new('CLASS_peaktable')
pt->set_object, self.peaktable
pt->initialize
ptc=pt->get_object()

imsize=size(image)


if w1[0] ne -1 then $
begin

 ys= w[w1]/998
 xs= w[w1]-(ys)*998

 for i=0L, min([n_elements(w1)-1,9999]) do $
 begin
  ref_peak.DetXY=[xs[i]/998.*arr1,ys[i]/998.*arr2]
                   ref_peak.IntAD[0]=adimage.img[ref_peak.DetXY[0],ref_peak.DetXY[1]]
                   ref_peak.gonio=adimage.sts.gonio
                   ref_peak.Selected[1]=0
                   ref_peak.Selected[0]=0
                   pt->Appendpeak, ref_peak
                   ptc=pt->get_object()

end

pt->set_object, ptc
self.peaktable=ptc
obj_destroy, pt
end
endif
end




 'Integrate chi':$
 begin
   capture_calibration, oadetector, wv
   npoints=1500
   time0= SYSTIME(/SECONDS)
   tthimg=oimage->create_tth_array(oadetector,[3.,20.], 1500)
   time1= SYSTIME(/SECONDS)
   print, 'Computation time: ', (time1-time0)
   spc=oimage->integrate2(oadetector, [3.,20.], 1500, tthimg)
   time2= SYSTIME(/SECONDS)
   print, 'Computation time: ', (time2-time1)
   goto, il
   npo=0
   tthmax=0.
   binarr_tth=oadetector->create_tth_bin_array(2048, npotth, tthmax)
   binarr_chi=oadetector->create_chi_bin_array(2048, npochi, chimax)
   free_lun, 2
   openw, 2, 'c:\binarr_tth.bin'
   A=assoc(2, binarr_tth)
   A[0]=binarr_tth
   close, 2
   openw, 2, 'c:\binarr_chi.bin'
   A=assoc(2, binarr_chi)
   A[0]=binarr_chi
   close, 2
   openw, 2, 'c:\npo_tth.bin'
   A=assoc(2, npotth)
   A[0]=npotth
   close, 2
   openw, 2, 'c:\npo_chi.bin'
   A=assoc(2, npochi)
   A[0]=npochi
   close, 2
   npoints=500
   spc=oimage->integrate_chi(oadetector, npoints, [-180.,180.],[9.5,10.5])
   il:
   wset, wid_draw_6
   plot, spc[0:npoints-1,0], spc[0:npoints-1,1]
   free_lun, 2
   openw, 2, 'c:\tth.chi'
   for i=0, 5 do printf, 2, ''
   for i=0, npoints-1 do printf, 2, spc[i,0], spc[i,1]
   close, 2
 end
;-------------------------------------------------


pro CLASS_peak::put_onepeak3_into_peak, onepeak3

                self.Stat     = onepeak3.Stat
                self.HKL      = onepeak3.HKL
                self.XYZ      = onepeak3.XYZ
                self.selected = onepeak3.selected
                self.DetXY    = onepeak3.DetXY
                self.Gonio    = onepeak3.Gonio
                self.GonioSS  = onepeak3.GonioSS
                self.nen      = onepeak3.nen
                self.energies = onepeak3.energies
                self.IntAD    = onepeak3.IntAD
                self.position = onepeak3.position
                self.IntSSD   = onepeak3.IntSSD

end


;-------------------------------------------------
function opt_omega, P
common args, xyz, xyz0
common Rota, Mtx

 GenerateR, 3, P
 OM=mtx
 xyz1=OM ## xyz
 return, vlength(xyz1-xyz0)
end

;-----------------------------------------------------

pro CLASS_peaktable_definition

COMMON CLASS_peaktable_reference, ref_peaktable, ref_peak
COMMON CLASS_Area_detector_parameters_reference, ref_adp

CLASS_Area_detector_parameters

 ref_peak = {CLASS_peak, $
                Stat     : 0,           $   ; reflection status
                HKL      : INTARR(3),   $   ; Miller indices
                XYZ      : FLTARR (3),  $   ; coordinates of the reciprocal sp. vector
                selected : INTARR(2),   $   ; 0-selcted, 1-visible
                DetXY    : FLTARR(2),   $   ; area detector pixel coordinates
                Gonio    : FLTARR(6),   $   ; goniometer settings for the Area detector
                GonioSS  : FLTARR(6),   $   ; setting angles for solid state detector
                nen      : 0,           $   ; number of different energy components
                energies : FLTARR(10),  $   ; energies
                IntAD    : FLTARR(2),   $   ; Intensity from area detector with e.s.d
                position : FLTARR(3),   $   ; Intensity from area detector with e.s.d
                IntSSD   : FLTARR(2),   $   ;
                ; rota   : 0L, $            ; rotation axis
                ; rota_range   : 0L, $      ; rotation range
                ; image_name  : '', $       ; name of the image
                Adp      : ref_adp}         ; Area detector parameters

 ref_peaktable={CLASS_peaktable, $
                 peakno : 0L,$
                 selectedno : 0L,$
                 peaks : REPLICATE(ref_peak, 10000)}

end


;------------------------------------------------------------------

function detector_edge, pix

; P.Dera, 04/05/2006
;
; checks is a given pixel is at the edge of the active area of detector
; size of the edge is now set to 3.0 pixels
; arguments: pix - pixel coordinates

  cen=[1024.0,1024.0]
  vec=pix - cen
  rad=sqrt(vec[0]*vec[0]+vec[1]*vec[1])
  if abs(rad-1024.0) lt 10.0 or rad gt 1014 then edge=1 else edge=0
  return, edge
end



;------------------------------------------------------------------

function same_side_of_the_beam, pix, pix0
; P.Dera, 05/25/06
; checks is pix is on the same side of the beam center as pix0

   common odet, oadetector
   ad=oadetector->get_object()

   cen=[ad.beamx,ad.beamy]

   d1=pix-cen
   d2=pix0-cen
   if sign(d1[0]) eq sign(d2[0]) and sign(d1[1]) eq sign(d2[1]) then res=1 else res=0

   return, res
end

;------------------------------------------------------------------

function beam_stop, pix

; P.Dera, 04/05/2006
;
; checks is a given pixel is in the region obscured by the beamstop
; uses oadetector through common block
; radius of the obscured region is now set to 50.0 pixels
; arguments: pix - piuxel coordinates


  common odet, oadetector
  ad=oadetector->get_object()

  cen=[ad.beamx,ad.beamy]
  vec=pix - cen
  rad=sqrt(vec[0]*vec[0]+vec[1]*vec[1])
  if rad lt 200.0 then edge=1 else edge=0
  return, edge
end


;-------------------------------------------------------------------

;---------------------------------------------------------------------


FUNCTION measure_OLA_curve, pn, nsteps, omv, chv, points

; This function resizes the result to the required size.


COMMON adetector, oimage
COMMON peaktable_objects, optable1,optable2, optable3, optable0

common odet, oadetector
common Rota, Mtx

; pn - peak number
         points=fltarr(nsteps,2)

         adimage=oimage->get_object()

         xp=long(adimage.sts.adet.nopixx/adimage.sts.binning)
         yp=long(adimage.sts.adet.nopixy/adimage.sts.binning)

         pt=optable1->get_object()

         dX=pt.peaks[long(pn)].detxy[0]
         dY=pt.peaks[long(pn)].detxy[1]

         GONIO=[0.0,0.0,0.0,0.0,0.0,0.0]
         XYZ=oadetector->calculate_XYZ_from_pixels(DX, DY, gonio)

         ; omv and chv are vectors, containing the start and range
         ; added third field = zero offset

         pxy=[dx, dy]
         om=omv[0]
         ch=chv[0]

         al=omv[1]
         be=chv[1]


         data=fltarr(nsteps, 33)


         pi=acos(-1.0)

         GenerateR, 2, float(chv[2])
         Mchiy=Mtx
         iMchiy=invert(Mtx)

         omega=float(om)+omv[2]
         GenerateR, 3, -omega
         Rom=Mtx
         iRom=invert(Mtx)


         GenerateR, 3, -omv[2]
         Rom0=Mtx
         idRom0=invert(Mtx)

         chi=float(ch)
         GenerateR, 1, float(ch)
         Rch=Mtx
         iRch=invert(Mtx)

          XYZ1=idRom0##Rom##Mchiy##Rch##iMchiy##XYZ
          XYZ=XYZ1


         for i=0,nsteps-1 do $
         begin

          if i gt 0 then $
          begin

           omega=omega+al/float(nsteps)
           GenerateR, 3, -omega
           Rom=Mtx
           iRom=invert(Mtx)

           GenerateR, 3, -al/float(nsteps)
           dRom=Mtx

           chi=chi+be/float(nsteps)
           GenerateR, 1, be/float(nsteps)

           XYZ1=dRom##Rom##Mchiy##Mtx##iMchiy##iRom##XYZ

          end


          data[i,0]=omega
          data[i,32]=chi

          data[i,2]=2.0*calculate_theta_from_xyz(xyz1)

          GONIO=[0.0,0.0,0.0,0.0,0.0,0.0]
          DXYZ=oadetector->calculate_pixels_from_xyz(XYZ1, gonio)

          XYZ=XYZ1
          points[i,0]=DXYZ[0]
          points[i,1]=DXYZ[1]

          x=fltarr(21)
          for t=0, 20 do x[t]=float(t)
          y=fltarr(21)

          if not (DXYZ[0] lt 0 or DXYZ[0] gt 2047 or DXYZ[1]-10 lt 0 or DXYZ[1]+10 gt 2047) then $
          begin



           ; have to prevent sampling beyond the edge
           an=vert_horiz(DXYZ)
           minn=0
           maxx=20

           if an eq 1 then $
             if DXYZ[1] lt 10 then minn=DXYZ[1] else $
             if DXYZ[1] gt adimage.sts.adet.nopixy-11 then maxx=long(10+adimage.sts.adet.nopixy-DXYZ[1])
           if an eq 0 then $
             if DXYZ[0] lt 10 then minn=DXYZ[0] else $
             if DXYZ[0] gt adimage.sts.adet.nopixx-11 then maxx=long(10+adimage.sts.adet.nopixx-DXYZ[0])

           if an eq 1 then $
           for rr=minn,maxx do y[rr]=adimage.img[DXYZ[0],DXYZ[1]-10+rr] else $
           for rr=minn,maxx do y[rr]=adimage.img[DXYZ[0]-10+rr,DXYZ[1]]
           if min(y) eq 0 then y=deblind(y)

           yfit = GAUSSFIT(x, y, coeff, NTERMS=5)
           if minn eq 0 and maxx eq 20 then bcg=(total(y[0:4])+total(y[16:20]))/10.0
           if abs((max(y)-min(y))*sqrt(2*pi)-coeff[0]*coeff[2]*sqrt(2*pi))/((max(y)-min(y))*sqrt(2*pi)) lt 5.0 then $
           data[i,1]=coeff[0]*coeff[2]*sqrt(2*pi) else $
           data[i,1]=(max(y)-min(y))*sqrt(2*pi)

           data[i,3]=coeff[0]
           data[i,4]=coeff[1]
           data[i,5]=coeff[2]
           data[i,6]=coeff[3]
           data[i,7]=coeff[4]



           data[i,8]=max(y,kk)
           data[i,9]=min(y)
           data[i,10]=kk
           data[i,11:31]=y

         ; Definition of the array that stores the OLA-curve data
         ;
         ; 0     - omega angle
         ;32     - chi angle
         ; 1     - Intensity from Gauss tif
         ; 2     - 2theta Bragg angle
         ; 3     - Gaussian max intensity
         ; 4     - Gaussian FWHM
         ; 5     - Gaussian
         ; 6     - Gaussian
         ; 7     - Gaussian
         ; 8     - max I
         ; 9     - min I
         ; 10    - max center
         ; 11:31 - data

           pxy=[dxyz[0], dxyz[1]]
          endif else data[i,1]=0 ; peak outside of detector
         endfor
         despike, data[0:nsteps-1,1], 3
         despike, data[0:nsteps-1,3], 3
         despike, data[0:nsteps-1,4], 3
         despike, data[0:nsteps-1,5], 3
         despike, data[0:nsteps-1,6], 3
         despike, data[0:nsteps-1,7], 3
         return, data

       END





;------------------------------------------

function vert_horiz, pix
common odet, oadetector
; 1 - scan horiz
; 0 - scan vert

ad=oadetector->get_object()
cen=[ad.beamx,ad.beamy]
pix_r=pix-cen
if abs(pix_r[0]) gt abs(pix_r[1]) then an=1 else an=0
return, an

end

;-----------------------------------------


pro despike, y, th
  sz=size(y)
  sz=sz[1]
  for i=1, sz-2 do $
  if abs(y[i]/y[i-1]) gt th and abs(y[i]/y[i+1]) gt th then y[i]=(y[i-1]+y[i+1])/2.0
end

;-----------------------------------------

function deblind, y
siz=size(y)

for i=1, siz[1]-2 do $
if y[i] eq 0 then $
begin
  j=i+1
  while y[j] eq 0 and j le siz[1]-2 do j=j+1
  if j le siz[1]-1 and y[j] ne 0 then y[i]=y[j] else y[i]=y[i-1]
endif
if y[siz[1]-1] eq 0 then y[siz[1]-1]=y[siz[1]-2]
return, y
end



pro obsolete
end