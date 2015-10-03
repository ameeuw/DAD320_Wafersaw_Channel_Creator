function varargout = dac_creator(varargin)
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @dac_creator_OpeningFcn, ...
                   'gui_OutputFcn',  @dac_creator_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

function dac_creator_OpeningFcn(hObject, eventdata, handles, varargin)
% Choose default command line output for dac_creator
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

% initialize GUI
init_gui(handles);

function varargout = dac_creator_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;



% create_code-button
function create_code_Callback(hObject, eventdata, handles)

%Execute Calculation Function
calculate_data(handles);

%SET UITABLE to PROGRAM-DATA
set(handles.uitable1,'Data',evalin('base','PROGRAM'));


% save_dac-button
function save_dac_Callback(hObject, eventdata, handles)
[FileName, PathName, FilterIndex] = uiputfile('.DAC','Program exportieren...',get(handles.name_edit,'String'));
if (FilterIndex==0)
else
    write_dac(evalin('base','PROGRAM'), FileName, PathName, handles);
end

function init_gui(handles)
set(handles.b_edit,'String',num2str(70));
set(handles.d_edit,'String',num2str(46));
set(handles.e_edit,'String',num2str(str2num(get(handles.d_edit,'String'))/4));
set(handles.n_edit,'String',num2str(5));
set(handles.rpm_edit,'String',num2str(38000));
set(handles.l_edit,'String',num2str(2));
set(handles.vdesc_edit,'String',num2str(400));
set(handles.name_edit,'String',num2str(300));
set(handles.descr_edit,'String',['DUESE ' get(handles.b_edit,'String')]);
set(handles.v_edit,'String','5.0');

% set logo
axes(handles.logo);
imshow('Logos.png');

function update_cutsection(handles)
set(handles.n_edit,'String',num2str(calc_cuts(str2num(get(handles.b_edit,'String')),str2num(get(handles.d_edit,'String')),str2num(get(handles.e_edit,'String')))));
set(handles.s_edit,'String',num2str(calc_offset(str2num(get(handles.b_edit,'String')),str2num(get(handles.d_edit,'String')),str2num(get(handles.n_edit,'String')))));

function b_edit_Callback(hObject, eventdata, handles)
update_cutsection(handles)
set(handles.descr_edit,'String',['DUESE ' get(handles.b_edit,'String')]);

function d_edit_Callback(hObject, eventdata, handles)
set(handles.e_edit,'String',num2str(str2num(get(handles.d_edit,'String'))/4));

function e_edit_Callback(hObject, eventdata, handles)
set(handles.n_edit,'String',num2str(calc_cuts(str2num(get(handles.b_edit,'String')),str2num(get(handles.d_edit,'String')),str2num(get(handles.e_edit,'String')))));
set(handles.s_edit,'String',num2str(calc_offset(str2num(get(handles.b_edit,'String')),str2num(get(handles.d_edit,'String')),str2num(get(handles.n_edit,'String')))));



function s = calc_offset(b,d,n)
s=(b-d)/(n-1);

function n = calc_cuts(b,d,e)
n=2.*round((((b-d)/e)+1)/2)-1;
    
function calculate_data(handles)

% Read values from GUI-editable-texts:
%
% b - width of channel
b=str2num(get(handles.b_edit,'String'));
% d - width of blade
d=str2num(get(handles.d_edit,'String'));
% l - length of cut
l=str2num(get(handles.l_edit,'String'));
% vdesc - descending speed
vdesc=str2num(get(handles.vdesc_edit,'String'));
% v - cutting speed
v=str2num(get(handles.v_edit,'String'));

% set description to 'DUESE [b]'
set(handles.descr_edit,'String',['DUESE ' num2str(b)]);

% set e - approximate offset-value
e=str2num(get(handles.e_edit,'String'));

% set v_absenk in [nm] to 1000*vdesc in [µm]
v_absenk=vdesc*1000;
% set v_schnitt in [mm/s] to v in [mm/s]
v_schnitt=5.0;
% set l_schnitt in [nm] to l in [µm]
l_schnitt=l*1000000;

% calculate n number of cuts
n=calc_cuts(b,d,e);
% set editable-text in GUI to calculated value
set(handles.n_edit,'String',num2str(n));

% calculate offset in [µm]
s=calc_offset(b,d,n);
% set editable-text in GUI to calculated value
set(handles.s_edit,'String',['± ' num2str(s)]);

% declare cell arrays for parameters
MODE_1=cell(30,1);
PARA_1=cell(30,1);
PARA_2=cell(30,1);
PARA_3=cell(30,1);
HEIGHT=cell(30,1);
MODE_2=cell(30,1);
SPEED=cell(30,1);
INDEX=cell(30,1);
MODE_3=cell(30,1);

% initialize cell arrays with parameters
for ind=1:30;
    MODE_1{ind,1}='End';
    PARA_1{ind,1}='0';
    PARA_2{ind,1}='0';
    PARA_3{ind,1}='0';
    HEIGHT{ind,1}='0';
    MODE_2{ind,1}='H';
    SPEED{ind,1}='0';
    INDEX{ind,1}='0';
    MODE_3{ind,1}='R';
