function info = function_pdslblread(lblfile)
% Code written by: Mike Bramble | michael.s.bramble@jpl.nasa.gov
% basic script to ingest and analyze pds lbl data
% the input is a character string of the label file name
% buids off of envihdrread by Ian M. Howat, Applied Physics Lab, University of Washington
% 20210914 - initial version
% 20210915 - version now reads everything correctly except for multi-line
% paramters or label notes with no '=' delimintor. version does not read
% header offset or band interleave

fid = fopen(lblfile);
while true
    line = fgetl(fid);
    if line == -1
        break
    else
        eqsn = strfind(line,'=');
        if ~isempty(eqsn)
            parameter = strtrim(line(1:eqsn-1));
            parameter(strfind(parameter,':')) = '_';
            parameter(strfind(parameter,'^')) = '';
            parameter(strfind(parameter,'/')) = '';
            parameter(strfind(parameter,'*')) = '';
            value = strtrim(line(eqsn+1:end));
            value(strfind(value,'*')) = '';
            value(strfind(value,'/')) = '';
            value(strfind(value,'"')) = '';

            %below currently not working but hope to implement
            %work in progress
%             value(strfind(value,'BAND_SEQUENTIAL')) = 'bsq';
%             value(strfind(value,'LINE_INTERLEAVED')) = 'bil';
%             value(strfind(value,'SAMPLE_INTERLEAVED')) = 'bip';
            %end work in progress
            
            if isempty(str2num(value))
                eval(['info.',parameter,' = ''',value,''';'])
            else
                eval(['info.',parameter,' = ',value,';'])
            end
        end
    end
end
fclose(fid);