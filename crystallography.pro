;  Last change 09/05/2008 PD
;           -- added function get_omega

;**************************************************************************
;*****
;*****   Library of crystallographic routines written in Dec. 2006
;*****
;*****   Include by calling 'crystallography'
;*****
;**************************************************************************
;
; List of routines:


;
; function angle_between_hkls, h1, h2, lp
; FUNCTION ERROR_estimates_from_d, lp, ds, hkls, sym
; FUNCTION ERROR_estimates_from_xyz, ub, xyzs, hkls, sym
; function automatic_lp_refinement, lp, ds, hkls, sym
; function flags_from_sym, sym
; tth_from_hkl_and_lp, hkl, lp, wv
; pro apply_symmetry_to_lp, lp, ch, sym
; function lp_error_estimate, lp, ds, hkls, lpn, DX, sym
; function lp_error_estimate_xyz, ub, xyzs, hkls, lpn, DX, sym
; function refine_lp, lp, ds, hkls, step1, step2, flags, sym, st
; function d_from_lp_and_hkl, lp, hkl
; function A_to_kev, la
; function kev_to_A, E
; function d_from_tth_and_en, tth, en
; function en_from_tth_and_d, tth, d
; function tth_from_en_and_d, en, d
; function ang, v, w
; function vlength, v
; function dotprod, w,v
; function b_from_lp, lp
; function lp_from_ub, ub
; function V_from_ub, ub
; function U_from_UB, ub
; function b_from_UB, ub
; function get_omega, en , xyz
;                  From xyz and energy  calculates the omega angle (in deg) at which xyz will come
;                  into diffracting position during omega scan at chi 0
;                  if diffraction position inaccessible in omega scan returns [-1000,-1000]
; function test_lp_against_ds, lp,ds, hkls
; function test_ub_against_xyz, ub, xyzs, hkls
; function find_closest_d, lp, d, hkl
; function hkl_from_ub_and_xyz, ub, xyz

function ang, v, w
; calculates  angle between two vectors
; output in deg.
  return, acos(dotprod(w,v)/vlength(v)/vlength(w))*!radeg
end

;-----------------------------------------

function vlength, v
; calculates length of vector
 return, sqrt(dotprod(v,v))
end

;-----------------------------------------

function dotprod, w,v
;calculates scalar product
 dot=0.0
 for i=0, 2 do dot=dot+w[i]*v[i]
 return, dot
end

;-----------------------------------------

;-----------------------------------------
function syst_extinction, exti,hkl
h=hkl[0]
k=hkl[1]
l=hkl[2]
          if  exti eq 'P' or $
             (exti eq 'Ro' and (long((-h+k+l)/3.0) eq (-h+k+l)/3.0)) or $
             (exti eq 'Rr' and (long((h-k+l)/3.0) eq (h-k+l)/3.0)) or $
             (exti eq 'F' and (long((h+k)/2.0) eq (h+k)/2.0) and  (long((k+l)/2.0) eq (k+l)/2.0) and  (long((h+l)/2.0) eq (h+l)/2.0)) or $
             (exti eq 'I' and (long((h+k+l)/2.0) eq (h+k+l)/2.0)) or $
             (exti eq 'A' and (long((k+l)/2.0) eq (k+l)/2.0)) or $
             (exti eq 'B' and (long((h+l)/2.0) eq (h+l)/2.0)) or $
             (exti eq 'C' and (long((h+k)/2.0) eq (h+k)/2.0)) then return, 1 else return, 0

end

;-----------------------------------------

;-----------------------------------------

function chi_at_phi0_from_xyz, xyz
;--- on Jan 03, 2011 this function is being replaced by a class method with the same name

; calculates the detector out of horiz. plane angle for a reflection from the Cartesian
; coordinates of reciprocal vector
   sd=[0., xyz[1],xyz[2]]
   nu=ang_between_vecs(sd,[0.,-1.,0.])
   if sd[2] lt 0.0 then y=nu else y=-nu
 return, y
end
;-----------------------------------------

function phi_at_bisect_from_xyz, xyz
;--- on Jan 03, 2011 this function is being replaced by a class method with the same name

; calculates the detector out of horiz. plane angle for a reflection from the Cartesian
; coordinates of reciprocal vector
   sd=[xyz[0],xyz[1],0]
   nu=ang_between_vecs(sd,[0.,-1.,0.])
   if sd[2] lt 0.0 then y=nu else y=-nu
 return, y
end
;-----------------------------------------

function eulerian_angles_phi0, xyz, en

; four sets of setting angles are calculated,
; two for positive 2theta nd two for negative
; chi differs by 180
; accessibility of the positions in dac is tested

common Rota, Mtx

  ttheta = 0.0
  omega  = 0.0
  chi    = 0.0
  angs=fltarr(4,4)
  tth=tth_from_en_and_d(en, 1.0/vlength(xyz))

  chi=chi_at_phi0_from_xyz(xyz)
  GenerateR, 1, chi
  Rch=mtx
  xyz1=Rch ## xyz
  om=get_omega(en , xyz1)

  GenerateR, 3, -om[0]
  Rom=mtx
  xyz2a=Rom ## xyz1

  GenerateR, 3, -om[1]
  Rom=mtx
  xyz2b=Rom ## xyz1

  if xyz2a[2] gt 0.0 then $
  begin
    angs[0,*]=[+tth, -om[0], chi,      0.0, 1.]
    angs[1,*]=[-tth, -om[1], chi,      0.0, 1.]
    angs[2,*]=[+tth,  om[1], chi+180., 0.0, 1.]
    angs[3,*]=[-tth,  om[0], chi+180,  0.0, 1.]
  endif else $
  begin
    angs[0,*]=[-tth, -om[0], chi,      0.0, 1.]
    angs[1,*]=[+tth, -om[1], chi,      0.0, 1.]
    angs[2,*]=[-tth,  om[1], chi+180., 0.0, 1.]
    angs[3,*]=[+tth,  om[0], chi+180,  0.0, 1.]
  endelse
  print, '--------------'
  print, angs
  print, '--------------'

  return, angs
end

;-----------------------------------------

function eulerian_angles_bisect, xyz, en

; four sets of setting angles are calculated,
; two for positive 2theta nd two for negative
; chi differs by 180
; accessibility of the positions in dac is tested
; assumes that 2theta, omega and phi rotate in the same direction

common Rota, Mtx

  ttheta = 0.0
  omega  = 0.0
  chi    = 0.0
  angs=fltarr(4,5)
  tth=tth_from_en_and_d(en, 1.0/vlength(xyz))

  chi=chi_at_phi0_from_xyz(xyz)
  GenerateR, 1, chi
  Rch=mtx
  xyz1=Rch ## xyz
  om=get_omega(en , xyz1)

  GenerateR, 3, -om[0]
  Rom=mtx
  xyz2a=Rom ## xyz1

  GenerateR, 3, -om[1]
  Rom=mtx
  xyz2b=Rom ## xyz1

  if xyz2a[2] gt 0.0 then $
  begin
    angs[0,*]=[+tth, +tth/2.0, chi,     -om[0]-tth/2.0, 1.]
    angs[1,*]=[-tth, -tth/2.0, chi,     -om[1]+tth/2.0, 1.]
    angs[2,*]=[+tth, +tth/2.0, chi+180., om[1]-tth/2.0, 1.]
    angs[3,*]=[-tth, -tth/2.0, chi+180., om[0]+tth/2.0, 1.]
  endif else $
  begin
    angs[0,*]=[-tth, -tth/2.0, chi,     -om[0]+tth/2.0, 1.]
    angs[1,*]=[+tth, +tth/2.0, chi,     -om[1]-tth/2.0, 1.]
    angs[2,*]=[-tth, -tth/2.0, chi+180., om[1]+tth/2.0, 1.]
    angs[3,*]=[+tth, +tth/2.0, chi+180., om[0]-tth/2.0, 1.]
  endelse
  print, '--------------'
  print, angs
  print, '--------------'

  return, angs
end

;-----------------------------------------


function A_to_kev, la
; changes lamda in A to energy in keV
  return, 12.39842/la
end

;-----------------------------------------

function kev_to_A, E
; changes energy in keV to lambda in A
  return, 12.39842/E
end

;-----------------------------------------


function en_from_tth_and_d, atth, d
 tth=atth/!radeg
; calculates energy from bragg angle and d-spc
 la=2.0*d*sin(tth/2.0)
 return, A_to_kev(la)
end

;-----------------------------------------
function ttheta_from_xyz, xyz
if xyz[0] gt 0.0 then return, 0 else $
begin
 e1=[-1.0,0.0,0.0]
 al=ang(xyz, e1)
 tth=2.0*(90.0-al)
 return, tth
 end
end
;-----------------------------------------
function en_from_xyz, xyz
 tth=ttheta_from_xyz(xyz)
 d=1.0/vlength(xyz)
 return,  en_from_tth_and_d(tth, d)
end
;-----------------------------------------

function b_from_lp, lp
;calculates metric matrix from lattice paramteres
as=lp[0]
bs=lp[1]
cs=lp[2]
al=lp[3]/!radeg
be=lp[4]/!radeg
ga=lp[5]/!radeg
b=fltarr(3,3)
b[0,0]=as
b[0,1]=0.0
b[0,2]=0.0
b[1,0]=bs*cos(ga)
b[1,1]=bs*sin(ga)
b[1,2]=0.0
b[2,0]=cs*cos(be)
b[2,1]=cs*(cos(al)-cos(be)*cos(ga))/sin(ga)
b[2,2]=cs*sqrt(sin(ga)^2-(cos(al)^2+cos(be)^2-2.0*cos(al)*cos(be)*cos(ga)))/sin(ga)
bs=transpose(invert(b))
;print, b
return, bs
end
;-----------------------------------------

function tth_from_en_and_d, en, d
; calculates bragg angle from energy and d-spc
 n=n_elements(d)
 t=fltarr(n)
 la=kev_to_A(En)
 for i=0, n-1 do t[i]=2.0*asin(la/(2.0*d[i]))*!radeg
 return, t

end

;--------------------------------------
function tth_from_hkl_and_lp, hkl, lp, wv
  B=b_from_lp(lp)
  xyz=B ## hkl
  d=1./vlength(xyz)
  return, tth_from_en_and_d(a_to_kev(wv),d)
end
;-----------------------------------------
function ttheta_from_xyz_and_en, xyz, en
  d=1.0/vlength(xyz)
  tth=tth_from_en_and_d(en, d)
  return, tth
end
;-----------------------------------------

function d_from_lp_and_hkl, lp, hkl
; calculates d-spc from lattice parameters and Miller indices
  b=b_from_lp(lp)
  xyz=hkl # b
  return, 1./vlength(xyz)
end

;-----------------------------------------

function d_from_tth_and_en, atth, en
tth=atth/!radeg
; calculated d from braggg angle and energy
 la=A_to_kev(en)
 return, la/(2.0*sin(tth/2.0))
end

;-----------------------------------------

function en_from_tth_and_d, atth, d
tth=atth/!radeg
; calculates energy from bragg angle and d-spc
 la=2.0*d*sin(tth/2.0)
 return, A_to_kev(la)
end


;-----------------------------------------