end;

% static first line of code (Align to Point)
MODE_1{1,1}='Ali_P';
PARA_3{1,1}='XT';
MODE_3{1,1}='R';

% calculate positions of cutting steps
achop_indices=2:2:2*n;
% calculate positions of offset steps
idx_y_indices=3:2:2*n-1;

% write cutting steps
for ind=1:1:n;
MODE_1{achop_indices(ind),1}='Achop';
PARA_1{achop_indices(ind),1}=int2str(v_absenk);
PARA_2{achop_indices(ind),1}=int2str(l_schnitt);
MODE_2{achop_indices(ind),1}='D';
SPEED{achop_indices(ind),1}=int2str(v_schnitt*1000000);
MODE_3{achop_indices(ind),1}='R';
end;

% write offset steps
for ind=1:1:n-1;
MODE_1{idx_y_indices(ind),1}='Idx_Y';
MODE_2{idx_y_indices(ind),1}='H';
INDEX{idx_y_indices(ind),1}=int2str((-1)^ind*s*ind*1000);
MODE_3{idx_y_indices(ind),1}='R';
end;

% static final line
MODE_1{2*n+1,1}='End';
MODE_3{2*n+1,1}='R';

% declare PROGRAM cell array
PROGRAM=cell(30,9);

% fill PROGRAM cell array
for ind=1:30;
PROGRAM{ind,1}=MODE_1{ind,1};
PROGRAM{ind,2}=PARA_1{ind,1};
PROGRAM{ind,3}=PARA_2{ind,1};
PROGRAM{ind,4}=PARA_3{ind,1};
PROGRAM{ind,5}=HEIGHT{ind,1};
PROGRAM{ind,6}=MODE_2{ind,1};
PROGRAM{ind,7}=SPEED{ind,1};
PROGRAM{ind,8}=INDEX{ind,1};
PROGRAM{ind,9}=MODE_3{ind,1};
end;

% assign variable in 'base' workspace
assignin('base','PROGRAM',PROGRAM);

% WRITE OUT FUNCTION
function write_dac(PROGRAM, filename, pathname, handles)

% Get values from editable-text
% name - program number
name=get(handles.name_edit,'String');
% descr - program discription
descr=get(handles.descr_edit,'String');
% rpm - speed of rotation
rpm=str2num(get(handles.rpm_edit,'String'));

% open file from save-to-dialog
fileID = fopen([pathname '/' filename],'w');

% print title and description in DAC-header
titleFormat = 'UNIT_DEV = "MM"\nDEV_ID = "%s"\n';
fprintf(fileID,titleFormat,descr);


% append middlepart of DAC file -> TODO make file agnostic
fprintf(fileID,'%s\n%s\n%s\n','PROG_MODE = "SPECIAL"', 'CUT_MODE = "A"', 'HEIGHT_MODE = "DEPTH"');

% write out spindle revolution value
fprintf(fileID,'SPNDL_REV = %s\n',num2str(rpm));

% write out mid-section
fprintf(fileID,'%s\n%s\n%s\n%s\n','WORK_SIZE = 35000000', 'WORK_DEPTH = 26000000', 'WORK_THICK = 1075000', 'WORK_ALIGN = 0');
fprintf(fileID,'%s\n%s\n%s\n%s\n','ALI_START_X = 0', 'ALI_START_Y = 50000000', 'CENT_ADJ_X = 0', 'CENT_ADJ_Y = 0');
fprintf(fileID,'%s\n%s\n%s\n%s\n%s\n','INDEX_DIR = "REAR"', 'PSPEC_NO = "0"', 'AUTODOWN_L = 0', 'AUTODOWN_Z = 0', 'TOTAL_LINE = 0');
fprintf(fileID,'%s\n%s\n%s\n%s\n%s\n','ALU_P_CH1 = 70', 'ALU_P_CH2 = 70', 'ALU_P_CH3 = 70', 'ALU_P_CH4 = 70', 'SWING_CH1 = 0');
fprintf(fileID,'%s\n%s\n%s\n%s\n%s\n%s\n','SWING_CH2 = 0', 'SWING_CH3 = 0', 'SWING_CH4 = 0', 'SETUP_AUTO = "NO"', 'SETUP_LEN = 0', 'SETUP_COU = 0');

% format specification for first section 'DESCR = [32, 0, 0, ..]'
formatSpec21 = '%s = [32, 0';
formatSpec22 = ', %s';
formatSpec23 = ', 0]\n';

% format specification for rest of parameters ('PA[i] = "[val]"')
formatSpec = '%s%02d = "%s"\n';

% print first parameter row (cutting height) TODO <- Anpassung bei tiefen größer 70µm
fprintf(fileID,formatSpec21,'DAC_HEI');
for ind=1:30;
fprintf(fileID,formatSpec22,PROGRAM{ind,5});
end;
fprintf(fileID,formatSpec23);

