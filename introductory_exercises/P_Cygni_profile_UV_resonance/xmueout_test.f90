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

!2) What would happen to line-profile, is you assumed scattering
!was isotropic (i.e., NOT following Sobo-distrobution)

!3) Put Eddington limb-darkening in. What happens? 

!4) Challening: Put photospheric line-profile (simple Gaussian) in
!What happens? Test on xk0=0 (opacity =0) case.

program xmueout_test
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
	integer, parameter :: nphoton=10000
	  
	integer, dimension(1) :: seed=(/4/)

	real, dimension(nphoton) :: flux,freq

	real :: xk0, alpha
	real :: xmax, vmin, vmax, deltax, rmax, vmin1, vmax1 
	real :: xrnd, xnew, xmuestart, xmuein, xmueou, pcheck, xnorm, randiso, xstartt, dxstartt
	real :: r,v,dvdr, sigma, tau

	integer:: i, phot, nin,nout, ichan, test_number
	character(len = 50) :: file_name

	call random_seed !
	
	photons: do phot = 1,nphoton
		xk0 = 100
		alpha = 0
		r = 1
		v = 1
		sigma = 1
		flux(phot) = xmueout(xk0,alpha,v,r,sigma)
	enddo photons

	open(1,file='out',status='unknown')
	do phot=1,nphoton
		print*,phot,flux(phot)
		write(1,*) flux(phot)
	enddo
	close(1)

end program xmueout_test

function func(r)						! VELOCITY PROFILE
	use common
	implicit none
	real, intent(in) :: r
	real :: FUNC
	func = sqrt(1.-(p/r)**2)*(1.-b/r)**beta-x
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

