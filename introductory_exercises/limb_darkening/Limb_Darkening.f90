program limb
	! Calculates the angular dependence of photon's emitted from
	! a plane-parallel, grey atmosphere of radial optical depth taumax

	! Note that tau and taumax are RADIAL optical depths.
	! Since photons have a direction of MU with respect to the radial
	! direction, we have to account for projection effects:
	! in order to calculate this quantity, i.e., to decide whether a
	! photon is
	! - inside the atmoshere (0 < tau < taumax), &
	! - has left the atmosphere (tau < 0)
	! - or has been scattered back into the stellar core (tau > taumax)
	! the actual value of tau(radial) has to be updated according to
	! tau(radial) = tau(radial) - tau_i * mu
	! if tau_i is the actual optial depth path-length for photon as drawn from the
	! corresponding pdf and mu its direction, also drawn
	! from the corresponding pdf.
	  
	! If a photon was found to have been scattered back into the core, 
	! just release a new photon at the inner boundary, however without
	! updating the number of photons since we want to have
	! NPHOT photons LEAVING the OUTER atmosphere 
	    
	implicit none
	! ALLOCATE ALL VARIABLES	
	! this is the array into which we will sort the emergent photons
	real,allocatable,dimension(:) :: muarray

	integer :: na,nphot,l,i,isum,seed,k,ii,jj,kk
	real :: dmu,taumax,mu,dist,norm,tau,tau_i,dummy,x,ran1,x1,x2,x3

	print*,'give in number of channels'  ! to check resolution effects
	read*,na

	! allocate the angular array and initialize it accounting for
	! the fact that no photons have been accumulated so far
	allocate( muarray(na) )
	muarray = 0.0

	dmu=1./na ! widths of channels 

	! provide input for photon number and total optical depth
	print*,'give number of photons'  ! give number of photons
	read*,nphot
	print*,'give maximum optical depth:' ! give taumax 
	read*,taumax
	seed=5

	do l=1,nphot  !big loop for all photons
		tau=taumax

		! follow the photon's path from first emission to final escape
		do while (tau >= 0) 
		   ! NOTE: Can use own "ran1" function, or built in
		   ! fortran random_number function 
		   ! x=ran1(seed)
		   ! x2=ran1(seed)
		   
		   !For angle
		   call random_number(x)
		   !For optical depth tau
		   call random_number(x2) 
		   
		   if (tau >= taumax) then 
		      mu = sqrt(x)
		      !Initial distribution: ~mu*dmu 
		      tau = taumax
		   else 
		      mu = 2.*x -1.
		      !Isotropic scattering: ~dmu     
		   endif

		   tau_i = -alog(x2)
		   !draw optical depth along line-of-sight 
		   tau = tau - tau_i * mu
		   !total radial (vertical) optical depth 
		enddo 

		! we have a photon leaving the atmosphere at angle mu

		! Finally (tau le 0), the photon should have left the photosphere, and
		! we can accumulate the angular distribution

		! How do we find the index of the channel according to angle mu?
		! Remember, we have NA channels, with widths DMU
		! the first channel should be used for all photons with MU = 0...DMU, 
		! the last one for photons with MU= 1-DMU...1
		k=1
		dummy=dmu
		do while ((mu-dummy) > 0.0)
		   dummy = dmu*(k+1)
		   k=k+1
		enddo
		i=k  
		muarray(i) = muarray(i) + 1 !one more photon into this channel
	enddo

	!test
	isum=0
	do i=1,na
	  isum=isum+muarray(i) ! conversion from real to integer
	enddo

	print*,isum
	! Just a test for security. Have we missed any photon?
	! if(isum.ne.nphot) stop 'not all photons counted'

	! preparation of output
	open(1,file='limb.out')

	!norm=muarray(na)  		! normalizing to the last channel
	do i=1,na
	  mu=(i-0.5)*dmu  		! to be centered! 
	  dist=muarray(i)/mu 
	  write(*, *) 'angle, phot-dist:',mu,dist
	  write(1,100) mu,dist
	enddo
	close(1)
	!99 format(' angle ',f6.4,'    photon-dist ',f6.4)
	100 format(2f15.4)
end program limb

!NOTE: The below can be used as "own written" random
!number generator, but one can also use built in in fortran:  random_number 
function ran1(seed)
	! minimum standard generated using Schrage's multiplication
 	 implicit none
  	integer, parameter :: m=2147483647,a=69621,q=30845, r=23902
  	real, parameter :: m1=1./m
  	integer :: k,seed
  	real :: ran1

  	k=seed/q

  	seed=a*(seed-k*q)-r*k
  	if(seed.lt.0) seed =seed+m
  	ran1=float(seed)*m1
return
end function ran1
