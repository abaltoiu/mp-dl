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

%% DL with training on clean image -- run setupDL.m from dl-box first!
clear; clc; close all; fclose all; format compact;
%%-------------------------------------------------------------------------
p = 3;                  % patch size
s = 3;                  % sparsity
N = 3000;               % total number of patches
n = 4*p^2;              % dictionary size
iters = 50;             % DL iterations
%std = 0;               % noise standard deviation

imdir = 'img\';
img = {'lena.png'};
datadir = 'data\';   %racheta
dataprefix = 'img';
%%-------------------------------------------------------------------------
D0 = odctdict(p^2,n);
%[~, ~, Yall, ~] = denoise_init_data([imdir,char(img)], std, p, p); % noisy
Yall = mkimgsigs(imdir,img,p*p);

Y = Yall(:,1:N);                        % Get only the first N blocks
%Y = Yall(:,randperm(size(Yall,2), N))  % Get N random blocks

[D, X, errs, Dall] = DL(Y, D0, s, iters, 'erropts', {'alliters'});

%%-------------------------------------------------------------------------
ts = datestr(now, 'yyyymmddHHMMss');
fname = [datadir dataprefix '-' char(img) ...
        '-p' num2str(p) '-s' num2str(s) '-N' num2str(N) '-n' num2str(n) ...
        '-i' num2str(iters) '-' ts '.mat'];
save(fname, 'Yall', 'Y', 'Dall', 'D', 'X');

%%-------------------------------------------------------------------------
plot(1:iters, errs)