function lp_from_ub, ub
;calculates lattice paramters from ub matrix
 gs=transpose(ub)##ub
 g=invert(gs)
 lp=fltarr(6)
 lp[0]=sqrt(g[0,0])
 lp[1]=sqrt(g[1,1])
 lp[2]=sqrt(g[2,2])
 lp[3]=acos(g[1,2]/(lp[1]*lp[2]))*!radeg
 lp[4]=acos(g[0,2]/(lp[0]*lp[2]))*!radeg
 lp[5]=acos(g[0,1]/(lp[0]*lp[1]))*!radeg
 return, lp
end

;-----------------------------------------

function V_from_ub, ub
;calculates unit cell volume from ub matrix
 gs=transpose(ub)##ub
 g=invert(gs)
 return, sqrt(determ(g))
end

;-----------------------------------------

function U_from_UB, ub
;calculates orientation matrix u from ub matrix
  lp=lp_from_ub(ub)
  B=b_from_lp(lp)
  return, UB ## invert(B)
end

;-----------------------------------------
function b_from_UB, ub
;calculates orientation matrix u from ub matrix
  lp=lp_from_ub(ub)
  B=b_from_lp(lp)
  return, b
end

;-----------------------------------------
function hkl_from_ub_and_xyz, ub, xyz
; calculates miller indices (floating point) from ub matrix and xyz coordinates
    iUB=invert(UB)
    hkl=iUB ## xyz
    return, hkl
end

;-----------------------------------------------------------------
;-- Calculates the solutions of equation a*sin(x)+b*cos(x)+c=0 ---
; INPUT:
; a, b, c
;
; OUTPUT
; two solutions in degrees
; if no solutions, returns [-1000,-1000]
function sincos, a,b,c
del=-c^2+a^2+b^2
if del lt 0 then res=[-1000,-1000] else $
begin
 x1=-2.0*atan((a+sqrt(del))/(c-b))
 x2=-2.0*atan((a-sqrt(del))/(c-b))
 res=-[x1,x2]*!radeg
endelse
return, res
end


;-----------------------------------------------------------------


function solve_general_axis, en, xyz, gonio
common Rota, Mtx
 om=0;-10.0
 chi= gonio[4]
 GenerateR, 3, om
 om_mtx=mtx
 GenerateR, 1, chi
 chi_mtx=mtx
 A=om_mtx # chi_mtx
 return, general_axis(invert(A),xyz,en)
end

;---
function AA, x, x1,A
 return, -A[1,0]*x[0]*x1[0]-A[1,1]*x[1]*x1[0]-A[1,2]*x[2]*x1[0]+A[0,0]*x[0]*x1[1]+A[0,1]*x[1]*x1[1]+A[0,2]*x[2]*x1[1]
end
;---
function BB1, x, x1,A
 return,  A[0,0]*x[0]*x1[0]+A[0,1]*x[1]*x1[0]+A[0,2]*x[2]*x1[0]+A[1,0]*x[0]*x1[1]+A[1,1]*x[1]*x1[1]+A[1,2]*x[2]*x1[1]
end
;---
function CC, x, x1,A
 return,  A[2,0]*x[0]*x1[2]+A[2,1]*x[1]*x1[2]+A[2,2]*x[2]*x1[2]
end

;-------------------

function general_axis, A, vec, en
;------------------------------------------------------------------
; Finds phi angles at which vector Vec is in diffracting position
; calculations allow to specify rotation matrix M that represents om-chi or om-kappa component
;------------------------------------------------------------------
; A   - rotation matrix for omega and chi
; Vec - Cart. coordinates of reciprocal vec.
; Wv  - wavelength

 d=1.0/vlength(vec)
 ttheta=tth_from_en_and_d(en,d)
 xyz=Vec*d
 xyz1=A#[1.0,0.0,0.0]
 return, sincos(AA(xyz,xyz1,A),BB1(xyz,xyz1,A),CC(xyz,xyz1,A)-cos((90.0+ttheta/2.0)/!radeg))
end

;--------------------------------------------------------------------
function get_omega, en , xyz
; From xyz and energy  calculates the omega angle (in deg) at which xyz will come
; into diffracting position during omega scan at chi 0
; if diffraction position inaccessible in omega scan returns [-1000,-1000]
common Rota, Mtx

 d=1./vlength(xyz)
 tthe=tth_from_en_and_d(en, d)
 ;print,tthe/2.
 xyz1=xyz/vlength(xyz)
 x=xyz1[0]
 y=xyz1[1]
 z=xyz1[2]
 tth=cos((90.+tthe/2.0)/!radeg)

 b1=(x^2*y^2-y^2*tth^2+y^4)
 if b1 lt 0 then goto, err
 b2=(x^2+y^2)

 a1=-(x*(x*tth-sqrt(b1))/b2 -tth)/y
 a2=(x*tth-sqrt(b1))/b2
 om1=atan(a1,a2)

 a1=-(x*(x*tth+sqrt(b1))/b2 -tth)/y
 a2=(x*tth+sqrt(b1))/b2
 om2=atan(a1,a2)

 return, [om1*!radeg, om2*!radeg]
 err: return, [-1000, -1000]
end

;--------------------------------------------------------------------



function flags_from_sym, sym

; Creates a flag vector, based on symmetry for controlling refinement
; INPUT:
;    sym - symmetry code, as in
; OUTPUT:
;    refinement flag vector intarr(6)
;    0 means do not refine, 1 means refine
;------
; Symmetry codes
; 0  - triclinic
; 11 - monoclinic a
; 12 - monoclinic b
; 13 - monoclinic c
; 2  - orthorhombic
; 3  - tetragonal
; 4  - hexagonal
; 5  - cubic
; 6  - rhombohedral


  case sym of
  0:  flags=[0,0,0,0,0,0]
  11: flags=[0,0,0,0,1,1]
  12: flags=[0,0,0,1,0,1]
  13: flags=[0,0,0,1,1,0]
  2:  flags=[0,0,0,1,1,1]
  3:  flags=[0,1,1,1,1,1]
  4:  flags=[0,1,1,1,1,1]
  5:  flags=[0,1,1,1,1,1]
  6:  flags=[1,0,0,0,0,0]
  else:
  endcase
  return, flags
end

;----------------------------------------------------------
function test_ub_against_xyz, ub, xyzs, hkls
; calculates average  difference between calculated and measured d-spc
 sz=size(hkls)
 if sz[0] eq 0 then sz=sz[2] else sz=sz[1]
 sum=0.0
 for i=0, sz-1 do $
 begin
  xyz=ub ## hkls[0:2,i]
  sum=sum+vlength(xyzs[0:2, i]-xyz)
 end
 return, sum/sz
end

;-----------------------------------------

function test_lp_against_ds, lp,ds, hkls
; calculates average  difference between calculated and measured d-spc
 sz=size(ds)
 if sz[0] eq 0 then sz=sz[2] else sz=sz[1]
 sum=0.0
 for i=0, sz-1 do $
 begin
  dc=d_from_lp_and_hkl(lp, hkls[0:2,i])
  ;print, dc
  sum=sum+abs(ds[i]-dc)
 end
 return, sum/sz
end

;-----------------------------------------

pro apply_symmetry_to_lp, lp, ch, sym
;
; Applies symmetry constraints to lattice parameters, based on change in lp index ch
; INPUT:
;    lp  - lattice parameters vector
;    ch  - index of the changing lp
;    sym - symmetry code
; OUTPUT:
;    lp values re changed to the new ones, compliant with the symmetry
;---------------
; Symmetry codes
; 0  - triclinic
; 11 - monoclinic a
; 12 - monoclinic b
; 13 - monoclinic c
; 2  - orthorhombic
; 3  - tetragonal
; 4  - hexagonal
; 5  - cubic
; 6  - rhombohedral
lp1=lp
case sym  of
0:
11:begin ; mono a
     lp1[4]=90.0
     lp1[5]=90.0
  end
12:begin ; mono b
     lp1[3]=90.0
     lp1[5]=90.0
  end
13:begin ; mono c
     lp1[3]=90.0
     lp1[4]=90.0
  end
2:begin ; orthorhombic
     lp1[3]=90.0
     lp1[4]=90.0
     lp1[5]=90.0
  end

3:begin ; tetragonal
     case ch of
     0: begin
          lp1[1]=lp1[0]
        end
     1:begin
          lp1[0]=lp1[1]
        end
     else:
     endcase ; ch
     lp1[3]=90.0
     lp1[4]=90.0
     lp1[5]=90.0
  end

4:begin ; hexagonal
     case ch of
     0: begin
          lp1[1]=lp1[0]
        end
     1:begin
          lp1[0]=lp1[1]
        end
     else:
     endcase ; ch
     lp1[3]=90.0
     lp1[4]=90.0
     lp1[5]=120.0
  end

5: begin ; cubic
     case ch of
     0: begin
          lp1[1]=lp1[0]
          lp1[2]=lp1[0]
        end
     1:begin
          lp1[0]=lp1[1]
          lp1[2]=lp1[1]
        end
     2:begin
          lp1[0]=lp1[2]
          lp1[1]=lp1[2]
        end
        else:
     endcase ; ch
     lp1[3]=90.0
     lp1[4]=90.0
     lp1[5]=90.0
   end
5: begin ; cubic
     case ch of
     0: begin
          lp1[1]=lp1[0]
          lp1[2]=lp1[0]
        end
     1:begin
          lp1[0]=lp1[1]
          lp1[2]=lp1[1]
        end
     2:begin
          lp1[0]=lp1[2]
          lp1[1]=lp1[2]
        end
     3:begin
          lp1[4]=lp1[3]
          lp1[5]=lp1[3]
        end
     4:begin
          lp1[3]=lp1[4]
          lp1[5]=lp1[4]
        end
     5:begin
          lp1[3]=lp1[5]
          lp1[4]=lp1[5]
        end
        else:
     endcase ; ch
   end
else:
endcase
lp=lp1
end

;------------------------------------------

function lp_error_estimate, lp, ds, hkls, lpn, DX, sym

; estimates error in the refined lattice parameter value based on the shape
; of FOM describing match betwen measured and calculated dspc
;
; INPUT:
;    lp  - lattice parameters vector
;    ds  - measured d-spc
;    hkls - Miller indices corresponding to measured d-spc
;    lpn - index of lattice param. for which the error is calculated
;    dx  - distance in lp at which gradient is estimated
;    sym - symmetry code
; OUTPUT:
;    value of the estimated error

  lp1=lp
  E1=test_lp_against_ds(lp1,ds,hkls)
  lp1[lpn]=lp[lpn]-DX
  apply_symmetry_to_lp, lp1, lpn, sym
  E2=test_lp_against_ds(lp1,ds,hkls)
  lp1[lpn]=lp[lpn]+DX
  apply_symmetry_to_lp, lp1, lpn, sym
  E3=test_lp_against_ds(lp1,ds,hkls)
  apply_symmetry_to_lp, lp1, lpn, sym
  dy=(abs(E3-e1)+abs(e2-e1))/2.0
  dy=dy/dx/(test_lp_against_ds(lp1,ds,hkls)*100.0)
  return, dy
end

;-----------------------------------------------------------------------

