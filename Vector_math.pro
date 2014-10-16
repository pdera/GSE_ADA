 ; -------------------------------------------------------------------------
; -----------------------  Generates rotation matrix            -----------
; -------------------------------------------------------------------------

; Rotation matrix about axisnumber (1=x, 2=y, 3=z) by angle, result passed in
; Rota, Mtx

; -------------------------------------------------------------------------


pro GenerateR, axisnumber, angle
common Rota, Mtx
Mtx=FLTARR(3,3)
       pi=acos(-1)
       s=angle*Pi/180.0;
       case axisnumber of $
       1: begin
            Mtx[0,0]=1.0;
            Mtx[0,1]=0.0;
            Mtx[0,2]=0.0;
            Mtx[1,0]=0.0;
            Mtx[1,1]=cos(s);
            Mtx[1,2]=-sin(s);
            Mtx[2,0]=0.0;
            Mtx[2,1]=sin(s);
            Mtx[2,2]=cos(s);
          end;
       2: begin
            Mtx[0,0]=cos(s);
            Mtx[0,1]=0.0;
            Mtx[0,2]=sin(s);
            Mtx[1,0]=0.0;
            Mtx[1,1]=1.0;
            Mtx[1,2]=0.0;
            Mtx[2,0]=-sin(s);
            Mtx[2,1]=0.0;
            Mtx[2,2]=cos(s);
          end;
       3: begin
            Mtx[0,0]=cos(s);
            Mtx[0,1]=sin(s);
            Mtx[0,2]=0.0
            Mtx[1,0]=-sin(s);
            Mtx[1,1]=cos(s);
            Mtx[1,2]=0.0
            Mtx[2,0]=0.0;
            Mtx[2,1]=0.0;
            Mtx[2,2]=1.0
          end
       endcase
end


Function Euler_decomposition, RR
R=transpose(RR)
 X=atan( R[2,1],R[2,2])
 Y=atan(-R[2,0],sqrt(R[2,1]*R[2,1]+R[2,2]*R[2,2]))
 Z=atan(R[1,0],R[0,0])
 return, [X,Y,Z]
end

Function Euler_composition, an
common Rota, Mtx
angs=an*!radeg
 GenerateR, 1, angs[0]
 X=mtx
 GenerateR, 2, angs[1]
 Y=mtx
 GenerateR, 3, -angs[2]
 Z=mtx
 return, transpose(Z # Y # X)
end

; -------------------------------------------------------------------------
; -----------------------  Calculates vector length             -----------
; -------------------------------------------------------------------------

FUNCTION vlength, vec
 a=sqrt(vec[0]*vec[0]+vec[1]*vec[1]+vec[2]*vec[2])
 return, a
end

;------------------------------------------------------
;------------------------------------------------------
function crossprod, vec1, vec2
return, [vec1[1]*vec2[2]-vec1[2]*vec2[1],-(vec1[0]*vec2[2]-vec1[2]*vec2[0]),vec1[0]*vec2[1]-vec1[1]*vec2[0]]
end



; -------------------------------------------------------------------------
; -----------------------  Calculates scalar product            -----------
; -------------------------------------------------------------------------


FUNCTION dotprod, vec1, vec2
 a=(vec1[0]*vec2[0]+vec1[1]*vec2[1]+vec1[2]*vec2[2])
 return, a
end


;================================================================
;   ---------------   Sign function -----------------------
;================================================================

function sign, x
  a=0
  if x lt 0 then a=-1 $
  else if  x gt 0 then a=1 $
  else a=0
  return, a
end

;================================================================
;   ---------------   Angle between vectors function -----------------------
;================================================================

function ang_between_vecs, vec1, vec2
  Pi=acos(-1.0)
  a=0.0
  a=dotprod(vec1, vec2)/(vlength(vec1)*vlength(vec2))
  a=abs(acos(a)*180.0/Pi)
  return, a
end

;-----------------------------
; Calculates point of intersection of straigt line defined by point P0
; and vector line u with a plane defined by point V0 and vector
; noramal n

function line_plane_intersection, u, n, P0, V0
  ;check if paralell
  if ang_between_vecs(u,n) eq 0 or ang_between_vecs(u,n) eq 180.0 then xyz=[0.0,0.0,0.0]
  w=P0-V0
  s=-dotprod(n,w)/dotprod(n,u)
  xyz=P0+s*u
  return, xyz
end

