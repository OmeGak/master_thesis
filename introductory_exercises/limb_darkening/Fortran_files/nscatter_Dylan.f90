program main
	implicit none

	real(8) :: rand, theta, phi, rmax
	real(8) :: xx, yy, zz, rr, tau
	integer :: itau, it, first
	real(8), dimension(:), allocatable :: nscat, taus
	integer :: nphot, ii

	itau = 7
	allocate(nscat(itau))
	allocate(taus(itau))

	nphot = 1.e5

	call random_seed()

	taus = (/0.1,0.3,1.0,3.0,10.0,30.0,100.0/)

	do it = 1, itau
		rmax = taus(it)
		nscat(it) = 0.0
		do ii = 1, nphot
		    call scatter(theta,phi)
		    xx = 0.0
		    yy = 0.0
		    zz = 0.0
		    rr = 0.0
		    first = 1
		    do while(rr < rmax)
				call scatter(theta,phi)
				call random_number(rand)
				tau = -log(rand)
				xx = xx + tau*sin(theta)*cos(phi)
				yy = yy + tau*sin(theta)*sin(phi)
				zz = zz + tau*cos(theta)
				rr = sqrt(xx**2+yy**2+zz**2)
				if (first /= 1) then
				    nscat(it) = nscat(it) + 1.0
				endif
				first = 0
		    end do
		end do
		nscat(it) = nscat(it)/nphot
	end do

	open(1,file = "./scatter_list.txt")
	do it = 1, itau
	    write(1,*) taus(it), nscat(it)
	end do
end program main

subroutine scatter(theta,phi)
	implicit none

	real(8), intent(out) :: theta, phi
	real(8) :: rand

	call random_number(rand)
	theta = acos(2*rand-1)
	call random_number(rand)
	phi = 2*3.14159*rand

	return
end subroutine scatter
