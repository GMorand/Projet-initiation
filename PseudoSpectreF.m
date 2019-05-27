function varargout = PseudoSpectreF(varargin)
% PSEUDOSPECTRE MATLAB code for PseudoSpectre.fig
%      PSEUDOSPECTRE, by itself, creates a new PSEUDOSPECTRE or raises the existing
%      singleton*.
%
%      H = PSEUDOSPECTRE returns the handle to a new PSEUDOSPECTRE or the handle to
%      the existing singleton*.
%
%      PSEUDOSPECTRE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PSEUDOSPECTRE.M with the given input arguments.
%
%      PSEUDOSPECTRE('Property','Value',...) creates a new PSEUDOSPECTRE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before PseudoSpectre_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to PseudoSpectre_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help PseudoSpectre

% Last Modified by GUIDE v2.5 25-May-2019 21:43:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PseudoSpectre_OpeningFcn, ...
                   'gui_OutputFcn',  @PseudoSpectre_OutputFcn, ...
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


% --- Executes just before PseudoSpectre is made visible.
function PseudoSpectre_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to PseudoSpectre (see VARARGIN)

% Choose default command line output for PseudoSpectre
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes PseudoSpectre wait for user response (see UIRESUME)
% uiwait(handles.figure1);

if nargin -3 <= 0
    disp("Dommage, vous n'avez pas donne la matrice en argument.") 
end 

i = nargin-3 ; % The first personnal argument is a this position 
setGlobalMat(varargin{i})

% Remet aux valeurs par defaut a chaque nouveau lancement
% On associe le texte de telle sorte que les valeurs internes de calcul et 
% les valeurs visuelles soient en phase
tmp = 0.01 ; 
set(handles.EpsilonAsString,'String',num2str(tmp,5))
setGlobalEpsilon(tmp)

tmp = 1.0 ; 
set(handles.StepAsString,'String',num2str(tmp,3))
setGlobalStep(tmp)   

% Add Figure operation
set(hObject,'toolbar','figure') ; 

% Esthetique 
set(handles.figure1,'Color', [0.75 0.75 0.90])
set(handles.buttongroup,'BackgroundColor', [ 0.75 0.67 0.90])
set(handles.rb_grille,'BackgroundColor', [ 0.75 0.72 0.90])
set(handles.rb_newton,'BackgroundColor', [ 0.75 0.72 0.90])

