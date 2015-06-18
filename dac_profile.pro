function dac_profile, angle, r

; Corrections made on 2/14/2011

; Calculates the absorption correction for the cBN upstream seat
; with a conical opening and the upstream diamond (diamond contribution is negligible)
; The function describes I/Io changes as a function of omega angle.
; Input angle in degrees

   ;==== DAC geometry parameters =====

   diam_height   =   1.8000 ; greg1 hpcat
   CBN_height    =   5.600
   CBN_bigdiam   =   4.000
   CBN_smalldiam =   0.705

   ;==================================

   diam_mu =  0.00462948
   CBN_mu =   0.1350460

   if n_params() gt 1 then $
   begin
    a=read_abs()

    angle=angle+a[5] ; omega offset
    an=angle/!radeg ; angle in radians

    diam_height   =   a[0]
    CBN_height    =   a[1]
    CBN_bigdiam   =   a[2]
    CBN_smalldiam =   a[3]
    CBN_mu        =   a[4]

   end

   if an eq 0 then l_diam=diam_height else l_diam=abs(diam_height/cos(an)) ; path length through diamond

   cbn_cangle1=atan(0.5*CBN_smalldiam/diam_height)*!radeg
   cbn_cangle2=atan(0.5*CBN_bigdiam/(diam_height+CBN_height))*!radeg
   alpha=atan(0.5*(CBN_bigdiam-CBN_smalldiam)/CBN_height)*!radeg ; opening angle of the cbn cone
   beta=180.0-alpha
   gamma=180.0-abs(angle)-beta
   dh=(CBN_height+diam_height)-0.5*CBN_bigdiam/tan(alpha/!radeg)


   if abs(angle) le cbn_cangle1 then l_CBN=0.0 else $        ; no cbn absorption
   if abs(angle) lt cbn_cangle2 then $
   begin
     l4=dh*sin(beta/!radeg)/sin(gamma/!radeg) ; total path length
     l_CBN=l4-l_diam
   endif else $  ; inside of the cone
   l_CBN=CBN_height/cos(an/2.0) 		    	                 ; full length of cbn

   att_diam=exp(-diam_mu*l_diam)
   att_cbn=exp(-CBN_mu*l_CBN)
   att=att_diam*att_cbn
   return, att

end