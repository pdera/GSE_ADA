;---------------------
function tilted_ellipse, ttheta, gamma, D, phi
 ;calculates the excentricity ratio and center shift for an ellipse Debay
 ; ring on a tilted detector
 ;
 ; Parameters:
 ; ttheta - Bragg angle
 ; gamma  - tilt angle
 ; D      - sample to detector distance
 tt=ttheta/!radeg
 ga=gamma/!radeg
 p=phi/!radeg
 A1=D*sin(tt)/sin(!pi/2.0+ga-tt)
 A2=D*sin(tt)/sin(!pi/2.0-ga-tt)
 A=D*tan(tt)        ; short radius
 cs =fltarr(2)
 cs1=fltarr(2)
 cs[0]=(A1-A2)/2.0     ; center shift in mm in canonic

 cs1[0]=( cos(p)*cs[0]+sin(p)*cs[1])
 cs1[1]=(-sin(p)*cs[0]+cos(p)*cs[1])
 ex=(A1+A2)/(2.0*A) ; excentricity ratio a/b
 return, [cs1, ex, 2.0*A]
end
;---------------------
function azimut, xy, xy0, a, b, phi
 p=phi/!radeg
n=n_elements(xy)/2
x0=replicate(xy0[0],n)
y0=replicate(xy0[1],n)
xy0s=[[x0],[y0]]
 dxy=xy-xy0s
 dxy1=dxy
 dxy1[*,0]=( cos(p)*dxy[*,0]+sin(p)*dxy[*,1])/a
 dxy1[*,1]=(-sin(p)*dxy[*,0]+cos(p)*dxy[*,1])/b
 return, atan(dxy1[*,1],dxy1[*,0])*!radeg
end

;---------------------

function ellipse_at_t, xc,yc,a,b, phi, t
  phi1=phi/!radeg
  t1=t/!radeg  ; azimuth angle converted to rad
  n=n_elements(t)
  xy=fltarr(n,2)
  xy[*,0]=xc+a*cos(t1)*cos(phi1)-b*sin(t1)*sin(phi1)
  xy[*,1]=yc+a*cos(t1)*sin(phi1)+b*sin(t1)*cos(phi1)
  return, xy
end
;---------------------
function ellipse, xc,yc,a,b, phi, w, col
  xy=fltarr(361,2)
  for i=0, 360 do $
  begin
    t=float(i);
    xy[i,*]=ellipse_at_t(xc,yc,a,b, phi, t) ; azimuth angle is in degrees
  end
  if w eq 0 then window,xsize=700,ysize=700
  if w eq 0 then plot, xy[*,0], xy[*,1], color=col, /isotropic else oplot, xy[*,0], xy[*,1], color=col
  return, xy
end
;---------------------
function ellipseT, xc,yc,gamma,phi, tth, D, w, col

  te=tilted_ellipse(tth, gamma, D, phi)
  xy=fltarr(361,2)
  for i=0, 360 do $
  begin
    t=float(i);
    xy[i,*]=ellipse_at_t(xc+te[0],yc+te[1],te[3]*te[2],te[3], phi, t) ; azimuth angle is in degrees
  end
  if w ne -1 then $
  begin
   if w eq 0 then window,xsize=700,ysize=700
   if w eq 0 then plot, xy[*,0], xy[*,1], color=col, xrange=[0,2048], yrange=[0,2048] else oplot, xy[*,0], xy[*,1], color=col
  endif
  return, xy
end



;---------------------
    FUNCTION FUN_ELLIPSE, p, X=x, Y=Y, ERR=err
  COMMON mp_data, Xm, Ym, indi
     ; The independent variables are X and Y
     ; Parameter values are passed in "P"
     ; 0 - xc
     ; 1 - yc
     ; 2 - gamma
     ; 3 - phi
     ; 4 distance
     ; 5 - 2theta - this one is the only parameter that differes for multiple ellipses
     D=P[4]
     neli=n_elements(indi) ; number of ellipses
     ; indi should have 0 in the first field
     for i=1, neli-1 do $
     begin
       tth=P[4+i]
       te=tilted_ellipse(tth, P[2], D, P[3])
       n0=indi[i-1]
       n1=indi[i]-1
       n=n1-n0
       XY=[[Xm[n0:n1]],[Ym[n0:n1]]]
       X0s=replicate(P[0]+te[0], n)
       Y0s=replicate(P[1]+te[1], n)
       XY0s=[[X0s],[Y0s]]
       a=te[3]*te[2]
       b=te[3]
       T=azimut(XY, [P[0]+te[0],P[1]+te[1]], a, b, p[3]) ; azimuth returned in deg
       xyc=ellipse_at_t(P[0]+te[0],P[1]+te[1],a, b, p[3], T)
      ; if i eq 1 then R=(XYC[*,0]^2+XYC[*,1])*(XYC[*,0]-XYC[*,1]^2) else $
      ; R=[R,(XYC[*,0]^2+XYC[*,1])*(XYC[*,0]-XYC[*,1]^2)]
       if i eq 1 then R=sqrt(XYC[*,0]^2+XYC[*,1]^2) else $
       R=[R,sqrt(XYC[*,0]^2+XYC[*,1]^2)]
     endfor
     return, abs(R-Y)/err
    END

;---------------------------------------------------------
function fit_ellipses, xydata, india, startpar
COMMON mp_data, Xm, Ym, indi
   nn=n_elements(india)-1
   np=intarr(nn)
   for i=0, nn-1 do $
   np[i]=india[i+1]-india[i]
   n=total(np)
   x=indgen(n)
   parinfo = replicate({value:0.D, fixed:0, limited:[0,0], limits:[0.,0.]}, 5+nn)
   parinfo[*].value = startpar
   parinfo[4].fixed = 1
   indi=india
   Xm=xydata[*,0]
   Ym=xydata[*,1]
   Y=sqrt(Xm^2+Ym^2)
   err= replicate(1.0, n)
   p0=parinfo[*].value
   fa = {X:x, Y:Y, ERR:err}
   p = mpfit('FUN_ELLIPSE', p0, functargs=fa, parinfo=parinfo, perror=pe, bestnorm=chi,QUIET=quiet)
   return, [[p],[pe]]
end

;---------------------------------------------------------
function estimate_ellipse, xy, xy0, D
  n=n_elements(xy)/2.0
  x0s=replicate(xy0[0],n)
  y0s=replicate(xy0[1],n)
  xy0s=[[x0s],[y0s]]
  xys=xy-xy0s
  rad=mean(sqrt(xys[*,0]^2+xys[*,1]^2)) ; mean radius
  return, atan(rad,D)*!radeg/2.0
end
;---------------------------------------------------------
pro fit_ellipse_test, xydata, xy0, D, india
COMMON mp_data, Xm, Ym, indi

   n=n_elements(india)
   xca=xy0[0]
   yca=xy0[1]
   t=fltarr(n-1)
   for i=0, n-2 do $
   t[i]=estimate_ellipse(xydata[india[i]:india[i+1]-1,*], [xca,yca], D)
   startpar=[xca, yca, 0.0, 0.0, D]
   for i=0, n-2 do startpar=[startpar,t[i]]
   pp=fit_ellipses(xydata, india, startpar)
   p=pp[*,0]
   pe=pp[*,1]


   print
   print, p
   print, pe

   for i=0, n-2 do $
   begin
    xy=ellipseT(p[0],p[1],p[2],p[3], P[5+i],P[4], -1,'ffffff'xl)
    plots, xy[*,0]/2048., xy[*,1]/2048., color='00ff00'xl, /normal, psym=1
   endfor

end
