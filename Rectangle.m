clear all; close all; clc;

%% Wave equation for a square membrane 
% d^2w/dt^2 = c*(d^2w/dx^2 + d^2w/dy^2) + f(w,x,y,t)
c = 1;
a = 0;
d = 0;
f = 0;
m = 1;

%% Creating our geometry
N = 1;
model = createpde(N);              %Create model
geometryFromEdges(model,@squareg); %Create 2-D geometry from decomposed geometry matrix
pdegplot(model);                   %Plot PDE geometry
ylim([-1 1]);                      %Setting range for the y axis [-1 to +1]
axis equal                      %Now length(+x axis) = length(+y axis)
title 'Rectangle for our model';
xlabel x;
ylabel y;

%% Finite element meshing for our geometry
generateMesh(model);    %Now we have created triangular grids inside our geometry
figure                  %Show the meshing
pdemesh(model);         %Plotting mesh to our PDE geometry
ylim([-1 1]);           %Setting range for the y axis [-1 to +1]
axis equal              %Now length(+x axis) = length(+y axis)
xlabel x
ylabel y

%% Defining the coefficient
specifyCoefficients(model,'m',m,'d',0,'c',c,'a',a,'f',f);

%% Making video writer
obj = VideoWriter('rect-vid');
obj.Quality = 100;
obj.FrameRate = 8;
open(obj);

%% BCs and ICs

%For edges 2 & 4 -> Dirichlet BC -> w(x=0,x=1) = sin(pi*x)
%For edges 1 & 3 -> Neumann BC ->   w(y=0,y=1) = cos(pi*x)

w0 = @(location) sin(pi*location.x);
g0 = @(location) cos(pi*location.y);

applyBoundaryCondition(model,'dirichlet','Edge',[2,4],'u',0); %Adding BCs to our geometry
applyBoundaryCondition(model,'neumann','Edge',([1,3]),'g',0); %Adding BCs to our geometry
setInitialConditions(model,w0,g0);                            %Giving ICs to our geometry


n = 100;
t_axis = linspace(0,5,n);
model.SolverOptions.ReportStatistics ='on';
result = solvepde(model,t_axis);
w = result.NodalSolution;
figure
wmax = max(max(w));
wmin = min(min(w));

for i = 1:n
    pdeplot(model,'XYData',w(:,i),'ZData',w(:,i),'ZStyle','continuous','Mesh','off');
    axis([-1 1 -1 1 wmin wmax]);
    caxis([wmin wmax]);
    xlabel x;
    ylabel y;
    zlabel w;
    shading faceted;
    colormap autumn;
    M(i) = getframe;
    f = getframe(gcf);
    writeVideo(obj, f);
end

obj.close();