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
; FUNCTION ERROR_estimates_from_d, lp, ds, hkls, sym
; FUNCTION ERROR_estimates_from_xyz, ub, xyzs, hkls, sym
; function automatic_lp_refinement, lp, ds, hkls, sym
; function flags_from_sym, sym
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
; function get_omega, en , xyz
;                  From xyz and energy  calculates the omega angle (in deg) at which xyz will come
;                  into diffracting position during omega scan at chi 0
;                  if diffraction position inaccessible in omega scan returns [-1000,-1000]
; function test_lp_against_ds, lp,ds, hkls
; function test_ub_against_xyz, ub, xyzs, hkls
; function find_closest_d, lp, d, hkl
; function hkl_from_ub_and_xyz, ub, xyz


function generate_rotation, om,ch,ph
  common Rota, Mtx

GenerateR, 3, ph
Rph=mtx
GenerateR, 1, ch
Rch=mtx
GenerateR, 3, om
Rom=mtx


return, Rom # Rch # Rph

end

function euler_decomposition, rr


r=transpose(rr)

common Rota, Mtx
 ; r is 3x3 general rotation matrix
 ; the result is omega, chi, phi Euler angles


;heading = atan2(-m20,m00)
;bank = atan2(-m12,m11)
;attitude = asin(m10)


ome=-atan(r[2,0],-r[2,1])*!radeg
chi=acos(r[2,2])  *!radeg
phi=-atan(r[0,2],r[1,2]) *!radeg

GenerateR, 3, phi
a1=mtx
GenerateR, 1, chi
a2=mtx
GenerateR, 3, ome
a3=mtx

;print, rr
;print
;print, a3 # a2 # a1
;print
return, [ome, chi, phi]

end

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
function A_to_kev, la
; changes lamda in A to energy in keV
  return, 12.39842/la
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

function tth_from_en_and_d, en, d
; calculates bragg angle from energy and d-spc
 la=kev_to_A(En)
 return, 2.0*asin(la/(2.0*d))*!radeg
end

;-----------------------------------------

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
function hkl_from_ub_and_xyz, ub, xyz
; calculates miller indices (floating point) from ub matrix and xyz coordinates
    iUB=invert(UB)
    hkl=iUB ## xyz
    return, hkl
end

;--------------------------------------------------------------------
function get_omega, en , xyz
; From xyz and energy  calculates the omega angle (in deg) at which xyz will come
; into diffracting position during omega scan at chi 0
; if diffraction position inaccessible in omega scan returns [-1000,-1000]
common Rota, Mtx

 d=1./vlength(xyz)
 tthe=tth_from_en_and_d(en, d)

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
function general_rotation_equation,a,b,f
 if a*a*b*b-a*a*f*f+a*a*a*a ge 0.0 then $
 begin
  C=sqrt(a*a*b*b-a*a*f*f+a*a*a*a)
  D=a*a+b*b
  x1=atan(-(b*(b*f-C)/D-f)/a,(b*f-C)/D)
  x2=atan(-(b*(b*f+C)/D-f)/a,(b*f+C)/D)
  return, [x1, x2]*!radeg
 endif else   return, [-1000, -1000]
end
;--------------------------------------------------------------------

function get_omega_nonorthog, en , xyz, al
; From xyz and energy  calculates the omega angle (in deg) at which xyz will come
; into diffracting position during scan about rotation axis nonorthogonal to the beam
; if diffraction position inaccessible in omega scan returns [-1000,-1000]
; al is the angle between plane normal to the meam and rotation axis.

common Rota, Mtx

 d=1./vlength(xyz)
 tthe=tth_from_en_and_d(en, d)

 xyz1=xyz/vlength(xyz)

 x=xyz1[0]
 y=xyz1[1]
 z=xyz1[2]

 tth=cos((90.+tthe/2.0)/!radeg)

 a=(y*cos(al/!radeg)-z*sin(al/!radeg))
 b=x
 f=tth
 return, general_rotation_equation(a,b,f)
end

;--------------------------------------------------------------------
function get_omega_orthog, en , xyz
; From xyz and energy  calculates the omega angle (in deg) at which xyz will come
; into diffracting position during omega scan at chi 0
; if diffraction position inaccessible in omega scan returns [-1000,-1000]
common Rota, Mtx

 d=1./vlength(xyz)
 tthe=tth_from_en_and_d(en, d)

 xyz1=xyz/vlength(xyz)

 x=xyz1[0]
 y=xyz1[1]
 z=xyz1[2]

 tth=cos((90.+tthe/2.0)/!radeg)

 a=y
 b=x
 f=tth
 return, general_rotation_equation(a,b,f)
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

  FUNCTION MYFUNCT, p, X=x, Y=y, ERR=err
  ; p= lp
  ; X=index
  ; Y=measured d
  common refine, ds1, hkls1
   N=n_elements(X)
   f=fltarr(N)
   for i=0, N-1 do F[i]=d_from_lp_and_hkl(p,hkls1[0:2,X[i]])
   return, (Y-F)/ERR
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

function automatic_lp_refinement1, lp, ds, hkls, sym, excl

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
 41 :$; - rhombohedral
 begin
   parinfo[1].tied = 'P[0]'
   parinfo[2].tied = 'P[0]'
   parinfo[4].tied = 'P[3]'
   parinfo[5].tied = 'P[3]'
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
  p0 = lp
  fa = {X:x, Y:ds1, ERR:err}

  p = mpfit('MYFUNCT', p0, functargs=fa,PERROR=PE, PARINFO=parinfo)
  lp=p0
  return, [p,pe]
end
;----------------------------------

function open_UB, fname
  ub=fltarr(3,3)
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

;----------------------------------

pro crystallography
end