function lp_error_estimate_xyz, ub, xyzs, hkls, lpn, DX, sym

; estimates error in the refined lattice parameter value based on the shape
; of FOM describing match betwen measured and calculated dspc
;
; INPUT:
;    lp  - lattice parameters vector
;    ds  - measured d-spc
;    hkls - Miller indices corresponding to measured d-spc
;    lpn - index of lattice param. for which the error is calculated
;    dx  - distance in lp at which gradient is estimated
;    sym - symmetry code
; OUTPUT:
;    value of the estimated error
  lp0=lp_from_ub(ub)
  B0=b_from_lp(lp0)
  U0=U_from_UB(ub)
  LP1=LP0
  E1=test_ub_against_xyz(ub, xyzs, hkls)

  lp1[lpn]=lp0[lpn]-DX
  apply_symmetry_to_lp, lp1, lpn, sym
  B1=b_from_lp(lp1)
  ub1=U0 ## b1

  E2=test_ub_against_xyz(ub1, xyzs, hkls)

  lp1[lpn]=lp0[lpn]+DX
  B1=b_from_lp(lp1)
  ub1=U0 ## b1
  apply_symmetry_to_lp, lp1, lpn, sym
  E3=test_ub_against_xyz(ub1, xyzs, hkls)

  dy=(abs(E3-e1)+abs(e2-e1))/2.0
  apply_symmetry_to_lp, lp1, lpn, sym
  dy=dy/dx/(test_ub_against_xyz(ub1, xyzs, hkls)*100.0)
  return, dy
end

;----------------------------------------------------

function refine_lp, lp, ds, hkls, step1, step2, flags, sym, st

;-----------------------------------------------------------------------
; refines lattice parameters against a list of observed d-spc
; uses only lengths of rec. vectors.
;
; ARGUMENTS:
;     lp    - lattice parameters
;     ds    - d-spacings
;     hkls - Miller indices corresponding to measured d-spc
;     step1 - range of x for refinement of cell edge
;     step2 - range of x for refinement of angles
;     flags - refinement flags 1 means refine, 0 skip
;     sym   - symmetry constraints
;     st    - number of steps in one stage optimization
;
; OUTPUT:
;     refined lattice parameters
;-----------------------------------------------------------------------

  lp1=lp
  res=fltarr(101,2)
  if flags[0] eq 1 then $
  begin
  ;-- refine a 1-st time ---
  a0=lp[0]-step1/2.0
  for i=0,st do $
  begin
    a=a0+i*step1/st
    lp1[0]=a
    apply_symmetry_to_lp, lp1, 0, sym
    res[i,0]=a
    res[i,1]=test_lp_against_ds(lp1,ds,hkls)
  endfor
  plot, res[0:st,0], res[0:st,1], /ynozero
  aa=min(res[0:st,1],i)
  lp1[0]=res[i,0]
  apply_symmetry_to_lp, lp1, 0, sym
  endif

  ;-- refine b 1-st time ---
  if flags[1] eq 1 then $
  begin

  a0=lp[1]-step1/2.0
  for i=0,st do $
  begin
    a=a0+i*step1/st
    lp1[1]=a
    apply_symmetry_to_lp, lp1, 1, sym
    res[i,0]=a
    res[i,1]=test_lp_against_ds(lp1,ds,hkls)
  endfor
  plot, res[0:st,0], res[0:st,1], /ynozero
  aa=min(res[0:st,1],i)
  lp1[1]=res[i,0]
  apply_symmetry_to_lp, lp1, 1, sym
  endif

  ;-- refine c 1-st time ---
    if flags[2] eq 1 then $
  begin
  a0=lp[2]-step1/2.0
  for i=0,st do $
  begin
    a=a0+i*step1/st
    lp1[2]=a
    apply_symmetry_to_lp, lp1, 2, sym
    res[i,0]=a
    res[i,1]=test_lp_against_ds(lp1,ds,hkls)
  endfor
  plot, res[0:st,0], res[0:st,1],/ynozero
  aa=min(res[0:st,1],i)
  lp1[2]=res[i,0]
  apply_symmetry_to_lp, lp1, 2, sym
  endif

  ;-- refine al 1-st time ---
    if flags[3] eq 1 then $
  begin

  a0=lp[3]-step2/2.0
  for i=0,st do $
  begin
    a=a0+i*step1/st
    lp1[3]=a
    apply_symmetry_to_lp, lp1, 3, sym
    res[i,0]=a
    res[i,1]=test_lp_against_ds(lp1,ds,hkls)
  endfor
  plot, res[0:st,0], res[0:st,1], /ynozero
  aa=min(res[0:st,1],i)
  lp1[3]=res[i,0]
  apply_symmetry_to_lp, lp1, 3, sym
  endif

  ;-- refine be 1-st time ---
  if flags[4] eq 1 then $
  begin

  a0=lp[4]-step2/2.0
  for i=0,st do $
  begin
    a=a0+i*step2/st
    lp1[4]=a
    apply_symmetry_to_lp, lp1, 4, sym
    res[i,0]=a
    res[i,1]=test_lp_against_ds(lp1,ds,hkls)
  endfor
  plot, res[0:st,0], res[0:st,1], /ynozero
  aa=min(res[0:st,1],i)
  lp1[4]=res[i,0]
  apply_symmetry_to_lp, lp1, 4, sym
 endif

  ;-- refine ga 1-st time ---
  if flags[5] eq 1 then $
  begin

  a0=lp[5]-step2/2.0
  for i=0,st do $
  begin
    a=a0+i*step2/st
    lp1[5]=a
    apply_symmetry_to_lp, lp1, 5, sym
    res[i,0]=a
    res[i,1]=test_lp_against_ds(lp1,ds,hkls)
  endfor
  plot, res[0:st,0], res[0:st,1], /ynozero
  aa=min(res[0:st,1],i)
  lp1[5]=res[i,0]
  apply_symmetry_to_lp, lp1, 5, sym
  endif


;-- refine a 2-nd time ---

  if flags[0] eq 1 then $
  begin

  a0=lp1[0]-step1/4
  for i=0,st do $
  begin
    a=a0+i*step1/st/2
    lp1[0]=a
    apply_symmetry_to_lp, lp1, 0, sym
    res[i,0]=a
    res[i,1]=test_lp_against_ds(lp1,ds,hkls)
  endfor
  plot, res[0:st,0], res[0:st,1], /ynozero
  aa=min(res[0:st,1],i)
  lp1[0]=res[i,0]
  apply_symmetry_to_lp, lp1, 0, sym
  endif

  ;-- refine b 2-nd time ---
  if flags[1] eq 1 then $
  begin
  a0=lp1[1]-step1/4
  for i=0,st do $
  begin
    a=a0+i*step1/st/2
    lp1[1]=a
    apply_symmetry_to_lp, lp1, 1, sym
    res[i,0]=a
    res[i,1]=test_lp_against_ds(lp1,ds,hkls)
  endfor
  plot, res[0:st,0], res[0:st,1], /ynozero
  aa=min(res[0:st,1],i)
  lp1[1]=res[i,0]
  apply_symmetry_to_lp, lp1, 1, sym
  endif

  ;-- refine c 2-nd time ---

   if flags[2] eq 1 then $
  begin

  a0=lp1[2]-step1/4
  for i=0,st do $
  begin
    a=a0+i*step1/st/2
    lp1[2]=a
    apply_symmetry_to_lp, lp1, 2, sym
    res[i,0]=a
    res[i,1]=test_lp_against_ds(lp1,ds,hkls)
  endfor
  plot, res[0:st,0], res[0:st,1], /ynozero
  aa=min(res[0:st,1],i)
  lp1[2]=res[i,0]
  apply_symmetry_to_lp, lp1, 2, sym
 endif

  ;-- refine al 2-nd time ---

  if flags[3] eq 1 then $
  begin

  a0=lp1[3]-step1/4
  for i=0,st do $
  begin
    a=a0+i*step1/st/2
    lp1[3]=a
    apply_symmetry_to_lp, lp1, 3, sym
    res[i,0]=a
    res[i,1]=test_lp_against_ds(lp1,ds,hkls)
  endfor
  plot, res[0:st,0], res[0:st,1], /ynozero
  aa=min(res[0:st,1],i)
  lp1[3]=res[i,0]
  apply_symmetry_to_lp, lp1, 3, sym
  endif

  ;-- refine be 2-nd time ---
  if flags[4] eq 1 then $
  begin

  a0=lp1[4]-step1/4
  for i=0,st do $
  begin
    a=a0+i*step1/st/2
    lp1[4]=a
    apply_symmetry_to_lp, lp1, 4, sym
    res[i,0]=a
    res[i,1]=test_lp_against_ds(lp1,ds,hkls)
  endfor
  plot, res[0:st,0], res[0:st,1], /ynozero
  aa=min(res[0:st,1],i)
  lp1[4]=res[i,0]
  apply_symmetry_to_lp, lp1, 4, sym
  endif


  ;-- refine ga 2-nd time ---
  if flags[5] eq 1 then $
  begin

  a0=lp1[5]-step1/4
  for i=0,st do $
  begin
    a=a0+i*step1/st/2
    lp1[5]=a
    apply_symmetry_to_lp, lp1, 5, sym
    res[i,0]=a
    res[i,1]=test_lp_against_ds(lp1,ds,hkls)
  endfor
  plot, res[0:st,0], res[0:st,1], /ynozero
  aa=min(res[0:st,1],i)
  lp1[5]=res[i,0]
  apply_symmetry_to_lp, lp1, 5, sym
  endif
  return, lp1
end


;-----------------------------------------

function angle_between_hkls, h1, h2, lp
 B=B_from_lp(lp)
 x1=h1 # B
 x2=h2 # B
 return, ang_between_vecs(x1,x2)
end
;-----
;-----

function bindec_con, a
 n=n_elements(a)
 b=0
 if n gt 0 then for i=0, n-1 do b=B+a[n-1-i]*2^i
 RETURN, B
end

;-----

;-----
function sum_modulo, a, b
  c=a+b
  w=where(c gt 1)
  if w[0] ge 0 then c[w]=0
  return, c
end
;-----------------------------------------
function sum_modulod, a, b
  A1=decbin_con(a)
  b1=decbin_con(B)
  RETURN, bindec_con(sum_modulo(a1, b1))
END
;-----------------------------------------
function decbin_con, a
c=a
 bin=intarr(10)
while c gt 0 do $
begin
 b=fix(alog(c)/alog(2))
 bin[9-b]=1
 c=c-2^b
endwhile
return, bin
end



;-----------------------------------------
FUNCTION TRANSFORM_ROW, R, T
; T IS A PRIMARY TRANSFORMATION
; R IS A VECTOR WITH COMBINATION TRANSFORMATION CODES
N=N_ELEMENTS(r)
R1=LONARR(n)
FOR I=0, N-1 DO $
BEGIN
  if r[i] gt 0 then $
  begin
   A=decbin_con(R[I])
   NN=N_ELEMENTS(A)-1-WHERE(A GT 0)
   IF NN[0] NE -1 THEN $
   BEGIN
      FOR J=0, N_ELEMENTS(NN)-1 DO R1[I]=R1[I]+2^sum_modulod(T,NN[J])
   END
  endif
