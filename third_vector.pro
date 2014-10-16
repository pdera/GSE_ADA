; Finding a third basis vector for 2d indexing

;- we have a a pair of basis vectors, a* and b*, and know the lattice parameters
;- calculate the inter vector angles and vector lengths

;- find transformation mtx. T to bring a* to be along x (a*')

;- generate c*' at a proper angle to a*', in x-z plane

;- find rotation angle about x-axis that will make the angle beetween c*' and b*' proper (result is c*'')

;- make the length of c*'' appropriate

;- apply inverse trnasformation T-1

;- the identity of the plane has to be recognized first


function reciprocal_lp, lp

 B=b_from_lp(lp)
 ;print, b
 as=B[0,0:2]
 bs=B[1,0:2]
 cs=B[2,0:2]
 return,[vlength(as),vlength(bs),vlength(cs),ang_between_vecs(bs,cs),ang_between_vecs(as,cs),ang_between_vecs(as,bs)]

end

;--------
function get_rot, abc

 b1=(abc[0]^2*abc[1]^2-abc[1]^2*abc[2]^2+abc[1]^4)
 if b1 lt 0 then goto, err
 b2=(abc[0]^2+abc[1]^2)

 a1=-(abc[0]*(abc[0]*abc[2]-sqrt(b1))/b2+abc[2])/abc[1]
 a2=(abc[0]*abc[2]-sqrt(b1))/b2
 om1=atan(a1,a2)

 a1=-(abc[0]*(abc[0]*abc[2]+sqrt(b1))/b2+abc[2])/abc[1]
 a2=(abc[0]*abc[2]+sqrt(b1))/b2
 om2=atan(a1,a2)

 return, [om1*!radeg, om2*!radeg]
 err: return, [-1000, -1000]
end

;------------

function third_vector, as, bs, lp

; This function calculates orientation matrix from two principal reciprocal vectors (only directions are used)
; and unit cell parameters (lp)
; it is assumed that the missing proncipal vector is a* (according to the unit cell parameter settings)
; the angle between the two vectors supplied as arguments should be equal alpha*

common Rota, Mtx


;-----temp
;B=b_from_lp(lp)
;GenerateR, 3, -23
;UB0=mtx ## B
;GenerateR, 1, -11
;UB0=mtx ## UB0
;GenerateR, 2, 131
;UB0=mtx ## UB0
;;print, ub0
;as=UB0[2,0:2]
;bs=UB0[1,0:2]
;------ temp


rlp=reciprocal_lp(lp)
if abs(ang_between_vecs(as,bs) - lp[3]) lt 1.0 or abs(abs(ang_between_vecs(as,bs) + lp[3])-180) lt 1.0 then $
begin




as=as/vlength(as)
bs=bs/vlength(bs)

;- find transformation mtx. T to bring a* to be along x (a*')
om=atan(as[1],as[0])*!radeg
GenerateR, 3, -om
om=mtx
as1=om ## as
as1=as1/vlength(as1)
ch=atan(as1[0],as1[2])*!radeg
GenerateR, 2, ch

T=mtx ## om
as2=T ## as
if as2[2] lt 0 then $
begin
 GenerateR, 2, -ch+180.
 ch=mtx
 T=ch ## om
 as2=T ## as
; print, as2
end

bs1=T ## bs

bs1n=bs1/vlength(bs1)

om2=atan(bs1n[0],bs1n[1])*!radeg
GenerateR, 3, om2
;print, mtx ## bs1n

T=mtx ## T
B=b_from_lp(lp)
UB=invert(T) ## B

return, ub
endif else $
begin
  print, 'angle does not agree', ang_between_vecs(as,bs), lp[3]
  return, 0
endelse
end

; within the given d-spc tolerance finds hkl indices of peaks that match the given d-spc

function find_possible_hkls, d1, lp, dtol, hkl
il=0
res=[0,0,0]
for i=-hkl[0], hkl[0] do $
  for j=-hkl[1], hkl[1] do $
    for k=-hkl[2], hkl[2] do $
    BEGIN
      hkla=[i,j,k]
      dc=d_from_lp_and_hkl(lp, hkla)
      dd=abs(d1-dc)
      if dd lt dtol then $
      begin
         il=il+1
         res[0,0]=il
         res=[[res],[hkla]]
      endif
   endfor
   return, res
end
;---------------------------------------------------
function recognize_two_vectors, x1,x2,lp,dtol, angtol

 d1=1./vlength(x1)
 d2=1./vlength(x2)
 hkls1=find_possible_hkls(d1,lp,dtol,[10,10,10])
 hkls2=find_possible_hkls(d2,lp,dtol,[10,10,10])
 ;print, hkls1
 ;print, hkls2
 ;print, '----------------------------------'
 meas_ang=ang_between_vecs(x1,x2)
 ;print, meas_ang
 a=(hkls1[0,0]-1)*(hkls2[0,0]-1)
 ch=fltarr(a[0])
 ij=fltarr(a[0],2)
 if hkls1[0,0] ne 0 and hkls2[0,0] ne 0 then $
 begin
   for i=1, hkls1[0,0]-1 do $
     for j=1, hkls2[0,0]-1 do $
     begin
        ij[(i-1)*(hkls2[0,0]-1)+j-1,*]=[i,j]
        ch[(i-1)*(hkls2[0,0]-1)+j-1]=angle_between_hkls(hkls1[0:2,i], hkls2[0:2,j], lp)
     endfor
 endif
 ch1=min(abs(ch-meas_ang), w)
 hkl1=hkls1[*,ij[w,0]]
 hkl2=hkls2[*,ij[w,1]]
 angerr=ch1
 if angerr lt angtol then return,[1, hkl1, hkl2] else return,[0,[0,0,0],[0,0,0]]
end
;---------------------------------------------------
function UB_from_two_vecs_and_lp, x1,x2,hkl1,hkl2,lp
; specify two primary vectors x1 and x2 and their respective hkls as well as  unit cell parametrs
; will calculate the orientation matrix
 ;--
 B=b_from_lp(lp)
 hkl3=crossprod(hkl1,hkl2) ; hkls of the  third vector I need
 x3=crossprod(x1,x2); Cartesian coords of the third vector
 x3=x3/vlength(x3)
 x3=x3/d_from_lp_and_hkl(lp, hkl3)
 xyzs=[[x1],[x2],[x3]]
 hkls=[[hkl1],[hkl2],[hkl3]]
 return, calc_ub_from_three(hkls, xyzs)
end
;---------------------------------------------------
;---------------------------------------------------

pro test
common Rota, Mtx

 lp=[4.737,4.737,3.185,90,90,90]
 B=b_from_lp(lp)
 GenerateR, 1, -11
 UB0=mtx ## B
 GenerateR, 2, 131
 UB0=mtx ## UB0
 print, ub0
 print, '--------'
 hkl1=[0,3,1]
 hkl2=[1,2,1]
 as= hkl1 # UB0
 bs= hkl2 # UB0
 ub=UB_from_two_vecs_and_lp(as,bs,hkl1,hkl2,lp)
 print, ub
 print, '--------'

end