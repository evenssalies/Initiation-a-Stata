clear
set	obs 1000
mat p=[1/2,1/3,1/6]
gen double x=p[1,_n]
list in 1/3
gen y=.
mata
p=st_data((1..3)',"x")
st_store(.,"y",rdiscrete(st_nobs(),1,p))
end
tab y
hist y, discrete
