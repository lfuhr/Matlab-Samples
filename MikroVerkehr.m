zellen = 300;
vMax = 5;
dichte = .16;
LEER = -1;
iterationen = 100;
troedelwsnlkt =  0.2;

idxmod = @(x, indexRange) mod(x - 1, indexRange) + 1;


strasse = zeros(1,zellen) - 1;
while (sum(strasse) < dichte * zellen)
    strasse(randi(zellen)) = randi(vMax + 1) - 1;
end

dsp(strasse);

for i = 1:iterationen
    neueStrasse = zeros(1,zellen) - 1;
    for zelle = 1:zellen
        v = strasse(zelle);
        if  v ~= LEER
            % Beschleunigen
            v = min(v+1, vMax);
            % Bremsen
            davor = find(strasse(idxmod(zelle+1:zelle+vMax, vMax))+1);
            if ~ isempty(davor)
                v = min(v, davor(1));
            end
            % Trödeln
            v = v - (rand()+troedelwsnlkt > 1);
            % Bewegen
            neueStrasse(idxmod(zelle+v,vMax)) = v;
        end
    end
    strasse = neueStrasse;
    
    %pause(.2)
end

function result = farbe(wert)
    disp(wert);
    global LEER; global vMax;
    
    if wert == LEER
        result = .9;
    else
        result = (wert * 0.6 / vMax);
    end
end

function dsp(strasse)
    global zellen;
    triple = @(x) [x x x];
    size(triple(arrayfun(farbe,strasse)'))
    scatter(cos((1:zellen)*2*pi/zellen), sin((1:zellen)*2*pi/zellen),[] ...
        ,triple(arrayfun(farbe(strasse)))');
end