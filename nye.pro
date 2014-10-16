pro nye

  lp0=[9.6539,8.7928,5.2935, 90, 107.436,90]
  lp1=[9.3931,8.5065,5.1394, 90, 106.187,90]
  B0=B_from_lp(lp0)
  B1=B_from_lp(lp1)
  print, b0
  print, '-------------'
  print, '-------------'
  print, '-------------'
  print, b1
  print, '-------------'
  c=(b1-b0) # invert(b0)
  symmetrize, c, sb, ab
  print, sb*1000./10.
  ;print, '-------------'
  ;print, ab
 C11=492
 C12=45.
 C44=130.

 t=1.5
 P=10.0
 Sig=fltarr(3,3)
 Sig=[[P+2.*t/3., 0,0],[0,P-t/3.,0],[0,0,P-t/3.]]
 Sigj=[Sig[0,0],Sig[1,1],Sig[2,2],Sig[1,2],Sig[0,2],Sig[0,1]]

 common Rota, Mtx
 GenerateR, 1, 25.
 mtx1=mtx
 GenerateR, 3, 25.
 print, '=============='
 print, sig
 print, '=============='
 Sig=mtx1 ## mtx ## Sig

 print, sig
 print, '=============='

 Sigj=[Sig[0,0],Sig[1,1],Sig[2,2],Sig[1,2],Sig[0,2],Sig[0,1]]

 Cij=fltarr(6,6)
 Cij=[[C11,C12,C12,0  ,0,  0  ],$
      [C12,C11,C12,0  ,0,  0  ],$
      [C12,C12,C11,0  ,0,  0  ],$
      [0  ,0  ,0  ,C44,0,  0  ],$
      [0  ,0  ,0  ,0  ,C44,0  ],$
      [0  ,0  ,0  ,0  ,0  ,C44]]

  print, '-------------'
  print, '-------------'
  print, '-------------'
  print, Cij # Sigj

end

pro symmetrize, a, sb, ab
 sb=fltarr(3,3)
 ab=fltarr(3,3)
 for i=0, 2 do for j=0, 2 do sb[i,j]=a[i,j]+a[j,i]
 for i=0, 2 do for j=0, 2 do ab[i,j]=a[i,j]-a[j,i]
 sb=sb/2.
 ab=ab/2.


end