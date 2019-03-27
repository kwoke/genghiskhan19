clear all


jenghisKhan = robot;

x = 150;
y = 150;
z = 240;
theta = 0; 

[q1,q2,q3,q4,q5] = jenghisKhan.inverseKinematics.findQ(x,y,z,theta);

plot = jenghisKhan.drawPose(q1,q2,q3,q4,q5);

[tx,ty,tz] = jenghisKhan.forwardKinematics.findCoordinates(q1,q2,q3,q4,q5);
tx(end)
ty(end)
tz(end)




