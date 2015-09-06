
;function CLASS_peaktable::recomp_UB
;pro CLASS_peaktable::select_close_overlaps, far
;function CLASS_peaktable::peak_pos_diff_one, ubc, oadn, pred, wv, k
;pro CLASS_peaktable::move_sel_peaks_AtoB, opt
;pro CLASS_peaktable::replace_all_peaks_AbyB, opt
;function CLASS_peaktable::peak_pos_diff, ub, oadet, pred,wv
;function CLASS_peaktable::build_HKLs
;pro CLASS_peaktable::set_alpha, al
;pro CLASS_peaktable::set_energy, al
;function CLASS_peaktable::build_XYZs
;function CLASS_peaktable::indexing_FOM, UB, pr
;------------
;function CLASS_peak::get_object
;pro CLASS_peak::set_object, ref_peak
;function CLASS_peak::distance, ref_peak
;------------
;function CLASS_peaktable::read_intensities
;pro CLASS_peaktable::copy_selection,optable1
;pro CLASS_peaktable::copy, opt
;pro CLASS_peaktable::refine_ind_omega, UB
;function CLASS_peaktable::save_intensities
;function CLASS_peaktable::save_hkl, out_dir
;pro CLASS_peaktable::save_hkl, fname
;function CLASS_peaktable::save_ascii
;pro CLASS_peaktable::export_peak_list2, wv, oad
;pro CLASS_peaktable::export_peak_list, wv, oad, out_dir
;pro CLASS_peaktable::export_peak_list1, wv, oad
;pro CLASS_peaktable::check_profiles
;pro CLASS_peaktable::select_rpeaks, box00x,box00y, box11x, box11y
;pro CLASS_peaktable::select_image, box00x,box00y, box11x, box11y
;pro CLASS_peaktable::unselect_image, box00x,box00y, box11x, box11y
;pro CLASS_peaktable::select_rpeaks_det, box00x,box00y, box11x, box11y
;pro CLASS_peaktable::unselect_rpeaks, box00x,box00y, box11x, box11y
;pro CLASS_peaktable::invert_selection
;pro CLASS_peaktable::unselect_all
;pro CLASS_peaktable::select_all
;pro CLASS_peaktable::delete_selected
;function CLASS_peaktable::get_object
;pro CLASS_peaktable::set_object,ref_peaktable
;function CLASS_peaktable::get_element, n
;pro CLASS_peaktable::set_element, n, ref_peak
;pro CLASS_peaktable::replacepeak, n, ref_peak
;pro CLASS_peaktable::appendpeak, ref_peak
;pro CLASS_peaktable::append_peaks, pt
;pro CLASS_peaktable::select_peak, k
;pro CLASS_peaktable::unselect_peak, k
;pro CLASS_peaktable::delete_peak, sell
;pro CLASS_peaktable::insert_peak, sel, ref_peak
;pro CLASS_peaktable::sort_peaks, field, order
;pro CLASS_peaktable::initialize
;pro CLASS_peaktable::rotate_vectors, ran, seli
;pro CLASS_peaktable::calculate_all_pixels_OLA, oadetector
;pro CLASS_peaktable::calculate_all_rprime_OLA, oadetector
;pro CLASS_peaktable::zero
;function CLASS_peaktable::refineX0, oadetector, ocrystal,wav, v_limit, v_range, v_var, v_old
;function CLASS_peaktable::refineY0, oadetector, ocrystal,wav, v_limit, v_range, v_var, v_old
;function CLASS_peaktable::refineD, oadetector, ocrystal,wav, v_limit, v_range, v_var, v_old
;function CLASS_peaktable::refineTth, oadetector, ocrystal,wav, v_limit, v_range, v_var, v_old
;function CLASS_peaktable::refineLa, oadetector, ocrystal,wav, v_limit, v_range, v_var, v_old
;pro CLASS_peaktable::refine_rotations, oadetector, ocrystal,wav, v_limit
;function CLASS_peaktable::calculate_indexing_fom,  ocrystal, limit
;function CLASS_peaktable::calculate_misindex, ocrystal, limit, i
;function CLASS_peaktable::calculate_indexing_fom,  ocrystal, limit
;function CLASS_peaktable::calculate_misindex, ocrystal, limit, i
;function CLASS_peaktable::find_closest_peak, ref_peak
;pro CLASS_peaktable::calculate_SSD_from_pixels, gonio
;pro CLASS_peaktable::read_object_from_file, fname
;pro CLASS_peaktable::APPEND_object_from_file, fname
;pro CLASS_peaktable::write_object_to_file, fname
;pro CLASS_peaktable::calculate_all_detXY_from_xyz, oadetector, wv
;pro CLASS_peaktable::calculate_all_xyz_from_pix, oadetector, wv
;pro CLASS_peaktable::remove_peaks_outside_aa, oadetector
;pro CLASS_peaktable::calculate_all_xyz_from_pix_laue, oadetector
;pro CLASS_peaktable::calculate_all_xyz_from_edd, oadetector
;pro CLASS_peaktable::set_all_gonio, gonio
;pro CLASS_peaktable::apply_rotation_mtx, RR, wv, oad
;pro CLASS_peaktable::apply_rotation, angles
;pro CLASS_peaktable::apply_dm, oadetector, mv, om0, omr
;function CLASS_peaktable::reindex, ocrystal, limit
;function CLASS_peaktable::calculate_2thetas, oad, wv
;function CLASS_peaktable::peak_list
;function CLASS_peaktable::peakno
;function CLASS_peaktable::selectedno
;pro CLASS_peaktable::set_peak_box_size, bx, whichpeak
;pro CLASS_peaktable::set_zero_peak_box_size, bx
;pro CLASS_peaktable::apply_transform, UT
;pro CLASS_peaktable::find_multiple_peak_copies
;------------------------------------------------
;function distance, x1,y1,x2,y2
;function OPTIMIZE_OMEGA, x, x0
;function OLA_accessible_range, pn, om0, ch0
;-------------------------------------

