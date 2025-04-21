function y = Pool(x,Z,N)

[xrow, xcol, numFilters] = size(x);
y = zeros(xrow/2, xcol/2, numFilters);

for k = 1:numFilters
    filter = ones(Z) / (Z*Z);
    image = conv2(x(:, :, k), filter, 'same');
    y(:, :, k) = image(1:N:end, 1:N:end);
end
end