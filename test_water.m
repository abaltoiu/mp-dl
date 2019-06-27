% Copyright (c) 2019 Paul Irofti <paul@irofti.net>
% 
% Permission to use, copy, modify, and/or distribute this software for any
% purpose with or without fee is hereby granted, provided that the above
% copyright notice and this permission notice appear in all copies.
% 
% THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
% WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
% MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
% ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
% WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
% ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
% OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

%% DL with training on water data -- run setupDL.m from dl-box first!
clear; clc; close all; fclose all; format compact;
%%-------------------------------------------------------------------------
s = 5;                  % sparsity
iters = 50;             % DL iterations

nsensors = 2:10;
sensors = {                 % nodes with sensors
[4  12]
[12  15  29]
[9  12  15  30]
[8   9  12  29  31]
[8   9  10  12  24  31]
[7   9  12  24  25  28  31]
[7  12  24  25  26  28  29  31]
[7  12  24  25  26  28  29  30  31]
[14  15  23  24  25  26  28  29  30  31]
};

waterdir='water\';
waterfile='residues.mat';

datadir = 'data\';   %racheta
dataprefix = 'water';
%%-------------------------------------------------------------------------
load([waterdir, waterfile], 'R')
Y = double(R);
%Y = double(R(sensor_nodes,:));
n = 4*size(Y,1);        % dictionary size

D0 = Y(:,randperm(size(Y,2), n));
D0 = normc(D0);

[D, X, errs, Dall] = DL(Y, D0, s, iters, 'erropts', {'alliters'});

%%-------------------------------------------------------------------------
ts = datestr(now, 'yyyymmddHHMMss');
fname = [datadir dataprefix '-' char(waterfile) ...
        '-s' num2str(s) '-n' num2str(n) ...
        '-i' num2str(iters) '-' ts '.mat'];
save(fname, 'Y', 'Dall', 'D', 'X');

%%-------------------------------------------------------------------------
plot(1:iters, errs)