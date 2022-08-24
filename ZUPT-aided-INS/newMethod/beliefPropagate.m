function [x_l, x_r]= beliefPropagate(x_l, x_r, alpha_x, alpha_y)
    x_l = (1-alpha_x) * x_l + alpha_x * x_r;
    x_r = (1-alpha_y) * x_r + alpha_y * x_l;