END
RETURN, R1
END

;-----------------------------------------
function how_many_ones, r
 ; checks how many identity transformations are present on the list

N=N_ELEMENTS(r)
count=0
FOR I=0, N-1 DO $
BEGIN
   A=decbin_con(R[I])
   if a[n_elements(a)-1] eq 1 then count=count+1
END
RETURN, count

end
;-----------------------------------------
function select_most_ones_T, r, ts
; selects a transformation that results in most matches requiring only identity transformation
; ts is a set of possible transformation in combination code
;---- decompose transformation to primary ones
   A=decbin_con(ts)
   n=where(a ne 0)
   nn=n_elements(a)-1-n
   if n[0] ge 0 then $
   begin
      ones=fltarr(n_elements(n))
      for i=0, n_elements(n)-1 do $
      begin
       r1=TRANSFORM_ROW(R, nn[i])
       ones[i]=how_many_ones(r1)
      endfor
   endif
   print, ones
   m=max(ones, k)
   return, nn[k]
end

;-----------------------------------------

pro indi, opt
mina=2.0
 lp=[16.80, 5.85, 4.83, 90,90,90]
 pt=opt->get_object()
 d=fltarr(pt.peakno)
 xhkl=intarr(3, pt.peakno)
 ;---- ASSIGN D-SPACINGS TO HKL
 for i=0, pt.peakno-1 do  $
 begin
   d[i]=1.0/vlength(pt.peaks[i].xyz)
   re=find_closest_d( lp, d[i], [5,5,5], 'P')
   xhkl[0:2,I]=lONG(re[2:4])
  ; PRINT, pt.peaks[i].hkl, xhkl[0:2,I]
  ; PRINT
 endfor
 ;----- VERIFY INTERVECTOR ANGLS
 cs=lonarr(pt.peakno)
 compat=intarr(pt.peakno, pt.peakno)
 for i=0, pt.peakno-1 do  $
 begin
   hkl1=xhkl[0:2,I]
   count=0
   for j=0,  pt.peakno-1 do if j ne i then $
   begin
     hkl2a= [ xhkl[0,j], xhkl[1,j], xhkl[2,j]]; 1=0
     hkl2b= [ xhkl[0,j], xhkl[1,j],-xhkl[2,j]]; 2=1
     hkl2c= [ xhkl[0,j],-xhkl[1,j], xhkl[2,j]]; 4=2
     hkl2d= [ xhkl[0,j],-xhkl[1,j],-xhkl[2,j]]; 8=3
     hkl2e= [-xhkl[0,j], xhkl[1,j], xhkl[2,j]]; 16=4
     hkl2f= [-xhkl[0,j], xhkl[1,j],-xhkl[2,j]]; 32=5
     hkl2g= [-xhkl[0,j],-xhkl[1,j], xhkl[2,j]]; 64=6
     hkl2h= [-xhkl[0,j],-xhkl[1,j],-xhkl[2,j]]; 128=7
     an0=ang_between_vecs(pt.peaks[i].xyz, pt.peaks[j].xyz)
     ;- have to consider all same d equivalents below
     an1a=angle_between_hkls(hkl1, hkl2a, lp)
     an1b=angle_between_hkls(hkl1, hkl2b, lp)
     an1c=angle_between_hkls(hkl1, hkl2c, lp)
     an1d=angle_between_hkls(hkl1, hkl2d, lp)
     an1e=angle_between_hkls(hkl1, hkl2e, lp)
     an1f=angle_between_hkls(hkl1, hkl2f, lp)
     an1g=angle_between_hkls(hkl1, hkl2g, lp)
     an1h=angle_between_hkls(hkl1, hkl2h, lp)

     if abs(an0-an1a) lt mina then compat[i,j]=compat[i,j]+1
     if abs(an0-an1b) lt mina then compat[i,j]=compat[i,j]+2
     if abs(an0-an1c) lt mina then compat[i,j]=compat[i,j]+4
     if abs(an0-an1d) lt mina then compat[i,j]=compat[i,j]+8
     if abs(an0-an1e) lt mina then compat[i,j]=compat[i,j]+16
     if abs(an0-an1f) lt mina then compat[i,j]=compat[i,j]+32
     if abs(an0-an1g) lt mina then compat[i,j]=compat[i,j]+64
     if abs(an0-an1h) lt mina then compat[i,j]=compat[i,j]+128

   endif ;j
   cs[i]=n_elements(where(compat[i,*] ne 0))
 endfor ;i

 ;------ select the most proper hkl and identify matching ones
 m=max(cs, pos)

 sel=select_most_ones_t(compat[*,9], compat[3,9])
 r1=TRANSFORM_ROW(compat[*,9], sel)
 ; remember to transform the indices as well
 compat[*,9]=r1
 compat[9,*]=r1

 sel=select_most_ones_t(compat[*,10], compat[3,10])
 r1=TRANSFORM_ROW(compat[*,10], sel)
 compat[*,10]=r1
 compat[10,*]=r1

 sel=select_most_ones_t(compat[*,11], compat[3,11])
 r1=TRANSFORM_ROW(compat[*,11], sel)
 compat[*,11]=r1
 compat[11,*]=r1




 hkl1=xhkl[0:2,pos]
 list=intarr(m)
 list2=intarr(m)
 p=0
 print, cs
 print, '--------------'

 for j=0,  pt.peakno-1 do if j ne pos then $
 begin
     hkl2a= [ xhkl[0,j], xhkl[1,j], xhkl[2,j]]
     hkl2b= [-xhkl[0,j],-xhkl[1,j],-xhkl[2,j]]
     hkl2c= [-xhkl[0,j], xhkl[1,j], xhkl[2,j]]
     hkl2d= [ xhkl[0,j],-xhkl[1,j], xhkl[2,j]]
     hkl2e= [ xhkl[0,j], xhkl[1,j],-xhkl[2,j]]
     hkl2f= [ xhkl[0,j],-xhkl[1,j],-xhkl[2,j]]
     hkl2g= [-xhkl[0,j], xhkl[1,j],-xhkl[2,j]]
     hkl2h= [-xhkl[0,j],-xhkl[1,j], xhkl[2,j]]
     an0=ang_between_vecs(pt.peaks[i].xyz, pt.peaks[j].xyz)
     ;- have to consider all same d equivalents below
     an1a=angle_between_hkls(hkl1, hkl2a, lp)
     an1b=angle_between_hkls(hkl1, hkl2b, lp)
     an1c=angle_between_hkls(hkl1, hkl2c, lp)
     an1d=angle_between_hkls(hkl1, hkl2d, lp)
     an1e=angle_between_hkls(hkl1, hkl2e, lp)
     an1f=angle_between_hkls(hkl1, hkl2f, lp)
     an1g=angle_between_hkls(hkl1, hkl2g, lp)
     an1h=angle_between_hkls(hkl1, hkl2h, lp)


 endif
 ;----
 print, '-----------'
 print, pos, '===', pt.peaks[pos].hkl,'----', hkl1
 for i=0, m-1 do $
 begin
   if list[i] ge 0 then print, list[i], '===', pt.peaks[list[i]].hkl, '----',xhkl[0:2,list[i]] else $
      print, abs(list[i]), '===', pt.peaks[abs(list[i])].hkl, '----',xhkl[0:2,abs(list[i])]
 endfor

 print, '-----------'
 ;print, list

end

;-----------------------------------------
function find_closest_d, lp, d, hkl, excl
; for a given d and lp finds the hkl that gives the closest d_calc
; result is d, difference in d, hkl
; the hkl argument is maximum indices to check
;----------------------------------------------
mi=100.0
df=0
hklf=[0,0,0]
for i=0, hkl[0] do $
  for j=-hkl[1], hkl[1] do $
    for k=-hkl[2], hkl[2] do $
    BEGIN
      hkla=[i,j,k]
      if n_params() eq 4 then $
      if syst_extinction(excl,hkl) eq 1 then $
      begin
      dc=d_from_lp_and_hkl(lp, hkla)
      dd=abs(d-dc)
      if dd lt mi then $
      begin
         mi=dd
         hklf=hkla
         df=dc
      endif
      endif
   endfor
return, [df, mi, hklf]
end

;----------------------------------------------------------
FUNCTION ERROR_estimates_from_d, lp, ds, hkls, sym
 err=fltarr(6)
 err[0]=1/lp_error_estimate(lp, ds,hkls, 0,0.01,(sym))/2000
 err[1]=1/lp_error_estimate(lp, ds,hkls, 1,0.01,(sym))/2000
 err[2]=1/lp_error_estimate(lp, ds,hkls, 2,0.01,(sym))/2000
 err[3]=1/lp_error_estimate(lp, ds,hkls, 3,0.01,(sym))/800
 err[4]=1/lp_error_estimate(lp, ds,hkls, 4,0.01,(sym))/800
 err[5]=1/lp_error_estimate(lp, ds,hkls, 5,0.01,(sym))/800
return, err
end
;----------------------------------------------------------

FUNCTION ERROR_estimates_from_xyz, ub, xyzs, hkls, sym
    err=fltarr(6)
    err[0]=1/lp_error_estimate_xyz(ub, xyzs,hkls, 0,0.01,(sym))/2000
    err[1]=1/lp_error_estimate_xyz(ub, xyzs,hkls, 1,0.01,(sym))/2000
    err[2]=1/lp_error_estimate_xyz(ub, xyzs,hkls, 2,0.01,(sym))/2000
    err[3]=1/lp_error_estimate_xyz(ub, xyzs,hkls, 3,0.01,(sym))/1000
    err[4]=1/lp_error_estimate_xyz(ub, xyzs,hkls, 4,0.01,(sym))/1000
    err[5]=1/lp_error_estimate_xyz(ub, xyzs,hkls, 5,0.01,(sym))/1000
return, err
end
;----------------------------------------------------------



function error_estimates_text,lp, ds,hkls, sym
 err=fltarr(6)
 err[0]=1/lp_error_estimate(lp, ds,hkls, 0,0.01,(sym))/2000
 err[1]=1/lp_error_estimate(lp, ds,hkls, 1,0.01,(sym))/2000
 err[2]=1/lp_error_estimate(lp, ds,hkls, 2,0.01,(sym))/2000
 err[3]=1/lp_error_estimate(lp, ds,hkls, 3,0.01,(sym))/800
 err[4]=1/lp_error_estimate(lp, ds,hkls, 4,0.01,(sym))/800
 err[5]=1/lp_error_estimate(lp, ds,hkls, 5,0.01,(sym))/800
 tex=''
 for i=0, 5 do tex=tex+string(err[i])+'  '
 return, tex
 end
;---------------------------------------------------------
;---- function minimized in B refinement from d
  FUNCTION MYFUNCT, p, X=x, Y=y, ERR=err
  ; p= lp
  ; X=index
  ; Y=measured d
  common refine, ds1, hkls1
   N=n_elements(X)
   f=fltarr(N)
   for i=0, N-1 do F[i]=d_from_lp_and_hkl(p,hkls1[0:2,X[i]])
   return, abs(Y-F)/ERR
 END;---------------------------------------------------------
;---- function minimized in B refinement from d



