function varargout = valeurPropre(varargin)
% VALEURPROPRE MATLAB code for valeurPropre.fig
%      VALEURPROPRE, by itself, creates a new VALEURPROPRE or raises the existing
%      singleton*.
%
%      H = VALEURPROPRE returns the handle to a new VALEURPROPRE or the handle to
%      the existing singleton*.
%
%      VALEURPROPRE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VALEURPROPRE.M with the given input arguments.
%
%      VALEURPROPRE('Property','Value',...) creates a new VALEURPROPRE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before valeurPropre_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to valeurPropre_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help valeurPropre

% Last Modified by GUIDE v2.5 13-Apr-2019 23:42:57

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @valeurPropre_OpeningFcn, ...
                   'gui_OutputFcn',  @valeurPropre_OutputFcn, ...
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

% --- Executes just before valeurPropre is made visible.
function valeurPropre_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to valeurPropre (see VARARGIN)

% Choose default command line output for valeurPropre
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% This sets up the initial plot - only do when we are invisible
% so window can get raised using valeurPropre.
if strcmp(get(hObject,'Visible'),'off')
    plot(rand(3));
end

if nargin -3 <= 0
    disp('Dommage, vous n avez pas donne la matrice en argument.') 
end 

i = nargin-3 ; % The first personnal argument is a this position 
setGlobalMat(varargin{i})


% Remet aux valeurs par d�faut � chaque nouveau lancement
% On associe le texte de telle sorte que les valeurs internes de calcul et 
% les valeurs visuelles soient en phase
tmp = 1.0 ; 
set(handles.EpsilonAsString,'String',num2str(tmp,3))
setGlobalEpsilon(tmp)

set(handles.StepAsString,'String',num2str(tmp,3))
setGlobalStep(tmp)   

% Add Figure operation
set(hObject,'toolbar','figure') ; 

% UIWAIT makes valeurPropre wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = valeurPropre_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Appliquer1.
function Appliquer1_Callback(hObject, eventdata, handles)
% hObject    handle to Appliquer1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1);
cla;

A = getGlobalMat ; 
[n,~] = size(A); % The matrix must be a square matrix

J1 = 0 ;
J2 = 0 ;
J3 = 0 ;
J4 = 0 ;
I  = 0 ;

% On construit le vecteur R o� r(i) sigma(abs(a(i,j)) pour tout j 
% On R est donc le vecteur compos� de la somme des valeurs absolus des
% cooefficients de la ligne.
for i = 1:n
    S = 0 ;
    for j = 1:n
        S = S+abs(A(i,j));
        R(i) = S ;
        if S>I
            I=S ;
        end
    end
end


hold on
for i = 1:n
       X(i) = A(i,i) ; % C'est le vecteur digonal
       
     % On cr�e les diff�rents disques de 0 � 2? par pas de ?/50
     % Les disques sont de centre (X(i),X(i) de rayon R(i)
        theta=0:pi./50:2*pi;
        x = R(i)*cos(theta)+X(i);
        y = R(i)*sin(theta)+X(i);
        
        %plot(x,y);
        
      % calcul des limites en x,y pour tracer le rectangle contenant
      % l'ensemble des cercles.
      % Le min du vecteur x est connu, car la figure est un cercle
        J1 = min(J1, -R(i)+X(i)) ;
        J2 = max(J2,  R(i)+X(i)) ;
        J3 = min(J3, -R(i)+X(i)) ;
        J4 = max(J4,  R(i)+X(i)) ; 
end

%afficher la grille
step = getGlobalStep() ; 

xh = J1 : step : J2 ;
yv = J3 : step : J4 ;

[X,Y] = meshgrid(xh,yv);
nbPoints = length(xh) * length(yv) ;  % Nb de point de la grille
nbA      = nbPoints / 100 ; % Incr�ment de la barre de progression en %
nb       = 0 ;  % NB de points d�j� calcul�

% On affiche un petit conseil pour la valeur de step 
lgx = abs(J2 - J1) ;
lgy = abs(J4 - J3) ; 
suggestion = max(lgx, lgy) / 50 ; 
% On fait une suggestion sur la nombre de step 
set(handles.SuggestStep,'String','Suggestion pour le pas ' + suggestion) 

% On prend une barre de progression
f  = waitbar(nb,'Veuillez patienter pour ' + nbPoints + ' points.') ; 

% On calcule les points sur la grille xh * yv 
% svd : calcul des valeurs propres d'une matrice co
for j=1:length(xh) 
    for k=1:length(yv)
        sigmin(j,k) = min(svd((X(j,k) + Y(j,k)*1i)*eye(n)-A))
        
        nb = nb +1 ; % Barre de progression
        %if mod(nb, nbA) == 0 
           waitbar(nb/nbPoints,f) % Mise � jour de la barre de progression
        %end
    end
end
close(f) % Fin de la barre de progression

minEpsi = min(min(sigmin))
maxEpsi = max(max(sigmin))
set(handles.SuggestEpsi,'String',minEpsi+ ' < Epsilon < ' + maxEpsi)

Epsi = getGlobalEpsilon
f=[Epsi Epsi];

contour(X, Y, sigmin, f)

% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to OpenMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
file = uigetfile('*.fig');
if ~isequal(file, 0)
    open(file);
end

% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to PrintMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
printdlg(handles.figure1)

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to CloseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
                     ['Close ' get(handles.figure1,'Name') '...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.figure1)


function EpsilonAsString_Callback(hObject, eventdata, handles)
% hObject    handle to EpsilonAsString (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EpsilonAsString as text
%        str2double(get(hObject,'String')) returns contents of EpsilonAsString as a double

tmp = str2double(get(hObject,'String')); 
setGlobalEpsilon(tmp) ; 


% --- Executes during object creation, after setting all properties.
function EpsilonAsString_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EpsilonAsString (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function StepAsString_Callback(hObject, eventdata, handles)
% hObject    handle to StepAsString (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of StepAsString as text
%        str2double(get(hObject,'String')) returns contents of StepAsString as a double
tmp = str2double(get(hObject,'String')); 
setGlobalStep(tmp) ; 

% --- Executes during object creation, after setting all properties.
function StepAsString_CreateFcn(hObject, eventdata, handles)
% hObject    handle to StepAsString (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Gestion des Variables Globales --------------------------------------
function setGlobalEpsilon(val)
global Epsilon
Epsilon = val;

function r = getGlobalEpsilon
global Epsilon
r = Epsilon;

function setGlobalStep(val)
global Step
Step = val;
disp('SetGlobalStep ' + val)

function r = getGlobalStep
global Step
r = Step;

function setGlobalMat(val)
global mat
mat = val;

function r = getGlobalMat
global mat
r = mat;
