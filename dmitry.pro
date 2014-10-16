pro Dmitry
a=fltarr(3,3)
 a[0:2,1]=[3.379,     0.062,    -1.479] ; y in my coordinates
 a[0:2,2]=[1.189,     2.081,     2.804] ; z in my coordinates
 a[0:2,0]=[0.881,    -3.045,     1.886] ; x in my coordinates
 print, a
 b=fltarr(3,3)
 b=invert(a)
 print, lp_from_ub(b)
end