Function MYFUNCT_two_Detectors, p, X=x, Y=y, ERR=err
  @COMMON_DATAS
  COMMON Nus, Nu1, Nu2, Del1, Del2
 ; COMMON Opts, opt1, opt2
  common refine, ds1, hkls1


   NP1=opt1->peakno()
   NP2=opt2->peakno()

   ; X should be NP1+NP2
   ; Does X do peak exclusions?

   oadetector->change_twist, p[6] ; so far it is just twist and cell parameters

   oadetector->change_NuDel, [Nu1, Del1]
   opt1->calculate_all_xyz_from_pix, oadetector, wv

   DD1=opt1->build_ds()
   HKLs1=opt1->build_hkls()
   Y1=DD1[0:NP1-1]

   oadetector->change_NuDel, [Nu2, Del2]
   opt2->calculate_all_xyz_from_pix, oadetector, wv
   HKLs2=opt2->build_hkls()

   DD2=opt2->build_ds()
   Y1=[DD1,DD2[0:NP2-1]]

   N=n_elements(X)
   f=fltarr(N)
   for i=0, N-1 do F[i]=d_from_lp_and_hkl(p[0:5],[hkls1,hkls1])
   return, abs(Y1-F)/ERR
 END;---------------------------------------------------------



FUNCTION MYFUNCT_twist, p, X=x, Y=y, ERR=err
  @COMMON_DATAS

  ; p= lp
  ; X=index
  ; Y=measured d
  common refine, ds1, hkls1

   oadetector->change_twist, p[6]
   opt->calculate_all_xyz_from_pix, oadetector, wv
   DD=opt->build_ds()
   Y1=DD[X]

   N=n_elements(X)
   f=fltarr(N)
   for i=0, N-1 do F[i]=d_from_lp_and_hkl(p[0:5],hkls1[0:2,X[i]])
   return, abs(Y1-F)/ERR
 END;---------------------------------------------------------




  FUNCTION MYFUNCT5, p, X=x, Y=y, ERR=err
  ; p= lp
  ; X=index
  ; Y=measured d
  common refine, ds1, hkls1
   N=n_elements(X)
   f=fltarr(N)
   for i=0, N-1 do F[i]=d_from_lp_and_hkl([p[0],p],hkls1[0:2,X[i]])
   return, abs(Y-F)/ERR
 END;---------------------------------------------------------
;---- function minimized in B refinement from d
  FUNCTION MYFUNCT4, p, X=x, Y=y, ERR=err
  ; p= lp
  ; X=index
  ; Y=measured d
  common refine, ds1, hkls1
   N=n_elements(X)
   f=fltarr(N)
   for i=0, N-1 do F[i]=d_from_lp_and_hkl([p[0],p[0],p],hkls1[0:2,X[i]])
   return, abs(Y-F)/ERR
 END
;---------------------------------------------------------
;---- function minimized in UB refinement from xyz
  FUNCTION XYZ_match, p, X=x, Y=y, ERR=err
  ; p= ub
  ; X= index
  ; Y= not used
  common refine_ub, xyza, hkla, U
  common Rota, Mtx

   GenerateR, 3, P[6]
   om=mtx
   GenerateR, 1, P[7]
   ch=mtx
   GenerateR, 3, P[8]
   ph=mtx
   RR=Om # Ch # Ph
   lp=p[0:5]
   B=B_from_lp(lp)
   UB0=U ## B
   UB=RR ## UB0
   N=n_elements(X)
   F=fltarr(N)
   for i=0, N-1 do $
   begin
     mxyz=xyza[0:2,i]
     cxyz=UB ## hkla[0:2,i]
     F[i]=vlength(mxyz-cxyz)/10.
   end
   return, (F)/ERR
 END

;-------------------------------------;---------------------------------------------------------
;---- function minimized in UB refinement from xyz
  FUNCTION XYZ_match5, p, X=x, Y=y, ERR=err
  ; p= ub
  ; X= index
  ; Y= not used
  common refine_ub, xyza, hkla, U
  common Rota, Mtx

   GenerateR, 3, P[5]
   om=mtx
   GenerateR, 1, P[6]
   ch=mtx
   GenerateR, 3, P[7]
   ph=mtx
   RR=Om # Ch # Ph
   lp=[p[0],p[0:4]]
   B=B_from_lp(lp)
   UB0=U ## B
   UB=RR ## UB0
   N=n_elements(X)
   F=fltarr(N)
   for i=0, N-1 do $
   begin
     mxyz=xyza[0:2,i]
     cxyz=UB ## hkla[0:2,i]
     F[i]=vlength(mxyz-cxyz)/10.
   end
   return, (F)/ERR
 END

;-------------------------------------;---------------------------------------------------------
;---- function minimized in UB refinement from xyz
  FUNCTION XYZ_match4, p, X=x, Y=y, ERR=err
  ; p= ub
  ; X= index
  ; Y= not used
  common refine_ub, xyza, hkla, U
  common Rota, Mtx

   GenerateR, 3, P[4]
   om=mtx
   GenerateR, 1, P[5]
   ch=mtx
   GenerateR, 3, P[6]
   ph=mtx
   RR=Om # Ch # Ph
   lp=[p[0],p[0],p[0:3]]
   B=B_from_lp(lp)
   UB0=U ## B
   UB=RR ## UB0
   N=n_elements(X)
   F=fltarr(N)
   for i=0, N-1 do $
   begin
     mxyz=xyza[0:2,i]
     cxyz=UB ## hkla[0:2,i]
     F[i]=vlength(mxyz-cxyz)/10.
   end
   return, (F)/ERR
 END

;-------------------------------------

  FUNCTION MYFUNCT2, p, X=x, Y=y, ERR=err
  ; p= lp
  ; X=index
  ; Y=measured d
  common refine1, XYZs1, u1a
  common refine, ds1, hkls1
   b=b_from_lp(p)
   ub1=u1a ## b
   N=n_elements(X)
   XYZcal=fltarr(3,N)
   f=fltarr(N)
   for i=0, N-1 do XYZcal[i]=ub1 ## hkls1[0:2,i]
   for i=0, N-1 do F[i]=abs(vlength(XYZs1[0:2,i]-XYZcal[0:2,i]))/1100.0
   return, F/ERR
 END

;------------------------------------------------------------------------

function convert_symmetry_from_vg, sym
; input = widget index
; output = sym index for lp refinement
case sym of
0:s=5  ; cub
1:s=3  ; tet
2:s=2  ; ort
3:s=4  ; hex
4:s=6  ; rhom
5:s=12 ; mono
6:s=0 ;  tri
else:s=0
endcase
return, s
end

;------------------------------------------------------------------------

function automatic_ub_refinement1, ub, XYZs, hkls, sym, lp1
;  refines lattice parameters against list of measured d-spc with assigned indices
;  applies symmetry constraints
;  estimates refinement errors
  common refine1, XYZs1, u1a
  common refine, ds1, hkls1
  lp1=lp_from_ub(ub)
  b1=b_from_lp(lp1)
  u1a=ub ## invert(b1)
  hkls1=hkls
  N=size(XYZs)
  N=N[2]
  X=findgen(N)
  Y=findgen(N)
  ERR=fltarr(N)
  XYZs1=XYZs
  XYZcal=fltarr(3,N)
  for i=0, N-1 do XYZcal[i]=ub ## hkls[0:2,i]
  for i=0, N-1 do ERR[i]=abs(vlength(XYZs[0:2,i]-XYZcal[0:2,i]))/1000.0
  lp=lp1
  ;ERR=ERR>0.0001

; Symmetry codes
; 0  - triclinic
; 11 - monoclinic a
; 12 - monoclinic b
; 13 - monoclinic c
; 2  - orthorhombic
; 3  - tetragonal
; 4  - hexagonal
; 5  - cubic
; 6  - rhombohedral

  parinfo = replicate({value:0.D, fixed:0, limited:[0,0], $
                       limits:[0.D,0], tied:''}, 6)

case sym of
 0: $; - triclinic
 begin
 end
 11:$; - monoclinic a
 begin
   lp[4]=90.0
   lp[5]=90.0
   parinfo[4].fixed = 1
   parinfo[5].fixed = 1
 end
 12:$; - monoclinic b
 begin
   lp[3]=90.0
   lp[5]=90.0
   parinfo[3].fixed = 1
   parinfo[5].fixed = 1
 end
 13:$; - monoclinic c
 begin
   lp[3]=90.0
   lp[4]=90.0
   parinfo[3].fixed = 1
   parinfo[4].fixed = 1
 end
 2 :$; - orthorhombic
 begin
   lp[3]=90.0
   lp[4]=90.0
   lp[5]=90.0
   parinfo[3].fixed = 1
   parinfo[4].fixed = 1
   parinfo[5].fixed = 1
 end
 3 :$; - tetragonal
 begin
   lp[3]=90.0
   lp[4]=90.0
   lp[5]=90.0
   parinfo[3].fixed = 1
   parinfo[4].fixed = 1
   parinfo[5].fixed = 1
   parinfo[1].tied = 'P[0]'
 end
 4 :$; - hexagonal
 begin
   lp[3]=90.0
   lp[4]=90.0
   lp[5]=120.0
   parinfo[3].fixed = 1
   parinfo[4].fixed = 1
   parinfo[5].fixed = 1
   parinfo[1].tied = 'P[0]'
 end
 5 :$; - cubic
 begin
   lp[3]=90.0
   lp[4]=90.0
   lp[5]=90.0
   parinfo[3].fixed = 1
   parinfo[4].fixed = 1
   parinfo[5].fixed = 1
   parinfo[1].tied = 'P[0]'
   parinfo[2].tied = 'P[0]'
 end
 6 :$; - rhombohedral
 begin
   parinfo[1].tied = 'P[0]'
   parinfo[2].tied = 'P[0]'
   parinfo[4].tied = 'P[3]'
   parinfo[5].tied = 'P[3]'
 end
endcase
  p0 = lp1
  fa = {X:x, Y:y, ERR:err}

  p = mpfit('MYFUNCT2', p0, functargs=fa,PERROR=PE, PARINFO=parinfo)
  lp1=p
  return, [p,pe]
end

;---------------------------------------------------------------
pro apply_exclusions, ds, hkls, excl
; this rutine allows to exclude peaks for which peak fitting was not satisfactory from the unit cell refinemt
; excl is an array with exclusion status for peaks
; 1 = use
; 0 = exclude
  N=total(excl)
  ds1=fltarr(N)
  hkls1=fltarr(3,N)
  Ni=n_elements(ds)
  k=0
  for i=0, Ni-1 do $
  begin
   if excl[i] eq 1 then $
   begin
     ds1[k]=ds[i]
     hkls1[0:2,k]=hkls[0:2,i]
     k=k+1
   end
  end
  ds=ds1
  hkls=hkls1
end

;---------------------------------------------------------------
; 03/04/2009 PD:
;    -- new version that allows to avoid using the TIDE parinfo parameter due to problems with VM w/o license
; 09/05/2008 PD:
;    -- first version written
;---------------------------------------------------------------

