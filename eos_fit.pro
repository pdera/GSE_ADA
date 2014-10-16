function BM3, P, X=x, Y=y, ERR=err
; parameters:
;      P[0]=V0
;      P[1]=K0
;      P[2]=KP

;WID_BASE_0_L


  V0=P[0]
  K0=P[1]
  KP=P[2]
  V=X
  KP=4
  ;V0=449.506
  fE=0.5*((V0/V)^(2.0/3.0)-1.0)
  model=3.0*K0*fE*(1.0+2.0*fE)^(5.0/2.0)*(1.0+3.0/2.0*(KP-4.0)*fE)
  return, (Y-model)/err
end

pro eos_fit
parinfo = replicate({value:0.D, fixed:0, limited:[0,0], $
                       limits:[0.D,0]}, 3)
N=33
p=fltarr(N)
V=fltarr(N)
err=fltarr(N)
file='C:\Users\Przemyslaw\Downloads\Zhang97aHd.txt'
;file='C:\Users\Przemyslaw\Downloads\Hd1.txt'
;file='E:\Dropbox\software\Ognjen\GSE_ADA\HdVs.txt'
get_lun, lu
openr, lu, file
a=0.0
b=0.0
c=0.0
i=0
while not eof(lu) do $
begin
readf, lu, a, b,c
p[i]=a
V[i]=b
Err[i]=c
i=i+1
endwhile
close, lu
parinfo[0].fixed=1

;ERR=fltarr(N)
;for i=0, 20 do ERR[i]=1.0

P0=[952.44,170.0,4.0]
;fa = {X:V[0:8], Y:P[0:8], ERR:err[0:8]}
fa = {X:V, Y:P, ERR:err}
pp = mpfit('BM3', p0, functargs=fa, PERROR=PE, BESTNORM=BN)


 if n_elements(pe) gt 0 then $
  begin
     DOF     = N_ELEMENTS(V) - N_ELEMENTS(PP) ; deg of freedom
     PCERROR = PE * SQRT(BN / DOF)*1.   ; scaled uncertainties
     print, PP
     print, PCERROR
   endif
  esd=PCERROR
  window
  plot, P, V, yrange=[380,450], psym=2
  for i=0, N-1 do ERR[i]=-1.0
  p1=fltarr(N)
  V0=PP[0]
  DV0=.05
  PC= BM3(PP, X=V, Y=P1, ERR=ERR)
  oplot, PC,V

  fE=0.5*((PP[0]/V)^(2.0/3.0)-1.0)
  sig_fE1=1./3./(V0^(1./3.)*V^(2./3.))*DV0
  sig_fE2=-1./3.*(V0^(2./3.)/V^(5./3.))*Err
  sig_fE=abs(sig_fE1)+abs(sig_fE1)

  BFE=P/(3.0*fE*(1.0+2.0*fE)^(5.0/2.0))
  Dp=replicate(0.1,N) ; error in pressure

  sig_bfe1=1./3.0*1./(fE*(1.+2.*Fe)^(5./2.))*Dp
  sig_bfe2=P/3.0 * (-1./(fE^2*(1.+2.*Fe)^(5./2.))-5./(Fe*(1.+2.*Fe)^(7./2.)))*sig_fE
  sig_bfe=abs(sig_bfe1)+abs(sig_bfe2)
  window, 2, xsize=600, ysize=600
  plot, fE, BFE, psym=2,  background=256*256*256-1, color=0, xrange=[0.0,0.07], yrange=[80,180]
  errplot, fe, BFE-sig_bfe,BFE+sig_bfe, width=0.02, color='000000'xl
  ;cgerrplot, fE, BFE-sig_bfe,BFE-sig_bfe

  Result = LINFIT( fE, BFE, CHISQ=ch, /DOUBLE, yfit=yf, MEASURE_ERRORS=sig_bfe, sigma=sig)
  print, '---------------------'
  print, 'bulk modulus:'
  print, yf[0], 4.0+yf[1]*(2./(3.*yf[0]))
  print, sig[0], sig[1]*(2./(3.*yf[0]))+sig[0]*yf[1]*(2./(3.*yf[0]^2))
  oplot, fe, yf, color='000000'xl
  print, '---------------------'
  print, result
  print, '---------------------'
  print
  print, transpose(P-PC)
end