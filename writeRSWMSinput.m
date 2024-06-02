function writeRSWMSinput(filename, seg_info, tip_info, simtime)
% writeRSWMSinput: writes an input file for RSWMS

fid = fopen(filename,'w');

fprintf(fid, 'Time:\n   %g\n\n',simtime);

fprintf(fid, 'Number of seeds:\n          1\n\n');

fprintf(fid,'ID, X and Y coordinates of the seeds (one per line)\n    1 0.00E+00 0.00E+00\n\n');

fprintf(fid,'Root DM, shoot DM, leaf area:\n   0.0000000       0.0000000       0.0000000\n\n');

fprintf(fid,'Average soil strength and solute concentration experienced by root system:\n   0.0000000000000000        0.0000000000000000 \n\n');

axes = sum(tip_info(:,6)==1);
fprintf(fid, 'Total # of axes:\n         %g\n\n',axes);

fprintf(fid,'Total # of branches, including axis(es):\n     %g\n\n',size(tip_info,1));

fprintf(fid,'Total # of segment records:\n     %g\n\n',size(seg_info,1));


fprintf(fid,'segID#    x          y          z      prev or  br#  length   surface  mass\norigination time\n');
for i = 1 : size(seg_info,1)   
    c = seg_info(i,:);    
    fprintf(fid,'%g  %g  %g  %g  %g  %g  %g  %g  %g  %g\n%g\n',c(1),c(2),c(3),c(4),c(5),c(6),c(7),c(8),c(9),c(10),c(11));    
end

fprintf(fid,'\nTotal # of growing branch tips:\n  %g\n\n',size(tip_info,1));


fprintf(fid,'tipID#    xg          yg          zg      sg.bhd.tp. ord  br#  tot.br.lgth. axs#\noverlength  # of estblished points\ntime of establishing (-->)\n');
for i = 1 : size(tip_info,1)   
    c = tip_info(i,:);    
    fprintf(fid,'%g  %g  %g  %g  %g  %g  %g  %g  %g  %g\n%g 0\n',c(1),c(2),c(3),c(4),c(5),c(6),c(7),c(8),c(9),c(10),c(11));    
end

fclose(fid);