function automatic_ub_refinement_against_xyz1, ub, xyzs, hkls, sym
  common refine_ub, xyza, hkla, U
  xyza=xyzs
  hkla=hkls
  xyzs1=xyzs
  N=n_elements(xyzs)/3
  X=findgen(N)
  Y=findgen(N)
  ERR=fltarr(N)
  for i=0, N-1 do ERR[i]=1.0
  lp=lp_from_ub(UB)
  apply_symmetry_to_lp, lp, 0, sym

  B=B_from_lp(lp)
  U=U_from_UB(UB)
  roan=[0.,0.,0.] ; additional rotation mtx Om Ch Ph applied to U

  P=[lp,roan]

; Symmetry codes
; 0  - triclinic
; 11 - monoclinic a
; 12 - monoclinic b
; 13 - monoclinic c
; 2  - orthorhombic
; 3  - tetragonal
; 4  - hexagonal
; 5  - cubic

  parinfo = replicate({value:0.D, fixed:0, limited:[0,0], $
                       limits:[0.D,0]}, 9)

case sym of
 0: $; - triclinic
 begin
 end
 11:$; - monoclinic a
 begin
   lp[4]=90.0
   lp[5]=90.0
   parinfo[4].fixed = 1
   parinfo[5].fixed = 1
 end
 12:$; - monoclinic b
 begin
   lp[3]=90.0
   lp[5]=90.0
   parinfo[3].fixed = 1
   parinfo[5].fixed = 1
 end
 13:$; - monoclinic c
 begin
   lp[3]=90.0
   lp[4]=90.0
   parinfo[3].fixed = 1
   parinfo[4].fixed = 1
 end
 2 :$; - orthorhombic
 begin
   lp[3]=90.0
   lp[4]=90.0
   lp[5]=90.0
   parinfo[3].fixed = 1
   parinfo[4].fixed = 1
   parinfo[5].fixed = 1
 end
 3 :$; - tetragonal
 begin
   lp[3]=90.0
   lp[4]=90.0
   lp[5]=90.0
   parinfo[3].fixed = 1
   parinfo[4].fixed = 1
   parinfo[5].fixed = 1
 end
 4 :$; - hexagonal
 begin
   lp[3]=90.0
   lp[4]=90.0
   lp[5]=120.0
   parinfo[3].fixed = 1
   parinfo[4].fixed = 1
   parinfo[5].fixed = 1
 end
 5 :$; - cubic
 begin
   lp[3]=90.0
   lp[4]=90.0
   lp[5]=90.0
   parinfo[3].fixed = 1
   parinfo[4].fixed = 1
   parinfo[5].fixed = 1
 end
endcase

   parinfo[0].limited(0) = 1
   parinfo[0].limited(1) = 1
   parinfo[0].limits(0) = P[0]-P[0]/10.
   parinfo[0].limits(1) = P[0]+P[0]/10.

   parinfo[1].limited(0) = 1
   parinfo[1].limited(1) = 1
   parinfo[1].limits(0) = P[1]-P[1]/10.
   parinfo[1].limits(1) = P[1]+P[1]/10.

   parinfo[2].limited(0) = 1
   parinfo[2].limited(1) = 1
   parinfo[2].limits(0) = P[2]-P[2]/10.
   parinfo[2].limits(1) = P[2]+P[2]/10.

   parinfo[6].limited(0) = 1
   parinfo[6].limited(1) = 1
   parinfo[6].limits(0) = 0.
   parinfo[6].limits(1) = 360.


   p0 = P
   fa = {X:x, Y:Y, ERR:err}

  case sym of
  3:$ ; tetragonal
     begin
       parinfo=parinfo[1:8]
       p0=p0[1:8]
       p = mpfit('XYZ_match5', p0, functargs=fa,PERROR=PE, PARINFO=parinfo, BESTNORM=bestnorm)
       if n_elements(PE) gt 0 then $
       begin
        p=[p[0],p]
        pe=[pe[0],pe]
       end
     end
  4:$ ; hexagonal
     begin
       parinfo=parinfo[1:8]
       p0=p0[1:8]
       p = mpfit('XYZ_match5', p0, functargs=fa,PERROR=PE, PARINFO=parinfo, BESTNORM=bestnorm)
       if n_elements(PE) gt 0 then $
       begin
        p=[p[0],p]
        pe=[pe[0],pe]
       end
     end
  5:$ ; cubic
     begin
       parinfo=parinfo[2:8]
       p0=p0[2:8]
       p = mpfit('XYZ_match4', p0, functargs=fa,PERROR=PE, PARINFO=parinfo, BESTNORM=bestnorm)
       if n_elements(PE) gt 0 then $
       begin
        p=[p[0],p[0],p]
        pe=[pe[0],pe[0],pe]
       end
     end
    else:$
        p = mpfit('XYZ_match', p0, functargs=fa,PERROR=PE, PARINFO=parinfo, BESTNORM=bestnorm)
  endcase


  if n_elements(PE) gt 0 then $
  begin
  DOF     = N_ELEMENTS(X) - N_ELEMENTS(P) ; deg of freedom
  PCERROR = PE * SQRT(BESTNORM / DOF)   ; scaled uncertainties
  ; PCERROR = PE
    return, [p,PCERROR,N_ELEMENTS(X)]
  endif else return, [p0,[0.,0.,0.,0.,0.,0.],N_ELEMENTS(X)]

end

;---------------------------------------------------------------
;---------------------------------------------------------------
; 09/05/2008 PD:
;    -- first version written

function automatic_ub_refinement_against_xyz, ub, xyzs, hkls, sym
  common refine_ub, xyza, hkla, U
  xyza=xyzs
  hkla=hkls
  xyzs1=xyzs
  N=n_elements(xyzs)/3
  X=findgen(N)
  Y=findgen(N)
  ERR=fltarr(N)
  for i=0, N-1 do ERR[i]=1.0
  lp=lp_from_ub(UB)
  apply_symmetry_to_lp, lp, 0, sym

  B=B_from_lp(lp)
  U=U_from_UB(UB)
  roan=[0.,0.,0.] ; additional rotation mtx Om Ch Ph applied to U

  P=[lp,roan]

; Symmetry codes
; 0  - triclinic
; 11 - monoclinic a
; 12 - monoclinic b
; 13 - monoclinic c
; 2  - orthorhombic
; 3  - tetragonal
; 4  - hexagonal
; 5  - cubic

  parinfo = replicate({value:0.D, fixed:0, limited:[0,0], $
                       limits:[0.D,0], tied:''}, 9)

case sym of
 0: $; - triclinic
 begin
 end
 11:$; - monoclinic a
 begin
   lp[4]=90.0
   lp[5]=90.0
   parinfo[4].fixed = 1
   parinfo[5].fixed = 1
 end
 12:$; - monoclinic b
 begin
   lp[3]=90.0
   lp[5]=90.0
   parinfo[3].fixed = 1
   parinfo[5].fixed = 1
 end
 13:$; - monoclinic c
 begin
   lp[3]=90.0
   lp[4]=90.0
   parinfo[3].fixed = 1
   parinfo[4].fixed = 1
 end
 2 :$; - orthorhombic
 begin
   lp[3]=90.0
   lp[4]=90.0
   lp[5]=90.0
   parinfo[3].fixed = 1
   parinfo[4].fixed = 1
   parinfo[5].fixed = 1
 end
 3 :$; - tetragonal
 begin
   lp[3]=90.0
   lp[4]=90.0
   lp[5]=90.0
   parinfo[3].fixed = 1
   parinfo[4].fixed = 1
   parinfo[5].fixed = 1
   parinfo[1].tied = 'P[0]'
 end
 4 :$; - hexagonal
 begin
   lp[3]=90.0
   lp[4]=90.0
   lp[5]=120.0
   parinfo[3].fixed = 1
   parinfo[4].fixed = 1
   parinfo[5].fixed = 1
   parinfo[1].tied = 'P[0]'
 end
 5 :$; - cubic
 begin
   lp[3]=90.0
   lp[4]=90.0
   lp[5]=90.0
   parinfo[3].fixed = 1
   parinfo[4].fixed = 1
   parinfo[5].fixed = 1
   parinfo[1].tied = 'P[0]'
   parinfo[2].tied = 'P[0]'
 end
endcase

   parinfo[0].limited(0) = 1
   parinfo[0].limited(1) = 1
   parinfo[0].limits(0) = P[0]-P[0]/10.
   parinfo[0].limits(1) = P[0]+P[0]/10.

   parinfo[1].limited(0) = 1
   parinfo[1].limited(1) = 1
   parinfo[1].limits(0) = P[1]-P[1]/10.
   parinfo[1].limits(1) = P[1]+P[1]/10.

   parinfo[2].limited(0) = 1
   parinfo[2].limited(1) = 1
   parinfo[2].limits(0) = P[2]-P[2]/10.
   parinfo[2].limits(1) = P[2]+P[2]/10.

   parinfo[6].limited(0) = 1
   parinfo[6].limited(1) = 1
   parinfo[6].limits(0) = 0.
   parinfo[6].limits(1) = 360.

   p0 = P
   fa = {X:x, Y:Y, ERR:err}
   p = mpfit('XYZ_match', p0, functargs=fa,PERROR=PE, PARINFO=parinfo, BESTNORM=bestnorm)

  if n_elements(PE) gt 0 then $
  begin
  DOF     = N_ELEMENTS(X) - N_ELEMENTS(P) ; deg of freedom
  PCERROR = PE * SQRT(BESTNORM / DOF)   ; scaled uncertainties
  ; PCERROR = PE
    return, [p,PCERROR,N_ELEMENTS(X)]
  endif else return, [p0,[0.,0.,0.,0.,0.,0.],N_ELEMENTS(X)]

end

;---------------------------------------------------------------

function recognize_crystal_system_from_lp, lp, lengtol, angtol

ab_dif  = abs(lp[0]-lp[1])
ac_dif  = abs(lp[0]-lp[2])
bc_dif  = abs(lp[1]-lp[2])
abc_dif = max([ab_dif, ac_dif, bc_dif])
alpha_dif = abs(lp[3]-90.0)
beta_dif  = abs(lp[4]-90.0)
gamma_dif = abs(lp[5]-90.0)
ang_dif=max([alpha_dif, beta_dif, gamma_dif])
																										symm=7 ; triclinic
if gamma_dif lt angtol and beta_dif lt angtol then 													symm=4 ; mono-a
if alpha_dif lt angtol and gamma_dif lt angtol then 													symm=5 ; mono-b
if alpha_dif lt angtol and beta_dif lt angtol then 													symm=6 ; mono-c
if ang_dif lt angtol then 																				symm=3 ; orthorhombic
if ab_dif lt lengtol and alpha_dif lt angtol and beta_dif lt angtol and abs(lp[5]-120.0) lt angtol then symm=2 ; hexagonal
if ab_dif lt lengtol and ang_dif lt angtol then 														symm=1 ; tetragonal
if abc_dif lt lengtol and ang_dif lt angtol then 														symm=0 ; cubic
return, symm
end

;---------------------------------------------------------------
function np_lp, sym
;- returns number of free paranmeters in constrained lp refinement
; 0  - triclinic
; 11 - monoclinic a
; 12 - monoclinic b
; 13 - monoclinic c
; 2  - orthorhombic
; 3  - tetragonal
; 4  - hexagonal
; 5  - cubic
case sym of
 0  :s=6 ;- triclinic
 12 :s=4;- monoclinic b
 2  :s=3;- orthorhombic
 3  :s=2;- tetragonal
 4  :s=2;- hexagonal
 5  :s=1;- cubic
 6  :s=2;- rhomb
