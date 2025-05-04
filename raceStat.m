function raceStats = raceStat(X,Y,t,path,out)
% Calculate race stats based on simulation results

prev_sec = 6;
loops = -1;
j = 0; k = 0;
Xerr = []; Yerr = []; terr = [];

for i = 1:length(X)
    if X(i) < path.l_st
        if X(i) >= 0
            if Y(i) < path.radius
                sec = 1;
            else
                sec = 4;
            end
        else
            if Y(i) < path.radius
                sec = 6;
            else
                sec = 5;
            end
        end
    else
        if Y(i) < path.radius
            sec = 2;
        else
            sec = 3;
        end
    end
    
    if (prev_sec == 6) && (sec == 1)
        loops = loops + 1;
        j = j + 1;
        tloops(j) = t(i);
    end
    prev_sec = sec;
    
    if ~insideTrack(X(i), Y(i), sec, path)
        k = k+1;
        Xerr(k) = X(i);
        Yerr(k) = Y(i);
        terr(k) = t(i);
    end
end

raceStats.loops = loops;
raceStats.tloops = tloops;
raceStats.leftTrack.X = Xerr;
raceStats.leftTrack.Y = Yerr;
raceStats.leftTrack.t = terr;
raceStats.minSOC = min(out.SOC.Data);
raceStats.maxSOC = max(out.SOC.Data);
raceStats.endSOC = out.SOC.Data(end);

if sum(out.brake.Data) == 0
    raceStats.brake_viol = 'False';
else
    raceStats.brake_viol = 'True';
end
end

function yesorno = insideTrack(x,y,sec,path)
switch sec
    case 1
        if (y < path.width) && (y > -path.width)
            yesorno = 1;
        else
            yesorno = 0;
        end
    case {2,3}
        r = sqrt((x - path.l_st)^2 + (y - path.radius)^2);
        if (r < path.radius + path.width) && (r > path.radius - path.width)
            yesorno = 1;
        else
            yesorno = 0;
        end
    case 4
        if (y < (2*path.radius + path.width)) && (y > (2*path.radius - path.width))
            yesorno = 1;
        else
            yesorno = 0;
        end
    case {5,6}
        r = sqrt((x)^2 + (y - path.radius)^2);
        if (r < path.radius + path.width) && (r > path.radius - path.width)
            yesorno = 1;
        else
            yesorno = 0;
        end
    otherwise
        disp('error')
        yesorno = 0;
end
end