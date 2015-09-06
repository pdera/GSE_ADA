












; Last updated 03/24/05

;==============================================================

; pro adetector_class::visible_mask, mask, gonio, DACopening,wv
; function adetector_class::pixel_visible, XY, DACopening, XYZ_DAC
; function adetector_class::generate_one_peak, ubc, wv, pred, hkl

;==============================================================


;function read_kappa_and_ttheta
; return, [0.0,0.0]
;end



;==============================================================

;------------------------------------
pro adetector_class::visible_mask, mask, gonio, DACopening,wv
 common Rota, Mtx
 GenerateR, 3, gonio[3]
 XYZ_DAC=Mtx # [1.,0.,0.]

 for i=0, self.nopixx-1 do $
  for j=0, self.nopixy-1 do $
  begin
     if mask[i,j] eq 1 then $
      if self->pixel_visible([i,j], DACopening,  XYZ_DAC) eq 0 then mask[i,j]=0
  endfor
end

;------------------------------------
function adetector_class::pixel_visible, XY, DACopening, XYZ_DAC

 g=fltarr(6)
 Diffxyz=self->calculate_sd_from_pixels(XY, g)
 ang=ang_between_vecs(XYZ_DAC, Diffxyz)
 if abs(ang) le DACopening then return, 1 else return, 0

end
;------------------------------------
function adetector_class::generate_one_peak, ubc, wv, pred, hkl

 ; generates all peaks from crystal represented by orientation matrix UB
COMMON CLASS_peaktable_reference, ref_peaktable, ref_peak
 kt=read_kappa_and_ttheta()
 gonio=fltarr(6)
 gonio[1]=kt[1]
 gonio[4]=pred.chi
        ;hkl=[h,k,l]
        xyz=UBc ## hkl
        om=get_omega(A_to_kev(wv), xyz)
        ;om=get_omega_nonorthog(A_to_kev(wv), xyz, self.alpha)
        if om[0] ge pred.om_start and om[0] le pred.om_start+pred.om_range then $
        begin
          gonio[3]=om[0]
          pix=self->calculate_pixels_from_xyz(xyz, gonio)
          r=(pix-[self.beamx,self.beamy])
          r=sqrt(r[0]^2+r[1]^2)
          psi2=self->calculate_psi_angles(gonio, pix)
          if pix[0] gt 0 and pix[0] lt self.nopixx-1 then $
          begin
             ref_peak.detxy=pix
             ref_peak.gonio=gonio
             ref_peak.xyz=xyz
             ref_peak.hkl=hkl
          endif
        endif else if om[1] ge pred.om_start and om[1] le pred.om_start+pred.om_range then $
        begin
          gonio[3]=om[1]
          pix=self->calculate_pixels_from_xyz(xyz, gonio)
          r=(pix-[self.beamx,self.beamy])
          r=sqrt(r[0]^2+r[1]^2)
          psi2=self->calculate_psi_angles(gonio, pix)
          if pix[0] gt 0 and pix[0] lt self.nopixx-1  then $
          begin
             ref_peak.detxy=pix
             ref_peak.gonio=gonio
             ref_peak.xyz=xyz
             ref_peak.hkl=hkl
          endif
        endif
        return, ref_peak
end
;--------------------------------------------------------------------

;------------------------------------
pro adetector_class::generate_all_peaks, ub, optable, wv, pred, exti, DAC_open, box
 ; generates all peaks from crystal represented by orientation matrix UB
COMMON CLASS_peaktable_reference, ref_peaktable, ref_peak
 kt=read_kappa_and_ttheta()
 gonio=fltarr(6)
 gonio[1]=kt[1] ; 2theta/Del
 gonio[0]=kt[0] ; nu