else: s=6
endcase
return, s
end
;---------------------------------------------------------------
function automatic_lp_refinement3, lp, ds, hkls, sym, excl
; 03/04/2009 PD:
;    -- new version of the routine avoiding TIDED due to problems with running sav files in VM w/o license
; 09/05/2008 PD:
;    -- restored apply_exclusions so it can work with GSE_SHELL
; 09/05/2008 PD:
;    -- modified error model to give more reasonable uncertainties

;  refines lattice parameters against list of measured d-spc with assigned indices
;  applies symmetry constraints
;  estimates refinement errors

  common refine, ds1, hkls1
  N=n_elements(ds)
  if n_elements(excl) eq 0 then $
  begin
    excl=lonarr(N)
    for i=0,n-1 do excl[i]=1
  endif

  ds1=ds
  hkls1=hkls
  Dcal=fltarr(N)
  for i=0, N-1 do Dcal[i]=d_from_lp_and_hkl(lp,hkls1[0:2,i])

  for i=0, N-1 do if abs(dcal[i]-ds[i]) gt 0.05 then excl[i]=0
  apply_exclusions, ds, hkls, excl
  apply_exclusions, dcal, hkls1, excl
  ds1=dcal
  N=n_elements(ds)
  ERR=fltarr(N)
  for i=0, N-1 do ERR[i]=1.0
  X=findgen(N)
  ;for i=0, N-1 do ERR[i]=abs(ds1[i]-Dcal[i])
  ;ERR=ERR>0.0001



; Symmetry codes
; 0  - triclinic
; 11 - monoclinic a
; 12 - monoclinic b
; 13 - monoclinic c
; 2  - orthorhombic
; 3  - tetragonal
; 4  - hexagonal
; 5  - cubic

  parinfo = replicate({value:0.D, fixed:0, limited:[0,0], $
                       limits:[0.D,0]}, 6)

case sym of
 0: $; - triclinic
 begin
 end
 11:$; - monoclinic a
 begin
   lp[4]=90.0
   lp[5]=90.0
   parinfo[4].fixed = 1
   parinfo[5].fixed = 1
 end
 12:$; - monoclinic b
 begin
   lp[3]=90.0
   lp[5]=90.0
   parinfo[3].fixed = 1
   parinfo[5].fixed = 1
 end
 13:$; - monoclinic c
 begin
   lp[3]=90.0
   lp[4]=90.0
   parinfo[3].fixed = 1
   parinfo[4].fixed = 1
 end
 2 :$; - orthorhombic
 begin
   lp[3]=90.0
   lp[4]=90.0
   lp[5]=90.0
   parinfo[3].fixed = 1
   parinfo[4].fixed = 1
   parinfo[5].fixed = 1
 end
 3 :$; - tetragonal
 begin
   lp[3]=90.0
   lp[4]=90.0
   lp[5]=90.0
   parinfo[3].fixed = 1
   parinfo[4].fixed = 1
   parinfo[5].fixed = 1
 end
 4 :$; - hexagonal
 begin
   lp[3]=90.0
   lp[4]=90.0
   lp[5]=120.0
   parinfo[3].fixed = 1
   parinfo[4].fixed = 1
   parinfo[5].fixed = 1
 end
 5 :$; - cubic
 begin
   lp[3]=90.0
   lp[4]=90.0
   lp[5]=90.0
   parinfo[3].fixed = 1
   parinfo[4].fixed = 1
   parinfo[5].fixed = 1
 end
endcase

   parinfo[0].limited(0) = 1
   parinfo[0].limited(1) = 1
   parinfo[0].limits(0) = lP[0]-lP[0]/10.
   parinfo[0].limits(1) = lP[0]+lP[0]/10.

   parinfo[1].limited(0) = 1
   parinfo[1].limited(1) = 1
   parinfo[1].limits(0) = lP[1]-lP[1]/10.
   parinfo[1].limits(1) = lP[1]+lP[1]/10.

   parinfo[2].limited(0) = 1
   parinfo[2].limited(1) = 1
   parinfo[2].limits(0) = lP[2]-lP[2]/10.
   parinfo[2].limits(1) = lP[2]+lP[2]/10.


   p0 = lp
   fa = {X:x, Y:ds, ERR:err}
   print, n_elements(where(excl ne 1))

  case sym of
  3:$ ; tetragonal
     begin
       parinfo=parinfo[1:5]
       p0=p0[1:5]
       p = mpfit('MYFUNCT5', p0, functargs=fa,PERROR=PE, PARINFO=parinfo, BESTNORM=bestnorm)
       if n_elements(PE) gt 0 then $
       begin
        p=[p[0],p]
        pe=[pe[0],pe]
       end
     end
  4:$ ; hexagonal
     begin
       parinfo=parinfo[1:5]
       p0=p0[1:5]
       p = mpfit('MYFUNCT5', p0, functargs=fa,PERROR=PE, PARINFO=parinfo, BESTNORM=bestnorm)
       if n_elements(PE) gt 0 then $
       begin
        p=[p[0],p]
        pe=[pe[0],pe]
       end
     end
  5:$ ; cubic
     begin
       parinfo=parinfo[2:5]
       p0=p0[2:5]
       p = mpfit('MYFUNCT4', p0, functargs=fa,PERROR=PE, PARINFO=parinfo, BESTNORM=bestnorm)
       if n_elements(PE) gt 0 then $
       begin
        p=[p[0],p[0],p]
        pe=[pe[0],pe[0],pe]
       end
     end
    else:$
       p = mpfit('MYFUNCT', p0, functargs=fa,PERROR=PE, PARINFO=parinfo, BESTNORM=bestnorm)
  endcase

  lp=p0
  if n_elements(PE) gt 0 then $
  begin
  DOF     = N_ELEMENTS(X) - np_lp(sym) ; deg of freedom
  PCERROR = PE * SQRT(BESTNORM / DOF)   ; scaled uncertainties
  ; PCERROR = PE
  return, [p,PCERROR,N_ELEMENTS(X)]
  endif else return, [p0,[0.,0.,0.,0.,0.,0.],N_ELEMENTS(X)]

end




function automatic_lp_refinement_twist, lp, ds, hkls, sym, excl
; 03/04/2009 PD:
;    -- new version of the routine avoiding TIDED due to problems with running sav files in VM w/o license
; 09/05/2008 PD:
;    -- restored apply_exclusions so it can work with GSE_SHELL
; 09/05/2008 PD:
;    -- modified error model to give more reasonable uncertainties

;  refines lattice parameters against list of measured d-spc with assigned indices
;  applies symmetry constraints
;  estimates refinement errors

  common refine, ds1, hkls1
  N=n_elements(ds)
  if n_elements(excl) eq 0 then $
  begin
    excl=lonarr(N)
    for i=0,n-1 do excl[i]=1
  endif

  ds1=ds
  hkls1=hkls
  Dcal=fltarr(N)
  for i=0, N-1 do Dcal[i]=d_from_lp_and_hkl(lp,hkls1[0:2,i])

  for i=0, N-1 do if abs(dcal[i]-ds[i]) gt 0.05 then excl[i]=0
  apply_exclusions, ds, hkls, excl
  apply_exclusions, dcal, hkls1, excl
  ds1=dcal
  N=n_elements(ds)
  ERR=fltarr(N)
  for i=0, N-1 do ERR[i]=1.0
  X=findgen(N)
  ;for i=0, N-1 do ERR[i]=abs(ds1[i]-Dcal[i])
  ;ERR=ERR>0.0001



; Symmetry codes
; 0  - triclinic
; 11 - monoclinic a
; 12 - monoclinic b
; 13 - monoclinic c
; 2  - orthorhombic
; 3  - tetragonal
; 4  - hexagonal
; 5  - cubic

  parinfo = replicate({value:0.D, fixed:0, limited:[0,0], $
                       limits:[0.D,0]}, 7)

case sym of
 0: $; - triclinic
 begin
 end
 11:$; - monoclinic a
 begin
   lp[4]=90.0
   lp[5]=90.0
   parinfo[4].fixed = 1
   parinfo[5].fixed = 1
 end
 12:$; - monoclinic b
 begin
   lp[3]=90.0
   lp[5]=90.0
   parinfo[3].fixed = 1
   parinfo[5].fixed = 1
 end
 13:$; - monoclinic c
 begin
   lp[3]=90.0
   lp[4]=90.0
   parinfo[3].fixed = 1
   parinfo[4].fixed = 1
 end
 2 :$; - orthorhombic
 begin
   lp[3]=90.0
   lp[4]=90.0
   lp[5]=90.0
   parinfo[3].fixed = 1
   parinfo[4].fixed = 1
   parinfo[5].fixed = 1
 end
 3 :$; - tetragonal
 begin
   lp[3]=90.0
   lp[4]=90.0
   lp[5]=90.0
   parinfo[3].fixed = 1
   parinfo[4].fixed = 1
   parinfo[5].fixed = 1
 end
 4 :$; - hexagonal
 begin
   lp[3]=90.0
   lp[4]=90.0
   lp[5]=120.0
   parinfo[3].fixed = 1
   parinfo[4].fixed = 1
   parinfo[5].fixed = 1
 end
 5 :$; - cubic
 begin
   lp[3]=90.0
   lp[4]=90.0
   lp[5]=90.0
   parinfo[3].fixed = 1
   parinfo[4].fixed = 1
   parinfo[5].fixed = 1
 end
endcase

   parinfo[0].limited(0) = 1
   parinfo[0].limited(1) = 1
   parinfo[0].limits(0) = lP[0]-lP[0]/10.
   parinfo[0].limits(1) = lP[0]+lP[0]/10.

   parinfo[1].limited(0) = 1
   parinfo[1].limited(1) = 1
   parinfo[1].limits(0) = lP[1]-lP[1]/10.
   parinfo[1].limits(1) = lP[1]+lP[1]/10.

   parinfo[2].limited(0) = 1
   parinfo[2].limited(1) = 1
   parinfo[2].limits(0) = lP[2]-lP[2]/10.
   parinfo[2].limits(1) = lP[2]+lP[2]/10.

   parinfo[6].limited(0) = 1
   parinfo[6].limited(1) = 1
   parinfo[6].limits(0) = -2.
   parinfo[6].limits(1) = 2.


   p0 = [lp,0.0]
   fa = {X:x, Y:ds, ERR:err}
   print, n_elements(where(excl ne 1))

  case sym of
  3:$ ; tetragonal
     begin
       parinfo=parinfo[1:6]
       p0=p0[1:6]
       p = mpfit('MYFUNCT5', p0, functargs=fa,PERROR=PE, PARINFO=parinfo, BESTNORM=bestnorm)
       if n_elements(PE) gt 0 then $
       begin
        p=[p[0],p]
        pe=[pe[0],pe]
       end
     end
  4:$ ; hexagonal
     begin
       parinfo=parinfo[1:6]
       p0=p0[1:6]
       p = mpfit('MYFUNCT5', p0, functargs=fa,PERROR=PE, PARINFO=parinfo, BESTNORM=bestnorm)
       if n_elements(PE) gt 0 then $
       begin
        p=[p[0],p]
        pe=[pe[0],pe]
       end
     end
  5:$ ; cubic
     begin
       parinfo=parinfo[2:6]
       p0=p0[2:6]
       p = mpfit('MYFUNCT4', p0, functargs=fa,PERROR=PE, PARINFO=parinfo, BESTNORM=bestnorm)
       if n_elements(PE) gt 0 then $
       begin
        p=[p[0],p[0],p]
        pe=[pe[0],pe[0],pe]
       end
     end
    else:$
       p = mpfit('MYFUNCT_twist', p0, functargs=fa,PERROR=PE, PARINFO=parinfo, BESTNORM=bestnorm)
  endcase

  lp=p0
  if n_elements(PE) gt 0 then $
  begin
  DOF     = N_ELEMENTS(X) - np_lp(sym) ; deg of freedom
  PCERROR = PE * SQRT(BESTNORM / DOF)   ; scaled uncertainties
  ; PCERROR = PE
  return, [p,PCERROR,N_ELEMENTS(X)]
  endif else return, [p0,[0.,0.,0.,0.,0.,0.],N_ELEMENTS(X)]

