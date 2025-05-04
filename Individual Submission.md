Summary of Modifications
This project enhances the original 2D racetrack simulation by incorporating a height profile into both the vehicle dynamics (Simulink) and the visualization (MATLAB). The vehicle's motion is now influenced by track elevation, and the animation reflects vehicle speed using color.

Changes Made
1. Track Height Implementation
Added a height function based on the car's X position:

cpp
Copy
Edit
h(x) = [exp((x - 450)/50)] / [1 + exp((x - 450)/50)] * 10
The height varies smoothly from 0 to 10 meters as the car moves along the track.

2. Simulink Model Updates
Inside Vehicle Dynamics > Longitudinal Dynamics Body Frame > Vehicle:

Added a MATLAB Function block named SlopeForce to compute slope-induced gravity force from dz/dx

Subtracted F_slope from the net forward force Fa using a Sum block

Passed global X as an additional input to the vehicle block

Net longitudinal acceleration now includes the gravity component:

ini
Copy
Edit
a_x = (F_drive - m * g * dz/dx) / m
3. MATLAB Script Enhancements
Calculated height Z from X values after simulation using the same equation as above

Computed vehicle speed using:

ini
Copy
Edit
speed = sqrt((dX/dt)^2 + (dY/dt)^2)
Normalized speed and mapped it to a jet colormap:

Blue = slow

Red = fast

Used fill3() for 3D car animation with dynamic color

Added a colorbar to visualize speed throughout the race