; gonio[4]=pred.chi ; this should be kappa/chi

 a=read_box_change()
 ref_peak.intssd[0:1]=[a,a]

 for h=pred.h1, pred.h2 do $
 begin
   for k=pred.k1, pred.k2 do $
   begin
     for l=pred.l1, pred.l2 do $
     begin
        hkl=[h,k,l]
        if syst_extinction(exti, hkl) eq 1 then $
        begin
        xyz=UB ## hkl
        om=get_omega(A_to_kev(wv), xyz)

        if om[0]+360. ge pred.om_start and om[0]+360. le pred.om_start+pred.om_range then om[0]=om[0]+360.0
        if om[0]-360. ge pred.om_start and om[0]-360. le pred.om_start+pred.om_range then om[0]=om[0]-360.0

        if om[1]+360. ge pred.om_start and om[1]+360. le pred.om_start+pred.om_range then om[1]=om[1]+360.0
        if om[1]-360. ge pred.om_start and om[1]-360. le pred.om_start+pred.om_range then om[1]=om[1]-360.0

        ;om=get_omega_nonorthog(A_to_kev(wv), xyz, self.alpha)
        if om[0] ge pred.om_start and om[0] le pred.om_start+pred.om_range then $
        begin
          gonio[3]=om[0]
          pix=self->calculate_pixels_from_xyz(xyz, gonio)
          r=(pix-[self.beamx,self.beamy])
          r=sqrt(r[0]^2+r[1]^2)
          psi2=self->calculate_psi_angles(gonio, pix)
          if pix[0] gt 0 and pix[0] lt self.nopixx-1 and pix[1] gt 0 and pix[1] lt self.nopixy-1 and  (abs(psi2[1]) lt DAC_open) then $
          begin
             ref_peak.detxy=pix
             ref_peak.gonio=gonio
             ref_peak.xyz=xyz
             ref_peak.hkl=hkl
             ref_peak.intssd[0:1]=[box[0],box[0]]
             optable->appendpeak,ref_peak
          endif
        endif else if om[1] ge pred.om_start and om[1] le pred.om_start+pred.om_range then $
        begin
          gonio[3]=om[1]
          pix=self->calculate_pixels_from_xyz(xyz, gonio)
          r=(pix-[self.beamx,self.beamy])
          r=sqrt(r[0]^2+r[1]^2)
          psi2=self->calculate_psi_angles(gonio, pix)
          if pix[0] gt 0 and pix[0] lt self.nopixx-1 and (abs(psi2[1]) lt DAC_open) then $
          begin
             ref_peak.detxy=pix
             ref_peak.gonio=gonio
             ref_peak.xyz=xyz
             ref_peak.hkl=hkl
             ref_peak.intssd[0:1]=[box[0],box[0]]
             optable->appendpeak,ref_peak
          endif
        endif
        endif
     endfor
   endfor
 endfor


end
;--------------------------------------------------------------------

;------------------------------------
pro adetector_class::generate_all_peaks1, ub, optable, wv, pred, exti, DAC_open
 ; generates all peaks from crystal represented by orientation matrix UB
COMMON CLASS_peaktable_reference, ref_peaktable, ref_peak
common Rota, Mtx
 kt=read_kappa_and_ttheta()
 gonio=fltarr(6)
 gonio[1]=kt[1] ; 2theta
 gonio[4]=kt[0] ; this should be kappa/chi
 GenerateR, 1, kt[0]
 chi=mtx
 ichi=invert(mtx)
 for h=pred.h1, pred.h2 do $
 begin
   for k=pred.k1, pred.k2 do $
   begin
     for l=pred.l1, pred.l2 do $
     begin
        hkl=[h,k,l]
        if syst_extinction(exti, hkl) eq 1 then $
        begin
        xyz=ichi## UB ## hkl
       ; om=get_omega(A_to_kev(wv), xyz)
        om=solve_general_axis(A_to_kev(wv), xyz, gonio)
        ;om=get_omega_nonorthog(A_to_kev(wv), xyz, self.alpha)
        if om[0] ge pred.om_start and om[0] le pred.om_start+pred.om_range then $
        begin
		;print, om
        ;print, solve_general_axis(A_to_kev(wv), xyz)
        ;print, '------------'
          GenerateR, 3, om[0]
          omi=mtx
          iomi=invert(mtx)
          gonio[3]=om[0] ;------------- change axis here
          pix=self->calculate_pixels_from_xyz(xyz, gonio)
          r=(pix-[self.beamx,self.beamy])
          r=sqrt(r[0]^2+r[1]^2)
          psi2=self->calculate_psi_angles(gonio, pix)
          if pix[0] gt 0 and pix[0] lt self.nopixx-1 and  (abs(psi2[1]) lt DAC_open) then $
          begin
             ref_peak.detxy=pix
             ref_peak.gonio=gonio
             ref_peak.xyz=xyz
             ref_peak.hkl=hkl
             optable->appendpeak,ref_peak
          endif
        endif else if om[1] ge pred.om_start and om[1] le pred.om_start+pred.om_range then $
        begin
          gonio[3]=om[1] ;------------- change axis here
          pix=self->calculate_pixels_from_xyz(xyz, gonio)
          r=(pix-[self.beamx,self.beamy])
          r=sqrt(r[0]^2+r[1]^2)
          psi2=self->calculate_psi_angles(gonio, pix)
          if pix[0] gt 0 and pix[0] lt self.nopixx-1  and (abs(psi2[1]) lt DAC_open) then $
          begin
             ref_peak.detxy=pix
             ref_peak.gonio=gonio
             ref_peak.xyz=xyz
             ref_peak.hkl=hkl
             optable->appendpeak,ref_peak
          endif
        endif
        endif
     endfor
   endfor
 endfor