end


;---------------------------------------------------------------
function automatic_lp_refinement1, lp, ds, hkls, sym, excl

; 09/05/2008 PD:
;    -- restored apply_exclusions so it can work with GSE_SHELL
; 09/05/2008 PD:
;    -- modified error model to give more reasonable uncertainties

;  refines lattice parameters against list of measured d-spc with assigned indices
;  applies symmetry constraints
;  estimates refinement errors

  common refine, ds1, hkls1
  N=n_elements(ds)
  if n_elements(excl) eq 0 then $
  begin
    excl=lonarr(N)
    for i=0,n-1 do excl[i]=1
  endif

  ds1=ds
  hkls1=hkls
  Dcal=fltarr(N)
  for i=0, N-1 do Dcal[i]=d_from_lp_and_hkl(lp,hkls1[0:2,i])

  for i=0, N-1 do if abs(dcal[i]-ds[i]) gt 0.05 then excl[i]=0
  apply_exclusions, ds, hkls, excl
  apply_exclusions, dcal, hkls1, excl
  ds1=dcal
  N=n_elements(ds)
  ERR=fltarr(N)
  for i=0, N-1 do ERR[i]=1.0
  X=findgen(N)
  ;for i=0, N-1 do ERR[i]=abs(ds1[i]-Dcal[i])
  ;ERR=ERR>0.0001



; Symmetry codes
; 0  - triclinic
; 11 - monoclinic a
; 12 - monoclinic b
; 13 - monoclinic c
; 2  - orthorhombic
; 3  - tetragonal
; 4  - hexagonal
; 5  - cubic

  parinfo = replicate({value:0.D, fixed:0, limited:[0,0], $
                       limits:[0.D,0], tied:''}, 6)

case sym of
 0: $; - triclinic
 begin
 end
 11:$; - monoclinic a
 begin
   lp[4]=90.0
   lp[5]=90.0
   parinfo[4].fixed = 1
   parinfo[5].fixed = 1
 end
 12:$; - monoclinic b
 begin
   lp[3]=90.0
   lp[5]=90.0
   parinfo[3].fixed = 1
   parinfo[5].fixed = 1
 end
 13:$; - monoclinic c
 begin
   lp[3]=90.0
   lp[4]=90.0
   parinfo[3].fixed = 1
   parinfo[4].fixed = 1
 end
 2 :$; - orthorhombic
 begin
   lp[3]=90.0
   lp[4]=90.0
   lp[5]=90.0
   parinfo[3].fixed = 1
   parinfo[4].fixed = 1
   parinfo[5].fixed = 1
 end
 3 :$; - tetragonal
 begin
   lp[3]=90.0
   lp[4]=90.0
   lp[5]=90.0
   parinfo[3].fixed = 1
   parinfo[4].fixed = 1
   parinfo[5].fixed = 1
   parinfo[1].tied = 'P[0]'
 end
 4 :$; - hexagonal
 begin
   lp[3]=90.0
   lp[4]=90.0
   lp[5]=120.0
   parinfo[3].fixed = 1
   parinfo[4].fixed = 1
   parinfo[5].fixed = 1
   parinfo[1].tied = 'P[0]'
 end
 5 :$; - cubic
 begin
   lp[3]=90.0
   lp[4]=90.0
   lp[5]=90.0
   parinfo[3].fixed = 1
   parinfo[4].fixed = 1
   parinfo[5].fixed = 1
   parinfo[1].tied = 'P[0]'
   parinfo[2].tied = 'P[0]'
 end
endcase

   parinfo[0].limited(0) = 1
   parinfo[0].limited(1) = 1
   parinfo[0].limits(0) = lP[0]-lP[0]/10.
   parinfo[0].limits(1) = lP[0]+lP[0]/10.

   parinfo[1].limited(0) = 1
   parinfo[1].limited(1) = 1
   parinfo[1].limits(0) = lP[1]-lP[1]/10.
   parinfo[1].limits(1) = lP[1]+lP[1]/10.

   parinfo[2].limited(0) = 1
   parinfo[2].limited(1) = 1
   parinfo[2].limits(0) = lP[2]-lP[2]/10.
   parinfo[2].limits(1) = lP[2]+lP[2]/10.

   ;parinfo[4].fixed = 1

   p0 = lp
   fa = {X:x, Y:ds, ERR:err}
   print, n_elements(where(excl ne 1))
   p = mpfit('MYFUNCT', p0, functargs=fa,PERROR=PE, PARINFO=parinfo, BESTNORM=bestnorm)
   lp=p0
  if n_elements(PE) gt 0 then $
  begin
  DOF     = N_ELEMENTS(X) - np_lp(sym) ; deg of freedom
  PCERROR = PE * SQRT(BESTNORM / DOF)   ; scaled uncertainties
  ; PCERROR = PE
  return, [p,PCERROR,N_ELEMENTS(X)]
  endif else return, [p0,[0.,0.,0.,0.,0.,0.],N_ELEMENTS(X)]

end
;---------------------------------------------------------------

function automatic_lp_refinement2, lp, ds, hkls, sym, excl

;  refines lattice parameters against list of measured d-spc with assigned indices
;  applies symmetry constraints
;  estimates refinement errors

  common refine, ds1, hkls1
  apply_exclusions, ds, hkls, excl
  ds1=ds
  hkls1=hkls
  N=n_elements(ds)
  X=findgen(N)
  ERR=fltarr(N)
  Dcal=fltarr(N)
  for i=0, N-1 do Dcal[i]=d_from_lp_and_hkl(lp,hkls1[0:2,i])
  for i=0, N-1 do ERR[i]=abs(ds1[i]-Dcal[i])
  ERR=ERR>0.0001

; Symmetry codes
; 0  - triclinic
; 11 - monoclinic a
; 12 - monoclinic b
; 13 - monoclinic c
; 2  - orthorhombic
; 3  - tetragonal
; 4  - hexagonal
; 5  - cubic

  ;'CUBIC'       :res=0
  ;'TETRAGONAL'  :res=1
  ;'ORTHORHOMBIC':res=2
  ;'HEXAGONAL'   :res=3
  ;'RHOMBOHEDRAL':res=4
  ;'MONOCLINIC'  :res=5
  ;'TRICLINIC'   :res=6


  parinfo = replicate({value:0.D, fixed:0, limited:[0,0], $
                       limits:[0.D,0], tied:''}, 6)

case sym of
 6: $; - triclinic
 begin
 end
 5:$; - monoclinic b
 begin
   lp[3]=90.0
   lp[5]=90.0
   parinfo[3].fixed = 1
   parinfo[5].fixed = 1
 end
 2 :$; - orthorhombic
 begin
   lp[3]=90.0
   lp[4]=90.0
   lp[5]=90.0
   parinfo[3].fixed = 1
   parinfo[4].fixed = 1
   parinfo[5].fixed = 1
 end
 1 :$; - tetragonal
 begin
   lp[3]=90.0
   lp[4]=90.0
   lp[5]=90.0
   parinfo[3].fixed = 1
   parinfo[4].fixed = 1
   parinfo[5].fixed = 1
   parinfo[1].tied = 'P[0]'
 end
 3 :$; - hexagonal
 begin
   lp[3]=90.0
   lp[4]=90.0
   lp[5]=120.0
   parinfo[3].fixed = 1
   parinfo[4].fixed = 1
   parinfo[5].fixed = 1
   parinfo[1].tied = 'P[0]'
 end
 4 :$; - rhombohedral
 begin
   parinfo[1].tied = 'P[0]'
   parinfo[2].tied = 'P[0]'
   parinfo[4].tied = 'P[3]'
   parinfo[5].tied = 'P[3]'
 end
 0 :$; - cubic
 begin
   lp[3]=90.0
   lp[4]=90.0
   lp[5]=90.0
   parinfo[3].fixed = 1
   parinfo[4].fixed = 1
   parinfo[5].fixed = 1
   parinfo[1].tied = 'P[0]'
   parinfo[2].tied = 'P[0]'
 end
endcase
  p0 = lp
  fa = {X:x, Y:ds1, ERR:err}

  p = mpfit('MYFUNCT', p0, functargs=fa,PERROR=PE, PARINFO=parinfo)
  lp=p0
  if n_elements(pe) eq 0 then pe=fltarr(6)
  return, [p,pe]
end

;----------------------------------

function open_UB, fname
COMMON pat, path
  ub=fltarr(3,3)
  if n_params() eq 0 then $
  fname=dialog_pickfile(FILTER='*.ub', /READ, PATH=path)
  if fname ne '' then $
  begin
  free_lun, 2
  openr, 2, fname
  a1=0.0
  a2=0.0
  a3=0.0
  readf, 2, a1, a2, a3
  UB[0,0]=float(a1)
  UB[1,0]=float(a2)
  UB[2,0]=float(a3)
  readf, 2, a1, a2, a3
  UB[0,1]=float(a1)
  UB[1,1]=float(a2)
  UB[2,1]=float(a3)
  readf, 2, a1, a2, a3
  UB[0,2]=float(a1)
  UB[1,2]=float(a2)
  UB[2,2]=float(a3)
  close,2
  free_lun, 2
  endif
  return, ub
end


;----------------------------------
function calc_ub_from_three, hkls, xyzs
  UB=transpose(XYZs # transpose(HKLs) # invert(HKLs # transpose(HKLS)))
  return, UB
end
;----------------------------------
function ang_between_hkls, lp, hkl1, hkl2
 b=b_from_lp(lp)
 xyz1=hkl1 # b
 xyz2=hkl2 # b
 return, ang_between_vecs(xyz1, xyz2)
end

;----------------------------------


pro save_UB, ub, fname
  if fname ne '' then $
  begin
   free_lun, 2
   openw, 2, fname
   printf, 2, ub[0,0], ub[1,0], ub[2,0]
   printf, 2, ub[0,1], ub[1,1], ub[2,1]
   printf, 2, ub[0,2], ub[1,2], ub[2,2]
   close,2
   free_lun, 2
  endif
end

pro crystallography
end
