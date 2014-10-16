pro testl, th
common Rota, Mtx
  wv=0.3344
  gonio=[0,0,0,0,0,0]
  a=[0,1,0]
  ;th=5.0

  GenerateR, 3, -th
  b=mtx # a
  print, b
  d=wv/(2.*sin(th/!radeg))
  b=b/d
  print, 'formula: ',1./sin(2.*th/!radeg)
  print, 'numeric: ',lorenz(b,gonio, wv)

end
function lorenzr, xyz, gonio, la
common Rota, Mtx
  GenerateR, 3, -gonio[3]
  OM=mtx
  s0=[1.0/la,0.0,0.0]
  rd=OM ## xyz
  sd0=s0+rd
  GenerateR, 3, 0.2
  rd1=mtx ## rd
  sd1=s0+rd1
  GenerateR, 3, -0.2
  rd2=mtx ## rd
  sd2=s0+rd2
  dv1=abs(vlength(sd1)-vlength(sd0))
  dv2=abs(vlength(sd2)-vlength(sd0))
  ;print, dv1, dv2
  dv=(dv1+dv2)/2.
  return, dv
end
;---------------------------------------
function lorenz1, la
  xyz=[-1./la,1./la,0.]
  gonio=[0,0,0,0,0,0]
  return, lorenzr(xyz, gonio, la)
end
;---------------------------------------
function lorenz, xyz, gonio, la
  return, lorenz1(la)/lorenzr(xyz, gonio, la)
end
;---------------------------------------
function polarization1, rho, tth, par
; rho - chi angle
; par - monochromator specific empirical parameter = 1 for lab source
 tth=tth/!radeg
 P1=(cos(tth)^2*cos(rho)^2)*par+(cos(tth)^2*sin(rho)^2)+cos(rho)^2
 P2=1.+par
 return, P1/P2
end
;---------------------------------------
function polarization, rho, tth, par
; rho - chi angle
; par - monochromator specific empirical parameter = 1 for lab source
; par=(Eh^2-Ev^2)/(Eh^2+Ev^2)
 tth1=tth/!radeg
 rho1=rho/!radeg
 ;P=0.5*(1+cos(tth)^2)-0.5*par*(sin(tth)^2*cos(2.0*rho))
 ;P=0.5*(1.+cos(tth1)^2)/(abs(cos(2.0*rho1))*par[0]+par(1))
 P=1.0/(abs(cos(2.0*rho1))*par[0]+par(1))
 return, P
end
;---------------------------------------
function polar, xyz, gonio

end
;---------------------------------------






pro ttt
common Rota, Mtx
xyz=[-2,2,0]
gonio=[0,0,0,0,0,0]
la=0.5
tth=88.
u1=lorenz(xyz, gonio, la)
GenerateR, 3, -tth
xyz=mtx ## [0.,2.,0.]-[2.,0.,0.]
print, '-----------'
print, xyz
print, '-----------'
u2=lorenz(xyz, gonio, la)
print, '-----------'
print, 1./sin((90.-tth)/!radeg), lorenz(xyz, gonio, la)
end