end
;--------------------------------------------------------------------

pro adetector_class::generate_peaks_laue, ub, optable, pred, en, exti, DAC_open
 ; generates all peaks from crystal represented by orientation matrix UB
COMMON CLASS_peaktable_reference, ref_peaktable, ref_peak

 gonio=fltarr(6)

 for h=pred.h1, pred.h2 do $
 begin
   for k=pred.k1, pred.k2 do $
   begin
     for l=pred.l1, pred.l2 do $
     begin
        if not (h eq 0 and k eq 0 and l eq 0) then $
        begin
        hkl=[h,k,l]
        if syst_extinction(exti, hkl) eq 1 then $
        begin
        xyz=UB ## hkl
        if vlength(xyz) ne 0 then $
        begin
        Ene=en_from_xyz(xyz)
        ;om=get_omega(A_to_kev(wv), xyz)
        if ene ge en[0] and  ene le en[1] then $
        begin
          pix=self->calculate_pixels_from_xyz(xyz, gonio)
          r=(pix-[self.beamx,self.beamy])
          r=sqrt(r[0]^2+r[1]^2)

          psi2=self->calculate_psi_angles(gonio, pix)
          if pix[0] gt 0 and pix[0] lt self.nopixx-1 and $
             pix[1] gt 0 and pix[1] lt self.nopixy-1 and $
              (abs(psi2[1]) lt DAC_open) then $
          begin
             ;print, hkl, ene, pix
             ref_peak.detxy=pix
             ref_peak.gonio=gonio
             ref_peak.xyz=xyz
             ref_peak.energies[0]=ene
             ref_peak.hkl=hkl
             optable->appendpeak,ref_peak
          endif
          endif
        endif
        endif
        endif
     endfor
   endfor
 endfor


end
;--------------------------------------------
function adetector_class::create_tth_bin_array,nbins, npo, tthmax
  binarr=fltarr(self.nopixx,self.nopixy)
  gonio=fltarr(6)
  spcx=fltarr(nbins)
  npo=lonarr(nbins)

  t1=self->calculate_tth_from_pixels([0,0], gonio)
  t2=self->calculate_tth_from_pixels([self.nopixx-1,0], gonio)
  t3=self->calculate_tth_from_pixels([0,self.nopixy-1], gonio)
  t4=self->calculate_tth_from_pixels([self.nopixx-1,self.nopixy-1], gonio)
  tthmax=max([t1,t2,t3,t4])
  dtth=tthmax/(nbins-2)
  for i=0, nbins-1 do spcx[i]=i*dtth

  for i=0, self.nopixx-1 do begin $
  print, i
  for j=0, self.nopixy-1 do $
  begin
       tth=self->calculate_tth_from_pixels([i,j], gonio)
       bin=long((tth)/dtth)+1
       binarr[i,j]=bin
       npo[bin]=npo[bin]+1
  endfor
  endfor
  return, binarr
end
;--------------------------------------------
function adetector_class::create_chi_bin_array,nbins, npo, chimax
  binarr=fltarr(self.nopixx,self.nopixy)
  gonio=fltarr(6)
  spcx=fltarr(nbins)
  npo=lonarr(nbins)
  pix0=[self.beamX,self.beamY]
  chimax=180.
  chimin=-180.
  dtth=(chimax-chimin)/(nbins-2)
  for i=0, nbins-1 do spcx[i]=i*dtth

  for i=0, self.nopixx-1 do begin $
  print, i
  for j=0, self.nopixy-1 do $
  begin
       tth=get_nu_from_pix([i,j],pix0)
       bin=long((tth-chimin)/dtth)+1
       binarr[i,j]=bin
       npo[bin]=npo[bin]+1
  endfor
  endfor
  return, binarr
