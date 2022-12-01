members = input("Number of members: ");
joints = input("Number of joints: ");

C = zeros(joints,members);

% for i=1:members
%     for j=1:joints
%         fprintf("Is joint %i in member %i? ",j,i)
%         ask = input("Please enter 1 if so: ");
%         if(ask == 1)
%             C(j,i) = 1;
%         end
%     end
% end

for i=1:members
    fprintf("First joint (#) in member %i? ",i)
    first_joint = input("");
    fprintf("Second joint (#) in member %i? ",i)
    second_joint = input("");
    C(first_joint,i) = 1;
    C(second_joint,i) = 1;
end

Sx = zeros(joints, 3);
Sy = zeros(joints, 3);

pin_loc = input("On what joint is the pin located: ");
roller_loc = input("On what joint is the roller located: ");

Sx(pin_loc,1) = 1;
Sy(pin_loc,2) = 1;
Sy(roller_loc, 3) = 1;

X = zeros(1,joints);
Y = zeros(1,joints);

for i=1:joints
    fprintf("x-coordinate for joint %i: ",i);
    ask = input("");
    X(i) = ask;
    fprintf("y-coordinate for joint %i: ",i);
    ask2 = input("");
    Y(i) = ask2;
end

load_loc = input("On what joint is the load: ");
load_am = input("How much is the load in oz: ");

L = zeros(2 * joints, 1);
L(load_loc + joints, 1) = load_am;

save('TrussDesign1_AC_A4.mat','C','Sx','Sy','X','Y','L')