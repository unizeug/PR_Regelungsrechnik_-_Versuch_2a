// ###################################################
// Scilab Plot Script bode_w()
// 
// Version:30.01.2011
// Autor: Markus Valtin
// ###################################################
//
// Einbinden:
//	erste Möglichkeit:  Die Funktion an den Anfang eures Scilab-Skripts kopieren.
//
// 	zweite Möglichkeit: Diese Datei mit via  "  exec("./bode_w.sci", -1);   "   einbinden.
//                          Dazu muss diese Datei im selben Verzeichnis wie euer Scilab-Skript sein.
//
// Benutzung:
//  in eurem Scilab-Skript den Befehl "w = bode_w(GK, [w_min, w_max]);" aufrufen
//	z.B. [w, db, phi] = bode_w(GGs*K, 10^(-3), 1);



// Fehlermeldung bei neudefinition vermeiden
funcprot(0);

// Definition der Funktion bode_w()
// Aufruf: [ w, [db], [phi] ] = bode_w_farbe(sl, [w_min, w_max], [title], [show_margins], [n], [farbe]);
//      sl =           Lineares System
//      w_min/w_max =  minimale/maximale Frequenz in rad/s
//      w_min/w_max =  Exponenten von 10^(X);  -1000 < X < 8
//      [title] =      Titel des Plots
//      show_margins = Amplituden / Phasengang anzeigen? [ %t, %f, 'hide', 'false']
//      n =            Anzahl der Stützstellen
function varargout=bode_w_farbe(sl, varargin)
  [lhs, rhs] = argn();
  // Defaults
  exponent = [-2 ; 4 ];
  title_ = '';
  show_margins = %t;
  n = 1000;
  farbe_ = 1;
  
  
  if (rhs > 1) then
    if (rhs == 3 | rhs == 4 | rhs == 5 | rhs == 6 | rhs == 7) then 	// w_min und w_max
      if ( varargin(1) < 0 | (varargin(1) > 0.1 & varargin(2) < 7)) then 
	exponent(1) = varargin(1);
        exponent(2) = varargin(2);
      else
        exponent(1) = log10(varargin(1));
        exponent(2) = log10(varargin(2));
      end
    end
    if (rhs == 4 | rhs == 5 | rhs == 6 | rhs == 7) then 	// w_min und w_max
        title_ = varargin(3);
    end
    if (rhs == 5 | rhs == 7) then
      s_m = varargin(4);
      if ( s_m == %t | s_m == %f ) then
	show_margins = s_m;
      elseif ( s_m == 'hide' | s_m == 'false' ) then
	show_margins = %f;
      end
    end
    if (rhs == 6 | rhs == 7) then 	// w_min und w_max
        n = varargin(5);
    end
        if (rhs == 7) then 	// w_min und w_max
        farbe_ = varargin(6);
    end
    if (~(rhs == 3 | rhs == 4 | rhs == 5 | rhs == 7)) then
      disp([ 	"Fehlerhafter Aufruf!"
		"Aufruf: [ w, [db], [phi] ] = bode_w(sl, [w_min, w_max], [n]);"
		"               sl = Lineares System"
		"               w_min/w_max = minimale/maximale Frequenz in rad/s"
		"               n = Anzahl der Stützstellen" ]);
      abort
    end
  end

  w = logspace((exponent(1)),(exponent(2)),n);
  f = w / (2*%pi);

  [f,r]=repfreq(sl,f);
  [db,phi]=dbphi(r);

  if ( show_margins ) then
    // Amplitudenreserve
    [gain, f_gain] = g_margin(sl);
    gain = gain(1); f_gain = f_gain(1);
    // Phasenreserve
    [phase, f_phase] = p_margin(sl);
    phase = phase(1); f_phase = f_phase(1);
    // Scilab 4 - Scilab 5 Fix
    // Scilab 4 p_margin gibt nicht die Phasenreserve, sondern den Wert des Phasengangs aus.
    // Falls die Differenz der Phase bei der Durchtrittsfrequenz größer 10 ist, ist es vermutlich falsch.
    if(~isempty(f_phase)) then
      [diff_min, min_index] = min(abs(f-f_phase))
      if ( abs(phase - phi(min_index)) > 10 ) then 
	phase =  -180 + phase;
      end
    end
  else
    gain = ''; f_gain = ''; phase = '', f_phase = '';
  end

  //scf();
  subplot(211);
    plot2d(f*2*%pi,db, style=[farbe_],logflag='ln' );
    e=gce();
    e.children(1).line_style=1;
    xgrid
    xtitle(string(title_),'Frequenz in [rad/s]', 'Verstaerkung in [dB]');

    fs_x = e.parent.x_ticks.locations;
    fs_y = e.parent.y_ticks.locations;
    figure_size = [(fs_x(1)*1.001) (fs_x(length(fs_x))*0.999) ; fs_y(1) fs_y(length(fs_y)) ];

    if (~(isempty(gain) | ~(f_gain > f(1) & f_gain < f(length(f))) )) then
      disp('Amplitudenreserve: ' + string(gain));
      plot2d([f_gain*2*%pi f_gain*2*%pi], [figure_size(2,1) figure_size(2,2)], style=2);
      e=gce(); e.children(1).line_style=4;
      plot2d([figure_size(1,1) figure_size(1,2)], [-gain -gain], style=2);
      e=gce(); e.children(1).line_style=4;
    end
    if (~(isempty(f_phase) | ~(f_phase > f(1) & f_phase < f(length(f))) )) then
      plot2d([f_phase*2*%pi f_phase*2*%pi], [figure_size(2,1) figure_size(2,2)], style=5);
      e=gce(); e.children(1).line_style=4;      
    end
  subplot(212);
    plot2d(f*2*%pi,phi, style=[farbe_],logflag='ln');
    e=gce();
    e.children(1).line_style=1;
    xgrid
    xtitle('','Frequenz in [rad/s]', 'Phasengang in Grad');
    fs_x = e.parent.x_ticks.locations;
    fs_y = e.parent.y_ticks.locations;
    figure_size = [(fs_x(1)*1.001) (fs_x(length(fs_x))*0.999) ; fs_y(1) fs_y(length(fs_y)) ];

    if (~(isempty(phase) | ~(f_phase > f(1) & f_phase < f(length(f))) )) then
      disp('Phasenreserve: ' + string(180 + phase));
      plot2d([f_phase*2*%pi f_phase*2*%pi], [figure_size(2,1) figure_size(2,2)], style=5);
      e=gce(); e.children(1).line_style=4;
      plot2d([f_phase*2*%pi f_phase*2*%pi], [-180 phase], style=5);
      e=gce(); e.children(1).thickness=2;
      plot2d([figure_size(1,1) figure_size(1,2)], [phase phase], style=5);
      e=gce(); e.children(1).line_style=4;
    end
    if (~(isempty(f_gain) | ~(f_gain > f(1) & f_gain < f(length(f))) )) then
      plot2d([f_gain*2*%pi f_gain*2*%pi], [figure_size(2,1) figure_size(2,2)], style=2);
      e=gce(); e.children(1).line_style=4;
    end

  varargout = list(w, db, phi);
endfunction


// Fehlermeldung bei Neudefinition wieder einschalten
funcprot(1);