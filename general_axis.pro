pro solve_general_axis, vec, wv, om, chi

 ang=general_axis(A,vec,wv)
end
;-------------------
function general_axis
;------------------------------------------------------------------
; Finds phi angles at which vector Vec is in diffracting position
;------------------------------------------------------------------
; A   - rotation matrix for omega and chi
; Vec - Cart. coordinates of reciprocal vec.
; Wv  - wavelength

 V=vlength(Vec)
 d=1.0/V
 xyz=Vec/V
 theta=asin(0.5*Wv/d)
 C=!pi/2.0-theta
 phi11=-xyz[1]*A[0,0]+xyz[0]*A[0,1]
 phi21= xyz[1]*A[0,0]-xyz[0]*A[0,1]

 SQ=sqrt(2.0*C*xyz[2]*A[0,2]-C^2+xyz[0]^2*(A[0,0]^2+A[0,1]^2)+xyz[1]^2*(A[0,0]^2+A[0,1]^2)-xyz[2]^2*A[0,2]^2)
 phi2=C+xyz[0]*A[0,0]+xyz[1]*A[0,1]-xyz[2]*A[0,2]

 P1= 2.0*atan((phi11+SQ),phi2)
 P2=-2.0*atan((phi21+SQ),phi2)
 return, (P1,P2)
end