end

;--------------------------------------------------------------------

function adetector_class::calculate_tth_from_pixels, pix, gonio

    sd=self->calculate_sd_from_pixels(pix, gonio)
    s0=[1,0,0]
    return, ang_between_vecs(sd,s0)
end
;--------------------------------------------------------------------

;--------------------------------------------------------------------
pro adetector_class::change_twist, newv
 self.angle  = newv
end

;--------------------------------------------------------------------



pro adetector_class::set_values

COMMON ADPV, dist,beamx,beamy,psizex,psizey,nopixx,nopixY,angle,omega0,ttheta0,tiltom,tiltch

  self.dist   = dist
  self.beamx  = beamx
  self.beamy  = beamy
  self.omega0  = omega0
  self.ttheta0 = ttheta0
  self.psizex = psizex
  self.psizey = psizey
  self.nopixx = nopixx
  self.nopixy = nopixy
  self.angle  = angle
  self.alpha  = alpha
  self.tiltom = tiltom
  self.tiltch = tiltch
  self.nu = nu
  self.del = del

end
;--------------------------------------------------------------------

pro adetector_class::set_object, ad

  self.dist   = ad.dist
  self.beamx  = ad.beamx
  self.beamy  = ad.beamy
  self.omega0 = ad.omega0
  self.ttheta0 = ad.ttheta0
  self.psizex = ad.psizex
  self.psizey = ad.psizey
  self.nopixx = ad.nopixx
  self.nopixy = ad.nopixy
  self.angle  = ad.angle
  self.alpha  = ad.alpha
  self.tiltom = ad.tiltom
  self.tiltch = ad.tiltch
  self.nu = ad.nu
  self.del = ad.del

end

function adetector_class::get_object

COMMON class_adetector_reference, ad

  ad.dist   = self.dist
  ad.beamx  = self.beamx
  ad.beamy  = self.beamy
  ad.omega0 = self.omega0
  ad.ttheta0 = self.ttheta0
  ad.psizex = self.psizex
  ad.psizey = self.psizey
  ad.nopixx = self.nopixx
  ad.nopixy = self.nopixy
  ad.angle  = self.angle
  ad.alpha  = self.alpha
  ad.tiltom = self.tiltom
  ad.tiltch = self.tiltch
  ad.nu = self.nu
  ad.del = self.del

  return, ad

end

;----------------------------------
pro adetector_class::write_object_to_disk, filename

COMMON class_adetector_reference, ad

     print, 'Writing detector parameters to:', filename

     ad=self->get_object()

     FREE_LUN, 2
     OPENW, 2, filename
     writeu, 2, ad
     CLOSE, 2
     FREE_LUN, 2

end

;----------------------------------

pro adetector_class::read_object_from_disk, filename

COMMON class_adetector_reference, ad

    print, 'Reading detector parameters from:', filename

     FREE_LUN, 2
     OPENR, 2, filename
     readu, 2, ad
     CLOSE, 2
     FREE_LUN, 2
     self->set_object, ad

end

;--------------------------------------------------------------
function adetector_class::polarization, pix, p

     xrel=-(pix[0]-self.beamX)*self.psizeX
     yrel= (pix[1]-self.beamY)*self.psizeY
     Ih=1.0
     Iv=(1.-p)/(1.+p)
     pol=(ih*abs(xrel)+iv*abs(yrel))/sqrt(xrel^2+yrel^2)
     return, pol
end
;--------------------------------------------------------------

function adetector_class::tilt_mtx
     common Rota, Mtx
     GenerateR, 3, self.tiltch
     omt=Mtx
     case read_cal_type() of
     0: GenerateR, 1, self.tiltom
     1: GenerateR, 2, self.tiltom
	 else:
	 endcase
     cht=Mtx
     icht=invert(cht)
     tiltmtx=icht##omt##cht
     tiltmtx1=dblarr(3,3)
     for i=0, 2 do for j=0, 2 do tiltmtx1[i,j]=double(tiltmtx[i,j])
     return, tiltmtx1

end

;--------------------------------------------------------------


