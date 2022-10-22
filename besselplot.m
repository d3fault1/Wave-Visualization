clear all; close all; clc;

r = 0:0.1:20; %Defining the domain with 201 columns

J0 = besselj(0,r); %Solution of Bessel function with m = 0
plot(r,J0, '.-', 'markersize',3); hold on

J1 = besselj(1,r); %Solution of Bessel function with m = 1
plot(r,J1, '.-', 'markersize',3); hold on

J2 = besselj(2,r); %Solution of Bessel function with m = 2
plot(r,J2, '.-', 'markersize',3); hold on

J3 = besselj(3,r); %Solution of Bessel function with m = 3
plot(r,J3, '.-', 'markersize',3); hold on

J4 = besselj(4,r); %Solution of Bessel function with m = 4
plot(r,J4, '.-', 'markersize',3); hold on

grid on
xlabel('r')
ylabel('J (m = 0,1,2,3,4)')
legend('J0','J1','J2','J3','J4','Location','Best')