% --- Outputs from this function are returned to the command line.
function varargout = PseudoSpectre_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function StepAsString_Callback(hObject, eventdata, handles)
% hObject    handle to StepAsString (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of StepAsString as text
%        str2double(get(hObject,'String')) returns contents of StepAsString as a double
   tmp = str2double(get(hObject,'String'));
   setGlobalStep(tmp) 

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

% --- Executes when selected object is changed in buttongroup.
function buttongroup_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in buttongroup 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
  % disp("SelectionChangedFcn "+get(hObject,'Tag'))
  switch get(hObject,'Tag')   % Get Tag of selected object
    case 'rb_grille'
        defDrawNewton(handles, 'Off')
        defDrawGrille(handles, 'On')

    case 'rb_newton'
        defDrawGrille(handles, 'Off')
        defDrawNewton(handles, 'On')
  end


% ---- Shared Function used to drive the GUI -------------------------------------
function defDrawGrille(handles, val)
% handles    structure with handles and user data (see GUIDATA)
% val == 'Off' to hide the GUI component
% val == 'On'  to show the GUI component, IE to set Visible the element
    set(handles.Epsilon,'Enable',val)
    set(handles.EpsilonAsString,'Enable',val)
    set(handles.SuggestEpsi,'Enable',val)
    set(handles.Epsilon,'Visible',val)
    set(handles.EpsilonAsString,'Visible',val)
    set(handles.SuggestEpsi,'Visible',val)

    set(handles.Step,'Enable',val)
    set(handles.StepAsString,'Enable',val)
    set(handles.SuggestStep,'Enable',val)
    set(handles.Step,'Visible',val)
    set(handles.StepAsString,'Visible',val)
    set(handles.SuggestStep,'Visible',val)

    set(handles.AppliquerGrille,'Enable',val)
    set(handles.AppliquerGrille,'Visible',val)
    set(handles.axes,'Visible',val)


function defDrawNewton(handles, val)
% handles    structure with handles and user data (see GUIDATA)
% val == 'Off' to hide the GUI component
% val == 'On'  to show the GUI component, IE to set Visible the element
% Enable does not exit for axes component 
    set(handles.axes,'Visible',val)
    set(handles.AppliquerNewton,'Enable',val)
    set(handles.AppliquerNewton,'Visible',val)

    set(handles.newtonProgression,'Enable',val) 
    set(handles.newtonProgression,'Visible',val)
    
    set(handles.Epsilon,'Enable',val)
    set(handles.Epsilon,'Visible',val)
    set(handles.EpsilonAsString,'Enable',val)
    set(handles.EpsilonAsString,'Visible',val)

    

% --- Executes on button press in AppliquerGrille.
function AppliquerGrille_Callback(hObject, eventdata, handles)
% hObject    handle to AppliquerGrille (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
   axes(handles.axes);
   cla;
   
   A = getGlobalMat ; 
   [n,~] = size(A); % The matrix must be a square matrix
   
   J1 = 0 ;
   J2 = 0 ;
   J3 = 0 ;
   J4 = 0 ;
   I  = 0 ;
   
   % On construit le vecteur R ou r(i) sigma(abs(a(i,j)) pour tout j 
   % On R est donc le vecteur compose de la somme des valeurs absolus des
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
          X(i) = A(i,i) ; % C'est le vecteur diagonale
          
        % On cree les differents disques de 0 a 2? par pas de ?/50
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
   nb       = 0 ;  % NB de points deja calcule
   
   % On affiche un petit conseil pour la valeur de step 
   lgx = abs(J2 - J1) ;
   lgy = abs(J4 - J3) ; 
   suggestion = max(lgx, lgy) / 50 ; 
   % On fait une suggestion sur la nombre de step 
   set(handles.SuggestStep,'String',"Suggestion pour le pas " + suggestion) 
   
   % On prend une barre de progression
   f  = waitbar(nb,"Veuillez patienter pour " + nbPoints + " points.") ; 
   
   % On calcule les points sur la grille xh * yv 
   % svd : calcul des valeurs propres d'une matrice co
   for j=1:length(xh) 
       for k=1:length(yv)
           sigmin(j,k) = min(svd((X(j,k) + Y(j,k)*1i)*eye(n)-A));
           nb = nb +1 ; % Barre de progression
           waitbar(nb/nbPoints,f) % Mise a jour de la barre de progression
       end
   end
   close(f) % Fin de la barre de progression
   
   minEpsi = min(min(sigmin))
   maxEpsi = max(max(sigmin))
   set(handles.SuggestEpsi,'String',minEpsi+ " < Epsilon < " + maxEpsi)
   
   Epsi = getGlobalEpsilon
   f=[Epsi Epsi];
   contour(X, Y, sigmin, f, 'LineWidth',2,'LineColor','black')
   

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
   disp("SetGlobalStep " + val)

function r = getGlobalStep
   global Step
   r = Step;

function setGlobalMat(val)
   global mat
   mat = val;

function r = getGlobalMat
   global mat
   r = mat;
                
% --- Executes on button press in AppliquerNewton.
function AppliquerNewton_Callback(hObject, eventdata, handles)
% hObject    handle to AppliquerNewton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%   axes(handles.axes);
   axes(handles.axes);
   cla;
   
   A = getGlobalMat ; 
 
   % l'ensemble des valeurs propres dans un vecteur que l'on appelle lambda
   lambda=eig(A) ; 
   lambda=unique(lambda) % Dans le cadre de reels on pourrait avoir un seuil de tolerance 
                         % pour calculer egalite ou difference des valeurs propres.  
   tol = 0.1 ;
   [n,n]=size(A); 
   
   %Initialisation
   X1=[];
   Y1=[]; 
   X=[] ;
   Y=[] ; 
   I= eye(n);%I matrice identite de dimension de A
   % epss=0.1; 
   epss = getGlobalEpsilon
   NB = 1000; 
   nbvp = length(lambda)  
   % boucle pour toutes les valeurs propres
   
   for ind = 1:length(lambda)

     % Mise a jour de la barre de progression
       set(handles.newtonProgression,'String',"Progression "+ind+"/"+nbvp+" valeurs propres") 
       drawnow

     % step 0
       lambda0= lambda(ind) 
       zcou = lambda0 + epss ; % Si lambda est reel => zcou reste reel
       k = 0 ; 
     % boucle pour determiner le premier point z1 appartenant a la courbe de niveau epsilon
       while (abs(min(svd(zcou*I - A)) - epss) > tol * epss) & k < 5000
           [U,S,V]= svd(zcou*I-A); %decomposition en valeurs singulieres pour déterminer le triplet singulier
           Umin=U(:,n);
           Vmin=V(:,n);
           Smin=S(n,n);
           zcou = zcou - ((Smin - epss)/real(Vmin'*Umin));  %equation 2.2 
           k = k + 1 ;
       end
       z1 = zcou ;  
       hold on
       plot(real(z1), imag(z1),'o')
       
       zj = z1 ; 
       flag=1;
       j=2; 
       
       while (flag==1 && j<NB)
         % Step prediction
           [U,S,V]=svd(zj*I-A);
           Umin = U(:,n);
           Vmin = V(:,n);
           Smin = S(n,n);
       
           gradient = (i*Vmin'*Umin)/(abs(Vmin'*Umin)) ; 
           Tk = 0.1;
           zj_t = zj+(Tk*gradient) ;  
         
         % Step correction Newton (une iteration)
           
           while (abs(min(svd(zj_t*I - A)) - epss) > tol * epss)
               [U,S,V]=svd(zj_t*I-A); 
               Umin=U(:,n);
               Vmin=V(:,n);
               Smin=S(n,n);
              
               zj_t = zj_t - ((Smin-epss)/(Umin'*Vmin)) ;  % equation 2.3 
           end
           zj=zj_t; 
    
           hold on
             x=real(zj);
             y=imag(zj);
           plot(x, y, 'x')
           
           if (abs(zj-z1)<0.001*z1)
               flag=0;
           end
           j=j+1;
           
       end % End for j 
   
   end % fin boucle valeur propre 