% print second parameter row (cutting speed)
fprintf(fileID,formatSpec21,'DAC_SPD');
for ind=1:30;
fprintf(fileID,formatSpec22,PROGRAM{ind,7});
end;
fprintf(fileID,formatSpec23);

% print third parameter row (offset values)
fprintf(fileID,formatSpec21,'DAC_IDX');
for ind=1:30;
fprintf(fileID,formatSpec22,PROGRAM{ind,8});
end;
fprintf(fileID,formatSpec23);


% print PARA_1 values
for ind=1:30;
fprintf(fileID,formatSpec,'PA',ind,PROGRAM{ind,2});
end;
% print PARA_2 values
for ind=1:30;
fprintf(fileID,formatSpec,'PB',ind,PROGRAM{ind,3});
end;
% print PARA_3 values
for ind=1:30;
fprintf(fileID,formatSpec,'PC',ind,PROGRAM{ind,4});
end;
% print Mode (command) values
for ind=1:30;
fprintf(fileID,formatSpec,'ST',ind,PROGRAM{ind,1});
end;
% print HEIGHT values
for ind=1:30;
fprintf(fileID,formatSpec,'HEI',ind,PROGRAM{ind,6});
end;
% print INDEX values
for ind=1:30;
fprintf(fileID,formatSpec,'IDX',ind,PROGRAM{ind,9});
end;

% append endpart of DAC file
endFormat = '%s\n%s\n%s\n%s\n';

fprintf(fileID, endFormat,'KC_LINE_L = 0', 'KERF_L = 0', 'KC_WORK_NO = 0', 'KC_LINE_M1 = 0');
fprintf(fileID, endFormat,'KC_LINE_N1 = 0', 'KC_LINE_M2 = 0', 'KC_LINE_N2 = 0', 'KC_LINE_M3 = 0');
fprintf(fileID, endFormat,'KC_LINE_N3 = 0', 'KC_LINE_M4 = 0', 'KC_LINE_N4 = 0', 'KC_MODE = "OPERATER"');
fprintf(fileID, endFormat,'KC_PNT_LIM = 50', 'KC_PNT_ERR = "CALL"', 'KC_OFF_LIM = 70000', 'KC_OFF_ADJ = 0');
fprintf(fileID, endFormat,'KC_MAX_LIM = 70000', 'KC_MAX_ERR = "CALL"', 'KC_MIN_LIM = 30000', 'KC_MIN_ERR = "CALL"');
fprintf(fileID, endFormat,'KC_MAXX_LIM = 0', 'KC_MAXX_ERR = "CALL"', 'KC_HAF_LIM = 0', 'KC_HAF_ERR = "CALL"');
fprintf(fileID, endFormat,'KC_CHIP_LIM = 20000', 'KC_CHIP_ERR = "CALL"', 'KC_AREA_LIM = 4000', 'KC_AREA_ERR = "CALL"');
fprintf(fileID, endFormat,'KC_PER_Y = 0', 'KC_OBJECT = "CENTER"', 'KC_SENSE = 2', 'KC_RETRY = 3');
fprintf(fileID, endFormat,'KC_BLOW_TIM = 5', 'KC_DIR_CH1 = 0', 'KC_OBL_CH1 = 0', 'ALI_MODE = "NORMAL"');
fprintf(fileID, endFormat,'ALU_PERCENT = 70', 'PC_TABLE00 = "CUTDAC"', 'PC_PARA00 = ""', 'PC_TABLE01 = "CUTWET"');
fprintf(fileID, endFormat,'PC_PARA01 = ""', 'PC_TABLE02 = ""', 'PC_PARA02 = ""', 'PC_TABLE03 = ""');
fprintf(fileID, endFormat,'PC_PARA03 = ""', 'PC_TABLE04 = ""', 'PC_PARA04 = ""', 'PC_TABLE05 = ""');
fprintf(fileID, endFormat,'PC_PARA05 = ""', 'PC_TABLE06 = ""', 'PC_PARA06 = ""', 'PC_TABLE07 = ""');
fprintf(fileID, endFormat,'PC_PARA07 = ""', 'PC_TABLE08 = ""', 'PC_PARA08 = ""', 'PC_TABLE09 = ""');
fprintf(fileID, endFormat,'PC_PARA09 = ""', 'ALU_MAG_CH1 = "HI"', 'ALU_MAG_CH2 = "HI"', 'ALU_MAG_CH3 = "HI"');
fprintf(fileID, endFormat,'ALU_MAG_CH4 = "HI"', 'ALU_DIR_CH1 = 0', 'ALU_DIR_CH2 = 0', 'ALU_DIR_CH3 = 0');
fprintf(fileID, '%s\n%s\n%s\n%s\n%s\n','ALU_DIR_CH4 = 0', 'ALU_OBL_CH1 = 0', 'ALU_OBL_CH2 = 0', 'ALU_OBL_CH3 = 0', 'ALU_OBL_CH4 = 0');

% close all opened files
fclose('all');



% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function descr_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function name_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function vdesc_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function l_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function rpm_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function d_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function b_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function n_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function s_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function v_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function e_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit13_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
