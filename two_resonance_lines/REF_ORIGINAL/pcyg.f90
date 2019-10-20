module common
	real :: p,b,beta,x
end module common

module my_inter
	interface
		function xmueout(xk0,alpha,r,v,sigma)
		  real, intent(in):: xk0,alpha,r,v,sigma
		  real:: xmueout
		end function
	end interface

	interface
		function RTBIS(FUNC,X1,X2,XACC)
		  real, intent(in) :: X1,X2,XACC
		  real :: RTBIS
		  interface
			  function FUNC(r)
			  real, intent(in) :: r
			  real :: FUNC
			  end function FUNC
		  end interface
		end function rtbis
	end interface
end module my_inter

!Tests:

!1) What wpuld happen with line-profile, if you assumed all photons
!were released radially from photopshere ?

!2) --What would happen to line-profile, is you assumed scattering
!was isotropic (i.e., NOT following Sobo-distrobution)

!3) Put Eddington limb-darkening in. What happens? 

!4) Challening: Put photospheric line-profile (simple Gaussian) in
!What happens? Test on xk0=0 (opacity =0) case.

program pcyg
	!     Monte-Carlo Simulation of P Cygni profile for beta-velocity law
	!     and opacity Chi_bar = xk0/(r^2 v) * v^alpha       
	!
	!     nchan has to be even!
	      
	use common, pstart => p, xstart => x
	use my_inter
	implicit none

	  interface
	  function FUNC(r)
		  real, intent(in) :: r
		  real :: FUNC
	  end function FUNC
	  end interface

	integer, parameter :: nchan=100
	integer            :: nphoton
	  
	integer, dimension(1) :: seed=(/4/)

	real, dimension(nchan) :: flux,freq

	real :: xk0, alpha
	real :: xmax, vmin, vmax, deltax, rmax, vmin1, vmax1 
	real :: xrnd, xnew, xmuestart, xmuein, xmueou, pcheck, xnorm
	real :: r,v,dvdr, sigma, tau

	integer:: i, nphot, nin,nout, ichan

	call random_seed !(put=seed)

	print*,' Give in number of photons'
	read*,nphoton
	print*

	print*,' Give in xk0,alpha,beta'
	read*,xk0,alpha,beta
	print*

	xmax=1.1
	vmin=.01

	deltax=2.*xmax/float(nchan)
	freq(1)=xmax-.5*deltax
	flux(1)=0.
	      
	do i=2,nchan
	   freq(i)=freq(1)-(i-1)*deltax
	   flux(i)=0.
	enddo
	      
	b=1.-vmin**(1./beta)
	vmax=.98
	rmax=b/(1.-vmax**(1./beta))
	      
	nin=0
	nout=0

	photons: do nphot=1,nphoton

		call random_number(xstart)
		xstart=xmax*xstart

		call random_number(xrnd)
		if(xrnd.ge..5) then
		xstart=-xstart        				!continuum red wing
		xnew=xstart
		goto 5
		endif  

		! (positive) start frequency between vmin and vmax
		! to avoid interaction zone at infinity, correction because of numerical precision     

		vmax1=vmax*.99
		vmin1=vmin*1.01

		if(xstart.ge.vmax1 .or. xstart.le.vmin1) then        
		   xnew=xstart        				!no resonance possible
		   goto 5
		endif  

		call random_number(xmuestart)   		!start angle between 0 and 1, no limb darkening
		xmuestart=sqrt(xmuestart)
		pstart=sqrt(1.-xmuestart**2)  			!according p-ray

		r=rtbis(func,1.,rmax,1.e-5)   			!calculate interaction zone from x=mue*v
		      
		xmuein=sqrt(1.-(pstart/r)**2)   		!calculate incident angle

		v=(1.-b/r)**beta              			!calculate optical depth      
		dvdr=b*beta/r**2 *(1.-b/r)**(beta-1.)
		sigma=dvdr/(v/r)-1.
		tau=xk0/(r*v**(2.-alpha) * (1.+xmuein**2*sigma))

		call random_number(xrnd)
		if (tau.gt. -log(xrnd)) then  			! calculate whether interaction      

		   xmueou=xmueout(xk0,alpha,r,v,sigma)  	!calculate outwards angle
		   
		   call random_number(xrnd)     		!calculate sign of outwards angle
		   if(xrnd.ge..5) then        			!inwards photons
		      xmueou=-xmueou
		      pcheck=sqrt(r**2*(1.-xmueou**2))  	!check whether photon hits core      

		      if (pcheck.le.1.) then    
			  nin=nin+1           			!core hit! forget photon
			  cycle
		      endif
		   endif  

		!xnew=xstart+(v-sign(0.06,xmueou))*xmueou-v*xmuein !calculate new photon frequency
		xnew=xstart+ v*(xmueou-xmuein) !calculate new photon frequency

		else                     			!no interaction
		   print*, 'NO INTERACTION'
		   xnew=xstart
		endif

		5  nout=nout+1

		ichan=int((xmax-xnew)/deltax)+1  		!sorting into chanels      
		flux(ichan)=flux(ichan)+1.
			    
	enddo photons 						!end of photon loop

	xnorm=float(nphoton)/float(nchan) 			!normalization

	open(1,file='out', status='unknown')
	do i=1,nchan
	   flux(i)=flux(i)/xnorm
	   print*,i,freq(i),flux(i)
	   write(1,*) freq(i), flux(i)
	enddo
	close(1)
	      
	print*,float(nin)/float(nphoton)*100.,' % of photons scattered back into core'
end program pcyg

function func(r)						! VELOCITY PROFILE
	use common
	implicit none
	real, intent(in) :: r
	real :: FUNC
	func=sqrt(1.-(p/r)**2)*(1.-b/r)**beta-x
	return
end

function xmueout(xk0,alpha,r,v,sigma)		
	implicit none
	real, intent(in) :: xk0,alpha,r,v,sigma
	real :: xmueout
	real :: x0,y0,tau,px,tau0,f3				! helper variables

	!von Neumann rejection method; see notes      
	tau0 = xk0/(r*v**(2.-alpha))
	f3 = min(1.,max((1.+sigma)/tau0,1./tau0))

	10 call random_number(x0) 				! first deviate
	tau=tau0/(1.+x0**2*sigma)

	call random_number(y0)
	y0 = y0*f3  						! 2nd deviate between 0 and f(x0)=f3       

	px = (1.-exp(-tau))/tau

	if(y0.gt.px) goto 10

	xmueout=x0
	return
end function xmueout

FUNCTION rtbis(func,x1,x2,xacc)
	IMPLICIT NONE
	REAL, INTENT(IN) :: x1,x2,xacc
	REAL :: rtbis
	interface
		function FUNC(r)
		  real, intent(in) :: r
		  real :: FUNC
		end function FUNC
	end interface
	INTEGER, PARAMETER :: MAXIT=40
	INTEGER :: j
	REAL    :: dx,f,fmid,xmid
		
	fmid=func(x2)
	f=func(x1)
	if (f*fmid >= 0.0) stop 'rtbis: root must be bracketed'
	if (f < 0.0) then
	        rtbis=x1
	        dx=x2-x1
	else
	        rtbis=x2
	        dx=x1-x2
	end if
	do j=1,MAXIT
	        dx=dx*0.5
	        xmid=rtbis+dx
	        fmid=func(xmid)
	        if (fmid <= 0.0) rtbis=xmid
	        if (abs(dx) < xacc .or. fmid == 0.0) RETURN
	end do
	stop 'rtbis: too many bisections'
END FUNCTION rtbis

