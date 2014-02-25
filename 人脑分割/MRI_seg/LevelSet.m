
function varargout = LevelSet(varargin)
% LEVELSET M-file for LevelSet.fig
%      LEVELSET, by itself, creates a new LEVELSET or raises the existing
%      singleton*.
%
%      H = LEVELSET returns the handle to a new LEVELSET or the handle to
%      the existing singleton*.
%
%      LEVELSET('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LEVELSET.M with the given input arguments.
%
%      LEVELSET('Property','Value',...) creates a new LEVELSET or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before LevelSet_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to LevelSet_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help LevelSet

% Last Modified by GUIDE v2.5 21-Jan-2010 19:48:47

% Begin initialization code - DO NOT EDITclear all;
clc;
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @LevelSet_OpeningFcn, ...
                   'gui_OutputFcn',  @LevelSet_OutputFcn, ...
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


% --- Executes just before LevelSet is made visible.
function LevelSet_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to LevelSet (see VARARGIN)

% Choose default command line output for LevelSet
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes LevelSet wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = LevelSet_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,PathName] = uigetfile({'*.tif';'*.jpg';'*.bmp';'*.gif'},'选择待分割图像');
fullName = [PathName FileName];
global img;
img=imread(fullName); 
global U;
U=img(:,:,1);
global tempImg;
tempImg = uint8(zeros(size(U)));
imagesc(U);colormap(gray)




function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
global itNum;
itNum = uint8(str2double(get(hObject,'String')));



% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global itNum;
global U;
global phi;
Message = '请用鼠标点数初始区域中心点(点第一个点选中心，点第二个点确定其与第一个点距离为半径)';
h = msgbox(Message,'replace');
waitfor(h);
phi = m_levelset(U,itNum);


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global phi;
global U;
 Message = '请用鼠标点选区域，按Enter完成';
 h = msgbox(Message,'modal');
 waitfor(h);
%求phi连通分量
L = bwlabeln(uint8(-phi));

[x,y] = ginput();
numberC = size(x,1);
[r,c] = size(L);
    sub1 = ones(r,c);
for k = 1:numberC
    sub2 = L-L(fix(y(k)),fix(x(k)));
    sub1 = sub1&abs(sub2);
end
U = uint8(~sub1).*U;
imagesc(U);colormap(gray);

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global U;
global cluster_n;
[center, u, obj_fcn] = fcm(double(U(:)), cluster_n);
[m,n] = size(U);

ppp = sort(center,'descend');
for i = 1:cluster_n
    CIndex(i) = find(center == ppp(i));
end
l = m*n;
for k = 1:l
    cluster = find(u(:,k) == max(u(:,k)),1);
    order = find(CIndex == cluster,1); 
    U(mod(k-1,n)+1,fix((k-1)/n+1)) =  255-(order-1)*255/(cluster_n-1);
end
global tempImg;
global img;
goOn =  questdlg('继续分割该图像吗？') ;
if strcmp(goOn,'Yes')
    tempImg = U + tempImg;
    U = img(:,:,1);
    figure;  
    imshow(tempImg);
    axes(handles.axes1);
    imshow(U);
else
    tempImg = U + tempImg;
    axes(handles.axes1);
    imshow(tempImg);colormap(gray);
end

function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double
global cluster_n;
cluster_n = uint8(str2double(get(hObject,'String')));

% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[fname,pname]=uiputfile({'*.tif';'*.jpg';'*.bmp';'*.gif'},'保存分割图像');
global tempImg;
imwrite(tempImg,strcat(pname,fname));