function CLASS_peaktable::recomp_UB
  HKLs=self->build_HKLs()
  XYZs=self->build_XYZs()
  UB=transpose(XYZs # transpose(HKLs) # invert(HKLs # transpose(HKLS)))
  return, UB
end

;--------------
function CLASS_peaktable::find_close_overlaps, pn, far

   noverlaps=0
   xy1=self.peaks[pn].DetXY
   for j=0, self.peakno-1 do if j ne pn then $
   begin
      xy2=self.peaks[j].DetXY
      dxy=xy1-xy2
      dst=sqrt(dxy[0]^2+dxy[1]^2)
      if dst lt far then $
      begin
        noverlaps[0]=noverlaps[0]+1
        if noverlaps[0] eq 1 then noverlaps=[noverlaps, pn, j] else $
        noverlaps=[noverlaps,j]
      endif
   endif
   return,noverlaps
end

;--------------
;--------------
pro CLASS_peaktable::select_close_overlaps, far
 for i=0, self.peakno-2 do $
 begin
   xy1=self.peaks[i].DetXY
   for j=i+1, self.peakno-1 do $
   begin
      xy2=self.peaks[j].DetXY
      dxy=xy1-xy2
      dst=sqrt(dxy[0]^2+dxy[1]^2)
      if dst lt far then $
      begin
        self.peaks[i].selected[0]=1
        self.peaks[j].selected[0]=1
      endif
   endfor
 endfor
end

;--------------

function CLASS_peaktable::peak_pos_diff_one, ubc, oadn, pred, wv, k
     pred.om_start=self.peaks[k].gonio[3]-3.0
     pred.om_range=6.0
     ref=oadn->generate_one_peak(ubc, wv, pred, self.peaks[k].hkl)
     dif=ref.detxy-self.peaks[k].detxy
     return,sqrt(dif[0]*dif[0]+dif[1]*dif[1])
end

;--------------

function CLASS_peaktable::calculate_Ddd, lp
; calculates difference between observed (from xyz) and calculated (from lp) d-spacings
       N=self.peakno
       ds=fltarr(N)
       dsc=fltarr(N)
       a=fltarr(N)
       for i=0, n-1 do $
       begin
        ds[i]=1.0/vlength(self.peaks[i].xyz)
        dsc[i]= d_from_lp_and_hkl(lp, self.peaks[i].hkl)
       endfor
       return,(ds-dsc)/dsc
end

;-------------------------------------------------

;--------------
function CLASS_peaktable::BUILD_d_list
; creates a vector of d-spacings
; requires correct xyz lengths
 dlist=fltarr(self.peakno)
 for i=1, self.peakno do dlist[i-1]=1/vlength(self.peaks[i-1].XYZ)
 return, dlist
end
;--------------
function CLASS_peaktable::build_HKLs
HKLs=fltarr(3,self.peakno)
  for i=1, self.peakno do $
   HKLs[0:2,i-1]=self.peaks[i-1].hkl
   return,HKLs
end
;----------
function CLASS_peaktable::build_XYZs
XYZs=fltarr(3,self.peakno)
  for i=1, self.peakno do $
   XYZs[0:2,i-1]=self.peaks[i-1].xyz
   return, XYZs
end



;----------
function CLASS_peaktable::build_ds
  ds=fltarr(self.peakno)
  for i=0, self.peakno-1 do $
  begin
   xyz=self.peaks[i].xyz
   ds[i]=1.0/vlength(xyz)
  end
   return, ds
end
;------------------------------------------------------

pro CLASS_peaktable::select_indexable, ub, limit

; reindexes peaktable with a limit

  iUB=invert(UB)
  ind=0
  self->unselect_all
  for i=0, self.peakno-1 do $
  begin
     vec=iUB##self.peaks[i].XYZ
     hkla=[round(vec[0]),round(vec[1]),round(vec[2])]
     dhkl=vlength(hkla-vec)
     if dhkl gt limit or $
        (abs(vec[0]) lt limit and abs(vec[1]) lt limit and abs(vec[2]) lt limit) then $
     begin
        self.peaks[i].HKL=[0,0,0]
        self.peaks[i].selected[0]=1
        self.selectedno=self.selectedno+1
     endif else $
     begin
        self.peaks[i].HKL=hkla
        self.peaks[i].selected[0]=0
        ind=ind+1
     endelse
  endfor

end
;---------------------------------------------

function CLASS_peaktable::get_rotations, axis
  if axis ge 0 and axis le 5 then $
  return, self.peaks[*].gonio[axis] else return, -1
end
;--------------
function CLASS_peaktable::get_DetXY, i
  return, self.peaks[i].DetXY
end
;--------------

pro CLASS_peaktable::move_sel_peaks_AtoB, opt
;COMMON CLASS_peaktable_reference, ref_peaktable, ref_peak
 sel=where(self.peaks[0:self.peakno-1].selected[0] eq 1)
 if sel[0] ne -1 then $
 begin
  sub=self.peaks[sel]
  pt=opt->get_object()
  for i=0, n_elements(sel)-1 do $
   opt->appendpeak,self.peaks[sel[i]]
  for i=n_elements(sel)-1, 0, -1 do $
   self->delete_peak,[sel[i]]
 endif
end

;--------------

pro CLASS_peaktable::replace_all_peaks_AbyB, opt
 self->zero
 pt=opt->get_object()
 for i=0, pt.peakno-1 do $
 self->appendpeak,pt.peaks[i]
end

;--------------
;--------------
;--------------
function CLASS_peaktable::peak_pos_diff, ub, oadet, pred,wv

; calculates sum of differences between calculated and observed peak positions (in pixdel coordinates)
; for the given orientation mtx and calibration

; May want to select peaks that are not in the right places/ above certain thershold of error in position

  sum=0
  for i=0, self.peakno-1 do $
  begin
     pred.om_start=self.peaks[i].gonio[3]-3.0
     pred.om_range=6.0
     ref=oadet->generate_one_peak(ub, wv, pred, self.peaks[i].hkl)
     dif=ref.detxy-self.peaks[i].detxy
     bb=sqrt(dif[0]*dif[0]+dif[1]*dif[1])
     if bb gt 10.0 then self.peaks[i].selected[0]=1 else self.peaks[i].selected[0]=0
     sum=sum+sqrt(dif[0]*dif[0]+dif[1]*dif[1])
     ;print,i,ref.detxy[0],self.peaks[i].detxy[0],ref.detxy[1],self.peaks[i].detxy[1],sqrt(dif[0]*dif[0]+dif[1]*dif[1])
  endfor
  return,sum/self.peakno
end

;-------------------------------------------------
function CLASS_peaktable::save_p4p, fname

          if n_params()  eq 0 then fname=dialog_pickfile(FILTER='*.p4p', /WRITE, DEFAULT_EXTENSION='p4p')
          free_lun, 4
          if fname ne '' then $
          begin
          OPENW, 4, fname


            printf, 4, 'FILEID Seattle      ?             4.00        08/20/08 14:27:16 C8H8Se3'
			printf, 4, 'SITEID ?                                  ?'
			printf, 4, 'TITLE  ?'
			printf, 4, 'CHEM   C8 H8 Se3'
			printf, 4, 'CELL      4.9159   11.1888   16.6681   90.0000   90.0000   90.0000    916.791'
			printf, 4, 'CELLSD    0.0011    0.0028    0.0091    0.0000    0.0000    0.0000     0.229'
			printf, 4, 'ORT1    -4.4774786e-002  2.9954357e-002  5.4960791e-002'
			printf, 4, 'ORT2    -4.7662384e-002  7.9853413e-002 -2.2988310e-002'
			printf, 4, 'ORT3    -1.9262548e-001 -2.6721303e-002 -7.0872242e-003'
			printf, 4, 'ZEROS   0.0000000  0.0000000  0.0000000    0.0000    0.0000    0.0000'
			printf, 4, 'SOURCE ?      0.41328   0.41328   0.41328   1.00000    0.00    0.00'
			printf, 4, 'LIMITS    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00    0.00'
			printf, 4, 'MORPH  ?'
			printf, 4, 'DNSMET ?'
			printf, 4, 'CCOLOR ?'
			printf, 4, 'CSIZE  ?            ?            ?            ?            ?'
			printf, 4, 'ADPAR      512.0000    512.0000      5.0000    1024'
			printf, 4, 'ADCOR       20.1957      9.0120     -0.0658      0.0000      0.0000      0.0000'
			printf, 4, 'BRAVAIS Orthorhombic          P'
       		printf, 4, 'MOSAIC  0.44 0.84'

          for i=1, self.peakno do $
          begin
            st = 'REF1K H      -1  -4   2 -30.000 180.000   0.150  54.736   15.40  166.45 1691.26    158'+$
                 string(self.peaks[i-1].xyz[0], format='(F11.6)')+$
                 string(self.peaks[i-1].xyz[1], format='(F11.6)')+$
                 string(self.peaks[i-1].xyz[2], format='(F11.6)')+$
                 '   0.000   0.000   0.000   0.000 '

            PRINTF, 4, st
          endfor
          PRINTF, 4,'DATA  SPATIAL linear          linear          3.0  512.00  512.00   17.000   3136 1024'
          CLOSE, 4
          free_lun, 4
          endif
          return, fname
end
;-------------------------------------------------
;-------------------------------------------------

pro CLASS_peaktable::import_p4p, fname
COMMON CLASS_peaktable_reference, ref_peaktable, ref_peak

; returns peak number
res=file_info(fname)
xyz=fltarr(3)
if res.exists eq 1 then $
begin
 FREE_LUN,2
 OPENR, 2, fname
 str='     '
 ; search for beginning of reflection block
 while str ne 'MOSA' and not eof(2) do $
   readf, 2, str, format='(A4)'
 readf, 2, str
 if strmid(str,0,5) eq 'REF1K' then $
 begin
  x=float(strmid(str,86,10))
  y=float(strmid(str,96,10))
  z=float(strmid(str,106,10))
  xyz=[x,y,z]
  ref_peak.xyz=xyz
  self->appendpeak,ref_peak
  while strmid(str,0,5) eq 'REF1K' and not eof(2) do $
  begin
    readf, 2, str
    x=float(strmid(str,86,10))
    y=float(strmid(str,96,10))
    z=float(strmid(str,106,10))
    xyz=[x,y,z]
    ref_peak.xyz=xyz
    self->appendpeak,ref_peak
  endwhile
 endif
 CLOSE, 2
 FREE_LUN,2
endif
end

;--------------------------------------------------------------------

;--------------
function CLASS_peaktable::build_HKLs
HKLs=fltarr(3,self.peakno)
  for i=1, self.peakno do $
   HKLs[0:2,i-1]=self.peaks[i-1].hkl
   return,HKLs
end

;--------------
pro CLASS_peaktable::set_alpha, al
  for i=0, self.peakno-1 do $
   self.peaks[i].energies[0]=al
end

;----------

pro CLASS_peaktable::set_energy, al
  for i=0, self.peakno-1 do $
   self.peaks[i].energies[0]=al
end

;----------

function CLASS_peaktable::build_XYZs
XYZs=fltarr(3,self.peakno)
  for i=1, self.peakno do $
   XYZs[0:2,i-1]=self.peaks[i-1].xyz
   return, XYZs
end

;-------------------------------------------------

function CLASS_peaktable::indexing_FOM, UB, pr
  fom=0.0
  iUB=invert(UB)
  no=0
  for i=1, self.peakno do $
  begin
    hkl=iUB ## self.peaks[i-1].xyz
    hkl1=[round(hkl[0]),round(hkl[1]),round(hkl[2])]
    self.peaks[i-1].hkl=hkl1
    fo=vlength(hkl1-hkl)
    ;print, fo
    if fo lt 0.1 then $
    begin
      fom=fom+fo
      no=no+1
    end ;else print, i
  end
  return, fom/no
end

;-------------------------------------------

function CLASS_peak::get_object

COMMON CLASS_peaktable_reference, ref_peaktable, ref_peak

                ref_peak.Stat     = self.Stat
                ref_peak.HKL      = self.HKL
                ref_peak.XYZ      = self.XYZ
                ref_peak.selected = self.selected
                ref_peak.DetXY    = self.DetXY
                ref_peak.Gonio    = self.Gonio
                ref_peak.GonioSS  = self.GonioSS
                ref_peak.nen      = self.nen
                ref_peak.energies = self.energies
                ref_peak.IntAD    = self.IntAD
                ref_peak.position = self.position
                ref_peak.IntSSD   = self.IntSSD
                ref_peak.adp      = self.adp

                return, ref_peak

end

;--------------------------------------------------

pro CLASS_peak::set_object, ref_peak

                self.Stat     = ref_peak.Stat
                self.HKL      = ref_peak.HKL
                self.XYZ      = ref_peak.XYZ
                self.selected = ref_peak.selected
                self.DetXY    = ref_peak.DetXY
                self.Gonio    = ref_peak.Gonio
                self.GonioSS  = ref_peak.GonioSS
                self.nen      = ref_peak.nen
                self.energies = ref_peak.energies
                self.IntAD    = ref_peak.IntAD
                self.position = ref_peak.position
                self.IntSSD   = ref_peak.IntSSD
                self.adp      = ref_peak.adp

end

;--------------------------------------------------

function CLASS_peak::distance, ref_peak

 x1=self.DetXY[0]
 y1=self.DetXY[1]
 x2=ref_peak.DetXY[0]
 y2=ref_peak.DetXY[1]

 return, sqrt((x1-x2)^2+(y1-y2)^2)

end


;-------------------------------------------------
;-------------------------------------------------
;-------------------------------------------------

; Class_peaktable methods

;-------------------------------------------------
;-------------------------------------------------
;-------------------------------------------------

function CLASS_peaktable::read_intensities

          COMMON CLASS_peaktable_reference, ref_peaktable, ref_peak

          hkl0=0.0
          hkl1=0.0
          hkl2=0.0

          fname=dialog_pickfile(FILTER='*.txt', /READ)
          free_lun, 4
          if fname ne '' then $
          begin
          OPENR, 4, fname
          i=0
          x_int=0
          x_flo1=0.0
          x_flo2=0.0
          x_flo3=0.0
          x_flo4=0.0
          inte=0.0
          en=0.0
          q1=0.0
          q2=0.0
          q3=0.0
          d=-0.0
          st=''
          READF, 4,st
          count=0
          while (not eof(4)) do begin
            READF, 4, x_flo1, x_flo2, inte, en, q1,q2,q3,d
            ref_peak.xyz=[q1/d/10.0, q2/d/10.0, q3/d/10.0]
            ref_peak.hkl=[0,0,0]
            ref_peak.IntAD[0]=inte
            ref_peak.energies[0]=en
            ref_peak.selected[0]=0
            self->appendpeak,ref_peak
            i=i+1
          endwhile
          peakno=i
          CLOSE, 4
          free_lun, 4
          endif
          return, fname
end

;-------------------------------------------------

pro CLASS_peaktable::copy_selection,optable1
  pt=optable1->get_object()
  for i=0, self.peakno-1 do if self.peaks[i].selected[0] eq 1 then $
     pt.peaks[i].selected[0]=1
  optable1->set_object, pt
end

;-------------------------------------------------

pro CLASS_peaktable::copy, opt

  pt=self->get_object()
  opt->set_object, pt

end
;-------------------------------------------------

function OPTIMIZE_OMEGA, x, x0

;-- used by CLASS_peaktable::refine_ind_omega

common args, xyz, xyz0
  xyz=x
  xyz0=x0
   ; Define the fractional tolerance:
   ftol = 1.0e-4

   ; Define the starting point:
   P = [0.0,0.0]

   ; Define the starting directional vectors in column format:
   xi = [[1.0,0.0],[0.0,1.0]]

   ; Minimize the function:
   POWELL, P, xi, ftol, fmin, 'opt_omega'

   ; Print the solution point:
   PRINT, 'Solution point: ', P

   ; Print the value at the solution point:
   PRINT, 'Value at solution point: ', fmin
   return,   P

END

;-------------------------------------------------

pro CLASS_peaktable::refine_ind_omega, UB
  common Rota, Mtx
  iub=invert(ub)

  for i=0, self.peakno-1 do $
  begin
    hkl=iUB ## self.peaks[i].xyz
    self.peaks[i].hkl=[round(hkl[0]),round(hkl[1]),round(hkl[2])]
    xyz0=UB ## self.peaks[i].hkl
    print, hkl
    ;print, self.peaks[i].xyz, xyz0
    om=OPTIMIZE_OMEGA(self.peaks[i].xyz, xyz0)
    GenerateR, 3, om[0]
    self.peaks[i].xyz=mtx ## self.peaks[i].xyz
    self.peaks[i].gonio[3]=self.peaks[i].gonio[3]+om[0]
    print, 'omega correction=', om
  end

end

;-------------------------------------------------
function CLASS_peaktable::save_intensities

          fname=dialog_pickfile(FILTER='*.txt', /WRITE)
          free_lun, 4
          if fname ne '' then $
          begin
          OPENW, 4, fname
          PRINTF, 4,''
          for i=1, self.peakno do $
          begin
            d=vlength(self.peaks[i-1].xyz)
            st = string(0.0)+ string(0.0)+ $
                 string(self.peaks[i-1].IntAD[0])+$
                 string(self.peaks[i-1].energies[0])+$
                 string(self.peaks[i-1].xyz[0]/d)+$
                 string(self.peaks[i-1].xyz[1]/d)+$
                 string(self.peaks[i-1].xyz[2]/d)+$
                 string(1/d/10)
            PRINTF, 4, st
          endfor
          CLOSE, 4
          free_lun, 4
          endif
          return, fname
end

;-------------------------------------------------

function CLASS_peaktable::save_hkl, out_dir

; saves an ascii .hkl file with hkl, peak intensity, sI in SHELXL format
; no intensity scaling or normalization is made

          fname=dialog_pickfile(FILTER='*.hkl', /WRITE, DEFAULT_EXTENSION='hkl', path=out_dir)
          free_lun, 4
          if fname ne '' then $
          begin
          OPENW, 4, fname
          for i=1, self.peakno do $
          begin
            if (self.peaks[i-1].intAD[0]) gt (self.peaks[i-1].intAD[1]) then $
            begin
            st = string(self.peaks[i-1].hkl[0], format='(I4)')+$
                 string(self.peaks[i-1].hkl[1], format='(I4)')+$
                 string(self.peaks[i-1].hkl[2], format='(I4)')+$
                 string((self.peaks[i-1].intAD[0]), format='(F8.2)')+$
                 string((self.peaks[i-1].intAD[1]), format='(F8.2)')
            PRINTF, 4, st
            endif
          endfor
          CLOSE, 4
          free_lun, 4
          endif
          return, fname
end

;-----------------------------------------------------

pro CLASS_peaktable::save_hkl, fname

; saves an ascii .hkl file with hkl, peak intensity, sI in SHELXL format
; no intensity scaling or normalization is made
   pt=self->get_object()

   m=9999.0/max(self.peaks[*].intAD[0])
   self.peaks[*].intAD[0]=self.peaks[*].intAD[0]*m
   self.peaks[*].intAD[1]=self.peaks[*].intAD[1]*m

          free_lun, 4
          if fname ne '' then $
          begin
          OPENW, 4, fname
          for i=1, self.peakno do $
          begin
            st = string(self.peaks[i-1].hkl[0], format='(I4)')+$
                 string(self.peaks[i-1].hkl[1], format='(I4)')+$
                 string(self.peaks[i-1].hkl[2], format='(I4)')+$
                 string((self.peaks[i-1].intAD[0]), format='(F8.2)')+$
                 string((self.peaks[i-1].intAD[1]), format='(F8.2)')
            PRINTF, 4, st
          endfor
          CLOSE, 4
          free_lun, 4
          endif
   self->set_object, pt
end

;-------------------------------------------------

function CLASS_peaktable::save_ascii

          fname=dialog_pickfile(FILTER='*.txt', /WRITE)
          free_lun, 4
          if fname ne '' then $
          begin
          pn=self.peakno
          m=max(self.peaks[0:pn-1].intAD[0])
          self.peaks[0:pn-1].intAD[0]=self.peaks[0:pn-1].intAD[0]*9999./m
          self.peaks[0:pn-1].intAD[1]=self.peaks[0:pn-1].intAD[1]*9999./m
          OPENW, 4, fname
          for i=1, self.peakno do $
          begin
           if not(self.peaks[i-1].hkl[0] eq 0 and self.peaks[i-1].hkl[1] eq 0 and self.peaks[i-1].hkl[2] eq 0) then $
           begin
            st = string(self.peaks[i-1].hkl[0], format='(I4)')+$
                 string(self.peaks[i-1].hkl[1], format='(I4)')+$
                 string(self.peaks[i-1].hkl[2], format='(I4)')+$
                 string(self.peaks[i-1].intAD[0], format='(F8.2)')+$
                 string(self.peaks[i-1].intAD[1], format='(F8.2)')
            PRINTF, 4, st
           end
          endfor
          CLOSE, 4
          free_lun, 4
          endif
          return, fname
end
;-------------------------------------------------


pro CLASS_peaktable::export_peak_list2, wv, oad

  fname=dialog_pickfile(FILTER='*.dsp', /WRITE,  DEFAULT_EXTENSION='dsp')
  free_lun, 4
  if fname ne '' then $
  begin
  OPENW, 4, fname
  printf,4, ''
  printf,4, ''
  ad=oad->get_object()
  for i=0, self.peakno-1 do $
  begin
    en=A_to_kev(wv)
    en=self.peaks[i].energies[0]
    nu=get_nu_from_pix(self.peaks[i].DetXY,[ad.beamX,ad.beamY])
    tth=get_tth_from_xyz(self.peaks[i].xyz)
    L=lorenz(self.peaks[i].xyz, self.peaks[i].gonio, wv)
    P=polarization(nu, tth, [0.5026,0.4974])
    psi=oad->calculate_psi_angles(self.peaks[i].gonio, self.peaks[i].DetXY)
    tx=string(1.0/vlength(self.peaks[i].xyz), format='(F9.5)')+string(100,format='(F8.1)')+string(self.peaks[i].hkl[0],format='(I5)')+string(self.peaks[i].hkl[1],format='(I4)')+string(self.peaks[i].hkl[2],format='(I4)')
    printf, 4, tx
  endfor
  close, 4
  free_lun, 4
 endif

end
;-------------------------------------------------
pro CLASS_peaktable::export_peak_list, wv, oad, out_dir

  fname=dialog_pickfile(FILTER='*.txt', /WRITE,  DEFAULT_EXTENSION='txt', path=out_dir)
  free_lun, 4
  if fname ne '' then $
  begin
  OPENW, 4, fname
  printf,4, '   #   h   k   l  d         tth        om    chi     Energy      Fo^2     s(Fo^2)  psiD     L       P       wX      wY    T   psiR'
  printf,4, '-----------------------------------------------------------------------------------------------------------------------------------'
  ad=oad->get_object()
  for i=0, self.peakno-1 do $
  begin
    en=A_to_kev(wv)
    en=self.peaks[i].energies[0]
    nu=get_nu_from_pix(self.peaks[i].DetXY,[ad.beamX,ad.beamY])
    tth=get_tth_from_xyz(self.peaks[i].xyz)
    L=lorenz(self.peaks[i].xyz, self.peaks[i].gonio, wv)
    P=1.0/(1.0-0.058675*cos(2.0*nu/!radeg))
    psi=oad->calculate_psi_angles(self.peaks[i].gonio, self.peaks[i].DetXY)
    tx=string(i, format='(I4)')+string(self.peaks[i].hkl[0],format='(I4)')+string(self.peaks[i].hkl[1],format='(I4)')+string(self.peaks[i].hkl[2],format='(I4)')+$
    string(1.0/vlength(self.peaks[i].xyz), format='(F8.4)')+string(tth, format='(F10.3)')+string(self.peaks[i].gonio[3], format='(F8.1)')+string(nu, format='(F8.1)')+string(en, format='(F8.2)')$
    +string(self.peaks[i].IntAD[0], format='(F12.2)')+string(self.peaks[i].IntAD[1], format='(F8.2)')+string(psi[1], format='(F10.2)')+string(L, format='(F8.2)')+string(P, format='(F8.2)') $
    +string(self.peaks[i].energies[2], format='(F8.2)')+string(self.peaks[i].energies[3], format='(F8.2)')+string(self.peaks[i].energies[6]*!radeg, format='(F8.2)') $
    +string(ang_between_vecs(self.peaks[i].xyz, [1.,0.,0.]), format='(F8.2)')+string(self.peaks[i].energies[2], format='(F8.4)')
    printf, 4, tx
  endfor
  close, 4
  free_lun, 4
 endif

end
;-------------------------------------------------

pro CLASS_peaktable::export_peak_list1, wv, oad

  fname=dialog_pickfile(FILTER='*.txt', /WRITE,  DEFAULT_EXTENSION='txt')
  free_lun, 4
  if fname ne '' then $
  begin
  OPENW, 4, fname
  printf,4, '   h   k   l  d
  ad=oad->get_object()
  for i=0, self.peakno-1 do $
  begin
    en=A_to_kev(wv)
    en=self.peaks[i].energies[0]
    nu=get_nu_from_pix(self.peaks[i].DetXY,[ad.beamX,ad.beamY])
    tth=get_tth_from_xyz(self.peaks[i].xyz)
    L=lorenz(self.peaks[i].xyz, self.peaks[i].gonio, wv)
    P=polarization(nu, tth, [0.5026,0.4974])
    psi=oad->calculate_psi_angles(self.peaks[i].gonio, self.peaks[i].DetXY)
    tx=string(self.peaks[i].hkl[0],format='(I4)')+string(self.peaks[i].hkl[1],format='(I4)')+string(self.peaks[i].hkl[2],format='(I4)')+$
    string(1.0/vlength(self.peaks[i].xyz), format='(F8.3)')
    printf, 4, tx
  endfor
  close, 4
  free_lun, 4
 endif

end
;-------------------------------------------------


 pro CLASS_peaktable::check_profiles
 pt=obj_new('CLASS_peaktable')
 count=1
 for i=self.peakno-1, 1, -1  do $
 begin
   ;print, self.peaks[i].xyz, self.peaks[i-1].xyz
   if abs (self.peaks[i].xyz[0]-self.peaks[i-1].xyz[0]) lt 0.01 and $
      abs (self.peaks[i].xyz[1]-self.peaks[i-1].xyz[1]) lt 0.01 and $
      abs (self.peaks[i].xyz[2]-self.peaks[i-1].xyz[2]) lt 0.01 then $
      begin
        count=count+1
        ;print, count
      endif else $
      begin
          if count eq 1 then self->delete_peak, i
          if count gt 1 then $
          begin
            pos=max(self.peaks[i:i+count-1].intAD[0], kl)
            ;xyz=self.peaks[i+kl].xyz
            ;leng=vlength(self.peaks[i+kl].xyz)
            ;for o=1,20 do $
            ;begin
            ;  self.peaks[i+kl].xyz=xyz/leng*0.2+o*0.6/20.0
            pt->appendpeak,self.peaks[i+kl]
            ;endfor
            count=1
          endif
      endelse
 endfor
 al=pt->get_object()
 self->set_object, al
 obj_destroy, pt
 end


;-------------------------------------------------

pro CLASS_peaktable::select_rpeaks, box00x,box00y, box11x, box11y

   for i=1, self.peakno do $
   begin
     if self.peaks[i-1].xyz[1] gt box00x and $
        self.peaks[i-1].xyz[1] lt box11x and $
        self.peaks[i-1].xyz[2] gt box00y and $
        self.peaks[i-1].xyz[2] lt box11y then $
        begin
          self.peaks[i-1].selected[0]=1
          self.selectedno=self.selectedno+1
        end
   endfor
end

;-------------------------------------------------

pro CLASS_peaktable::select_image, box00x,box00y, box11x, box11y

   for i=1, self.peakno do $
   begin
     if self.peaks[i-1].detXY[0] gt box00x and $
        self.peaks[i-1].detXY[0] lt box11x and $
        self.peaks[i-1].detXY[1] gt box00y and $
        self.peaks[i-1].detXY[1] lt box11y then $
        begin
          self.peaks[i-1].selected[0]=1
          self.selectedno=self.selectedno+1
        end
   endfor
end
;-------------------------------------------------
pro CLASS_peaktable::unselect_image, box00x,box00y, box11x, box11y

   for i=1, self.peakno do $
   begin
     if self.peaks[i-1].detXY[0] gt box00x and $
        self.peaks[i-1].detXY[0] lt box11x and $
        self.peaks[i-1].detXY[1] gt box00y and $
        self.peaks[i-1].detXY[1] lt box11y then $
        begin
          self.peaks[i-1].selected[0]=0
          self.selectedno=self.selectedno-1
        end
   endfor
end
;-------------------------------------------------

pro CLASS_peaktable::select_rpeaks_det, box00x,box00y, box11x, box11y

   for i=1, self.peakno do $
   begin
     if self.peaks[i-1].DetXY[0] gt box00x and $
        self.peaks[i-1].DetXY[0] lt box11x and $
        self.peaks[i-1].DetXY[1] gt box00y and $
        self.peaks[i-1].DetXY[1] lt box11y then $
        begin
          self.peaks[i-1].selected[0]=1
          self.selectedno=self.selectedno+1
        end
   endfor
end

;-------------------------------------------------

pro CLASS_peaktable::unselect_rpeaks, box00x,box00y, box11x, box11y

   for i=1, self.peakno do $
   begin
     if self.peaks[i-1].xyz[1] gt box00x and $
        self.peaks[i-1].xyz[1] lt box11x and $
        self.peaks[i-1].xyz[2] gt box00y and $
        self.peaks[i-1].xyz[2] lt box11y then $
        begin
          self.peaks[i-1].selected[0]=0
          self.selectedno=self.selectedno-1
        end
   endfor
end


;-------------------------------------------------

pro CLASS_peaktable::invert_selection

   for i=1, self.peakno do $
     if self.peaks[i-1].selected[0] eq 1 then $
     begin
        self.peaks[i-1].selected[0]=0
        self.selectedno=self.selectedno-1
      endif else $
      begin
        self.peaks[i-1].selected[0]=1
        self.selectedno=self.selectedno+1
      endelse
end

;-------------------------------------------------

pro CLASS_peaktable::unselect_all

   for i=1, self.peakno do $
     self.peaks[i-1].selected[0]=0
     self.selectedno=0
end
;-------------------------------------------------
pro CLASS_peaktable::select_all

   for i=1, self.peakno do $
     self.peaks[i-1].selected[0]=1
     self.selectedno=self.peakno
end
;-------------------------------------------------

pro CLASS_peaktable::delete_selected

   for i=self.peakno[0]-1, 0, -1 do $
     if self.peaks[i].selected[0] eq 1 then self->delete_peak, i[0]
   self.selectedno=0
end

;-------------------------------------------------

function CLASS_peaktable::get_object
COMMON CLASS_peaktable_reference, ref_peaktable, ref_peak

  ref_peaktable.peakno = self.peakno
  ref_peaktable.selectedno = self.selectedno
  ref_peaktable.peaks  = self.peaks

  return, ref_peaktable

end

;--------------------------------------------------------------

pro CLASS_peaktable::set_object,ref_peaktable

  self.peakno = ref_peaktable.peakno
  self.selectedno = ref_peaktable.selectedno
  self.peaks  = ref_peaktable.peaks

end

;--------------------------------------------------------------

function CLASS_peaktable::get_element, n
common errors, er

           er=0
           if n lt self.peakno then return, self.peaks[n] else er=1

end

;--------------------------------------------------------------

pro CLASS_peaktable::set_element, n, ref_peak
common errors, er

           er=0
           if n lt self.peakno then self.peaks[n]=ref_peak else er=1
end

;---------------------------------------------------------------

pro CLASS_peaktable::replacepeak, n, ref_peak
common errors, er

           er=0
           if n lt self.peakno then self->set_element, n, ref_peak else er=1
end

;---------------------------------------------------------------

pro CLASS_peaktable::appendpeak, ref_peak
            if self.peakno lt 10000 then begin
             self.peakno=self.peakno+1
             self.peaks[self.peakno-1]=ref_peak
            endif
end

;---------------------------------------------------------------
; Appends all peaks from the structure pt to the peaktable self.peaks


pro CLASS_peaktable::append_peaks, pt
            if self.peakno+pt.peakno lt 10000 then $
            for i=0, pt.peakno-1 do self->appendpeak, pt.peaks[i]

end

;---------------------------------------------------------------

pro CLASS_peaktable::select_peaks, list
       n=n_elements(list)
       if n ne 0 then $
       self.peaks[list].selected[0]=1
end

;---------------------------------------------------------------

pro CLASS_peaktable::select_peak, k
            if k ge 0 and k lt self.peakno  then begin
             self.peaks[k].selected[0]=1
            endif
end

;---------------------------------------------------------------

pro CLASS_peaktable::unselect_peak, k
            if k ge 0 and k lt self.peakno  then begin
             self.peaks[k].selected[0]=0
            endif
end

;---------------------------------------------------------------

pro CLASS_peaktable::delete_peak, sell
common errors, er

           er=0
           sel=reform(long(sell))
           if sel lt self.peakno then $
           begin
            if self.peaks[sel].selected[0] eq 1 then self.selectedno=self.selectedno-1

            for k=sel[0], self.peakno-2 do $
              self.peaks[k]=self.peaks[k+1]
            self.peakno=self.peakno-1
           endif else er=1

end

;---------------------------------------------------------------

pro CLASS_peaktable::insert_peak, sel, ref_peak
common errors, er

           er=0
           if sel le self.peakno then $
           begin
            for k=self.peakno, sel+1, -1 do $
            self.peaks[k]=self.peaks[k-1]
            self.peaks[sel]=ref_peak
            self.peakno=self.peakno+1
           endif else er=1
end

;---------------------------------------------------------------

pro CLASS_peaktable::sort_peaks, field, order
common errors, er
COMMON CLASS_peaktable_reference, ref_peaktable, ref_peak

           pt=obj_new('CLASS_peaktable')
           ;field: 2= energy, 1=intensity, 3=d-spc
           ;order: 2= asc, 1=desc

           if field ge 1 and field le 3 and order ge 1 and order le 2 and self.peakno gt 0 then $
           begin
           ref_peak=self->get_element(0)
           pt->appendpeak, ref_peak
           l=1
           for k=l, self.peakno-1 do $
           begin
             for m=0, l do $
             begin
             case field of
             1:$
             begin
                if order eq 2 then $
                begin
                  if self.peaks[k].intAD[0] lt pt.peaks[m].intAD[0] then $
                  begin
                    ref_peak=self->get_element(k)
                    pt->insert_peak, m, ref_peak
                    l=l+1
                    goto, nex
                  endif
                endif else $
                begin
                  if self.peaks[k].intAD[0] gt pt.peaks[m].intAD[0] then $
                  begin
                    ref_peak=self->get_element(k)
                    pt->insert_peak, m, ref_peak
                    l=l+1
                    goto, nex
                  endif
                endelse
             end
             2:$
             begin
                if order eq 2 then $
                begin
                  if self.peaks[k].energies[0] lt pt.peaks[m].energies[0] then $
                  begin
                    ref_peak=self->get_element(k)
                    pt->insert_peak, m, ref_peak
                    l=l+1
                    goto, nex
                  endif
                endif else $
                begin
                  if self.peaks[k].energies[0] gt pt.peaks[m].energies[0] then $
                  begin
                    ref_peak=self->get_element(k)
                    pt->insert_peak, m, ref_peak
                    l=l+1
                    goto, nex
                  endif
                endelse
             end
             3:$
             begin
                d =1/vlength(self.peaks[k].xyz)
                d1=1/vlength(pt.peaks[m].xyz)
                if order eq 2 then $
                begin
                  if d lt d1 then $
                  begin
                    ref_peak=self->get_element(k)
                    pt->insert_peak, m, ref_peak
                    l=l+1
                    goto, nex
                  endif
                endif else $
                begin
                  if d gt d1 then $
                  begin
                    ref_peak=self->get_element(k)
                    pt->insert_peak, m, ref_peak
                    l=l+1
                    goto, nex
                  endif
                endelse
             end
             else:
             endcase
             endfor ;m
             ref_peak=self->get_element(k)
             pt->appendpeak, ref_peak
             l=l+1
           nex:
           endfor ;k
           lg=pt->get_object()
           self->set_object, lg
           endif
           obj_destroy, pt
end

;---------------------------------------------------------------

pro CLASS_peaktable::initialize

           self.peakno=0
           self.selectedno=0
end

;---------------------------------------------------------------
;---------------------------------------------------------------
;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

pro CLASS_peaktable::rotate_vectors, ran, seli
common Rota, Mtx
pi=acos(-1.0)
xyz=[0.0,0.0,0.0]

          GenerateR, 3, -ran[0]
          Om=Mtx
          GenerateR, 1, -ran[1]
          Ch=Mtx
          ;GenerateR, 2, -ran[2]
          ;Ph=Mtx

      for i=0,self.peakno-1 do $
      begin
         if (seli[0] eq 1 and self.peaks[i].selected[0] eq 1) or $
            (seli[0] eq 2 and self.peaks[i].selected[0] eq 0) or $
            (seli[0] eq 3) then $
         self.peaks[i].XYZ=Om ## Ch ## self.peaks[i].XYZ
      endfor

end

;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

pro CLASS_peaktable::calculate_all_pixels_OLA, oadetector
      for i=0,self.peakno-1 do $
      begin
                self.peaks[i].DetXY=oadetector->calculate_pixels_from_XYZ(self.peaks[i].XYZ,  [0.0,0.0,0.0,0.0,0.0,0.0])
      endfor
end

;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

pro CLASS_peaktable::calculate_all_rprime_OLA, oadetector

      for i=0,self.peakno-1 do $
      begin
                vec1=oadetector->calculate_XYZ_from_pixels(self.peaks[i].DetXY[0],self.peaks[i].DetXY[1], [0.0,0.0,0.0,0.0,0.0,0.0])
                self.peaks[i].xyz=(1/VLength(vec1))#vec1
      endfor

end
;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

pro CLASS_peaktable::zero
      self.peakno=0
end

;XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

function CLASS_peaktable::refineX0, oadetector, ocrystal,wav, v_limit, v_range, v_var, v_old

  ad=oadetector->get_object()
  foms=fltarr(21,2)
  step=v_range/21
  wv=wav
  limit=v_limit
  v_old=ad.beamx

  print, self->reindex(ocrystal, limit)

  for i=-10, 10 do $
  begin
    ad.beamx=v_old+i*step
    oadetector->set_object, ad
    self->recalculate_all_xyz, oadetector, wv
    foms[i+10,1]=self->calculate_indexing_fom(ocrystal, limit)
    print, i, self->reindex(ocrystal, limit)
    foms[i+10,0]=ad.beamx
  end

  ad.beamx=v_old
  oadetector->set_object, ad
  self->recalculate_all_xyz, oadetector, wv
  plot, foms[0:20,0], foms[0:20,1]
  a=min(foms[0:20,1],i)
  if a gt -1.0 then return, foms[i,0] else return, v_old
end
;---------------------------------------------------------------

function CLASS_peaktable::refineY0, oadetector, ocrystal,wav, v_limit, v_range, v_var, v_old

  ad=oadetector->get_object()
  foms=fltarr(21,2)
  step=v_range/21
  wv=wav
  limit=v_limit
  v_old=ad.beamy

  pn=self->reindex(ocrystal, limit)

  for i=-10, 10 do $
  begin
    ad.beamy=v_old+i*step
    oadetector->set_object, ad
    self->recalculate_all_xyz, oadetector, wv
    foms[i+10,1]=self->calculate_indexing_fom(ocrystal, limit)
    foms[i+10,0]=ad.beamy
  end

  ad.beamy=v_old
  oadetector->set_object, ad
  self->recalculate_all_xyz, oadetector, wv
  plot, foms[0:20,0], foms[0:20,1]
  a=min(foms[0:20,1],i)
  if a gt -1.0 then return, foms[i,0] else return, v_old
end

;---------------------------------------------------

pro  CLASS_peaktable::recalculate_all_xyz, oadetector, wv
   gonio=fltarr(6)
   for i=0, self.peakno-1 do $
   begin
     DXY=self.peaks[i].DetXY
     self.peaks[i].XYZ=oadetector->calculate_XYZ_from_pixels1(DXY[0], DXY[1], gonio)
   end
 end

;---------------------------------------------------------------



function CLASS_peaktable::refineD, oadetector, ocrystal,wav, v_limit, v_range, v_var, v_old

  ad=oadetector->get_object()
  foms=fltarr(21,2)
  step=v_range/21
  wv=wav
  limit=v_limit
  v_old=ad.dist

  pn=self->reindex(ocrystal, limit)

  for i=-10, 10 do $
  begin
    ad.dist=v_old+i*step
    oadetector->set_object, ad
    self->recalculate_all_xyz, oadetector, wv
    foms[i+10,1]=self->calculate_indexing_fom(ocrystal, limit)
    foms[i+10,0]=ad.dist
  end

  ad.dist=v_old
  oadetector->set_object, ad
  self->recalculate_all_xyz, oadetector, wv
  plot, foms[0:20,0], foms[0:20,1]
  a=min(foms[0:20,1],i)
  if a gt -1.0 then return, foms[i,0] else return, v_old
end

;---------------------------------------------------------------

function CLASS_peaktable::refineTth, oadetector, ocrystal,wav, v_limit, v_range, v_var, v_old

  ad=oadetector->get_object()
  foms=fltarr(21,2)
  step=v_range/21
  wv=wav
  limit=v_limit

  v_old=ad.ttheta0

  pn=self->reindex(ocrystal, limit)

  for i=-10, 10 do $
  begin
    ad.ttheta0=v_old+i*step
    oadetector->set_object, ad
    self->recalculate_all_xyz, oadetector, wv
    foms[i+10,1]=self->calculate_indexing_fom(ocrystal, limit)
    foms[i+10,0]=ad.ttheta0
  end

  ad.ttheta0=v_old
  oadetector->set_object, ad
  self->recalculate_all_xyz, oadetector, wv
  plot, foms[0:20,0], foms[0:20,1]
  a=min(foms[0:20,1],i)
  if a gt -1.0 then return, foms[i,0] else return, v_old
end

;---------------------------------------------------------------

function CLASS_peaktable::refineLa, oadetector, ocrystal,wav, v_limit, v_range, v_var, v_old

  ad=oadetector->get_object()
  foms=fltarr(21,2)
  step=v_range/21
  wv=wav
  limit=v_limit
  v_old=wav

  pn=self->reindex(ocrystal, limit)

  for i=-10, 10 do $
  begin
    wv=v_old+i*step
    oadetector->set_object, ad
    self->recalculate_all_xyz, oadetector, wv
    foms[i+10,1]=self->calculate_indexing_fom(ocrystal, limit)
    foms[i+10,0]=wv
  end

  wav=v_old
  self->recalculate_all_xyz, oadetector, wav
  plot, foms[0:20,0], foms[0:20,1]
  a=min(foms[0:20,1],i)
  if a gt -1.0 then return, foms[i,0] else return, v_old
end

;---------------------------------------------------------------

pro CLASS_peaktable::refine_rotations, oadetector, ocrystal,wav, v_limit

  ad=oadetector->get_object()
  foms=fltarr(21,2)
  step=2.0/21
  wv=wav
  limit=v_limit
  sum=0.0
  count=0
  for j=0, self.peakno-1 do $
  if self.peaks[j].selected[0] eq 0 then $
  begin
    v_old=self.peaks[j].gonio[5]
    aa=self->calculate_misindex(ocrystal, limit, j)
    for i=-10, 10 do $
    begin
      self.peaks[j].gonio[5]=v_old+i*step
      self->recalculate_xyz, oadetector, wv, j
      foms[i+10,1]=self->calculate_misindex(ocrystal, limit, j)
      foms[i+10,0]=self.peaks[j].gonio[5]
    endfor
  a=min(foms[0:20,1],k)
  self.peaks[j].gonio[5]=foms[k,0]
  self->recalculate_xyz, oadetector, wv, j
  sum=sum+a
  count=count+1
  endif
  print, 'final fom=', sum/count
end

;---------------------------------------------------------------

function CLASS_peaktable::calculate_indexing_fom,  ocrystal, limit

  cry=ocrystal->get_object()
  UB=cry.UB_matrix
  iUB=invert(UB)

  fom=0.0
  count=0

  for i=0, self.peakno-1 do $
     if self.peaks[i].selected[0] eq 0 then $
          begin
           fom=fom+self->calculate_misindex(ocrystal, limit, i)
           count=count+1
          end
  ;print, 'fom= ', fom/count
  if count gt 0 then return, fom/count $
     else return, -1
end

;---------------------------------------------------------------

function CLASS_peaktable::calculate_misindex, ocrystal, limit, i
  cry=ocrystal->get_object()
  UB=cry.UB_matrix
  iUB=invert(UB)
  vec1=iUB##self.peaks[i].XYZ
  if self.peaks[i].selected[0] eq 0 then return, vlength(vec1-self.peaks[i].HKL) else return, -1.0
end
;---------------------------------------------------------------

; performs distance search in peaktable
; distance is defined as pixel distance within image
; input is the peak with which you are compating
; output is a table with two colums. Column 0 are distances (in pixels) column 2 are indices of respective peaks in self.peaks
; the results are not sorted


function CLASS_peaktable::find_closest_peak1, ref_peak, START_NO=sn

pk=obj_new('CLASS_peak')

tab=fltarr(self.peakno-sn,2)

for i=sn, self.peakno-1 do $
begin
  pk->set_object, self.peaks[i]
  disti=pk->distance(ref_peak)
  tab[i-sn,0]=disti
  tab[i-sn,1]=i
end
;print,'mindist= ', distmin
obj_destroy, pk
return, tab

end
;----------------------------------------------
function CLASS_peaktable::find_closest_peak, ref_peak

pk=obj_new('CLASS_peak')

tab=[1000.0,9999]

for i=0, self.peakno-1 do $
begin
  pk->set_object, self.peaks[i]
  disti=pk->distance(ref_peak)
  if disti lt tab[0] then $
  begin
    tab[0]=disti
    tab[1]=i
  endif
end
;print,'mindist= ', distmin
obj_destroy, pk
return, tab

end

;----------------------------------------------------------

pro CLASS_peaktable::calculate_SSD_from_pixels, gonio
common odet, oadetector
outgonio=fltarr(2,3)

 for i=0, self.peakno do $
 begin
   outgonio=oadetector->calculate_EDDangles_from_pixels(self.peaks[i].detxy[0], self.peaks[i].detxy[1], gonio)
   if abs(outgonio[1,1]) lt abs(outgonio[0,1]) then $
   self.peaks[i].gonioSS=[0.0,outgonio[1,0], 0.0,outgonio[1,1], outgonio[1,2],0.0] else $
   self.peaks[i].gonioSS=[0.0,outgonio[0,0], 0.0,outgonio[0,1], outgonio[0,2],0.0]
 endfor

end



;-------------------------------------------

function distance, x1,y1,x2,y2
return, sqrt((x1-x2)^2+(y1-y2)^2)
end

;----------------------------------------------------------------------------

pro CLASS_peaktable::read_object_from_file, fname

  common peakread, prchoice
  common odet, oadetector
  COMMON CLASS_peaktable_reference, ref_peaktable, ref_peak
  COMMON wavelength, wv
  gonio=[0.0,0.0,0.0,0.0,0.0,0.0]
            prchoice=1
            ;if self.peakno ne 0 then peak_table_not_empty
            self->initialize
            case prchoice of
            2: $ ; overwrite
            begin
              self->initialize
              free_lun, 4
              OPENR, 4, fname
              A=assoc(4, ref_peak)
              i=0
              while (not eof(4)) do begin
                ref_peak=A[i]
                ref_peak.xyz=oadetector->calculate_XYZ_from_pixels(ref_peak.detXY[0], ref_peak.detXY[1], gonio)
                self->appendpeak, ref_peak
                i=i+1
              endwhile
              CLOSE, 4
              free_lun, 4
            end ; of overwrite
            1: $
            begin
              free_lun, 4
              OPENR, 4, fname
              A=assoc(4, ref_peak)
              i=0
              while (not eof(4)) do begin
                ref_peak=A[i]
                ;ref_peak.xyz=oadetector->calculate_XYZ_from_pixels(ref_peak.detXY[0], ref_peak.detXY[1], gonio)
                self->appendpeak, ref_peak
                i=i+1
              endwhile
              CLOSE, 4
              free_lun, 4
            end ; of append
            else:
            endcase
 END
;----------------------------------------------------------------------------

pro CLASS_peaktable::APPEND_object_from_file, fname
common odet, oadetector
COMMON CLASS_peaktable_reference, ref_peaktable, ref_peak
COMMON wavelength, wv

              free_lun, 4
              OPENR, 4, fname
              A=assoc(4, ref_peak)
              i=0
              while (not eof(4)) do begin
                ref_peak=A[i]
                self->appendpeak, ref_peak
                i=i+1
              endwhile
              CLOSE, 4
              free_lun, 4
 END
;----------------------------------------------------------------------------

pro CLASS_peaktable::write_object_to_file, fname, zeroint

            COMMON CLASS_peaktable_reference, ref_peaktable, ref_peak

            if n_params() eq 1 then zeroint=0
            free_lun, 4
            OPENW, 4, fname
            A=assoc(4, ref_peak)
            i=self.peakno
            count=0
            for i=0, self.peakno-1 do $
            begin
               ref_peak=self->get_element(i)
               if ref_peak.intad[0] gt ref_peak.intad[1] or zeroint eq 1 then $
               begin
                A[count]=ref_peak
                count=count+1
               endif
            end
            CLOSE, 4
            free_lun, 4
 END

;------------------------------------------------------
pro CLASS_peaktable::calculate_all_detXY_from_xyz, oadetector, wv
  ktth=read_kappa_and_ttheta()

  for i=0, self.peakno-1 do $
  begin
    self.peaks[i].gonio[1]=ktth[1]
    self.peaks[i].gonio[0]=ktth[0]

    self.peaks[i].detXY=oadetector->calculate_pixels_from_xyz(self.peaks[i].xyz, self.peaks[i].gonio)
  end
end
;------------------------------------------------------

pro CLASS_peaktable::calculate_all_xyz_from_pix, oadetector, wv
ktth=read_kappa_and_ttheta()
  for i=0, self.peakno-1 do $
  begin
  ; pix, gonio, lambda
    pix=[self.peaks[i].detxy[0], self.peaks[i].detxy[1]]
    gonio=self.peaks[i].gonio
    gonio[0]=ktth[0]
    gonio[1]=ktth[1]
    ;*************************** NEW CODE ********************
    ;gonio[3] = read_om_rotation_dir() * gonio[3]
    ;*************************** NEW CODE ********************
    ;gonio[4]=ktth[0]
    ty=omega_or_energy()
    if ty[0] eq 1 then xyz=oadetector->calculate_XYZ_from_pixels_mono(pix, gonio, wv) else $
    xyz=oadetector->calculate_XYZ_from_pixels_mono(pix, gonio, kev_to_a(self.peaks[i].energies[0]))
    self.peaks[i].xyz=xyz
  endfor

  ;draw_rpeaks, self
end
;------------------------------------------------------

pro CLASS_peaktable::remove_peaks_outside_aa, oadetector
  ad=oadetector->get_object()
  for i=0, self.peakno-1 do $
  begin
    x=self.peaks[i].detxy[0]-ad.nopixx/2.
    y=self.peaks[i].detxy[1]-ad.nopixy/2.
    if sqrt(x^2+y^2) gt ad.nopixx/2-10. then self.peaks[i].selected[0]=1 else self.peaks[i].selected[0]=0
  endfor
  self->delete_selected
end
;------------------------------------------------------
pro CLASS_peaktable::calculate_all_xyz_from_pix_laue, oadetector

  for i=0, self.peakno-1 do $
  begin
    pix=[self.peaks[i].detxy[0], self.peaks[i].detxy[1]]
    gonio=self.peaks[i].gonio
    xyz=oadetector->calculate_XYZ_from_pixels_mono(pix, gonio, kev_to_A(self.peaks[i].energies[0]))
    self.peaks[i].xyz=xyz
  endfor

  ;draw_rpeaks, self
end

;------------------------------------------------------

pro CLASS_peaktable::calculate_all_xyz_from_edd, oadetector
  ad=oadetector->get_object()
  zeros=[0.0,ad.omega0,0.0]
  pi=acos(-1)
  for i=0, self.peakno-1 do $
  begin
     xyz=calculate_xyz_from_EDD(self.peaks[i].gonioSS, zeros)
     xyz=xyz/vlength(xyz)
     lambda = 12.39842/self.peaks[i].energies[0]
     leng=lambda/(2.0*sin(self.peaks[i].gonioSS[0]*pi/360.0))
     self.peaks[i].xyz=xyz/leng
  endfor
end


;------------------------------------------------------
pro CLASS_peaktable::set_all_gonio, gonio
  for i=0, self.peakno-1 do $
     self.peaks[i].gonio=gonio
end


;------------------------------------------------------
pro CLASS_peaktable::apply_rotation_mtx, RR, wv, oad

  for i=0, self.peakno-1 do $
  begin
     self.peaks[i].xyz=RR ## self.peaks[i].xyz
     om=get_omega(A_to_kev(wv), self.peaks[i].xyz)
     if abs(om[0]-self.peaks[i].gonio[3]) lt abs(om[1]-self.peaks[i].gonio[3]) then self.peaks[i].gonio[3]=om[0] else self.peaks[i].gonio[3]=om[1]
     self.peaks[i].DetXY=oad->calculate_pixels_from_xyz(self.peaks[i].xyz, self.peaks[i].gonio)
  endfor
end


;------------------------------------------------------
;------------------------------------------------------
pro CLASS_peaktable::apply_rotation, angles

common odet, oadetector

common Rota, Mtx
pi=acos(-1.0)
xyz=[0.0,0.0,0.0]

          GenerateR, 3, -angles[0]
          Om=Mtx

          GenerateR, 1,  angles[1]
          Ch=Mtx
          iCh=invert(Ch)

          GenerateR, 2,  angles[2]
          Chy=Mtx
          iChy=invert(Chy)


          gonio=[0.0,0.0,0.0,-angles[0],angles[1],0.0]


  for i=0, self.peakno-1 do $
  begin

     ;xyz1=Om##Chy##Ch##iChy##self.peaks[i].xyz
     DXYZ=oadetector->calculate_pixels_from_xyz(self.peaks[i].xyz, gonio)
     ;self.peaks[i].xyz=xyz1
     self.peaks[i].DetXY=DXYZ
  endfor
end
;------------------------------------------------------

pro CLASS_peaktable::apply_dm, oadetector, mv, om0, omr
  od0=oadetector->get_object()
  od=od0
  bx0=od0.dist
  for i=0, self.peakno-1 do $
  begin
    m=(self.peaks[i].gonio[3]-om0)/omr
    od.dist=bx0+mv*m
    oadetector->set_object, od
    self.peaks[i].detXY=oadetector->calculate_pixels_from_xyz(self.peaks[i].xyz, self.peaks[i].gonio)
  endfor
  oadetector->set_object, od0
end
;------------------------------------------------------

function CLASS_peaktable::reindex, ocrystal, limit

  cry=ocrystal->get_object()
  UB=cry.UB_matrix
  iUB=invert(UB)
  ind=0
  self->unselect_all
  for i=0, self.peakno-1 do $
  begin
     vec=iUB##self.peaks[i].XYZ

     if (abs(vec[0]-round(vec[0])) gt limit) or $
        (abs(vec[1]-round(vec[1])) gt limit) or $
        (abs(vec[2]-round(vec[2])) gt limit) or $
        (abs(vec[0]) lt 0.01 and abs(vec[1]) lt 0.01 and abs(vec[2]) lt 0.01) then $
     begin
        self.peaks[i].HKL=[0,0,0]
        self.peaks[i].selected[0]=1
        self.selectedno=self.selectedno+1
     endif else $
     begin
        self.peaks[i].HKL=round(vec)
        self.peaks[i].selected[0]=0
        ind=ind+1
     endelse
  endfor
  ;print, 'indexed: ', ind
  ;draw_rpeaks, self
  return, ind
end

;---------------------------------------------------------
function CLASS_peaktable::calculate_2thetas, oad, wv
; PARAMETERS:
;  oad - area detector object (oadetector global variable)
;  wv  - wavelength (global variable)
ret=fltarr(self.peakno)
gonio=fltarr(6)
for i=0, self.peakno-1 do $
begin
  self.peaks[i].xyz=oad->calculate_XYZ_from_pixels_mono(self.peaks[i].detXY, gonio, wv)
  ret[i]=2.0*calculate_theta_from_xyz(self.peaks[i].xyz)
endfor
return, ret
end
;---------------------------------------------------------
function CLASS_peaktable::peak_list

       list2=''
       list=''
       for i=1, self.peakno do begin
            list2=string(self.peaks[i-1].selected[0])
            list2=list2+string(i)
            list2=list2+string(self.peaks[i-1].HKL[0])
            list2=list2+string(self.peaks[i-1].HKL[1])
            list2=list2+string(self.peaks[i-1].HKL[2])
            list2=list2+string(self.peaks[i-1].XYZ[0])
            list2=list2+string(self.peaks[i-1].XYZ[1])
            list2=list2+string(self.peaks[i-1].XYZ[2])
            list2=list2+string(self.peaks[i-1].energies[0])
            list2=list2+string(self.peaks[i-1].intAD[0])
            list2=list2+string(1/vlength(self.peaks[i-1].XYZ))
            if i eq 1 then list=list2 else list=[list,list2]
        endfor
        return, list
end

;----------------------------------------------------------------------------

function CLASS_peaktable::peakno
    return, self.peakno
end

;----------------------------------------------------------------------------
function CLASS_peaktable::selectedno
    return, self.selectedno
end

;----------------------------------------------------------------------------
pro CLASS_peaktable::set_peak_box_size, bx, whichpeak

if n_params() eq 1 then $
begin
  for i=0, self.peakno-1 do $
    self.peaks[i].intssd[0:1]=[bx[0],bx[0]]
endif else $
begin
  if whichpeak ge 0 and whichpeak lt self.peakno then self.peaks[whichpeak].intssd[0:1]=[bx[0],bx[0]]
endelse

end
;----------------------------------------------------------------------------
pro CLASS_peaktable::set_zero_peak_box_size, bx

  for i=0, self.peakno-1 do $
    if self.peaks[i].intssd[0] eq 0 then self.peaks[i].intssd[0:1]=[bx[0],bx[0]]
end
;----------------------------------------------------------------------------
pro CLASS_peaktable::set_box_size, bx

  for i=0, self.peakno-1 do $
    self.peaks[i].intssd[0:1]=[bx[0],bx[0]]
end
;----------------------------------------------------------------------------


pro CLASS_peaktable::apply_transform, UT

  for i=0, self.peakno-1 do $
    self.peaks[i].hkl=transpose(UT) ## self.peaks[i].hkl
end


function OLA_accessible_range, pn, om0, ch0

; P.Dera, 04/05/2006
;
; determines for a given peak, the range of omega and chi rotation that keeps the
; peak inside the active region of the detector
; uses oadetector through common block
;
; arguments: pix - pixel coordinates of the peak at 0 goniometer position
;            om0 - proposed range of omega rotation - [start, range, offset]
;            ch0 - proposed range of omega rotation - [start, range, offset]
;
; results:   res - omega start and end, chi start and end, number of steps (every x deg)
;

vis=fltarr(400,3)

res={rs, om:[0.0,0.0,0.0],ch:[0.0,0.0,0.0], leng:0L}

common Rota, Mtx
common odet, oadetector

         om0=[float(om0[0]),float(om0[1]),float(om0[2])]
         ch0=[float(ch0[0]),float(ch0[1]),float(ch0[2])]
         om1=fltarr(2)
         ch1=fltarr(2)
         omo=float(om0[2])
         cho=float(ch0[2])

         data=measure_OLA_curve(pn, 400, [om0,omo],[ch0,cho], points)

         pix0=[0.0,0.0]

         COMMON peaktable_objects, optable1,optable2, optable3, optable0

         pt=optable1->get_object()

         pix0=pt.peaks[long(pn)].detxy

         for i=0, 399 do $
         begin
           pix=[points[i,0],points[i,1]]
           vis[i,0]=data[i,0]
           vis[i,1]=data[i,32]
           if beam_stop(pix) eq 1 or detector_edge(pix) eq 1 or same_side_of_the_beam(pix, pix0) eq 0 then  $
                    vis[i,2]=0 else $
                    vis[i,2]=1
         endfor
         i=0
         ki=[0,0]

         ; determine starting angles

         om1[0]=vis[0,0]
         ch1[0]=vis[0,1]

         if (vis[0,2] eq 0) then $ ; beginning not visible
         begin
           while (vis[i,2] eq 0) and (i lt 399) do $
           begin
             om1[0]=vis[i,0]
             ch1[0]=vis[i,1]
             ki[0]=i
             i=i+1
           endwhile
           if i eq 399 then $ ; no visibility at all
           begin
             om1[1]=-om1[0]+vis[i,0]
             ch1[1]=-ch1[0]+vis[i,1]
             pix_dif=[0,0]
           endif else $ ; visibility found
           begin
             while vis[i,2] eq 1 and i lt 399 do $
             begin
               om1[1]=-om1[0]+vis[i,0]
               ch1[1]=-ch1[0]+vis[i,1]
               ki[1]=i
               i=i+1
             endwhile
             pix_0=[points[ki[0],0],points[ki[0],1]]
             pix_1=[points[ki[1],0],points[ki[1],1]]
             pix_dif=pix_1-pix_0
          endelse
        endif else $ ; beginning visible
        begin
           om1[0]=vis[0,0]
           ch1[0]=vis[0,1]
           ki[0]=0
           while (vis[i,2] eq 1) and (i lt 399) do $
           begin
             om1[1]=-om1[0]+vis[i,0]
             ch1[1]=-ch1[0]+vis[i,1]
             ki[1]=i
             i=i+1
           endwhile
             pix_0=[points[ki[0],0],points[ki[0],1]]
             pix_1=[points[ki[1],0],points[ki[1],1]]
             pix_dif=pix_1-pix_0
        endelse

           res.leng=sqrt(pix_dif[0]*pix_dif[0]+pix_dif[1]*pix_dif[1])
           res.om=[om1,omo]
           res.ch=[ch1,cho]
           return, res
end


;--------------------------------------
;finds and eliminates multiple copies of a peak obtained from step scan

pro CLASS_peaktable::find_multiple_peak_copies

i=0
pn=self->peakno()

cgProgressBar = Obj_New("CGPROGRESSBAR", /Cancel)
cgProgressBar -> Start
while i lt pn-2 do $
begin
    ref_peak=self->get_element(i)
    di=self->find_closest_peak1(ref_peak,START_NO=i+1)
    di[*,1]=di[*,1]
    w=where(di[*,0] lt 3)
    if w[0] ne -1 then $
    begin
     di=[[di],transpose([0,i])]
     w=[w,n_elements(di2)/2]
     m=max(self.peaks[di[w,1]].intAD[0],kk)
     self->select_peaks, di[w,1]
     self->unselect_peak, di[w[kk],1]
     self->delete_selected
     pn=self->peakno()
     cgProgressBar -> Update, float(i)/float(pn)*100.0
     if kk ne i then i=i+1
    endif else i=i+1
endwhile
 cgProgressBar -> Destroy
end

;-------------------------------------------------------------------

pro class_peaktable__define
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
                IntSSD   : FLTARR(2),   $   ; Will now be used to store individualized peak fitting box size
                Adp      : ref_adp}         ; Area detector parameters

 CLASS_peaktable={CLASS_peaktable, $
                 peakno : 0L,$
                 selectedno : 0L,$
                 peaks : REPLICATE(ref_peak, 10000)}

 ref_peaktable=CLASS_peaktable

end

;-------------------------------------------------------------------