function adetector_class::calculate_sd_from_pixels, pix, gonio

; Calculates the coordinates of the diffracted beam
; versor from pixel coordinates

; modified for GSECARS
     common Rota, Mtx

     xpix=pix[0]
     ypix=pix[1]

     vec1=[0.0,0.0,0.0]
     vec2=vec1
     vec3=vec1

    ; apply detector twist
     va=fltarr(3)
     va[1]=xpix-self.nopixx/2.0
     va[2]=ypix-self.nopixy/2.0

     GenerateR, 1,-self.angle
     chiA=Mtx
     vb=chiA##va

     vb[1]=vb[1]+self.nopixx/2.0
     vb[2]=vb[2]+self.nopixy/2.0

     ;--- calclate relative coordinares

     xrel=-(vb[1]-self.beamX)*self.psizeX
     yrel=(vb[2]-self.beamY)*self.psizeY

     ;--- create sd at 2theta 0
     vec1a=[0.0,0.0,0.0]

     vec1a[0]=0.0
     vec1a[1]=xrel
     vec1a[2]=yrel

     ;GenerateR, 1,-self.angle
     ;chiA=Mtx
     ;Vec1=chiA##vec1A

     Vec1=vec1A



    ;---- apply detector tilts

     mtx=self->tilt_mtx()

     vec2=mtx##vec1
     ;---------------------

     vec2a=[0.0,0.0,0.0]

     vec2a[0]=self.dist
     vec2a[1]=0
     vec2a[2]=0
     vec3=vec2+vec2a

     ;--- include detector roatations ---
     GenerateR, 3,gonio[1]
     tth=Mtx
     vec3=tth ## (vec3)

     GenerateR, 2,gonio[0]
     nu=Mtx
     vec3=nu ## (vec3)

     ;--- normalize ----

     sd=transpose(vec3/vlength(vec3))
     return, sd

end

;----------------------------------------------------------------------


;----------------------------------------------------------------------

function adetector_class::calculate_pixels_from_sd, sd, gonio

; calculates pixel coordinates from diffracted beam versor coordinates

; modified for GSECARS 11/30/2005
     common Rota, Mtx

     Pi=acos(-1.0)
     vec1=[1.0,0.0,0.0]
     vec2=vec1
     vec3=vec1
     sd2=vec1
     pix=[0.0,0.0]


     sd2=sd/vlength(sd)

;--- include detector roatations ---

     GenerateR, 2,-gonio[0]
     nu=Mtx
     sd2=nu ## sd2

     GenerateR, 3,-gonio[1]
     tth=Mtx
     sd1=tth ## sd2

     ; calculate Bragg angle
     tth=ang_between_vecs(sd1,vec3)

     ;calculate detector normal vector
    ;---- apply detector tilts
     det=[-1.0,0.0,0.0]

     mtx=self->tilt_mtx()
     det1=mtx##det

     ;---------------------
     ; calculate point of intersection
     dv=line_plane_intersection(sd1, det1, [0.0,0.0,0.0], [self.dist,0.0,0.0])

     ;dvi=icht##iomt##cht##(dv+det*self.dist)
     dvi=invert(mtx)##(dv+det*self.dist)


dv=dvi

     pix[0]=-dv[1]/self.psizeX+self.beamX
     pix[1]= dv[2]/self.psizeY+self.beamY

     ;---------------------- apply twist

     va=fltarr(3)
     va[1]=pix[0]-self.nopixx/2.0
     va[2]=pix[1]-self.nopixy/2.0


     GenerateR, 1,self.angle
     chiA=Mtx

;     dv=chiA##dvi
     vb=chiA##va
     pix=[vb[1]+self.nopixx/2.0,vb[2]+self.nopixy/2.0]

     ;pix[0]=-dv[1]/self.psizeX+self.beamX
     ;pix[1]= dv[2]/self.psizeY+self.beamY

     return, pix

end


;--------------------------------------------------------------------

; ---------------------------------------
; Caculates the diffracted beam versor coordinates
; from the reciprocal vector coordinates
; Checked 03/04/05
;----------------------------------------
function calculate_sd_from_hl, hl,wv

