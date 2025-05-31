clc
clear
hold on
axis equal

%Set Python interpreter
pyenv('Version','C:\Users\ekral\AppData\Local\Programs\Python\Python312\python.exe');
script_path = fullfile('C:\Users\ekral\Documents\PřF\Mgr\2.semestr\MatKarto\uloha4_kralova_pospechova', 'mk.py');

% Python import helpery (chatgpt)
spec = py.importlib.util.spec_from_file_location("mk", script_path);
mkmod = py.importlib.util.module_from_spec(spec);
spec.loader.exec_module(mkmod);

%Projection properties
%proj_name = 'sinu';
%proj_name = 'bonne';
%proj_name = 'eck5';
%proj_name = 'wintri';
proj_name = 'hammer';
R = 6380000;

%Input parameters
u = 50;
v = 15;

umin = 50 *pi/180;
umax = 90 *pi/180;
vmin = -80 *pi/180;
vmax = 80 *pi/180;

Du = 10 *pi/180;
Dv = 10 *pi/180;
du = 0.1 * Du;
dv = 0.1 * Dv;

uk = pi/2;
vk = 0;
u0 = 75 *pi/180;

%Mesh gird
[ug, vg] = meshgrid(umin:du:umax, vmin:dv:vmax);

%Test: project + extract arrays from tuple and convert to matrix
vals = py.mk.project(proj_name, R, py.numpy.array(ug *180/pi), py.numpy.array(vg *180/pi));
x = double(vals{1});
y = double(vals{2});
a = double(vals{3});
b = double(vals{4});

%Airy criterium (local)
h2a = ((a - 1).^2 + (b - 1).^2)/2;

%Complex criterium (local)
h2c = (abs(a - 1) + abs(b - 1))/2 + abs(a./b - 1);

%Airy criterium (global)
H2a = mean(h2a(:))

%Complex criterium (global)
H2c = mean(h2c(:))

%Airy criterium (global, weighted)
w = cos(ug);
num = sum(w .* h2a);
denum = sum(w);

H2aw = num/denum

%Complex criterium (global, weighted)
w = cos(ug);
num = sum(w .* h2c);
denum = sum(w);

H2cw = num/denum

%Graticule
[XM, YM, XP, YP] = graticule_proj(umin, umax,vmin, vmax, Du, Dv, du, dv, R, uk, vk, u0, proj_name);
plot(XM', YM', 'k');
plot(XP', YP', 'k');

%Load Greenland
G = load("gl.txt");

vals = py.mk.project(proj_name, R, py.numpy.array(G(:, 1)), py.numpy.array(G(:, 2)));
XG = double(vals{1});
YG = double(vals{2});

plot(XG, YG, 'b');

%Load Denmark
D1 = load("den1.txt");

vals = py.mk.project(proj_name, R, py.numpy.array(D1(:, 1)), py.numpy.array(D1(:, 2)));
XD1 = double(vals{1});
YD1 = double(vals{2});

plot(XD1, YD1, 'b');

%Load Denmark
D2 = load("den2.txt");

vals = py.mk.project(proj_name, R, py.numpy.array(D2(:, 1)), py.numpy.array(D2(:, 2)));
XD2 = double(vals{1});
YD2 = double(vals{2});

plot(XD2, YD2, 'b');

%Load Finland
F = load("fin.txt");

vals = py.mk.project(proj_name, R, py.numpy.array(F(:, 1)), py.numpy.array(F(:, 2)));
XF = double(vals{1});
YF = double(vals{2});

plot(XF, YF, 'b');

%Load Norway
N = load("nor.txt");

vals = py.mk.project(proj_name, R, py.numpy.array(N(:, 1)), py.numpy.array(N(:, 2)));
XN = double(vals{1});
YN = double(vals{2});

plot(XN, YN, 'b');

%Load Sweden
S = load("swe.txt");

vals = py.mk.project(proj_name, R, py.numpy.array(S(:, 1)), py.numpy.array(S(:, 2)));
XS = double(vals{1});
YS = double(vals{2});

plot(XS, YS, 'b');

%Compute distortions
M = 100000000;
Muv = M./a;

%Draw contour line
Mmin = 50000000;
Mmax = 100000000;
dM = 10000000;
[C, h] = contour(x, y, Muv, [Mmin:dM:Mmax], 'LineColor', 'r');
clabel(C, h, 'Color', 'r');