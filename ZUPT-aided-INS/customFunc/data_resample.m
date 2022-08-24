function u_finals = data_resample(u,m,n,p,q)
% resample the data
% from row m to n,  p/q
N = length(u(m,:));
% if p > q
% u_new = zeros(n-m+1, p/q * N);
% else
[rows, columns] = size(u);
for i = m:n
%     u_new(i-m+1,:) = resample(u(i,:), p, q);
    u_new = resample(u(i,:), p, q);
    if i == m
%         u_news = zeros(n-m+1, length(u_new));
        final_len = min(N, length(u_new));
        u_finals = zeros(rows, final_len);
    end
%     u_news(i-m+1,:) = u_new;
    if final_len == N
        % the resampling is upwards, so obtained u_new is longer than the
        % original just cut it
        u_finals(i,:) = u_new(1:N);
    else
        % downsampling, u_new shorter than the original
        u_finals(i,:) = u_new;
    end
end

for i = 1 : rows
    if (final_len == N)
        % the resampling is upwards, so obtained u_new is longer than the
        % original just cut it
        if i < m || i > n
            u_finals(i,:) = u(i,:);
        end
    else
        % downsampling, the original of u that has not been resampled need
        % to be cut
        if i < m || i > n
            u_finals(i,:) = u(i,1:final_len);
        end
    end
end