; hl is at diffracting position


 hl1=hl/vlength(hl)

 Pi=acos(-1.0)
 s0=[1.0,0.0,0.0]
 al= ang_between_vecs(hl1,s0)
 if al lt 90.0 then $
 begin
   hl1=-hl1
   al= ang_between_vecs(hl1,s0)
   om=90.0-al
   print, "inversion"
 endif
 om=al-90
 tth=om*2.0
 ;hle=sin(tth*pi/180.0)/cos(om*pi/180.0)
 hle=2.0*sin(om*pi/180.0)
 h=hl1*hle
 sd=s0+h

 return, sd

end



; ---------------------------------------
; Caculates the rec. vector coordinates
; from diffracted beam versor (hl) coordinates
; Checked 03/04/05
;----------------------------------------
function calculate_hl_from_sd, sd, wv

 ;sd=sd/vlength(sd)
 s0=[1.0,0.0,0.0]
 hl=sd-s0

 return, hl/wv[0] ; needs to be multiplied by lambda

 end

;----------------------------------------------------------
;----------------------------------------------------------

function calculate_theta_from_xyz, xyz

  vec1=[1.0,0.0,0.0]
  xyz1=xyz/vlength(xyz)
  ang=ang_between_vecs(vec1, xyz1)
  return, (abs(ang)-90.0)

end

;-----------------------------------------------------------


;&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

;--------------------------------------------------------------------
; Calculates pixel coordinates from rec. vector coordinates, allows to apply further
; goniometer rotation gonio
; it is assumed that the goniometer rotation is relative to the original position of xyz
;--------------------------------------------------------------------

function adetector_class::calculate_pixels_from_xyz, xyz, gonio

; this is used for recalc detxy

; angle gonio[0] is used to describe alpha - deviation of the omega axis from the vertical direction
; for now this is for an omega axis

     sd=[0.0,0.0,0.0]
     pix=[0.0,0.0]
     xyz1=xyz/vlength(xyz)
     common Rota, Mtx

     GenerateR, 3, gonio[3]
     om=Mtx

     GenerateR, 1, gonio[4]
     ch=Mtx

     GenerateR, 3, gonio[5]
     ph=Mtx


     iom=invert(om)
     ich=invert(ch)
     iph=invert(ph)

     hl=iom##ich##iph##xyz1 ; already unit length

     sd=calculate_sd_from_hl(hl)

     pix=self->calculate_pixels_from_sd(sd, gonio)

     return, pix

 end

;--------------------------------------------------------------------
; Calculates recip. versor coordinates from pixel coordinates
; (including non zero goinio position)
; Back rotation is applied, so the final vector coordinates are at zero
; goniometer position
;---------------------------------------------------------------------


function adetector_class::calculate_XYZ_from_pixels_mono, pix, gonio, wv

;this is used for xyz from pixels

     common Rota, Mtx

     vec1=[0.0,0.0,0.0]
     vec2=vec1
     sd=vec1
     hl=vec1
     gonio0=fltarr(6)
     gonio0[0:1]=gonio[0:1]
     ;----------------------------
     sd=self->calculate_sd_from_pixels(pix, gonio0)
     ; sd has unit length
     ; it uses detector angles from gonio

     tth=self->calculate_tth_from_pixels(pix, gonio0)
     d=d_from_tth_and_en(tth, A_to_kev(wv))

     hl=(calculate_hl_from_sd(sd, wv))
     ; hl already has a proper length

     GenerateR, 3,-gonio[3]
     om=Mtx
     GenerateR, 1,-gonio[4]
     ch=Mtx
     GenerateR, 3,-gonio[5]
     ph=Mtx

     vec2=ph # ch # om # hl

     return, vec2

 end

;--------------------------------------------------------------------

;----------------------------------------------------------


function adetector_class::generate_ds_ring, tth

  common Rota, Mtx

  vec=[1.,0.,0.]
  GenerateR, 3, tth
  sd=Mtx ## vec
  an=read_kappa_and_ttheta()
  gonio=[an[0],an[1],0.,0.,an[0],0.]
  pix=self->calculate_pixels_from_sd(sd, gonio)
  path=fltarr(360, 2)
  path[0,0:1]=pix
  for i=1, 359 do $
  begin
   GenerateR, 1, i*1.0
   vec2=Mtx ## sd
   pix=self->calculate_pixels_from_sd(vec2, gonio)
   path[i,0:1]=pix
  end
  return, path

end
;----------------------------------------------------------


