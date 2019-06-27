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

%% DL with training on synthetic data -- run setupDL.m from dl-box first!
clear; clc; close all; fclose all; format compact;
%%-------------------------------------------------------------------------
m = 20;                 % patch size
s = 5;                  % sparsity
N = 1500;                % total number of original signals
ndup = 1;              % signal duplication (yi = Dx + vi)
n = 50;                 % dictionary size
iters = 50;             % DL iterations
SNRdB = 20;             % signal-to-noise ratio in decibels

datadir = 'data\';
dataprefix = 'synth';
%%-------------------------------------------------------------------------
% true dictionary
Dtrue = normc(randn(m,n));

% noisy signals generated from the true dictionary: y = Dx + v
Y = gen_synth_sigs_dup(Dtrue,m,n,N,s,SNRdB,0,ndup);

% Initialize a dictionary with the same set of training signals
D0 = normc(Y(:,randperm(N*ndup,n)));

[D, X, errs, Dall] = DL(Y, D0, s, iters, 'erropts', {'alliters'});

%%-------------------------------------------------------------------------
ts = datestr(now, 'yyyymmddHHMMss');
fname = [datadir dataprefix ...
        '-m' num2str(m) '-s' num2str(s) '-N' num2str(N) '-n' num2str(n) ...
        '-ndup' num2str(ndup) '-i' num2str(iters) '-' ts '.mat'];
save(fname, 'Y', 'Dall', 'D', 'X');

%%-------------------------------------------------------------------------
plot(1:iters, errs)