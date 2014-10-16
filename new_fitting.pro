
;-----------------------------

function G2D_flattop, X, Y, P

; parameters
;   P[0] - background
;   P[1] - peak intensity
;   P[2] - x width
;   P[3] - y width
;   P[4] - tilting of the profile
;   P[5] - x shift
;   P[6] - y shift
 LYV=65535 ;top y value

 mtx=[[cos(p[4]),sin(p[4])],[-sin(p[4]),cos(p[4])]]
 XY=[[X],[Y]]
 XY1=mtx ## XY
 sz=n_elements(X)
 X1=XY1[0:sz-1,0]
 Y1=XY1[0:sz-1,1]
 sz=n_elements(p)
 if sz eq 8 then $
 begin
 U=((x1-p[5])/p[2])^2+((y1-p[6])/p[3])^2
 G=p[0]+p[1]*exp(-U/2.)
 return,G<LYV
 endif else return,0
end

;--------------------------------

pro new_fitting, pica, bs

    pic=pica;<1000
    Gauss = GAUSS2DFIT( pic, P0, /TILT)
    print, 'gaussfit', p0
    p1=p0
    p1[2]=p0[2]
    p1[3]=p0[3]
    p1[5]=p0[5]-BS[0]
    p1[6]=p0[4]-bs[1]
    p1[4]=p0[6]


   parinfo = replicate({value:0.D, fixed:0, limited:[0,0], $
                       limits:[0.D,0]}, 8)
   parinfo[4].limits(0)  = -!pi;!pi/2.
   parinfo[4].limits(1)  =  !pi;*3./2.
   parinfo[5].limited(0) = 1
   parinfo[5].limited(1) = 1
   parinfo[5].limits(0)  = -bs[0]
   parinfo[5].limits(1)  = bs[0]
   parinfo[6].limited(0) = 1
   parinfo[6].limited(1) = 1
   parinfo[6].limits(0)  = -bs[1]
   parinfo[6].limits(1)  = bs[1]
   parinfo[7].limited(0) = 1
   parinfo[7].limited(1) = 1
   parinfo[7].limits(0)  = 0.
   parinfo[7].limits(1)  = 1.


   p1=[p1,0.0]
   parinfo[*].value  = p1
   XX=Xinvec([bs[0]*2+1,bs[1]*2+1])
   yy=yinvec([bs[0]*2+1,bs[1]*2+1])
   zz=TWO2ONE(PIC)
   er=REPLICATE(1.,(bs[0]*2+1)*(bs[1]*2+1))
   A = MPFIT2DFUN('G2D_flattop', XX, YY, ZZ, ER, PERROR=PE, BESTNORM=BN,parinfo=parinfo, ERRMSG=msg)
   pic2=long(one2two(G2D_flattop(XX, YY, A)))
   print, pic
   print
   print, pic2
   print
   print, pic-pic2
   b=congrid(pic-pic2, 500,500)
   window, 1, xsize=500, ysize=500
   tvscl, b


   window, 2, xsize=500, ysize=500
   c=congrid(pic2, 500,500)
   tvscl, c

   window, 3, xsize=500, ysize=500
   c=congrid(pic, 500,500)
   tvscl, c

    print, 'gaussfit', p0
   print, 'XXXXXXXXXXXX ',a

   print,'--------> ', min(pic-pic2), max(pic-pic2)

end