;--------------------------------------------------------------------
function adetector_class::calculate_psi_angles, gonio, pix
; psi1 is the angle between incident beam and DAC axis,
; psi2 is the angle between diffracted beam and DAC axis
     common Rota, Mtx
g=fltarr(6)
g[0:1]=gonio[0:1]
nn=n_elements(pix)/2
y=fltarr(2,nn)
for i=0,nn-1 do $
begin
 g[0:1]=gonio[0:1,i]
 sd=self->calculate_sd_from_pixels(pix[0:1,i], g)

 if gonio[3,i] lt -90 then $
 begin
    psi1=180.0+gonio[3,i]
    GenerateR, 3, -psi1
 endif else $
 if gonio[3,i] lt 90 then $
 begin
    psi1=gonio[3,i]
    GenerateR, 3, -psi1
 endif else $
 begin
    psi1=gonio[3,i]-180.0
    GenerateR, 3, -psi1
  endelse
 e1=[1.,0.,0.]
 e1=Mtx ## e1
 psi2=min([ang_between_vecs(sd,e1),ang_between_vecs(sd,-1.0*e1)])
 ;if psi2 gt 90. then psi2=psi2-90.
 y[0:1,i]=[psi1,psi2]
endfor
return, y
end


function adetector_class::get_nu_from_pix, pix

;--- New class method replacing the old get_nu_from_pix
; calculates the detector out of horiz. plane angle for a reflection from the Cartesian
; coordinates of reciprocal vector


  gonio=fltarr(6)
  nn=n_elements(pix)/2
  y=fltarr(nn)
  for i=0, nn-1 do $
  begin
   sd=self->calculate_sd_from_pixels(pix[0:1,i], gonio)
   sd[0]=0
   nu=ang_between_vecs(sd,[0.,-1.,0.])
   if sd[2] lt 0.0 then y[i]=nu else y[i]=-nu
 endfor
 return, y
end

;--------------------------------------------------------------------
function get_nu_from_pix, pix, pix0
;--- on Jan 03, 2011 this function is being replaced by a class method with the same name

; calculates the detector out of horiz. plane angle for a reflection from the Cartesian
; coordinates of reciprocal vector
  nn=n_elements(pix)/2
  y=fltarr(nn)
  for i=0, nn-1 do $
  begin
   sd=[0.,pix[0,i],pix[1,i]]-[0.,pix0[0],pix0[1]]
   nu=ang_between_vecs(sd,[0.,-1.,0.])
   if sd[2] lt 0.0 then y[i]=nu else y[i]=-nu
 endfor
 return, y
end
;---;--------------------------------------------------------------------
function get_nu_from_xyz, pix
oad=obj_new('adetector_class')
capture_calibration, oad, wv
ad=oad->get_object()
; calculates the detector out of horiz. plane angle for a reflection from the Cartesian
; coordinates of reciprocal vector
  sd=[0.,pix[0],pix[1]]-[0.,ad.beamx,ad.beamx]
  nu=ang_between_vecs(sd,[0.,-1.,0.])
  obj_destroy, oad
  if sd[2] lt 0.0 then return, nu else return, -nu
end
;--------------------------------------------------------------------
function get_tth_from_xyz, xyz
nn=n_elements(xyz)/3
y=fltarr(nn)
oad=obj_new('adetector_class')
capture_calibration, oad, wv
; calculates the detector out of plane angle for a reflection from the Cartesian
; coordinates of reciprocal vector
 common Rota, Mtx
 for i=0, nn-1 do $
 begin
  d=1./vlength(xyz[0:2,i])
  y[i]=tth_from_en_and_d(A_to_kev(wv), d)
 end
  obj_destroy, oad
  return, y
end;--------------------------------------------------------------------

;----------------------------------------------------------
pro class_adetector

COMMON class_adetector_reference, ad

ad={adetector_class, $
  dist   : 0.0,  $
  beamx  : 0.0,  $
  beamy  : 0.0,  $
  psizex : 0.0,     $
  psizey : 0.0,     $
  nopixx : 0,       $
  nopixY : 0,       $
  angle  : 0.0,     $
  alpha  : 0.0,     $
  omega0 : 0.0,     $
  ttheta0: 0.0,     $
  tiltom : 0.0,     $
  tiltch : 0.0,	    $
  nu     : 0.0,     $
  del    : 0.0}

end