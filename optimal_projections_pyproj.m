clc
clear
format long g
hold on
axis equal

%Set Python interpreter
pyenv('Version','C:\Users\ekral\AppData\Local\Programs\Python\Python312\python.exe', 'ExecutionMode','OutOfProcess');
terminate(pyenv);
script_path = fullfile('C:\Users\ekral\Documents\PřF\Mgr\2.semestr\MatKarto\uloha4_kralova_pospechova', 'mk.py');

% Python import helpery (chatgpt)
spec = py.importlib.util.spec_from_file_location("mk", script_path);
mkmod = py.importlib.util.module_from_spec(spec);
spec.loader.exec_module(mkmod);

%Projection properties
proj_name = 'sinu';
%proj_name = 'bonne';
%proj_name = 'eck5';
%proj_name = 'wintri';
%proj_name = 'hammer';
R = 1;

umin = 50 *pi/180;
umax = 90 *pi/180;
vmin = -80 *pi/180;
vmax = 40 *pi/180;

Du = 10 *pi/180;
Dv = 10 *pi/180;
du = 0.1 * Du;
dv = 0.1 * Dv;

uk = pi/2;
vk = -20 *pi/180;
u_0 = 70 *pi/180;
v_0 = -20 *pi/180;

[u0, v0] = uv_sd(u_0, v_0, uk, vk);


%Mesh gird
[ug, vg] = meshgrid(umin:du:umax, vmin:dv:vmax);
[u, v] = uv_sd(ug, vg, uk, vk);

%Test: project + extract arrays from tuple and convert to matrix
vals = py.mk.project(proj_name, R, py.numpy.array(u *180/pi), py.numpy.array(v *180/pi), u0 *180/pi, v0 *180/pi);
X = double(vals{1});
Y = double(vals{2});
a = double(vals{3});
b = double(vals{4});

%Airy criterium (local)
h2a = ((a - 1).^2 + (b - 1).^2)/2;

%Complex criterium (local)
h2c = (abs(a - 1) + abs(b - 1))/2 + a./b - 1;

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
[XM, YM, XP, YP] = graticule_proj(umin, umax, vmin, vmax, Du, Dv, du, dv, R, uk, vk, u0, v0, proj_name);
plot(-XM', YM', 'k');
plot(-XP', YP', 'k');

%Load Greenland
G = load("gl.txt");
[Gu, Gv] = uv_sd(G(:, 1)*pi/180, G(:, 2)*pi/180, uk, vk);

vals = py.mk.project(proj_name, R, Gu*180/pi, Gv*180/pi, u0*180/pi, v0*180/pi);
XG = double(vals{1});
YG = double(vals{2});

plot(-XG, YG, 'b');

%Load Denmark
D1 = load("den1.txt");
[D1u, D1v] = uv_sd(D1(:, 1)*pi/180, D1(:, 2)*pi/180, uk, vk);

vals = py.mk.project(proj_name, R, D1u*180/pi, D1v*180/pi, u0*180/pi, v0*180/pi);
XD1 = double(vals{1});
YD1 = double(vals{2});

plot(-XD1, YD1, 'b');

%Load Denmark
D2 = load("den2.txt");
[D2u, D2v] = uv_sd(D2(:, 1)*pi/180, D2(:, 2)*pi/180, uk, vk);

vals = py.mk.project(proj_name, R, D2u*180/pi, D2v*180/pi, u0*180/pi, v0*180/pi);
XD2 = double(vals{1});
YD2 = double(vals{2});

plot(-XD2, YD2, 'b');

%Load Finland
F = load("fin.txt");
[Fu, Fv] = uv_sd(F(:, 1)*pi/180, F(:, 2)*pi/180, uk, vk);

vals = py.mk.project(proj_name, R, Fu*180/pi, Fv*180/pi, u0*180/pi, v0*180/pi);
XF = double(vals{1});
YF = double(vals{2});

plot(-XF, YF, 'b');

%Load Norway
N = load("nor.txt");
[Nu, Nv] = uv_sd(N(:, 1)*pi/180, N(:, 2)*pi/180, uk, vk);

vals = py.mk.project(proj_name, R, Nu*180/pi, Nv*180/pi, u0*180/pi, v0*180/pi);
XN = double(vals{1});
YN = double(vals{2});

plot(-XN, YN, 'b');

%Load Sweden
S = load("swe.txt");
[Su, Sv] = uv_sd(S(:, 1)*pi/180, S(:, 2)*pi/180, uk, vk);

vals = py.mk.project(proj_name, R, Su*180/pi, Sv*180/pi, u0*180/pi, v0*180/pi);
XS = double(vals{1});
YS = double(vals{2});

plot(-XS, YS, 'b');

%Compute distortions
M = 100000000;
Muv = M./a;

%Draw contour line
Mmin = 10000000;
Mmax = 100000000;
dM = 10000000;
[C, h] = contour(-X, Y, Muv, [Mmin:dM:Mmax], 'LineColor', 'r');
clabel(C, h, 'Color', 'r');

axis off